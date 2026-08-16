import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/trade/trade_manager.dart';

import '../app_scope.dart';

enum _Section { draft, trade }

/// Draft results (read-only — the rookie draft runs automatically at
/// season rollover, see lib/draft/draft_manager.dart) and a trade proposal
/// flow (lib/trade/trade_manager.dart's proposeTrade, which evaluates any
/// AI-controlled side and executes immediately if both sides accept).
class DraftTradeScreen extends StatefulWidget {
  const DraftTradeScreen({super.key});

  @override
  State<DraftTradeScreen> createState() => _DraftTradeScreenState();
}

class _DraftTradeScreenState extends State<DraftTradeScreen> {
  _Section _section = _Section.draft;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<_Section>(
            segments: const [
              ButtonSegment(value: _Section.draft, label: Text('Draft')),
              ButtonSegment(value: _Section.trade, label: Text('Trade')),
            ],
            selected: {_section},
            onSelectionChanged: (selection) => setState(() => _section = selection.first),
          ),
        ),
        Expanded(
          child: _section == _Section.draft ? const _DraftResultsView() : const _TradeView(),
        ),
      ],
    );
  }
}

class _DraftPickRow {
  final int round;
  final int overallPick;
  final String teamName;
  final String playerName;

  const _DraftPickRow({
    required this.round,
    required this.overallPick,
    required this.teamName,
    required this.playerName,
  });
}

class _DraftData {
  final int seasonNumber;
  final List<_DraftPickRow> picks;

  const _DraftData({required this.seasonNumber, required this.picks});
}

class _DraftResultsView extends StatefulWidget {
  const _DraftResultsView();

  @override
  State<_DraftResultsView> createState() => _DraftResultsViewState();
}

class _DraftResultsViewState extends State<_DraftResultsView> {
  Future<_DraftData>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load(AppScope.of(context).db);
  }

  Future<_DraftData> _load(AppDatabase db) async {
    final season = await (db.select(db.seasons)..where((s) => s.isActive.equals(true))).getSingle();
    final picks = await (db.select(db.draftPicks)
          ..where((p) => p.seasonId.equals(season.id))
          ..orderBy([(p) => OrderingTerm(expression: p.overallPick)]))
        .get();
    final teamNames = {for (final t in await db.select(db.teams).get()) t.id: t.name};
    final playerIds = picks.map((p) => p.playerId).toSet();
    final playerNames = playerIds.isEmpty
        ? <int, String>{}
        : {
            for (final p in await (db.select(db.players)..where((p) => p.id.isIn(playerIds))).get())
              p.id: '${p.firstName} ${p.lastName}',
          };

    return _DraftData(
      seasonNumber: season.number,
      picks: [
        for (final p in picks)
          _DraftPickRow(
            round: p.round,
            overallPick: p.overallPick,
            teamName: teamNames[p.teamId] ?? 'Unknown',
            playerName: playerNames[p.playerId] ?? 'Unknown',
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DraftData>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (data.picks.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No draft picks yet this season. The rookie draft runs automatically '
                'when the season rolls over (via "Start Next Season" on the Standings screen).',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Season ${data.seasonNumber} Draft', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final pick in data.picks)
              ListTile(
                dense: true,
                leading: SizedBox(width: 48, child: Text('R${pick.round} #${pick.overallPick}')),
                title: Text(pick.playerName),
                subtitle: Text(pick.teamName),
              ),
          ],
        );
      },
    );
  }
}

class _TradeSetup {
  final int seasonId;
  final Team myTeam;
  final List<Player> myRoster;
  final List<Team> otherTeams;
  final bool beforeDeadline;

  const _TradeSetup({
    required this.seasonId,
    required this.myTeam,
    required this.myRoster,
    required this.otherTeams,
    required this.beforeDeadline,
  });
}

class _TradeView extends StatefulWidget {
  const _TradeView();

  @override
  State<_TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<_TradeView> {
  Tier _tier = Tier.major;
  Future<_TradeSetup?>? _future;

  int? _opposingTeamId;
  List<Player>? _opposingRoster;
  final Set<int> _selectedMine = {};
  final Set<int> _selectedTheirs = {};
  String? _resultMessage;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load(AppScope.of(context).db, _tier);
  }

  void _switchTier(Tier tier) {
    if (tier == _tier) return;
    setState(() {
      _tier = tier;
      _future = _load(AppScope.of(context).db, tier);
      _resetSelection();
    });
  }

  void _resetSelection() {
    _opposingTeamId = null;
    _opposingRoster = null;
    _selectedMine.clear();
    _selectedTheirs.clear();
    _resultMessage = null;
  }

  Future<_TradeSetup?> _load(AppDatabase db, Tier tier) async {
    final org = await (db.select(db.organizations)..where((o) => o.isPlayerControlled.equals(true)))
        .getSingleOrNull();
    if (org == null) return null;

    final season = await (db.select(db.seasons)..where((s) => s.isActive.equals(true))).getSingle();
    final divisionIds =
        (await (db.select(db.divisions)..where((d) => d.tier.equalsValue(tier))).get()).map((d) => d.id).toSet();
    final tierTeams = await (db.select(db.teams)..where((t) => t.divisionId.isIn(divisionIds))).get();

    Team? myTeam;
    final otherTeams = <Team>[];
    for (final t in tierTeams) {
      if (t.organizationId == org.id) {
        myTeam = t;
      } else {
        otherTeams.add(t);
      }
    }
    if (myTeam == null) return null;
    final resolvedTeam = myTeam;

    final myRoster = await (db.select(db.players)..where((p) => p.teamId.equals(resolvedTeam.id))).get();
    final beforeDeadline = await isBeforeTradeDeadline(db, seasonId: season.id);

    return _TradeSetup(
      seasonId: season.id,
      myTeam: resolvedTeam,
      myRoster: myRoster,
      otherTeams: otherTeams,
      beforeDeadline: beforeDeadline,
    );
  }

