import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import 'package:wballmgr/career/org_roster.dart' as org_roster;
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_rules.dart';
import 'package:wballmgr/roster/roster_writer.dart';

import '../app_scope.dart';

class _LoadedRoster {
  final int organizationId;
  final Team team;
  final Team? otherTierTeam;
  final List<Player> players;
  final List<Player> otherTierActivePlayers;
  final TeamLineup? lineup;

  const _LoadedRoster({
    required this.organizationId,
    required this.team,
    required this.otherTierTeam,
    required this.players,
    required this.otherTierActivePlayers,
    required this.lineup,
  });
}

List<int> _parseIds(String csv) => csv.isEmpty ? [] : csv.split(',').map(int.parse).toList();

/// Manual lineup/rotation editing for the player's team, plus (Phase 7)
/// call-up/send-down between the org's major and minor rosters. Shows only
/// name/age/roster-slot — never true ratings, per the Hidden Ratings model
/// (prd/product-requirements.md).
class RosterScreen extends StatefulWidget {
  const RosterScreen({super.key});

  @override
  State<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  Tier _tier = Tier.major;
  Future<_LoadedRoster?>? _future;

  List<int>? _battingOrder;
  List<int>? _pitcherRotation;
  int? _fielder2Id;
  int? _fielder3Id;
  String? _saveError;