  Future<void> _selectOpponent(int? teamId) async {
    setState(() {
      _opposingTeamId = teamId;
      _opposingRoster = null;
      _selectedTheirs.clear();
      _resultMessage = null;
    });
    if (teamId == null) return;
    final db = AppScope.of(context).db;
    final roster = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
    if (!mounted) return;
    setState(() => _opposingRoster = roster);
  }

  Future<void> _propose(_TradeSetup data) async {
    setState(() {
      _busy = true;
      _resultMessage = null;
    });
    final db = AppScope.of(context).db;
    final opponentId = _opposingTeamId!;
    try {
      final result = await proposeTrade(
        db,
        seasonId: data.seasonId,
        teamAId: data.myTeam.id,
        playersFromA: _selectedMine.toList(),
        teamBId: opponentId,
        playersFromB: _selectedTheirs.toList(),
      );
      if (!mounted) return;

      if (result.accepted) {
        // Both rosters may have changed (players swapped sides), so reload
        // both before rebuilding — awaited up front so the FutureBuilder's
        // new future is already complete and doesn't blank the screen (and
        // this result message) out for a frame while it resolves.
        final freshData = await _load(db, _tier);
        final freshOpposingRoster =
            await (db.select(db.players)..where((p) => p.teamId.equals(opponentId))).get();
        if (!mounted) return;
        setState(() {
          _future = Future.value(freshData);
          _opposingTeamId = opponentId;
          _opposingRoster = freshOpposingRoster;
          _selectedMine.clear();
          _selectedTheirs.clear();
          _resultMessage = 'Trade accepted and executed.';
          _busy = false;
        });
      } else {
        setState(() {
          _resultMessage = result.reason ?? 'Trade declined.';
          _busy = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _resultMessage = e.toString();
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TradeSetup?>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text('No team yet.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<Tier>(
              segments: const [
                ButtonSegment(value: Tier.major, label: Text('Major')),
                ButtonSegment(value: Tier.minor, label: Text('Minor')),
              ],
              selected: {_tier},
              onSelectionChanged: (selection) => _switchTier(selection.first),
            ),
            const SizedBox(height: 16),
            if (!data.beforeDeadline)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'The trade deadline has passed for this season.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Text('${data.myTeam.name} sends:', style: Theme.of(context).textTheme.titleMedium),
            for (final p in data.myRoster)
              CheckboxListTile(
                key: ValueKey('mine-${p.id}'),
                dense: true,
                title: Text('${p.firstName} ${p.lastName}'),
                subtitle: Text(p.rosterSlot == RosterSlot.dl ? 'DL' : 'Active'),
                value: _selectedMine.contains(p.id),
                onChanged: data.beforeDeadline
                    ? (checked) => setState(() {
                          if (checked ?? false) {
                            _selectedMine.add(p.id);
                          } else {
                            _selectedMine.remove(p.id);
                          }
                        })
                    : null,
              ),
            const Divider(height: 32),
            Text('Trade with', style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<int>(
              key: const ValueKey('opposingTeamDropdown'),
              initialValue: _opposingTeamId,
              decoration: const InputDecoration(labelText: 'Opposing team'),
              items: [
                for (final t in data.otherTeams)
                  DropdownMenuItem(key: ValueKey('opposingTeamOption-${t.id}'), value: t.id, child: Text(t.name)),
              ],
              onChanged: data.beforeDeadline ? _selectOpponent : null,
            ),
            if (_opposingRoster != null) ...[
              const SizedBox(height: 8),
              Text('They send:', style: Theme.of(context).textTheme.titleMedium),
              for (final p in _opposingRoster!)
                CheckboxListTile(
                  key: ValueKey('theirs-${p.id}'),
                  dense: true,
                  title: Text('${p.firstName} ${p.lastName}'),
                  subtitle: Text(p.rosterSlot == RosterSlot.dl ? 'DL' : 'Active'),
                  value: _selectedTheirs.contains(p.id),
                  onChanged: data.beforeDeadline
                      ? (checked) => setState(() {
                            if (checked ?? false) {
                              _selectedTheirs.add(p.id);
                            } else {
                              _selectedTheirs.remove(p.id);
                            }
                          })
                      : null,
                ),
            ],
            const SizedBox(height: 16),
            if (_resultMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_resultMessage!),
              ),
            FilledButton(
              onPressed: data.beforeDeadline &&
                      !_busy &&
                      _opposingTeamId != null &&
                      _selectedMine.isNotEmpty &&
                      _selectedTheirs.isNotEmpty
                  ? () => _propose(data)
                  : null,
              child: Text(_busy ? 'Proposing...' : 'Propose Trade'),
            ),
          ],
        );
      },
    );
  }
}