  int? _outgoingPlayerId;
  int? _incomingPlayerId;
  String? _callUpError;

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
      _resetEditState();
    });
  }

  void _resetEditState() {
    _battingOrder = null;
    _pitcherRotation = null;
    _fielder2Id = null;
    _fielder3Id = null;
    _saveError = null;
    _outgoingPlayerId = null;
    _incomingPlayerId = null;
    _callUpError = null;
  }

  Future<_LoadedRoster?> _load(AppDatabase db, Tier tier) async {
    final org = await (db.select(db.organizations)..where((o) => o.isPlayerControlled.equals(true)))
        .getSingleOrNull();
    if (org == null) return null;

    final divisionRows = await db.select(db.divisions).get();
    final divisionTier = {for (final d in divisionRows) d.id: d.tier};
    final orgTeams = await (db.select(db.teams)..where((t) => t.organizationId.equals(org.id))).get();

    Team? team, otherTierTeam;
    for (final t in orgTeams) {
      if (divisionTier[t.divisionId] == tier) team = t;
      if (divisionTier[t.divisionId] != tier) otherTierTeam = t;
    }
    if (team == null) return null;
    final resolvedTeam = team;

    final players = await (db.select(db.players)..where((p) => p.teamId.equals(resolvedTeam.id))).get();
    final lineup = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(resolvedTeam.id)))
        .getSingleOrNull();
    final otherTierActivePlayers = otherTierTeam == null
        ? const <Player>[]
        : await (db.select(db.players)
              ..where((p) => p.teamId.equals(otherTierTeam!.id) & p.rosterSlot.equalsValue(RosterSlot.active)))
            .get();

    return _LoadedRoster(
      organizationId: org.id,
      team: team,
      otherTierTeam: otherTierTeam,
      players: players,
      otherTierActivePlayers: otherTierActivePlayers,
      lineup: lineup,
    );
  }

  void _initEditState(_LoadedRoster data) {
    if (_battingOrder != null) return;
    final lineup = data.lineup;
    _battingOrder = lineup != null ? _parseIds(lineup.battingOrder) : [];
    _pitcherRotation = lineup != null ? _parseIds(lineup.pitcherRotation) : [];
    _fielder2Id = lineup?.fielder2Id;
    _fielder3Id = lineup?.fielder3Id;
  }

  List<RosterMember> _rosterMembers(List<Player> players) => [
        for (final p in players)
          if (p.rosterSlot != null) RosterMember(playerId: p.id, slot: p.rosterSlot!),
      ];

  List<String> _currentErrors(List<Player> players) {
    final roster = _rosterMembers(players);
    return [
      ...validateRosterComposition(roster),
      ...validateBattingOrder(_battingOrder!, roster),
      ...validatePitcherRotation(_pitcherRotation!, _battingOrder!, roster),
      if (_fielder2Id != null && _fielder3Id != null)
        ...validateFielders(_fielder2Id!, _fielder3Id!, _pitcherRotation!, roster)
      else
        'Select Fielder 2 and Fielder 3.',
    ];
  }

  Future<void> _save(BuildContext context, _LoadedRoster data) async {
    final errors = _currentErrors(data.players);
    if (errors.isNotEmpty) {
      setState(() => _saveError = errors.join('\n'));
      return;
    }
    try {
      await saveTeamLineup(
        AppScope.of(context).db,
        teamId: data.team.id,
        battingOrder: _battingOrder!,
        pitcherRotation: _pitcherRotation!,
        fielder2Id: _fielder2Id!,
        fielder3Id: _fielder3Id!,
      );
      if (!context.mounted) return;
      setState(() => _saveError = null);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lineup saved.')));
    } catch (e) {
      setState(() => _saveError = e.toString());
    }
  }

  String _name(List<Player> players, int id) {
    for (final p in players) {
      if (p.id == id) return '${p.firstName} ${p.lastName}';
    }
    return 'Unknown';
  }

  /// Swaps [_outgoingPlayerId] (active on the currently-viewed tier's team)
  /// with [_incomingPlayerId] (active on the other tier's team) — the
  /// Phase 7 manual call-up/send-down primitive
  /// (lib/career/org_roster.dart's `swapActiveAssignment`). Both saved
  /// lineups may now legally-but-incorrectly reference a player who just
  /// left their roster; that's surfaced by the normal "Save Lineup"
  /// validation errors on each team's own Roster screen rather than fixed
  /// automatically here, same as any other roster-membership change.
  Future<void> _swap(BuildContext context, _LoadedRoster data) async {
    if (_outgoingPlayerId == null || _incomingPlayerId == null) return;
    try {
      await org_roster.swapActiveAssignment(
        AppScope.of(context).db,
        organizationId: data.organizationId,
        playerAId: _incomingPlayerId!,
        playerBId: _outgoingPlayerId!,
      );
      if (!context.mounted) return;
      final db = AppScope.of(context).db;
      setState(() {
        _future = _load(db, _tier);
        _resetEditState();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Roster updated.')));
    } catch (e) {
      setState(() => _callUpError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_LoadedRoster?>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text('No team yet.'));
        }
        _initEditState(data);

        final active = data.players.where((p) => p.rosterSlot == RosterSlot.active).toList();
        final dl = data.players.where((p) => p.rosterSlot == RosterSlot.dl).toList();
        final battingOrder = _battingOrder!;
        final pitcherRotation = _pitcherRotation!;
        final availableBatters =
            active.where((p) => !battingOrder.contains(p.id) && !pitcherRotation.contains(p.id)).toList();
        final availablePitchers = data.players
            .where((p) => !battingOrder.contains(p.id) && !pitcherRotation.contains(p.id))
            .toList();
        final availableFielders =
            active.where((p) => !pitcherRotation.contains(p.id)).toList();

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
            Text(data.team.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Roster (${active.length} active)', style: Theme.of(context).textTheme.titleMedium),
            for (final p in active)
              ListTile(
                dense: true,
                title: Text('${p.firstName} ${p.lastName}'),
                subtitle: Text('Age ${p.age}'),
                trailing: const Chip(label: Text('Active')),
              ),
            if (dl.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Disabled List', style: Theme.of(context).textTheme.titleMedium),
              for (final p in dl)
                ListTile(
                  dense: true,
                  title: Text('${p.firstName} ${p.lastName}'),
                  subtitle: Text('Age ${p.age}'),
                  trailing: Text('${p.gamesUnavailable} games left'),
                ),
            ],
            const Divider(height: 32),
            Text('Batting Order', style: Theme.of(context).textTheme.titleMedium),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorderItem: (oldIndex, newIndex) {
                setState(() {
                  final id = battingOrder.removeAt(oldIndex);
                  battingOrder.insert(newIndex, id);
                });
              },
              children: [
                for (final id in battingOrder)
                  ListTile(
                    key: ValueKey('bat-$id'),
                    leading: const Icon(Icons.drag_handle),
                    title: Text(_name(data.players, id)),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => setState(() => battingOrder.remove(id)),
                    ),
                  ),
              ],
            ),
            if (availableBatters.isNotEmpty && battingOrder.length < 5)
              Wrap(
                spacing: 8,
                children: [
                  for (final p in availableBatters)
                    ActionChip(
                      key: ValueKey('addBat-${p.id}'),
                      label: Text('+ ${p.firstName} ${p.lastName}'),
                      onPressed: () => setState(() => battingOrder.add(p.id)),
                    ),
                ],
              ),
            const Divider(height: 32),
            Text('Pitcher Rotation', style: Theme.of(context).textTheme.titleMedium),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorderItem: (oldIndex, newIndex) {
                setState(() {
                  final id = pitcherRotation.removeAt(oldIndex);
                  pitcherRotation.insert(newIndex, id);
                });
              },
              children: [
                for (final id in pitcherRotation)
                  ListTile(
                    key: ValueKey('pitch-$id'),
                    leading: const Icon(Icons.drag_handle),
                    title: Text(_name(data.players, id)),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => setState(() => pitcherRotation.remove(id)),
                    ),
                  ),
              ],
            ),
            if (availablePitchers.isNotEmpty)
              Wrap(
                spacing: 8,
                children: [
                  for (final p in availablePitchers)
                    ActionChip(
                      key: ValueKey('addPitch-${p.id}'),
                      label: Text('+ ${p.firstName} ${p.lastName}'),
                      onPressed: () => setState(() => pitcherRotation.add(p.id)),
                    ),
                ],
              ),
            const Divider(height: 32),
            Text('Fielders', style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<int>(
              key: const ValueKey('fielder2Dropdown'),
              decoration: const InputDecoration(labelText: 'Fielder 2'),
              initialValue: availableFielders.any((p) => p.id == _fielder2Id) ? _fielder2Id : null,
              items: [
                for (final p in availableFielders)
                  DropdownMenuItem(
                    key: ValueKey('fielder2Option-${p.id}'),
                    value: p.id,
                    child: Text('${p.firstName} ${p.lastName}'),
                  ),
              ],
              onChanged: (id) => setState(() => _fielder2Id = id),
            ),
            DropdownButtonFormField<int>(
              key: const ValueKey('fielder3Dropdown'),
              decoration: const InputDecoration(labelText: 'Fielder 3'),
              initialValue: availableFielders.any((p) => p.id == _fielder3Id) ? _fielder3Id : null,
              items: [
                for (final p in availableFielders)
                  DropdownMenuItem(
                    key: ValueKey('fielder3Option-${p.id}'),
                    value: p.id,
                    child: Text('${p.firstName} ${p.lastName}'),
                  ),
              ],
              onChanged: (id) => setState(() => _fielder3Id = id),
            ),
            const SizedBox(height: 16),
            if (_saveError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_saveError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            FilledButton(
              onPressed: () => _save(context, data),
              child: const Text('Save Lineup'),
            ),
            if (data.otherTierTeam != null) ...[
              const Divider(height: 32),
              Text(
                'Call-Up / Send-Down (${_tier == Tier.major ? "Major" : "Minor"} ↔ '
                '${_tier == Tier.major ? "Minor" : "Major"})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Select one active player from each roster, then swap them.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text('${data.team.name} (send down)', style: Theme.of(context).textTheme.titleSmall),
              for (final p in active)
                ListTile(
                  dense: true,
                  selected: p.id == _outgoingPlayerId,
                  leading: Icon(
                    p.id == _outgoingPlayerId ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  ),
                  title: Text('${p.firstName} ${p.lastName}'),
                  subtitle: Text('Age ${p.age}'),
                  onTap: () => setState(() => _outgoingPlayerId = p.id),
                ),
              const SizedBox(height: 8),
              Text('${data.otherTierTeam!.name} (call up)', style: Theme.of(context).textTheme.titleSmall),
              for (final p in data.otherTierActivePlayers)
                ListTile(
                  dense: true,
                  selected: p.id == _incomingPlayerId,
                  leading: Icon(
                    p.id == _incomingPlayerId ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  ),
                  title: Text('${p.firstName} ${p.lastName}'),
                  subtitle: Text('Age ${p.age}'),
                  onTap: () => setState(() => _incomingPlayerId = p.id),
                ),
              const SizedBox(height: 8),
              if (_callUpError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_callUpError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              FilledButton(
                onPressed:
                    _outgoingPlayerId != null && _incomingPlayerId != null ? () => _swap(context, data) : null,
                child: const Text('Swap'),
              ),
            ],
          ],
        );
      },
    );
  }
}
