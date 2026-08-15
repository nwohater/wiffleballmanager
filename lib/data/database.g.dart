// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $OrganizationsTable extends Organizations
    with TableInfo<$OrganizationsTable, Organization> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPlayerControlledMeta =
      const VerificationMeta('isPlayerControlled');
  @override
  late final GeneratedColumn<bool> isPlayerControlled = GeneratedColumn<bool>(
    'is_player_controlled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_player_controlled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isPlayerControlled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Organization> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_player_controlled')) {
      context.handle(
        _isPlayerControlledMeta,
        isPlayerControlled.isAcceptableOrUnknown(
          data['is_player_controlled']!,
          _isPlayerControlledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Organization map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Organization(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isPlayerControlled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_player_controlled'],
      )!,
    );
  }

  @override
  $OrganizationsTable createAlias(String alias) {
    return $OrganizationsTable(attachedDatabase, alias);
  }
}

class Organization extends DataClass implements Insertable<Organization> {
  final int id;
  final String name;

  /// True for exactly one org — the human player's franchise. Everything
  /// else is AI-controlled (PRD: Hidden Ratings / AI team management).
  final bool isPlayerControlled;
  const Organization({
    required this.id,
    required this.name,
    required this.isPlayerControlled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_player_controlled'] = Variable<bool>(isPlayerControlled);
    return map;
  }

  OrganizationsCompanion toCompanion(bool nullToAbsent) {
    return OrganizationsCompanion(
      id: Value(id),
      name: Value(name),
      isPlayerControlled: Value(isPlayerControlled),
    );
  }

  factory Organization.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Organization(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isPlayerControlled: serializer.fromJson<bool>(json['isPlayerControlled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isPlayerControlled': serializer.toJson<bool>(isPlayerControlled),
    };
  }

  Organization copyWith({int? id, String? name, bool? isPlayerControlled}) =>
      Organization(
        id: id ?? this.id,
        name: name ?? this.name,
        isPlayerControlled: isPlayerControlled ?? this.isPlayerControlled,
      );
  Organization copyWithCompanion(OrganizationsCompanion data) {
    return Organization(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isPlayerControlled: data.isPlayerControlled.present
          ? data.isPlayerControlled.value
          : this.isPlayerControlled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Organization(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isPlayerControlled: $isPlayerControlled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isPlayerControlled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Organization &&
          other.id == this.id &&
          other.name == this.name &&
          other.isPlayerControlled == this.isPlayerControlled);
}

class OrganizationsCompanion extends UpdateCompanion<Organization> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isPlayerControlled;
  const OrganizationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isPlayerControlled = const Value.absent(),
  });
  OrganizationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isPlayerControlled = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Organization> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isPlayerControlled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isPlayerControlled != null)
        'is_player_controlled': isPlayerControlled,
    });
  }

  OrganizationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isPlayerControlled,
  }) {
    return OrganizationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isPlayerControlled: isPlayerControlled ?? this.isPlayerControlled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isPlayerControlled.present) {
      map['is_player_controlled'] = Variable<bool>(isPlayerControlled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isPlayerControlled: $isPlayerControlled')
          ..write(')'))
        .toString();
  }
}

class $DivisionsTable extends Divisions
    with TableInfo<$DivisionsTable, Division> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DivisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Tier, int> tier =
      GeneratedColumn<int>(
        'tier',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Tier>($DivisionsTable.$convertertier);
  @override
  List<GeneratedColumn> get $columns => [id, name, tier];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'divisions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Division> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Division map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Division(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      tier: $DivisionsTable.$convertertier.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tier'],
        )!,
      ),
    );
  }

  @override
  $DivisionsTable createAlias(String alias) {
    return $DivisionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Tier, int, int> $convertertier =
      const EnumIndexConverter<Tier>(Tier.values);
}

class Division extends DataClass implements Insertable<Division> {
  final int id;
  final String name;
  final Tier tier;
  const Division({required this.id, required this.name, required this.tier});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['tier'] = Variable<int>($DivisionsTable.$convertertier.toSql(tier));
    }
    return map;
  }

  DivisionsCompanion toCompanion(bool nullToAbsent) {
    return DivisionsCompanion(
      id: Value(id),
      name: Value(name),
      tier: Value(tier),
    );
  }

  factory Division.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Division(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      tier: $DivisionsTable.$convertertier.fromJson(
        serializer.fromJson<int>(json['tier']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'tier': serializer.toJson<int>(
        $DivisionsTable.$convertertier.toJson(tier),
      ),
    };
  }

  Division copyWith({int? id, String? name, Tier? tier}) => Division(
    id: id ?? this.id,
    name: name ?? this.name,
    tier: tier ?? this.tier,
  );
  Division copyWithCompanion(DivisionsCompanion data) {
    return Division(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      tier: data.tier.present ? data.tier.value : this.tier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Division(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tier: $tier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, tier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Division &&
          other.id == this.id &&
          other.name == this.name &&
          other.tier == this.tier);
}

class DivisionsCompanion extends UpdateCompanion<Division> {
  final Value<int> id;
  final Value<String> name;
  final Value<Tier> tier;
  const DivisionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.tier = const Value.absent(),
  });
  DivisionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required Tier tier,
  }) : name = Value(name),
       tier = Value(tier);
  static Insertable<Division> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? tier,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (tier != null) 'tier': tier,
    });
  }

  DivisionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<Tier>? tier,
  }) {
    return DivisionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      tier: tier ?? this.tier,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tier.present) {
      map['tier'] = Variable<int>(
        $DivisionsTable.$convertertier.toSql(tier.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DivisionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tier: $tier')
          ..write(')'))
        .toString();
  }
}

class $TeamsTable extends Teams with TableInfo<$TeamsTable, Team> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<int> organizationId = GeneratedColumn<int>(
    'organization_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _divisionIdMeta = const VerificationMeta(
    'divisionId',
  );
  @override
  late final GeneratedColumn<int> divisionId = GeneratedColumn<int>(
    'division_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES divisions (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, organizationId, divisionId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<Team> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('division_id')) {
      context.handle(
        _divisionIdMeta,
        divisionId.isAcceptableOrUnknown(data['division_id']!, _divisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_divisionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Team map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Team(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organization_id'],
      )!,
      divisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}division_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TeamsTable createAlias(String alias) {
    return $TeamsTable(attachedDatabase, alias);
  }
}

class Team extends DataClass implements Insertable<Team> {
  final int id;
  final int organizationId;
  final int divisionId;
  final String name;
  const Team({
    required this.id,
    required this.organizationId,
    required this.divisionId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organization_id'] = Variable<int>(organizationId);
    map['division_id'] = Variable<int>(divisionId);
    map['name'] = Variable<String>(name);
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      divisionId: Value(divisionId),
      name: Value(name),
    );
  }

  factory Team.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Team(
      id: serializer.fromJson<int>(json['id']),
      organizationId: serializer.fromJson<int>(json['organizationId']),
      divisionId: serializer.fromJson<int>(json['divisionId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organizationId': serializer.toJson<int>(organizationId),
      'divisionId': serializer.toJson<int>(divisionId),
      'name': serializer.toJson<String>(name),
    };
  }

  Team copyWith({
    int? id,
    int? organizationId,
    int? divisionId,
    String? name,
  }) => Team(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    divisionId: divisionId ?? this.divisionId,
    name: name ?? this.name,
  );
  Team copyWithCompanion(TeamsCompanion data) {
    return Team(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      divisionId: data.divisionId.present
          ? data.divisionId.value
          : this.divisionId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Team(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('divisionId: $divisionId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, organizationId, divisionId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Team &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.divisionId == this.divisionId &&
          other.name == this.name);
}

class TeamsCompanion extends UpdateCompanion<Team> {
  final Value<int> id;
  final Value<int> organizationId;
  final Value<int> divisionId;
  final Value<String> name;
  const TeamsCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.divisionId = const Value.absent(),
    this.name = const Value.absent(),
  });
  TeamsCompanion.insert({
    this.id = const Value.absent(),
    required int organizationId,
    required int divisionId,
    required String name,
  }) : organizationId = Value(organizationId),
       divisionId = Value(divisionId),
       name = Value(name);
  static Insertable<Team> custom({
    Expression<int>? id,
    Expression<int>? organizationId,
    Expression<int>? divisionId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (divisionId != null) 'division_id': divisionId,
      if (name != null) 'name': name,
    });
  }

  TeamsCompanion copyWith({
    Value<int>? id,
    Value<int>? organizationId,
    Value<int>? divisionId,
    Value<String>? name,
  }) {
    return TeamsCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      divisionId: divisionId ?? this.divisionId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<int>(organizationId.value);
    }
    if (divisionId.present) {
      map['division_id'] = Variable<int>(divisionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('divisionId: $divisionId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $SeasonsTable extends Seasons with TableInfo<$SeasonsTable, Season> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, number, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seasons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Season> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Season map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Season(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SeasonsTable createAlias(String alias) {
    return $SeasonsTable(attachedDatabase, alias);
  }
}

class Season extends DataClass implements Insertable<Season> {
  final int id;
  final int number;
  final bool isActive;
  const Season({
    required this.id,
    required this.number,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SeasonsCompanion toCompanion(bool nullToAbsent) {
    return SeasonsCompanion(
      id: Value(id),
      number: Value(number),
      isActive: Value(isActive),
    );
  }

  factory Season.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Season(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Season copyWith({int? id, int? number, bool? isActive}) => Season(
    id: id ?? this.id,
    number: number ?? this.number,
    isActive: isActive ?? this.isActive,
  );
  Season copyWithCompanion(SeasonsCompanion data) {
    return Season(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Season(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Season &&
          other.id == this.id &&
          other.number == this.number &&
          other.isActive == this.isActive);
}

class SeasonsCompanion extends UpdateCompanion<Season> {
  final Value<int> id;
  final Value<int> number;
  final Value<bool> isActive;
  const SeasonsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  SeasonsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    this.isActive = const Value.absent(),
  }) : number = Value(number);
  static Insertable<Season> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (isActive != null) 'is_active': isActive,
    });
  }

  SeasonsCompanion copyWith({
    Value<int>? id,
    Value<int>? number,
    Value<bool>? isActive,
  }) {
    return SeasonsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasonsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $PlayoffSeriesTable extends PlayoffSeries
    with TableInfo<$PlayoffSeriesTable, PlayoffSeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayoffSeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES seasons (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Tier, int> tier =
      GeneratedColumn<int>(
        'tier',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(Tier.major.index),
      ).withConverter<Tier>($PlayoffSeriesTable.$convertertier);
  @override
  late final GeneratedColumnWithTypeConverter<PlayoffRound, int> round =
      GeneratedColumn<int>(
        'round',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PlayoffRound>($PlayoffSeriesTable.$converterround);
  static const VerificationMeta _higherSeedTeamIdMeta = const VerificationMeta(
    'higherSeedTeamId',
  );
  @override
  late final GeneratedColumn<int> higherSeedTeamId = GeneratedColumn<int>(
    'higher_seed_team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _higherSeedRankMeta = const VerificationMeta(
    'higherSeedRank',
  );
  @override
  late final GeneratedColumn<int> higherSeedRank = GeneratedColumn<int>(
    'higher_seed_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowerSeedTeamIdMeta = const VerificationMeta(
    'lowerSeedTeamId',
  );
  @override
  late final GeneratedColumn<int> lowerSeedTeamId = GeneratedColumn<int>(
    'lower_seed_team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _lowerSeedRankMeta = const VerificationMeta(
    'lowerSeedRank',
  );
  @override
  late final GeneratedColumn<int> lowerSeedRank = GeneratedColumn<int>(
    'lower_seed_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bestOfMeta = const VerificationMeta('bestOf');
  @override
  late final GeneratedColumn<int> bestOf = GeneratedColumn<int>(
    'best_of',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _higherSeedWinsMeta = const VerificationMeta(
    'higherSeedWins',
  );
  @override
  late final GeneratedColumn<int> higherSeedWins = GeneratedColumn<int>(
    'higher_seed_wins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lowerSeedWinsMeta = const VerificationMeta(
    'lowerSeedWins',
  );
  @override
  late final GeneratedColumn<int> lowerSeedWins = GeneratedColumn<int>(
    'lower_seed_wins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _winnerTeamIdMeta = const VerificationMeta(
    'winnerTeamId',
  );
  @override
  late final GeneratedColumn<int> winnerTeamId = GeneratedColumn<int>(
    'winner_team_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seasonId,
    tier,
    round,
    higherSeedTeamId,
    higherSeedRank,
    lowerSeedTeamId,
    lowerSeedRank,
    bestOf,
    higherSeedWins,
    lowerSeedWins,
    winnerTeamId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playoff_series';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayoffSeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    if (data.containsKey('higher_seed_team_id')) {
      context.handle(
        _higherSeedTeamIdMeta,
        higherSeedTeamId.isAcceptableOrUnknown(
          data['higher_seed_team_id']!,
          _higherSeedTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_higherSeedTeamIdMeta);
    }
    if (data.containsKey('higher_seed_rank')) {
      context.handle(
        _higherSeedRankMeta,
        higherSeedRank.isAcceptableOrUnknown(
          data['higher_seed_rank']!,
          _higherSeedRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_higherSeedRankMeta);
    }
    if (data.containsKey('lower_seed_team_id')) {
      context.handle(
        _lowerSeedTeamIdMeta,
        lowerSeedTeamId.isAcceptableOrUnknown(
          data['lower_seed_team_id']!,
          _lowerSeedTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lowerSeedTeamIdMeta);
    }
    if (data.containsKey('lower_seed_rank')) {
      context.handle(
        _lowerSeedRankMeta,
        lowerSeedRank.isAcceptableOrUnknown(
          data['lower_seed_rank']!,
          _lowerSeedRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lowerSeedRankMeta);
    }
    if (data.containsKey('best_of')) {
      context.handle(
        _bestOfMeta,
        bestOf.isAcceptableOrUnknown(data['best_of']!, _bestOfMeta),
      );
    } else if (isInserting) {
      context.missing(_bestOfMeta);
    }
    if (data.containsKey('higher_seed_wins')) {
      context.handle(
        _higherSeedWinsMeta,
        higherSeedWins.isAcceptableOrUnknown(
          data['higher_seed_wins']!,
          _higherSeedWinsMeta,
        ),
      );
    }
    if (data.containsKey('lower_seed_wins')) {
      context.handle(
        _lowerSeedWinsMeta,
        lowerSeedWins.isAcceptableOrUnknown(
          data['lower_seed_wins']!,
          _lowerSeedWinsMeta,
        ),
      );
    }
    if (data.containsKey('winner_team_id')) {
      context.handle(
        _winnerTeamIdMeta,
        winnerTeamId.isAcceptableOrUnknown(
          data['winner_team_id']!,
          _winnerTeamIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayoffSeriesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayoffSeriesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
      tier: $PlayoffSeriesTable.$convertertier.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tier'],
        )!,
      ),
      round: $PlayoffSeriesTable.$converterround.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}round'],
        )!,
      ),
      higherSeedTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}higher_seed_team_id'],
      )!,
      higherSeedRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}higher_seed_rank'],
      )!,
      lowerSeedTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lower_seed_team_id'],
      )!,
      lowerSeedRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lower_seed_rank'],
      )!,
      bestOf: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_of'],
      )!,
      higherSeedWins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}higher_seed_wins'],
      )!,
      lowerSeedWins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lower_seed_wins'],
      )!,
      winnerTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}winner_team_id'],
      ),
    );
  }

  @override
  $PlayoffSeriesTable createAlias(String alias) {
    return $PlayoffSeriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Tier, int, int> $convertertier =
      const EnumIndexConverter<Tier>(Tier.values);
  static JsonTypeConverter2<PlayoffRound, int, int> $converterround =
      const EnumIndexConverter<PlayoffRound>(PlayoffRound.values);
}

class PlayoffSeriesRow extends DataClass
    implements Insertable<PlayoffSeriesRow> {
  final int id;
  final int seasonId;

  /// Major and minor tiers each run their own independent bracket (Phase 7)
  /// — needed because [higherSeedTeamId]/[lowerSeedTeamId] alone don't
  /// disambiguate which tier's standings this series was seeded from.
  /// Existing rows (pre-Phase-7) default to major, which is correct — no
  /// minor tier existed when they were written.
  final Tier tier;
  final PlayoffRound round;
  final int higherSeedTeamId;
  final int higherSeedRank;
  final int lowerSeedTeamId;
  final int lowerSeedRank;

  /// 5 for a semifinal, 7 for the championship.
  final int bestOf;
  final int higherSeedWins;
  final int lowerSeedWins;

  /// Null until the series is clinched (wins reach ceil(bestOf/2)).
  final int? winnerTeamId;
  const PlayoffSeriesRow({
    required this.id,
    required this.seasonId,
    required this.tier,
    required this.round,
    required this.higherSeedTeamId,
    required this.higherSeedRank,
    required this.lowerSeedTeamId,
    required this.lowerSeedRank,
    required this.bestOf,
    required this.higherSeedWins,
    required this.lowerSeedWins,
    this.winnerTeamId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['season_id'] = Variable<int>(seasonId);
    {
      map['tier'] = Variable<int>(
        $PlayoffSeriesTable.$convertertier.toSql(tier),
      );
    }
    {
      map['round'] = Variable<int>(
        $PlayoffSeriesTable.$converterround.toSql(round),
      );
    }
    map['higher_seed_team_id'] = Variable<int>(higherSeedTeamId);
    map['higher_seed_rank'] = Variable<int>(higherSeedRank);
    map['lower_seed_team_id'] = Variable<int>(lowerSeedTeamId);
    map['lower_seed_rank'] = Variable<int>(lowerSeedRank);
    map['best_of'] = Variable<int>(bestOf);
    map['higher_seed_wins'] = Variable<int>(higherSeedWins);
    map['lower_seed_wins'] = Variable<int>(lowerSeedWins);
    if (!nullToAbsent || winnerTeamId != null) {
      map['winner_team_id'] = Variable<int>(winnerTeamId);
    }
    return map;
  }

  PlayoffSeriesCompanion toCompanion(bool nullToAbsent) {
    return PlayoffSeriesCompanion(
      id: Value(id),
      seasonId: Value(seasonId),
      tier: Value(tier),
      round: Value(round),
      higherSeedTeamId: Value(higherSeedTeamId),
      higherSeedRank: Value(higherSeedRank),
      lowerSeedTeamId: Value(lowerSeedTeamId),
      lowerSeedRank: Value(lowerSeedRank),
      bestOf: Value(bestOf),
      higherSeedWins: Value(higherSeedWins),
      lowerSeedWins: Value(lowerSeedWins),
      winnerTeamId: winnerTeamId == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerTeamId),
    );
  }

  factory PlayoffSeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayoffSeriesRow(
      id: serializer.fromJson<int>(json['id']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
      tier: $PlayoffSeriesTable.$convertertier.fromJson(
        serializer.fromJson<int>(json['tier']),
      ),
      round: $PlayoffSeriesTable.$converterround.fromJson(
        serializer.fromJson<int>(json['round']),
      ),
      higherSeedTeamId: serializer.fromJson<int>(json['higherSeedTeamId']),
      higherSeedRank: serializer.fromJson<int>(json['higherSeedRank']),
      lowerSeedTeamId: serializer.fromJson<int>(json['lowerSeedTeamId']),
      lowerSeedRank: serializer.fromJson<int>(json['lowerSeedRank']),
      bestOf: serializer.fromJson<int>(json['bestOf']),
      higherSeedWins: serializer.fromJson<int>(json['higherSeedWins']),
      lowerSeedWins: serializer.fromJson<int>(json['lowerSeedWins']),
      winnerTeamId: serializer.fromJson<int?>(json['winnerTeamId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seasonId': serializer.toJson<int>(seasonId),
      'tier': serializer.toJson<int>(
        $PlayoffSeriesTable.$convertertier.toJson(tier),
      ),
      'round': serializer.toJson<int>(
        $PlayoffSeriesTable.$converterround.toJson(round),
      ),
      'higherSeedTeamId': serializer.toJson<int>(higherSeedTeamId),
      'higherSeedRank': serializer.toJson<int>(higherSeedRank),
      'lowerSeedTeamId': serializer.toJson<int>(lowerSeedTeamId),
      'lowerSeedRank': serializer.toJson<int>(lowerSeedRank),
      'bestOf': serializer.toJson<int>(bestOf),
      'higherSeedWins': serializer.toJson<int>(higherSeedWins),
      'lowerSeedWins': serializer.toJson<int>(lowerSeedWins),
      'winnerTeamId': serializer.toJson<int?>(winnerTeamId),
    };
  }

  PlayoffSeriesRow copyWith({
    int? id,
    int? seasonId,
    Tier? tier,
    PlayoffRound? round,
    int? higherSeedTeamId,
    int? higherSeedRank,
    int? lowerSeedTeamId,
    int? lowerSeedRank,
    int? bestOf,
    int? higherSeedWins,
    int? lowerSeedWins,
    Value<int?> winnerTeamId = const Value.absent(),
  }) => PlayoffSeriesRow(
    id: id ?? this.id,
    seasonId: seasonId ?? this.seasonId,
    tier: tier ?? this.tier,
    round: round ?? this.round,
    higherSeedTeamId: higherSeedTeamId ?? this.higherSeedTeamId,
    higherSeedRank: higherSeedRank ?? this.higherSeedRank,
    lowerSeedTeamId: lowerSeedTeamId ?? this.lowerSeedTeamId,
    lowerSeedRank: lowerSeedRank ?? this.lowerSeedRank,
    bestOf: bestOf ?? this.bestOf,
    higherSeedWins: higherSeedWins ?? this.higherSeedWins,
    lowerSeedWins: lowerSeedWins ?? this.lowerSeedWins,
    winnerTeamId: winnerTeamId.present ? winnerTeamId.value : this.winnerTeamId,
  );
  PlayoffSeriesRow copyWithCompanion(PlayoffSeriesCompanion data) {
    return PlayoffSeriesRow(
      id: data.id.present ? data.id.value : this.id,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      tier: data.tier.present ? data.tier.value : this.tier,
      round: data.round.present ? data.round.value : this.round,
      higherSeedTeamId: data.higherSeedTeamId.present
          ? data.higherSeedTeamId.value
          : this.higherSeedTeamId,
      higherSeedRank: data.higherSeedRank.present
          ? data.higherSeedRank.value
          : this.higherSeedRank,
      lowerSeedTeamId: data.lowerSeedTeamId.present
          ? data.lowerSeedTeamId.value
          : this.lowerSeedTeamId,
      lowerSeedRank: data.lowerSeedRank.present
          ? data.lowerSeedRank.value
          : this.lowerSeedRank,
      bestOf: data.bestOf.present ? data.bestOf.value : this.bestOf,
      higherSeedWins: data.higherSeedWins.present
          ? data.higherSeedWins.value
          : this.higherSeedWins,
      lowerSeedWins: data.lowerSeedWins.present
          ? data.lowerSeedWins.value
          : this.lowerSeedWins,
      winnerTeamId: data.winnerTeamId.present
          ? data.winnerTeamId.value
          : this.winnerTeamId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayoffSeriesRow(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('tier: $tier, ')
          ..write('round: $round, ')
          ..write('higherSeedTeamId: $higherSeedTeamId, ')
          ..write('higherSeedRank: $higherSeedRank, ')
          ..write('lowerSeedTeamId: $lowerSeedTeamId, ')
          ..write('lowerSeedRank: $lowerSeedRank, ')
          ..write('bestOf: $bestOf, ')
          ..write('higherSeedWins: $higherSeedWins, ')
          ..write('lowerSeedWins: $lowerSeedWins, ')
          ..write('winnerTeamId: $winnerTeamId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    seasonId,
    tier,
    round,
    higherSeedTeamId,
    higherSeedRank,
    lowerSeedTeamId,
    lowerSeedRank,
    bestOf,
    higherSeedWins,
    lowerSeedWins,
    winnerTeamId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayoffSeriesRow &&
          other.id == this.id &&
          other.seasonId == this.seasonId &&
          other.tier == this.tier &&
          other.round == this.round &&
          other.higherSeedTeamId == this.higherSeedTeamId &&
          other.higherSeedRank == this.higherSeedRank &&
          other.lowerSeedTeamId == this.lowerSeedTeamId &&
          other.lowerSeedRank == this.lowerSeedRank &&
          other.bestOf == this.bestOf &&
          other.higherSeedWins == this.higherSeedWins &&
          other.lowerSeedWins == this.lowerSeedWins &&
          other.winnerTeamId == this.winnerTeamId);
}

class PlayoffSeriesCompanion extends UpdateCompanion<PlayoffSeriesRow> {
  final Value<int> id;
  final Value<int> seasonId;
  final Value<Tier> tier;
  final Value<PlayoffRound> round;
  final Value<int> higherSeedTeamId;
  final Value<int> higherSeedRank;
  final Value<int> lowerSeedTeamId;
  final Value<int> lowerSeedRank;
  final Value<int> bestOf;
  final Value<int> higherSeedWins;
  final Value<int> lowerSeedWins;
  final Value<int?> winnerTeamId;
  const PlayoffSeriesCompanion({
    this.id = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.tier = const Value.absent(),
    this.round = const Value.absent(),
    this.higherSeedTeamId = const Value.absent(),
    this.higherSeedRank = const Value.absent(),
    this.lowerSeedTeamId = const Value.absent(),
    this.lowerSeedRank = const Value.absent(),
    this.bestOf = const Value.absent(),
    this.higherSeedWins = const Value.absent(),
    this.lowerSeedWins = const Value.absent(),
    this.winnerTeamId = const Value.absent(),
  });
  PlayoffSeriesCompanion.insert({
    this.id = const Value.absent(),
    required int seasonId,
    this.tier = const Value.absent(),
    required PlayoffRound round,
    required int higherSeedTeamId,
    required int higherSeedRank,
    required int lowerSeedTeamId,
    required int lowerSeedRank,
    required int bestOf,
    this.higherSeedWins = const Value.absent(),
    this.lowerSeedWins = const Value.absent(),
    this.winnerTeamId = const Value.absent(),
  }) : seasonId = Value(seasonId),
       round = Value(round),
       higherSeedTeamId = Value(higherSeedTeamId),
       higherSeedRank = Value(higherSeedRank),
       lowerSeedTeamId = Value(lowerSeedTeamId),
       lowerSeedRank = Value(lowerSeedRank),
       bestOf = Value(bestOf);
  static Insertable<PlayoffSeriesRow> custom({
    Expression<int>? id,
    Expression<int>? seasonId,
    Expression<int>? tier,
    Expression<int>? round,
    Expression<int>? higherSeedTeamId,
    Expression<int>? higherSeedRank,
    Expression<int>? lowerSeedTeamId,
    Expression<int>? lowerSeedRank,
    Expression<int>? bestOf,
    Expression<int>? higherSeedWins,
    Expression<int>? lowerSeedWins,
    Expression<int>? winnerTeamId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seasonId != null) 'season_id': seasonId,
      if (tier != null) 'tier': tier,
      if (round != null) 'round': round,
      if (higherSeedTeamId != null) 'higher_seed_team_id': higherSeedTeamId,
      if (higherSeedRank != null) 'higher_seed_rank': higherSeedRank,
      if (lowerSeedTeamId != null) 'lower_seed_team_id': lowerSeedTeamId,
      if (lowerSeedRank != null) 'lower_seed_rank': lowerSeedRank,
      if (bestOf != null) 'best_of': bestOf,
      if (higherSeedWins != null) 'higher_seed_wins': higherSeedWins,
      if (lowerSeedWins != null) 'lower_seed_wins': lowerSeedWins,
      if (winnerTeamId != null) 'winner_team_id': winnerTeamId,
    });
  }

  PlayoffSeriesCompanion copyWith({
    Value<int>? id,
    Value<int>? seasonId,
    Value<Tier>? tier,
    Value<PlayoffRound>? round,
    Value<int>? higherSeedTeamId,
    Value<int>? higherSeedRank,
    Value<int>? lowerSeedTeamId,
    Value<int>? lowerSeedRank,
    Value<int>? bestOf,
    Value<int>? higherSeedWins,
    Value<int>? lowerSeedWins,
    Value<int?>? winnerTeamId,
  }) {
    return PlayoffSeriesCompanion(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      tier: tier ?? this.tier,
      round: round ?? this.round,
      higherSeedTeamId: higherSeedTeamId ?? this.higherSeedTeamId,
      higherSeedRank: higherSeedRank ?? this.higherSeedRank,
      lowerSeedTeamId: lowerSeedTeamId ?? this.lowerSeedTeamId,
      lowerSeedRank: lowerSeedRank ?? this.lowerSeedRank,
      bestOf: bestOf ?? this.bestOf,
      higherSeedWins: higherSeedWins ?? this.higherSeedWins,
      lowerSeedWins: lowerSeedWins ?? this.lowerSeedWins,
      winnerTeamId: winnerTeamId ?? this.winnerTeamId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (tier.present) {
      map['tier'] = Variable<int>(
        $PlayoffSeriesTable.$convertertier.toSql(tier.value),
      );
    }
    if (round.present) {
      map['round'] = Variable<int>(
        $PlayoffSeriesTable.$converterround.toSql(round.value),
      );
    }
    if (higherSeedTeamId.present) {
      map['higher_seed_team_id'] = Variable<int>(higherSeedTeamId.value);
    }
    if (higherSeedRank.present) {
      map['higher_seed_rank'] = Variable<int>(higherSeedRank.value);
    }
    if (lowerSeedTeamId.present) {
      map['lower_seed_team_id'] = Variable<int>(lowerSeedTeamId.value);
    }
    if (lowerSeedRank.present) {
      map['lower_seed_rank'] = Variable<int>(lowerSeedRank.value);
    }
    if (bestOf.present) {
      map['best_of'] = Variable<int>(bestOf.value);
    }
    if (higherSeedWins.present) {
      map['higher_seed_wins'] = Variable<int>(higherSeedWins.value);
    }
    if (lowerSeedWins.present) {
      map['lower_seed_wins'] = Variable<int>(lowerSeedWins.value);
    }
    if (winnerTeamId.present) {
      map['winner_team_id'] = Variable<int>(winnerTeamId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayoffSeriesCompanion(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('tier: $tier, ')
          ..write('round: $round, ')
          ..write('higherSeedTeamId: $higherSeedTeamId, ')
          ..write('higherSeedRank: $higherSeedRank, ')
          ..write('lowerSeedTeamId: $lowerSeedTeamId, ')
          ..write('lowerSeedRank: $lowerSeedRank, ')
          ..write('bestOf: $bestOf, ')
          ..write('higherSeedWins: $higherSeedWins, ')
          ..write('lowerSeedWins: $lowerSeedWins, ')
          ..write('winnerTeamId: $winnerTeamId')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES seasons (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Tier, int> tier =
      GeneratedColumn<int>(
        'tier',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Tier>($GamesTable.$convertertier);
  static const VerificationMeta _homeTeamIdMeta = const VerificationMeta(
    'homeTeamId',
  );
  @override
  late final GeneratedColumn<int> homeTeamId = GeneratedColumn<int>(
    'home_team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _awayTeamIdMeta = const VerificationMeta(
    'awayTeamId',
  );
  @override
  late final GeneratedColumn<int> awayTeamId = GeneratedColumn<int>(
    'away_team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _gameNumberMeta = const VerificationMeta(
    'gameNumber',
  );
  @override
  late final GeneratedColumn<int> gameNumber = GeneratedColumn<int>(
    'game_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<int> seriesId = GeneratedColumn<int>(
    'series_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES playoff_series (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(GameStatus.scheduled.index),
      ).withConverter<GameStatus>($GamesTable.$converterstatus);
  static const VerificationMeta _homeScoreMeta = const VerificationMeta(
    'homeScore',
  );
  @override
  late final GeneratedColumn<int> homeScore = GeneratedColumn<int>(
    'home_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _awayScoreMeta = const VerificationMeta(
    'awayScore',
  );
  @override
  late final GeneratedColumn<int> awayScore = GeneratedColumn<int>(
    'away_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _inningsPlayedMeta = const VerificationMeta(
    'inningsPlayed',
  );
  @override
  late final GeneratedColumn<int> inningsPlayed = GeneratedColumn<int>(
    'innings_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seasonId,
    tier,
    homeTeamId,
    awayTeamId,
    gameNumber,
    seriesId,
    status,
    homeScore,
    awayScore,
    inningsPlayed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    if (data.containsKey('home_team_id')) {
      context.handle(
        _homeTeamIdMeta,
        homeTeamId.isAcceptableOrUnknown(
          data['home_team_id']!,
          _homeTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeTeamIdMeta);
    }
    if (data.containsKey('away_team_id')) {
      context.handle(
        _awayTeamIdMeta,
        awayTeamId.isAcceptableOrUnknown(
          data['away_team_id']!,
          _awayTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_awayTeamIdMeta);
    }
    if (data.containsKey('game_number')) {
      context.handle(
        _gameNumberMeta,
        gameNumber.isAcceptableOrUnknown(data['game_number']!, _gameNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_gameNumberMeta);
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    }
    if (data.containsKey('home_score')) {
      context.handle(
        _homeScoreMeta,
        homeScore.isAcceptableOrUnknown(data['home_score']!, _homeScoreMeta),
      );
    }
    if (data.containsKey('away_score')) {
      context.handle(
        _awayScoreMeta,
        awayScore.isAcceptableOrUnknown(data['away_score']!, _awayScoreMeta),
      );
    }
    if (data.containsKey('innings_played')) {
      context.handle(
        _inningsPlayedMeta,
        inningsPlayed.isAcceptableOrUnknown(
          data['innings_played']!,
          _inningsPlayedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
      tier: $GamesTable.$convertertier.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tier'],
        )!,
      ),
      homeTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_team_id'],
      )!,
      awayTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_team_id'],
      )!,
      gameNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_number'],
      )!,
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_id'],
      ),
      status: $GamesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      homeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_score'],
      )!,
      awayScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_score'],
      )!,
      inningsPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}innings_played'],
      )!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Tier, int, int> $convertertier =
      const EnumIndexConverter<Tier>(Tier.values);
  static JsonTypeConverter2<GameStatus, int, int> $converterstatus =
      const EnumIndexConverter<GameStatus>(GameStatus.values);
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final int seasonId;
  final Tier tier;
  final int homeTeamId;
  final int awayTeamId;

  /// For a regular-season game: the day number within the season (1-based
  /// — every team plays at most once per day, so this doubles as the
  /// "simulate this day" grouping key). For a playoff game (`seriesId` set):
  /// just a continuing incrementing value with no day semantics, since
  /// playoff series aren't simultaneous across the league the way the
  /// round-robin regular season is.
  final int gameNumber;

  /// Null for a regular-season game; set for a playoff game (see
  /// `lib/data/tables/playoff_series.dart`).
  final int? seriesId;
  final GameStatus status;
  final int homeScore;
  final int awayScore;

  /// Innings actually played — 3 for regulation, more if it went extras
  /// (MLW ruleset: extra innings until a winner is determined).
  final int inningsPlayed;
  const Game({
    required this.id,
    required this.seasonId,
    required this.tier,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.gameNumber,
    this.seriesId,
    required this.status,
    required this.homeScore,
    required this.awayScore,
    required this.inningsPlayed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['season_id'] = Variable<int>(seasonId);
    {
      map['tier'] = Variable<int>($GamesTable.$convertertier.toSql(tier));
    }
    map['home_team_id'] = Variable<int>(homeTeamId);
    map['away_team_id'] = Variable<int>(awayTeamId);
    map['game_number'] = Variable<int>(gameNumber);
    if (!nullToAbsent || seriesId != null) {
      map['series_id'] = Variable<int>(seriesId);
    }
    {
      map['status'] = Variable<int>($GamesTable.$converterstatus.toSql(status));
    }
    map['home_score'] = Variable<int>(homeScore);
    map['away_score'] = Variable<int>(awayScore);
    map['innings_played'] = Variable<int>(inningsPlayed);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      seasonId: Value(seasonId),
      tier: Value(tier),
      homeTeamId: Value(homeTeamId),
      awayTeamId: Value(awayTeamId),
      gameNumber: Value(gameNumber),
      seriesId: seriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesId),
      status: Value(status),
      homeScore: Value(homeScore),
      awayScore: Value(awayScore),
      inningsPlayed: Value(inningsPlayed),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
      tier: $GamesTable.$convertertier.fromJson(
        serializer.fromJson<int>(json['tier']),
      ),
      homeTeamId: serializer.fromJson<int>(json['homeTeamId']),
      awayTeamId: serializer.fromJson<int>(json['awayTeamId']),
      gameNumber: serializer.fromJson<int>(json['gameNumber']),
      seriesId: serializer.fromJson<int?>(json['seriesId']),
      status: $GamesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      homeScore: serializer.fromJson<int>(json['homeScore']),
      awayScore: serializer.fromJson<int>(json['awayScore']),
      inningsPlayed: serializer.fromJson<int>(json['inningsPlayed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seasonId': serializer.toJson<int>(seasonId),
      'tier': serializer.toJson<int>($GamesTable.$convertertier.toJson(tier)),
      'homeTeamId': serializer.toJson<int>(homeTeamId),
      'awayTeamId': serializer.toJson<int>(awayTeamId),
      'gameNumber': serializer.toJson<int>(gameNumber),
      'seriesId': serializer.toJson<int?>(seriesId),
      'status': serializer.toJson<int>(
        $GamesTable.$converterstatus.toJson(status),
      ),
      'homeScore': serializer.toJson<int>(homeScore),
      'awayScore': serializer.toJson<int>(awayScore),
      'inningsPlayed': serializer.toJson<int>(inningsPlayed),
    };
  }

  Game copyWith({
    int? id,
    int? seasonId,
    Tier? tier,
    int? homeTeamId,
    int? awayTeamId,
    int? gameNumber,
    Value<int?> seriesId = const Value.absent(),
    GameStatus? status,
    int? homeScore,
    int? awayScore,
    int? inningsPlayed,
  }) => Game(
    id: id ?? this.id,
    seasonId: seasonId ?? this.seasonId,
    tier: tier ?? this.tier,
    homeTeamId: homeTeamId ?? this.homeTeamId,
    awayTeamId: awayTeamId ?? this.awayTeamId,
    gameNumber: gameNumber ?? this.gameNumber,
    seriesId: seriesId.present ? seriesId.value : this.seriesId,
    status: status ?? this.status,
    homeScore: homeScore ?? this.homeScore,
    awayScore: awayScore ?? this.awayScore,
    inningsPlayed: inningsPlayed ?? this.inningsPlayed,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      tier: data.tier.present ? data.tier.value : this.tier,
      homeTeamId: data.homeTeamId.present
          ? data.homeTeamId.value
          : this.homeTeamId,
      awayTeamId: data.awayTeamId.present
          ? data.awayTeamId.value
          : this.awayTeamId,
      gameNumber: data.gameNumber.present
          ? data.gameNumber.value
          : this.gameNumber,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      status: data.status.present ? data.status.value : this.status,
      homeScore: data.homeScore.present ? data.homeScore.value : this.homeScore,
      awayScore: data.awayScore.present ? data.awayScore.value : this.awayScore,
      inningsPlayed: data.inningsPlayed.present
          ? data.inningsPlayed.value
          : this.inningsPlayed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('tier: $tier, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('awayTeamId: $awayTeamId, ')
          ..write('gameNumber: $gameNumber, ')
          ..write('seriesId: $seriesId, ')
          ..write('status: $status, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('inningsPlayed: $inningsPlayed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    seasonId,
    tier,
    homeTeamId,
    awayTeamId,
    gameNumber,
    seriesId,
    status,
    homeScore,
    awayScore,
    inningsPlayed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.seasonId == this.seasonId &&
          other.tier == this.tier &&
          other.homeTeamId == this.homeTeamId &&
          other.awayTeamId == this.awayTeamId &&
          other.gameNumber == this.gameNumber &&
          other.seriesId == this.seriesId &&
          other.status == this.status &&
          other.homeScore == this.homeScore &&
          other.awayScore == this.awayScore &&
          other.inningsPlayed == this.inningsPlayed);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<int> seasonId;
  final Value<Tier> tier;
  final Value<int> homeTeamId;
  final Value<int> awayTeamId;
  final Value<int> gameNumber;
  final Value<int?> seriesId;
  final Value<GameStatus> status;
  final Value<int> homeScore;
  final Value<int> awayScore;
  final Value<int> inningsPlayed;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.tier = const Value.absent(),
    this.homeTeamId = const Value.absent(),
    this.awayTeamId = const Value.absent(),
    this.gameNumber = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.status = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.inningsPlayed = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required int seasonId,
    required Tier tier,
    required int homeTeamId,
    required int awayTeamId,
    required int gameNumber,
    this.seriesId = const Value.absent(),
    this.status = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.inningsPlayed = const Value.absent(),
  }) : seasonId = Value(seasonId),
       tier = Value(tier),
       homeTeamId = Value(homeTeamId),
       awayTeamId = Value(awayTeamId),
       gameNumber = Value(gameNumber);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<int>? seasonId,
    Expression<int>? tier,
    Expression<int>? homeTeamId,
    Expression<int>? awayTeamId,
    Expression<int>? gameNumber,
    Expression<int>? seriesId,
    Expression<int>? status,
    Expression<int>? homeScore,
    Expression<int>? awayScore,
    Expression<int>? inningsPlayed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seasonId != null) 'season_id': seasonId,
      if (tier != null) 'tier': tier,
      if (homeTeamId != null) 'home_team_id': homeTeamId,
      if (awayTeamId != null) 'away_team_id': awayTeamId,
      if (gameNumber != null) 'game_number': gameNumber,
      if (seriesId != null) 'series_id': seriesId,
      if (status != null) 'status': status,
      if (homeScore != null) 'home_score': homeScore,
      if (awayScore != null) 'away_score': awayScore,
      if (inningsPlayed != null) 'innings_played': inningsPlayed,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<int>? seasonId,
    Value<Tier>? tier,
    Value<int>? homeTeamId,
    Value<int>? awayTeamId,
    Value<int>? gameNumber,
    Value<int?>? seriesId,
    Value<GameStatus>? status,
    Value<int>? homeScore,
    Value<int>? awayScore,
    Value<int>? inningsPlayed,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      tier: tier ?? this.tier,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      gameNumber: gameNumber ?? this.gameNumber,
      seriesId: seriesId ?? this.seriesId,
      status: status ?? this.status,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      inningsPlayed: inningsPlayed ?? this.inningsPlayed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (tier.present) {
      map['tier'] = Variable<int>($GamesTable.$convertertier.toSql(tier.value));
    }
    if (homeTeamId.present) {
      map['home_team_id'] = Variable<int>(homeTeamId.value);
    }
    if (awayTeamId.present) {
      map['away_team_id'] = Variable<int>(awayTeamId.value);
    }
    if (gameNumber.present) {
      map['game_number'] = Variable<int>(gameNumber.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<int>(seriesId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $GamesTable.$converterstatus.toSql(status.value),
      );
    }
    if (homeScore.present) {
      map['home_score'] = Variable<int>(homeScore.value);
    }
    if (awayScore.present) {
      map['away_score'] = Variable<int>(awayScore.value);
    }
    if (inningsPlayed.present) {
      map['innings_played'] = Variable<int>(inningsPlayed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('tier: $tier, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('awayTeamId: $awayTeamId, ')
          ..write('gameNumber: $gameNumber, ')
          ..write('seriesId: $seriesId, ')
          ..write('status: $status, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('inningsPlayed: $inningsPlayed')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<int> organizationId = GeneratedColumn<int>(
    'organization_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RosterSlot?, int> rosterSlot =
      GeneratedColumn<int>(
        'roster_slot',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<RosterSlot?>($PlayersTable.$converterrosterSlotn);
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<int> contact = GeneratedColumn<int>(
    'contact',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _powerMeta = const VerificationMeta('power');
  @override
  late final GeneratedColumn<int> power = GeneratedColumn<int>(
    'power',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _disciplineMeta = const VerificationMeta(
    'discipline',
  );
  @override
  late final GeneratedColumn<int> discipline = GeneratedColumn<int>(
    'discipline',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<int> speed = GeneratedColumn<int>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _controlMeta = const VerificationMeta(
    'control',
  );
  @override
  late final GeneratedColumn<int> control = GeneratedColumn<int>(
    'control',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _staminaMeta = const VerificationMeta(
    'stamina',
  );
  @override
  late final GeneratedColumn<int> stamina = GeneratedColumn<int>(
    'stamina',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rangeMeta = const VerificationMeta('range');
  @override
  late final GeneratedColumn<int> range = GeneratedColumn<int>(
    'range',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _handsMeta = const VerificationMeta('hands');
  @override
  late final GeneratedColumn<int> hands = GeneratedColumn<int>(
    'hands',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armMeta = const VerificationMeta('arm');
  @override
  late final GeneratedColumn<int> arm = GeneratedColumn<int>(
    'arm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _battingPotentialMeta = const VerificationMeta(
    'battingPotential',
  );
  @override
  late final GeneratedColumn<int> battingPotential = GeneratedColumn<int>(
    'batting_potential',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pitchingPotentialMeta = const VerificationMeta(
    'pitchingPotential',
  );
  @override
  late final GeneratedColumn<int> pitchingPotential = GeneratedColumn<int>(
    'pitching_potential',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldingPotentialMeta = const VerificationMeta(
    'fieldingPotential',
  );
  @override
  late final GeneratedColumn<int> fieldingPotential = GeneratedColumn<int>(
    'fielding_potential',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedPotentialMeta = const VerificationMeta(
    'speedPotential',
  );
  @override
  late final GeneratedColumn<int> speedPotential = GeneratedColumn<int>(
    'speed_potential',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gamesUnavailableMeta = const VerificationMeta(
    'gamesUnavailable',
  );
  @override
  late final GeneratedColumn<int> gamesUnavailable = GeneratedColumn<int>(
    'games_unavailable',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    teamId,
    rosterSlot,
    firstName,
    lastName,
    age,
    contact,
    power,
    discipline,
    speed,
    control,
    stamina,
    range,
    hands,
    arm,
    battingPotential,
    pitchingPotential,
    fieldingPotential,
    speedPotential,
    gamesUnavailable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    } else if (isInserting) {
      context.missing(_contactMeta);
    }
    if (data.containsKey('power')) {
      context.handle(
        _powerMeta,
        power.isAcceptableOrUnknown(data['power']!, _powerMeta),
      );
    } else if (isInserting) {
      context.missing(_powerMeta);
    }
    if (data.containsKey('discipline')) {
      context.handle(
        _disciplineMeta,
        discipline.isAcceptableOrUnknown(data['discipline']!, _disciplineMeta),
      );
    } else if (isInserting) {
      context.missing(_disciplineMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('control')) {
      context.handle(
        _controlMeta,
        control.isAcceptableOrUnknown(data['control']!, _controlMeta),
      );
    } else if (isInserting) {
      context.missing(_controlMeta);
    }
    if (data.containsKey('stamina')) {
      context.handle(
        _staminaMeta,
        stamina.isAcceptableOrUnknown(data['stamina']!, _staminaMeta),
      );
    } else if (isInserting) {
      context.missing(_staminaMeta);
    }
    if (data.containsKey('range')) {
      context.handle(
        _rangeMeta,
        range.isAcceptableOrUnknown(data['range']!, _rangeMeta),
      );
    } else if (isInserting) {
      context.missing(_rangeMeta);
    }
    if (data.containsKey('hands')) {
      context.handle(
        _handsMeta,
        hands.isAcceptableOrUnknown(data['hands']!, _handsMeta),
      );
    } else if (isInserting) {
      context.missing(_handsMeta);
    }
    if (data.containsKey('arm')) {
      context.handle(
        _armMeta,
        arm.isAcceptableOrUnknown(data['arm']!, _armMeta),
      );
    } else if (isInserting) {
      context.missing(_armMeta);
    }
    if (data.containsKey('batting_potential')) {
      context.handle(
        _battingPotentialMeta,
        battingPotential.isAcceptableOrUnknown(
          data['batting_potential']!,
          _battingPotentialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_battingPotentialMeta);
    }
    if (data.containsKey('pitching_potential')) {
      context.handle(
        _pitchingPotentialMeta,
        pitchingPotential.isAcceptableOrUnknown(
          data['pitching_potential']!,
          _pitchingPotentialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pitchingPotentialMeta);
    }
    if (data.containsKey('fielding_potential')) {
      context.handle(
        _fieldingPotentialMeta,
        fieldingPotential.isAcceptableOrUnknown(
          data['fielding_potential']!,
          _fieldingPotentialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldingPotentialMeta);
    }
    if (data.containsKey('speed_potential')) {
      context.handle(
        _speedPotentialMeta,
        speedPotential.isAcceptableOrUnknown(
          data['speed_potential']!,
          _speedPotentialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_speedPotentialMeta);
    }
    if (data.containsKey('games_unavailable')) {
      context.handle(
        _gamesUnavailableMeta,
        gamesUnavailable.isAcceptableOrUnknown(
          data['games_unavailable']!,
          _gamesUnavailableMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organization_id'],
      ),
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      ),
      rosterSlot: $PlayersTable.$converterrosterSlotn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}roster_slot'],
        ),
      ),
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contact'],
      )!,
      power: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}power'],
      )!,
      discipline: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discipline'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed'],
      )!,
      control: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}control'],
      )!,
      stamina: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stamina'],
      )!,
      range: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}range'],
      )!,
      hands: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hands'],
      )!,
      arm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}arm'],
      )!,
      battingPotential: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batting_potential'],
      )!,
      pitchingPotential: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pitching_potential'],
      )!,
      fieldingPotential: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fielding_potential'],
      )!,
      speedPotential: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_potential'],
      )!,
      gamesUnavailable: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_unavailable'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RosterSlot, int, int> $converterrosterSlot =
      const EnumIndexConverter<RosterSlot>(RosterSlot.values);
  static JsonTypeConverter2<RosterSlot?, int?, int?> $converterrosterSlotn =
      JsonTypeConverter2.asNullable($converterrosterSlot);
}

class Player extends DataClass implements Insertable<Player> {
  final int id;

  /// Null when a free agent (unsigned / cut, per Draft & Trades rules).
  final int? organizationId;

  /// Null when not currently on a roster (free agent).
  final int? teamId;
  final RosterSlot? rosterSlot;
  final String firstName;
  final String lastName;
  final int age;
  final int contact;
  final int power;
  final int discipline;
  final int speed;
  final int control;
  final int stamina;
  final int range;
  final int hands;
  final int arm;

  /// Hidden per-cluster ceilings (0-99) assigned at generation time; ratings
  /// grow toward these and never exceed them. See context/player-ratings.md
  /// "Career Progression: Potential & Aging".
  final int battingPotential;
  final int pitchingPotential;
  final int fieldingPotential;
  final int speedPotential;

  /// Games remaining before this player is available again (0 = healthy).
  final int gamesUnavailable;
  const Player({
    required this.id,
    this.organizationId,
    this.teamId,
    this.rosterSlot,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.contact,
    required this.power,
    required this.discipline,
    required this.speed,
    required this.control,
    required this.stamina,
    required this.range,
    required this.hands,
    required this.arm,
    required this.battingPotential,
    required this.pitchingPotential,
    required this.fieldingPotential,
    required this.speedPotential,
    required this.gamesUnavailable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<int>(organizationId);
    }
    if (!nullToAbsent || teamId != null) {
      map['team_id'] = Variable<int>(teamId);
    }
    if (!nullToAbsent || rosterSlot != null) {
      map['roster_slot'] = Variable<int>(
        $PlayersTable.$converterrosterSlotn.toSql(rosterSlot),
      );
    }
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['age'] = Variable<int>(age);
    map['contact'] = Variable<int>(contact);
    map['power'] = Variable<int>(power);
    map['discipline'] = Variable<int>(discipline);
    map['speed'] = Variable<int>(speed);
    map['control'] = Variable<int>(control);
    map['stamina'] = Variable<int>(stamina);
    map['range'] = Variable<int>(range);
    map['hands'] = Variable<int>(hands);
    map['arm'] = Variable<int>(arm);
    map['batting_potential'] = Variable<int>(battingPotential);
    map['pitching_potential'] = Variable<int>(pitchingPotential);
    map['fielding_potential'] = Variable<int>(fieldingPotential);
    map['speed_potential'] = Variable<int>(speedPotential);
    map['games_unavailable'] = Variable<int>(gamesUnavailable);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      teamId: teamId == null && nullToAbsent
          ? const Value.absent()
          : Value(teamId),
      rosterSlot: rosterSlot == null && nullToAbsent
          ? const Value.absent()
          : Value(rosterSlot),
      firstName: Value(firstName),
      lastName: Value(lastName),
      age: Value(age),
      contact: Value(contact),
      power: Value(power),
      discipline: Value(discipline),
      speed: Value(speed),
      control: Value(control),
      stamina: Value(stamina),
      range: Value(range),
      hands: Value(hands),
      arm: Value(arm),
      battingPotential: Value(battingPotential),
      pitchingPotential: Value(pitchingPotential),
      fieldingPotential: Value(fieldingPotential),
      speedPotential: Value(speedPotential),
      gamesUnavailable: Value(gamesUnavailable),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      organizationId: serializer.fromJson<int?>(json['organizationId']),
      teamId: serializer.fromJson<int?>(json['teamId']),
      rosterSlot: $PlayersTable.$converterrosterSlotn.fromJson(
        serializer.fromJson<int?>(json['rosterSlot']),
      ),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      age: serializer.fromJson<int>(json['age']),
      contact: serializer.fromJson<int>(json['contact']),
      power: serializer.fromJson<int>(json['power']),
      discipline: serializer.fromJson<int>(json['discipline']),
      speed: serializer.fromJson<int>(json['speed']),
      control: serializer.fromJson<int>(json['control']),
      stamina: serializer.fromJson<int>(json['stamina']),
      range: serializer.fromJson<int>(json['range']),
      hands: serializer.fromJson<int>(json['hands']),
      arm: serializer.fromJson<int>(json['arm']),
      battingPotential: serializer.fromJson<int>(json['battingPotential']),
      pitchingPotential: serializer.fromJson<int>(json['pitchingPotential']),
      fieldingPotential: serializer.fromJson<int>(json['fieldingPotential']),
      speedPotential: serializer.fromJson<int>(json['speedPotential']),
      gamesUnavailable: serializer.fromJson<int>(json['gamesUnavailable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organizationId': serializer.toJson<int?>(organizationId),
      'teamId': serializer.toJson<int?>(teamId),
      'rosterSlot': serializer.toJson<int?>(
        $PlayersTable.$converterrosterSlotn.toJson(rosterSlot),
      ),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'age': serializer.toJson<int>(age),
      'contact': serializer.toJson<int>(contact),
      'power': serializer.toJson<int>(power),
      'discipline': serializer.toJson<int>(discipline),
      'speed': serializer.toJson<int>(speed),
      'control': serializer.toJson<int>(control),
      'stamina': serializer.toJson<int>(stamina),
      'range': serializer.toJson<int>(range),
      'hands': serializer.toJson<int>(hands),
      'arm': serializer.toJson<int>(arm),
      'battingPotential': serializer.toJson<int>(battingPotential),
      'pitchingPotential': serializer.toJson<int>(pitchingPotential),
      'fieldingPotential': serializer.toJson<int>(fieldingPotential),
      'speedPotential': serializer.toJson<int>(speedPotential),
      'gamesUnavailable': serializer.toJson<int>(gamesUnavailable),
    };
  }

  Player copyWith({
    int? id,
    Value<int?> organizationId = const Value.absent(),
    Value<int?> teamId = const Value.absent(),
    Value<RosterSlot?> rosterSlot = const Value.absent(),
    String? firstName,
    String? lastName,
    int? age,
    int? contact,
    int? power,
    int? discipline,
    int? speed,
    int? control,
    int? stamina,
    int? range,
    int? hands,
    int? arm,
    int? battingPotential,
    int? pitchingPotential,
    int? fieldingPotential,
    int? speedPotential,
    int? gamesUnavailable,
  }) => Player(
    id: id ?? this.id,
    organizationId: organizationId.present
        ? organizationId.value
        : this.organizationId,
    teamId: teamId.present ? teamId.value : this.teamId,
    rosterSlot: rosterSlot.present ? rosterSlot.value : this.rosterSlot,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    age: age ?? this.age,
    contact: contact ?? this.contact,
    power: power ?? this.power,
    discipline: discipline ?? this.discipline,
    speed: speed ?? this.speed,
    control: control ?? this.control,
    stamina: stamina ?? this.stamina,
    range: range ?? this.range,
    hands: hands ?? this.hands,
    arm: arm ?? this.arm,
    battingPotential: battingPotential ?? this.battingPotential,
    pitchingPotential: pitchingPotential ?? this.pitchingPotential,
    fieldingPotential: fieldingPotential ?? this.fieldingPotential,
    speedPotential: speedPotential ?? this.speedPotential,
    gamesUnavailable: gamesUnavailable ?? this.gamesUnavailable,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      rosterSlot: data.rosterSlot.present
          ? data.rosterSlot.value
          : this.rosterSlot,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      age: data.age.present ? data.age.value : this.age,
      contact: data.contact.present ? data.contact.value : this.contact,
      power: data.power.present ? data.power.value : this.power,
      discipline: data.discipline.present
          ? data.discipline.value
          : this.discipline,
      speed: data.speed.present ? data.speed.value : this.speed,
      control: data.control.present ? data.control.value : this.control,
      stamina: data.stamina.present ? data.stamina.value : this.stamina,
      range: data.range.present ? data.range.value : this.range,
      hands: data.hands.present ? data.hands.value : this.hands,
      arm: data.arm.present ? data.arm.value : this.arm,
      battingPotential: data.battingPotential.present
          ? data.battingPotential.value
          : this.battingPotential,
      pitchingPotential: data.pitchingPotential.present
          ? data.pitchingPotential.value
          : this.pitchingPotential,
      fieldingPotential: data.fieldingPotential.present
          ? data.fieldingPotential.value
          : this.fieldingPotential,
      speedPotential: data.speedPotential.present
          ? data.speedPotential.value
          : this.speedPotential,
      gamesUnavailable: data.gamesUnavailable.present
          ? data.gamesUnavailable.value
          : this.gamesUnavailable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('teamId: $teamId, ')
          ..write('rosterSlot: $rosterSlot, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('age: $age, ')
          ..write('contact: $contact, ')
          ..write('power: $power, ')
          ..write('discipline: $discipline, ')
          ..write('speed: $speed, ')
          ..write('control: $control, ')
          ..write('stamina: $stamina, ')
          ..write('range: $range, ')
          ..write('hands: $hands, ')
          ..write('arm: $arm, ')
          ..write('battingPotential: $battingPotential, ')
          ..write('pitchingPotential: $pitchingPotential, ')
          ..write('fieldingPotential: $fieldingPotential, ')
          ..write('speedPotential: $speedPotential, ')
          ..write('gamesUnavailable: $gamesUnavailable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    organizationId,
    teamId,
    rosterSlot,
    firstName,
    lastName,
    age,
    contact,
    power,
    discipline,
    speed,
    control,
    stamina,
    range,
    hands,
    arm,
    battingPotential,
    pitchingPotential,
    fieldingPotential,
    speedPotential,
    gamesUnavailable,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.teamId == this.teamId &&
          other.rosterSlot == this.rosterSlot &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.age == this.age &&
          other.contact == this.contact &&
          other.power == this.power &&
          other.discipline == this.discipline &&
          other.speed == this.speed &&
          other.control == this.control &&
          other.stamina == this.stamina &&
          other.range == this.range &&
          other.hands == this.hands &&
          other.arm == this.arm &&
          other.battingPotential == this.battingPotential &&
          other.pitchingPotential == this.pitchingPotential &&
          other.fieldingPotential == this.fieldingPotential &&
          other.speedPotential == this.speedPotential &&
          other.gamesUnavailable == this.gamesUnavailable);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<int?> organizationId;
  final Value<int?> teamId;
  final Value<RosterSlot?> rosterSlot;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<int> age;
  final Value<int> contact;
  final Value<int> power;
  final Value<int> discipline;
  final Value<int> speed;
  final Value<int> control;
  final Value<int> stamina;
  final Value<int> range;
  final Value<int> hands;
  final Value<int> arm;
  final Value<int> battingPotential;
  final Value<int> pitchingPotential;
  final Value<int> fieldingPotential;
  final Value<int> speedPotential;
  final Value<int> gamesUnavailable;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.rosterSlot = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.age = const Value.absent(),
    this.contact = const Value.absent(),
    this.power = const Value.absent(),
    this.discipline = const Value.absent(),
    this.speed = const Value.absent(),
    this.control = const Value.absent(),
    this.stamina = const Value.absent(),
    this.range = const Value.absent(),
    this.hands = const Value.absent(),
    this.arm = const Value.absent(),
    this.battingPotential = const Value.absent(),
    this.pitchingPotential = const Value.absent(),
    this.fieldingPotential = const Value.absent(),
    this.speedPotential = const Value.absent(),
    this.gamesUnavailable = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.rosterSlot = const Value.absent(),
    required String firstName,
    required String lastName,
    required int age,
    required int contact,
    required int power,
    required int discipline,
    required int speed,
    required int control,
    required int stamina,
    required int range,
    required int hands,
    required int arm,
    required int battingPotential,
    required int pitchingPotential,
    required int fieldingPotential,
    required int speedPotential,
    this.gamesUnavailable = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       age = Value(age),
       contact = Value(contact),
       power = Value(power),
       discipline = Value(discipline),
       speed = Value(speed),
       control = Value(control),
       stamina = Value(stamina),
       range = Value(range),
       hands = Value(hands),
       arm = Value(arm),
       battingPotential = Value(battingPotential),
       pitchingPotential = Value(pitchingPotential),
       fieldingPotential = Value(fieldingPotential),
       speedPotential = Value(speedPotential);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<int>? organizationId,
    Expression<int>? teamId,
    Expression<int>? rosterSlot,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<int>? age,
    Expression<int>? contact,
    Expression<int>? power,
    Expression<int>? discipline,
    Expression<int>? speed,
    Expression<int>? control,
    Expression<int>? stamina,
    Expression<int>? range,
    Expression<int>? hands,
    Expression<int>? arm,
    Expression<int>? battingPotential,
    Expression<int>? pitchingPotential,
    Expression<int>? fieldingPotential,
    Expression<int>? speedPotential,
    Expression<int>? gamesUnavailable,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (teamId != null) 'team_id': teamId,
      if (rosterSlot != null) 'roster_slot': rosterSlot,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (age != null) 'age': age,
      if (contact != null) 'contact': contact,
      if (power != null) 'power': power,
      if (discipline != null) 'discipline': discipline,
      if (speed != null) 'speed': speed,
      if (control != null) 'control': control,
      if (stamina != null) 'stamina': stamina,
      if (range != null) 'range': range,
      if (hands != null) 'hands': hands,
      if (arm != null) 'arm': arm,
      if (battingPotential != null) 'batting_potential': battingPotential,
      if (pitchingPotential != null) 'pitching_potential': pitchingPotential,
      if (fieldingPotential != null) 'fielding_potential': fieldingPotential,
      if (speedPotential != null) 'speed_potential': speedPotential,
      if (gamesUnavailable != null) 'games_unavailable': gamesUnavailable,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<int?>? organizationId,
    Value<int?>? teamId,
    Value<RosterSlot?>? rosterSlot,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<int>? age,
    Value<int>? contact,
    Value<int>? power,
    Value<int>? discipline,
    Value<int>? speed,
    Value<int>? control,
    Value<int>? stamina,
    Value<int>? range,
    Value<int>? hands,
    Value<int>? arm,
    Value<int>? battingPotential,
    Value<int>? pitchingPotential,
    Value<int>? fieldingPotential,
    Value<int>? speedPotential,
    Value<int>? gamesUnavailable,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      teamId: teamId ?? this.teamId,
      rosterSlot: rosterSlot ?? this.rosterSlot,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      contact: contact ?? this.contact,
      power: power ?? this.power,
      discipline: discipline ?? this.discipline,
      speed: speed ?? this.speed,
      control: control ?? this.control,
      stamina: stamina ?? this.stamina,
      range: range ?? this.range,
      hands: hands ?? this.hands,
      arm: arm ?? this.arm,
      battingPotential: battingPotential ?? this.battingPotential,
      pitchingPotential: pitchingPotential ?? this.pitchingPotential,
      fieldingPotential: fieldingPotential ?? this.fieldingPotential,
      speedPotential: speedPotential ?? this.speedPotential,
      gamesUnavailable: gamesUnavailable ?? this.gamesUnavailable,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<int>(organizationId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (rosterSlot.present) {
      map['roster_slot'] = Variable<int>(
        $PlayersTable.$converterrosterSlotn.toSql(rosterSlot.value),
      );
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (contact.present) {
      map['contact'] = Variable<int>(contact.value);
    }
    if (power.present) {
      map['power'] = Variable<int>(power.value);
    }
    if (discipline.present) {
      map['discipline'] = Variable<int>(discipline.value);
    }
    if (speed.present) {
      map['speed'] = Variable<int>(speed.value);
    }
    if (control.present) {
      map['control'] = Variable<int>(control.value);
    }
    if (stamina.present) {
      map['stamina'] = Variable<int>(stamina.value);
    }
    if (range.present) {
      map['range'] = Variable<int>(range.value);
    }
    if (hands.present) {
      map['hands'] = Variable<int>(hands.value);
    }
    if (arm.present) {
      map['arm'] = Variable<int>(arm.value);
    }
    if (battingPotential.present) {
      map['batting_potential'] = Variable<int>(battingPotential.value);
    }
    if (pitchingPotential.present) {
      map['pitching_potential'] = Variable<int>(pitchingPotential.value);
    }
    if (fieldingPotential.present) {
      map['fielding_potential'] = Variable<int>(fieldingPotential.value);
    }
    if (speedPotential.present) {
      map['speed_potential'] = Variable<int>(speedPotential.value);
    }
    if (gamesUnavailable.present) {
      map['games_unavailable'] = Variable<int>(gamesUnavailable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('teamId: $teamId, ')
          ..write('rosterSlot: $rosterSlot, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('age: $age, ')
          ..write('contact: $contact, ')
          ..write('power: $power, ')
          ..write('discipline: $discipline, ')
          ..write('speed: $speed, ')
          ..write('control: $control, ')
          ..write('stamina: $stamina, ')
          ..write('range: $range, ')
          ..write('hands: $hands, ')
          ..write('arm: $arm, ')
          ..write('battingPotential: $battingPotential, ')
          ..write('pitchingPotential: $pitchingPotential, ')
          ..write('fieldingPotential: $fieldingPotential, ')
          ..write('speedPotential: $speedPotential, ')
          ..write('gamesUnavailable: $gamesUnavailable')
          ..write(')'))
        .toString();
  }
}

class $PlayerPitchesTable extends PlayerPitches
    with TableInfo<$PlayerPitchesTable, PlayerPitche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerPitchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PitchType, int> pitchType =
      GeneratedColumn<int>(
        'pitch_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PitchType>($PlayerPitchesTable.$converterpitchType);
  static const VerificationMeta _movementMeta = const VerificationMeta(
    'movement',
  );
  @override
  late final GeneratedColumn<int> movement = GeneratedColumn<int>(
    'movement',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, playerId, pitchType, movement];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_pitches';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerPitche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('movement')) {
      context.handle(
        _movementMeta,
        movement.isAcceptableOrUnknown(data['movement']!, _movementMeta),
      );
    } else if (isInserting) {
      context.missing(_movementMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {playerId, pitchType},
  ];
  @override
  PlayerPitche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerPitche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      pitchType: $PlayerPitchesTable.$converterpitchType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}pitch_type'],
        )!,
      ),
      movement: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movement'],
      )!,
    );
  }

  @override
  $PlayerPitchesTable createAlias(String alias) {
    return $PlayerPitchesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PitchType, int, int> $converterpitchType =
      const EnumIndexConverter<PitchType>(PitchType.values);
}

class PlayerPitche extends DataClass implements Insertable<PlayerPitche> {
  final int id;
  final int playerId;
  final PitchType pitchType;
  final int movement;
  const PlayerPitche({
    required this.id,
    required this.playerId,
    required this.pitchType,
    required this.movement,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['player_id'] = Variable<int>(playerId);
    {
      map['pitch_type'] = Variable<int>(
        $PlayerPitchesTable.$converterpitchType.toSql(pitchType),
      );
    }
    map['movement'] = Variable<int>(movement);
    return map;
  }

  PlayerPitchesCompanion toCompanion(bool nullToAbsent) {
    return PlayerPitchesCompanion(
      id: Value(id),
      playerId: Value(playerId),
      pitchType: Value(pitchType),
      movement: Value(movement),
    );
  }

  factory PlayerPitche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerPitche(
      id: serializer.fromJson<int>(json['id']),
      playerId: serializer.fromJson<int>(json['playerId']),
      pitchType: $PlayerPitchesTable.$converterpitchType.fromJson(
        serializer.fromJson<int>(json['pitchType']),
      ),
      movement: serializer.fromJson<int>(json['movement']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playerId': serializer.toJson<int>(playerId),
      'pitchType': serializer.toJson<int>(
        $PlayerPitchesTable.$converterpitchType.toJson(pitchType),
      ),
      'movement': serializer.toJson<int>(movement),
    };
  }

  PlayerPitche copyWith({
    int? id,
    int? playerId,
    PitchType? pitchType,
    int? movement,
  }) => PlayerPitche(
    id: id ?? this.id,
    playerId: playerId ?? this.playerId,
    pitchType: pitchType ?? this.pitchType,
    movement: movement ?? this.movement,
  );
  PlayerPitche copyWithCompanion(PlayerPitchesCompanion data) {
    return PlayerPitche(
      id: data.id.present ? data.id.value : this.id,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      pitchType: data.pitchType.present ? data.pitchType.value : this.pitchType,
      movement: data.movement.present ? data.movement.value : this.movement,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerPitche(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('pitchType: $pitchType, ')
          ..write('movement: $movement')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playerId, pitchType, movement);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerPitche &&
          other.id == this.id &&
          other.playerId == this.playerId &&
          other.pitchType == this.pitchType &&
          other.movement == this.movement);
}

class PlayerPitchesCompanion extends UpdateCompanion<PlayerPitche> {
  final Value<int> id;
  final Value<int> playerId;
  final Value<PitchType> pitchType;
  final Value<int> movement;
  const PlayerPitchesCompanion({
    this.id = const Value.absent(),
    this.playerId = const Value.absent(),
    this.pitchType = const Value.absent(),
    this.movement = const Value.absent(),
  });
  PlayerPitchesCompanion.insert({
    this.id = const Value.absent(),
    required int playerId,
    required PitchType pitchType,
    required int movement,
  }) : playerId = Value(playerId),
       pitchType = Value(pitchType),
       movement = Value(movement);
  static Insertable<PlayerPitche> custom({
    Expression<int>? id,
    Expression<int>? playerId,
    Expression<int>? pitchType,
    Expression<int>? movement,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playerId != null) 'player_id': playerId,
      if (pitchType != null) 'pitch_type': pitchType,
      if (movement != null) 'movement': movement,
    });
  }

  PlayerPitchesCompanion copyWith({
    Value<int>? id,
    Value<int>? playerId,
    Value<PitchType>? pitchType,
    Value<int>? movement,
  }) {
    return PlayerPitchesCompanion(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      pitchType: pitchType ?? this.pitchType,
      movement: movement ?? this.movement,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (pitchType.present) {
      map['pitch_type'] = Variable<int>(
        $PlayerPitchesTable.$converterpitchType.toSql(pitchType.value),
      );
    }
    if (movement.present) {
      map['movement'] = Variable<int>(movement.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerPitchesCompanion(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('pitchType: $pitchType, ')
          ..write('movement: $movement')
          ..write(')'))
        .toString();
  }
}

class $BattingStatsTable extends BattingStats
    with TableInfo<$BattingStatsTable, BattingStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BattingStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _gsMeta = const VerificationMeta('gs');
  @override
  late final GeneratedColumn<bool> gs = GeneratedColumn<bool>(
    'gs',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gs" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _paMeta = const VerificationMeta('pa');
  @override
  late final GeneratedColumn<int> pa = GeneratedColumn<int>(
    'pa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _abMeta = const VerificationMeta('ab');
  @override
  late final GeneratedColumn<int> ab = GeneratedColumn<int>(
    'ab',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rMeta = const VerificationMeta('r');
  @override
  late final GeneratedColumn<int> r = GeneratedColumn<int>(
    'r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hMeta = const VerificationMeta('h');
  @override
  late final GeneratedColumn<int> h = GeneratedColumn<int>(
    'h',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _doublesMeta = const VerificationMeta(
    'doubles',
  );
  @override
  late final GeneratedColumn<int> doubles = GeneratedColumn<int>(
    'doubles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _triplesMeta = const VerificationMeta(
    'triples',
  );
  @override
  late final GeneratedColumn<int> triples = GeneratedColumn<int>(
    'triples',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hrMeta = const VerificationMeta('hr');
  @override
  late final GeneratedColumn<int> hr = GeneratedColumn<int>(
    'hr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rbiMeta = const VerificationMeta('rbi');
  @override
  late final GeneratedColumn<int> rbi = GeneratedColumn<int>(
    'rbi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bbMeta = const VerificationMeta('bb');
  @override
  late final GeneratedColumn<int> bb = GeneratedColumn<int>(
    'bb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kMeta = const VerificationMeta('k');
  @override
  late final GeneratedColumn<int> k = GeneratedColumn<int>(
    'k',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hbpMeta = const VerificationMeta('hbp');
  @override
  late final GeneratedColumn<int> hbp = GeneratedColumn<int>(
    'hbp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ibbMeta = const VerificationMeta('ibb');
  @override
  late final GeneratedColumn<int> ibb = GeneratedColumn<int>(
    'ibb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sbMeta = const VerificationMeta('sb');
  @override
  late final GeneratedColumn<int> sb = GeneratedColumn<int>(
    'sb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _csMeta = const VerificationMeta('cs');
  @override
  late final GeneratedColumn<int> cs = GeneratedColumn<int>(
    'cs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _shMeta = const VerificationMeta('sh');
  @override
  late final GeneratedColumn<int> sh = GeneratedColumn<int>(
    'sh',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sfMeta = const VerificationMeta('sf');
  @override
  late final GeneratedColumn<int> sf = GeneratedColumn<int>(
    'sf',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dpMeta = const VerificationMeta('dp');
  @override
  late final GeneratedColumn<int> dp = GeneratedColumn<int>(
    'dp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _roeMeta = const VerificationMeta('roe');
  @override
  late final GeneratedColumn<int> roe = GeneratedColumn<int>(
    'roe',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fcMeta = const VerificationMeta('fc');
  @override
  late final GeneratedColumn<int> fc = GeneratedColumn<int>(
    'fc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lobMeta = const VerificationMeta('lob');
  @override
  late final GeneratedColumn<int> lob = GeneratedColumn<int>(
    'lob',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    playerId,
    teamId,
    gs,
    pa,
    ab,
    r,
    h,
    doubles,
    triples,
    hr,
    rbi,
    bb,
    k,
    hbp,
    ibb,
    sb,
    cs,
    sh,
    sf,
    dp,
    roe,
    fc,
    lob,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batting_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<BattingStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('gs')) {
      context.handle(_gsMeta, gs.isAcceptableOrUnknown(data['gs']!, _gsMeta));
    }
    if (data.containsKey('pa')) {
      context.handle(_paMeta, pa.isAcceptableOrUnknown(data['pa']!, _paMeta));
    }
    if (data.containsKey('ab')) {
      context.handle(_abMeta, ab.isAcceptableOrUnknown(data['ab']!, _abMeta));
    }
    if (data.containsKey('r')) {
      context.handle(_rMeta, r.isAcceptableOrUnknown(data['r']!, _rMeta));
    }
    if (data.containsKey('h')) {
      context.handle(_hMeta, h.isAcceptableOrUnknown(data['h']!, _hMeta));
    }
    if (data.containsKey('doubles')) {
      context.handle(
        _doublesMeta,
        doubles.isAcceptableOrUnknown(data['doubles']!, _doublesMeta),
      );
    }
    if (data.containsKey('triples')) {
      context.handle(
        _triplesMeta,
        triples.isAcceptableOrUnknown(data['triples']!, _triplesMeta),
      );
    }
    if (data.containsKey('hr')) {
      context.handle(_hrMeta, hr.isAcceptableOrUnknown(data['hr']!, _hrMeta));
    }
    if (data.containsKey('rbi')) {
      context.handle(
        _rbiMeta,
        rbi.isAcceptableOrUnknown(data['rbi']!, _rbiMeta),
      );
    }
    if (data.containsKey('bb')) {
      context.handle(_bbMeta, bb.isAcceptableOrUnknown(data['bb']!, _bbMeta));
    }
    if (data.containsKey('k')) {
      context.handle(_kMeta, k.isAcceptableOrUnknown(data['k']!, _kMeta));
    }
    if (data.containsKey('hbp')) {
      context.handle(
        _hbpMeta,
        hbp.isAcceptableOrUnknown(data['hbp']!, _hbpMeta),
      );
    }
    if (data.containsKey('ibb')) {
      context.handle(
        _ibbMeta,
        ibb.isAcceptableOrUnknown(data['ibb']!, _ibbMeta),
      );
    }
    if (data.containsKey('sb')) {
      context.handle(_sbMeta, sb.isAcceptableOrUnknown(data['sb']!, _sbMeta));
    }
    if (data.containsKey('cs')) {
      context.handle(_csMeta, cs.isAcceptableOrUnknown(data['cs']!, _csMeta));
    }
    if (data.containsKey('sh')) {
      context.handle(_shMeta, sh.isAcceptableOrUnknown(data['sh']!, _shMeta));
    }
    if (data.containsKey('sf')) {
      context.handle(_sfMeta, sf.isAcceptableOrUnknown(data['sf']!, _sfMeta));
    }
    if (data.containsKey('dp')) {
      context.handle(_dpMeta, dp.isAcceptableOrUnknown(data['dp']!, _dpMeta));
    }
    if (data.containsKey('roe')) {
      context.handle(
        _roeMeta,
        roe.isAcceptableOrUnknown(data['roe']!, _roeMeta),
      );
    }
    if (data.containsKey('fc')) {
      context.handle(_fcMeta, fc.isAcceptableOrUnknown(data['fc']!, _fcMeta));
    }
    if (data.containsKey('lob')) {
      context.handle(
        _lobMeta,
        lob.isAcceptableOrUnknown(data['lob']!, _lobMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {gameId, playerId},
  ];
  @override
  BattingStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BattingStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      gs: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gs'],
      )!,
      pa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pa'],
      )!,
      ab: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ab'],
      )!,
      r: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}r'],
      )!,
      h: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}h'],
      )!,
      doubles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}doubles'],
      )!,
      triples: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triples'],
      )!,
      hr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr'],
      )!,
      rbi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rbi'],
      )!,
      bb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bb'],
      )!,
      k: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}k'],
      )!,
      hbp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hbp'],
      )!,
      ibb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ibb'],
      )!,
      sb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sb'],
      )!,
      cs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cs'],
      )!,
      sh: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sh'],
      )!,
      sf: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sf'],
      )!,
      dp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dp'],
      )!,
      roe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}roe'],
      )!,
      fc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fc'],
      )!,
      lob: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lob'],
      )!,
    );
  }

  @override
  $BattingStatsTable createAlias(String alias) {
    return $BattingStatsTable(attachedDatabase, alias);
  }
}

class BattingStat extends DataClass implements Insertable<BattingStat> {
  final int id;
  final int gameId;
  final int playerId;
  final int teamId;
  final bool gs;
  final int pa;
  final int ab;
  final int r;
  final int h;
  final int doubles;
  final int triples;
  final int hr;
  final int rbi;
  final int bb;
  final int k;
  final int hbp;
  final int ibb;
  final int sb;
  final int cs;
  final int sh;
  final int sf;
  final int dp;
  final int roe;
  final int fc;
  final int lob;
  const BattingStat({
    required this.id,
    required this.gameId,
    required this.playerId,
    required this.teamId,
    required this.gs,
    required this.pa,
    required this.ab,
    required this.r,
    required this.h,
    required this.doubles,
    required this.triples,
    required this.hr,
    required this.rbi,
    required this.bb,
    required this.k,
    required this.hbp,
    required this.ibb,
    required this.sb,
    required this.cs,
    required this.sh,
    required this.sf,
    required this.dp,
    required this.roe,
    required this.fc,
    required this.lob,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['player_id'] = Variable<int>(playerId);
    map['team_id'] = Variable<int>(teamId);
    map['gs'] = Variable<bool>(gs);
    map['pa'] = Variable<int>(pa);
    map['ab'] = Variable<int>(ab);
    map['r'] = Variable<int>(r);
    map['h'] = Variable<int>(h);
    map['doubles'] = Variable<int>(doubles);
    map['triples'] = Variable<int>(triples);
    map['hr'] = Variable<int>(hr);
    map['rbi'] = Variable<int>(rbi);
    map['bb'] = Variable<int>(bb);
    map['k'] = Variable<int>(k);
    map['hbp'] = Variable<int>(hbp);
    map['ibb'] = Variable<int>(ibb);
    map['sb'] = Variable<int>(sb);
    map['cs'] = Variable<int>(cs);
    map['sh'] = Variable<int>(sh);
    map['sf'] = Variable<int>(sf);
    map['dp'] = Variable<int>(dp);
    map['roe'] = Variable<int>(roe);
    map['fc'] = Variable<int>(fc);
    map['lob'] = Variable<int>(lob);
    return map;
  }

  BattingStatsCompanion toCompanion(bool nullToAbsent) {
    return BattingStatsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      playerId: Value(playerId),
      teamId: Value(teamId),
      gs: Value(gs),
      pa: Value(pa),
      ab: Value(ab),
      r: Value(r),
      h: Value(h),
      doubles: Value(doubles),
      triples: Value(triples),
      hr: Value(hr),
      rbi: Value(rbi),
      bb: Value(bb),
      k: Value(k),
      hbp: Value(hbp),
      ibb: Value(ibb),
      sb: Value(sb),
      cs: Value(cs),
      sh: Value(sh),
      sf: Value(sf),
      dp: Value(dp),
      roe: Value(roe),
      fc: Value(fc),
      lob: Value(lob),
    );
  }

  factory BattingStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BattingStat(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      teamId: serializer.fromJson<int>(json['teamId']),
      gs: serializer.fromJson<bool>(json['gs']),
      pa: serializer.fromJson<int>(json['pa']),
      ab: serializer.fromJson<int>(json['ab']),
      r: serializer.fromJson<int>(json['r']),
      h: serializer.fromJson<int>(json['h']),
      doubles: serializer.fromJson<int>(json['doubles']),
      triples: serializer.fromJson<int>(json['triples']),
      hr: serializer.fromJson<int>(json['hr']),
      rbi: serializer.fromJson<int>(json['rbi']),
      bb: serializer.fromJson<int>(json['bb']),
      k: serializer.fromJson<int>(json['k']),
      hbp: serializer.fromJson<int>(json['hbp']),
      ibb: serializer.fromJson<int>(json['ibb']),
      sb: serializer.fromJson<int>(json['sb']),
      cs: serializer.fromJson<int>(json['cs']),
      sh: serializer.fromJson<int>(json['sh']),
      sf: serializer.fromJson<int>(json['sf']),
      dp: serializer.fromJson<int>(json['dp']),
      roe: serializer.fromJson<int>(json['roe']),
      fc: serializer.fromJson<int>(json['fc']),
      lob: serializer.fromJson<int>(json['lob']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'playerId': serializer.toJson<int>(playerId),
      'teamId': serializer.toJson<int>(teamId),
      'gs': serializer.toJson<bool>(gs),
      'pa': serializer.toJson<int>(pa),
      'ab': serializer.toJson<int>(ab),
      'r': serializer.toJson<int>(r),
      'h': serializer.toJson<int>(h),
      'doubles': serializer.toJson<int>(doubles),
      'triples': serializer.toJson<int>(triples),
      'hr': serializer.toJson<int>(hr),
      'rbi': serializer.toJson<int>(rbi),
      'bb': serializer.toJson<int>(bb),
      'k': serializer.toJson<int>(k),
      'hbp': serializer.toJson<int>(hbp),
      'ibb': serializer.toJson<int>(ibb),
      'sb': serializer.toJson<int>(sb),
      'cs': serializer.toJson<int>(cs),
      'sh': serializer.toJson<int>(sh),
      'sf': serializer.toJson<int>(sf),
      'dp': serializer.toJson<int>(dp),
      'roe': serializer.toJson<int>(roe),
      'fc': serializer.toJson<int>(fc),
      'lob': serializer.toJson<int>(lob),
    };
  }

  BattingStat copyWith({
    int? id,
    int? gameId,
    int? playerId,
    int? teamId,
    bool? gs,
    int? pa,
    int? ab,
    int? r,
    int? h,
    int? doubles,
    int? triples,
    int? hr,
    int? rbi,
    int? bb,
    int? k,
    int? hbp,
    int? ibb,
    int? sb,
    int? cs,
    int? sh,
    int? sf,
    int? dp,
    int? roe,
    int? fc,
    int? lob,
  }) => BattingStat(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    playerId: playerId ?? this.playerId,
    teamId: teamId ?? this.teamId,
    gs: gs ?? this.gs,
    pa: pa ?? this.pa,
    ab: ab ?? this.ab,
    r: r ?? this.r,
    h: h ?? this.h,
    doubles: doubles ?? this.doubles,
    triples: triples ?? this.triples,
    hr: hr ?? this.hr,
    rbi: rbi ?? this.rbi,
    bb: bb ?? this.bb,
    k: k ?? this.k,
    hbp: hbp ?? this.hbp,
    ibb: ibb ?? this.ibb,
    sb: sb ?? this.sb,
    cs: cs ?? this.cs,
    sh: sh ?? this.sh,
    sf: sf ?? this.sf,
    dp: dp ?? this.dp,
    roe: roe ?? this.roe,
    fc: fc ?? this.fc,
    lob: lob ?? this.lob,
  );
  BattingStat copyWithCompanion(BattingStatsCompanion data) {
    return BattingStat(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      gs: data.gs.present ? data.gs.value : this.gs,
      pa: data.pa.present ? data.pa.value : this.pa,
      ab: data.ab.present ? data.ab.value : this.ab,
      r: data.r.present ? data.r.value : this.r,
      h: data.h.present ? data.h.value : this.h,
      doubles: data.doubles.present ? data.doubles.value : this.doubles,
      triples: data.triples.present ? data.triples.value : this.triples,
      hr: data.hr.present ? data.hr.value : this.hr,
      rbi: data.rbi.present ? data.rbi.value : this.rbi,
      bb: data.bb.present ? data.bb.value : this.bb,
      k: data.k.present ? data.k.value : this.k,
      hbp: data.hbp.present ? data.hbp.value : this.hbp,
      ibb: data.ibb.present ? data.ibb.value : this.ibb,
      sb: data.sb.present ? data.sb.value : this.sb,
      cs: data.cs.present ? data.cs.value : this.cs,
      sh: data.sh.present ? data.sh.value : this.sh,
      sf: data.sf.present ? data.sf.value : this.sf,
      dp: data.dp.present ? data.dp.value : this.dp,
      roe: data.roe.present ? data.roe.value : this.roe,
      fc: data.fc.present ? data.fc.value : this.fc,
      lob: data.lob.present ? data.lob.value : this.lob,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BattingStat(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('teamId: $teamId, ')
          ..write('gs: $gs, ')
          ..write('pa: $pa, ')
          ..write('ab: $ab, ')
          ..write('r: $r, ')
          ..write('h: $h, ')
          ..write('doubles: $doubles, ')
          ..write('triples: $triples, ')
          ..write('hr: $hr, ')
          ..write('rbi: $rbi, ')
          ..write('bb: $bb, ')
          ..write('k: $k, ')
          ..write('hbp: $hbp, ')
          ..write('ibb: $ibb, ')
          ..write('sb: $sb, ')
          ..write('cs: $cs, ')
          ..write('sh: $sh, ')
          ..write('sf: $sf, ')
          ..write('dp: $dp, ')
          ..write('roe: $roe, ')
          ..write('fc: $fc, ')
          ..write('lob: $lob')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    gameId,
    playerId,
    teamId,
    gs,
    pa,
    ab,
    r,
    h,
    doubles,
    triples,
    hr,
    rbi,
    bb,
    k,
    hbp,
    ibb,
    sb,
    cs,
    sh,
    sf,
    dp,
    roe,
    fc,
    lob,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattingStat &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.playerId == this.playerId &&
          other.teamId == this.teamId &&
          other.gs == this.gs &&
          other.pa == this.pa &&
          other.ab == this.ab &&
          other.r == this.r &&
          other.h == this.h &&
          other.doubles == this.doubles &&
          other.triples == this.triples &&
          other.hr == this.hr &&
          other.rbi == this.rbi &&
          other.bb == this.bb &&
          other.k == this.k &&
          other.hbp == this.hbp &&
          other.ibb == this.ibb &&
          other.sb == this.sb &&
          other.cs == this.cs &&
          other.sh == this.sh &&
          other.sf == this.sf &&
          other.dp == this.dp &&
          other.roe == this.roe &&
          other.fc == this.fc &&
          other.lob == this.lob);
}

class BattingStatsCompanion extends UpdateCompanion<BattingStat> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> playerId;
  final Value<int> teamId;
  final Value<bool> gs;
  final Value<int> pa;
  final Value<int> ab;
  final Value<int> r;
  final Value<int> h;
  final Value<int> doubles;
  final Value<int> triples;
  final Value<int> hr;
  final Value<int> rbi;
  final Value<int> bb;
  final Value<int> k;
  final Value<int> hbp;
  final Value<int> ibb;
  final Value<int> sb;
  final Value<int> cs;
  final Value<int> sh;
  final Value<int> sf;
  final Value<int> dp;
  final Value<int> roe;
  final Value<int> fc;
  final Value<int> lob;
  const BattingStatsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.gs = const Value.absent(),
    this.pa = const Value.absent(),
    this.ab = const Value.absent(),
    this.r = const Value.absent(),
    this.h = const Value.absent(),
    this.doubles = const Value.absent(),
    this.triples = const Value.absent(),
    this.hr = const Value.absent(),
    this.rbi = const Value.absent(),
    this.bb = const Value.absent(),
    this.k = const Value.absent(),
    this.hbp = const Value.absent(),
    this.ibb = const Value.absent(),
    this.sb = const Value.absent(),
    this.cs = const Value.absent(),
    this.sh = const Value.absent(),
    this.sf = const Value.absent(),
    this.dp = const Value.absent(),
    this.roe = const Value.absent(),
    this.fc = const Value.absent(),
    this.lob = const Value.absent(),
  });
  BattingStatsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int playerId,
    required int teamId,
    this.gs = const Value.absent(),
    this.pa = const Value.absent(),
    this.ab = const Value.absent(),
    this.r = const Value.absent(),
    this.h = const Value.absent(),
    this.doubles = const Value.absent(),
    this.triples = const Value.absent(),
    this.hr = const Value.absent(),
    this.rbi = const Value.absent(),
    this.bb = const Value.absent(),
    this.k = const Value.absent(),
    this.hbp = const Value.absent(),
    this.ibb = const Value.absent(),
    this.sb = const Value.absent(),
    this.cs = const Value.absent(),
    this.sh = const Value.absent(),
    this.sf = const Value.absent(),
    this.dp = const Value.absent(),
    this.roe = const Value.absent(),
    this.fc = const Value.absent(),
    this.lob = const Value.absent(),
  }) : gameId = Value(gameId),
       playerId = Value(playerId),
       teamId = Value(teamId);
  static Insertable<BattingStat> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? playerId,
    Expression<int>? teamId,
    Expression<bool>? gs,
    Expression<int>? pa,
    Expression<int>? ab,
    Expression<int>? r,
    Expression<int>? h,
    Expression<int>? doubles,
    Expression<int>? triples,
    Expression<int>? hr,
    Expression<int>? rbi,
    Expression<int>? bb,
    Expression<int>? k,
    Expression<int>? hbp,
    Expression<int>? ibb,
    Expression<int>? sb,
    Expression<int>? cs,
    Expression<int>? sh,
    Expression<int>? sf,
    Expression<int>? dp,
    Expression<int>? roe,
    Expression<int>? fc,
    Expression<int>? lob,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (playerId != null) 'player_id': playerId,
      if (teamId != null) 'team_id': teamId,
      if (gs != null) 'gs': gs,
      if (pa != null) 'pa': pa,
      if (ab != null) 'ab': ab,
      if (r != null) 'r': r,
      if (h != null) 'h': h,
      if (doubles != null) 'doubles': doubles,
      if (triples != null) 'triples': triples,
      if (hr != null) 'hr': hr,
      if (rbi != null) 'rbi': rbi,
      if (bb != null) 'bb': bb,
      if (k != null) 'k': k,
      if (hbp != null) 'hbp': hbp,
      if (ibb != null) 'ibb': ibb,
      if (sb != null) 'sb': sb,
      if (cs != null) 'cs': cs,
      if (sh != null) 'sh': sh,
      if (sf != null) 'sf': sf,
      if (dp != null) 'dp': dp,
      if (roe != null) 'roe': roe,
      if (fc != null) 'fc': fc,
      if (lob != null) 'lob': lob,
    });
  }

  BattingStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<int>? playerId,
    Value<int>? teamId,
    Value<bool>? gs,
    Value<int>? pa,
    Value<int>? ab,
    Value<int>? r,
    Value<int>? h,
    Value<int>? doubles,
    Value<int>? triples,
    Value<int>? hr,
    Value<int>? rbi,
    Value<int>? bb,
    Value<int>? k,
    Value<int>? hbp,
    Value<int>? ibb,
    Value<int>? sb,
    Value<int>? cs,
    Value<int>? sh,
    Value<int>? sf,
    Value<int>? dp,
    Value<int>? roe,
    Value<int>? fc,
    Value<int>? lob,
  }) {
    return BattingStatsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      playerId: playerId ?? this.playerId,
      teamId: teamId ?? this.teamId,
      gs: gs ?? this.gs,
      pa: pa ?? this.pa,
      ab: ab ?? this.ab,
      r: r ?? this.r,
      h: h ?? this.h,
      doubles: doubles ?? this.doubles,
      triples: triples ?? this.triples,
      hr: hr ?? this.hr,
      rbi: rbi ?? this.rbi,
      bb: bb ?? this.bb,
      k: k ?? this.k,
      hbp: hbp ?? this.hbp,
      ibb: ibb ?? this.ibb,
      sb: sb ?? this.sb,
      cs: cs ?? this.cs,
      sh: sh ?? this.sh,
      sf: sf ?? this.sf,
      dp: dp ?? this.dp,
      roe: roe ?? this.roe,
      fc: fc ?? this.fc,
      lob: lob ?? this.lob,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (gs.present) {
      map['gs'] = Variable<bool>(gs.value);
    }
    if (pa.present) {
      map['pa'] = Variable<int>(pa.value);
    }
    if (ab.present) {
      map['ab'] = Variable<int>(ab.value);
    }
    if (r.present) {
      map['r'] = Variable<int>(r.value);
    }
    if (h.present) {
      map['h'] = Variable<int>(h.value);
    }
    if (doubles.present) {
      map['doubles'] = Variable<int>(doubles.value);
    }
    if (triples.present) {
      map['triples'] = Variable<int>(triples.value);
    }
    if (hr.present) {
      map['hr'] = Variable<int>(hr.value);
    }
    if (rbi.present) {
      map['rbi'] = Variable<int>(rbi.value);
    }
    if (bb.present) {
      map['bb'] = Variable<int>(bb.value);
    }
    if (k.present) {
      map['k'] = Variable<int>(k.value);
    }
    if (hbp.present) {
      map['hbp'] = Variable<int>(hbp.value);
    }
    if (ibb.present) {
      map['ibb'] = Variable<int>(ibb.value);
    }
    if (sb.present) {
      map['sb'] = Variable<int>(sb.value);
    }
    if (cs.present) {
      map['cs'] = Variable<int>(cs.value);
    }
    if (sh.present) {
      map['sh'] = Variable<int>(sh.value);
    }
    if (sf.present) {
      map['sf'] = Variable<int>(sf.value);
    }
    if (dp.present) {
      map['dp'] = Variable<int>(dp.value);
    }
    if (roe.present) {
      map['roe'] = Variable<int>(roe.value);
    }
    if (fc.present) {
      map['fc'] = Variable<int>(fc.value);
    }
    if (lob.present) {
      map['lob'] = Variable<int>(lob.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BattingStatsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('teamId: $teamId, ')
          ..write('gs: $gs, ')
          ..write('pa: $pa, ')
          ..write('ab: $ab, ')
          ..write('r: $r, ')
          ..write('h: $h, ')
          ..write('doubles: $doubles, ')
          ..write('triples: $triples, ')
          ..write('hr: $hr, ')
          ..write('rbi: $rbi, ')
          ..write('bb: $bb, ')
          ..write('k: $k, ')
          ..write('hbp: $hbp, ')
          ..write('ibb: $ibb, ')
          ..write('sb: $sb, ')
          ..write('cs: $cs, ')
          ..write('sh: $sh, ')
          ..write('sf: $sf, ')
          ..write('dp: $dp, ')
          ..write('roe: $roe, ')
          ..write('fc: $fc, ')
          ..write('lob: $lob')
          ..write(')'))
        .toString();
  }
}

class $PitchingStatsTable extends PitchingStats
    with TableInfo<$PitchingStatsTable, PitchingStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PitchingStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _gsMeta = const VerificationMeta('gs');
  @override
  late final GeneratedColumn<bool> gs = GeneratedColumn<bool>(
    'gs',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gs" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cgMeta = const VerificationMeta('cg');
  @override
  late final GeneratedColumn<bool> cg = GeneratedColumn<bool>(
    'cg',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cg" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _outsRecordedMeta = const VerificationMeta(
    'outsRecorded',
  );
  @override
  late final GeneratedColumn<int> outsRecorded = GeneratedColumn<int>(
    'outs_recorded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rMeta = const VerificationMeta('r');
  @override
  late final GeneratedColumn<int> r = GeneratedColumn<int>(
    'r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _erMeta = const VerificationMeta('er');
  @override
  late final GeneratedColumn<int> er = GeneratedColumn<int>(
    'er',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hMeta = const VerificationMeta('h');
  @override
  late final GeneratedColumn<int> h = GeneratedColumn<int>(
    'h',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bbMeta = const VerificationMeta('bb');
  @override
  late final GeneratedColumn<int> bb = GeneratedColumn<int>(
    'bb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hbpMeta = const VerificationMeta('hbp');
  @override
  late final GeneratedColumn<int> hbp = GeneratedColumn<int>(
    'hbp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ibbMeta = const VerificationMeta('ibb');
  @override
  late final GeneratedColumn<int> ibb = GeneratedColumn<int>(
    'ibb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kMeta = const VerificationMeta('k');
  @override
  late final GeneratedColumn<int> k = GeneratedColumn<int>(
    'k',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wMeta = const VerificationMeta('w');
  @override
  late final GeneratedColumn<int> w = GeneratedColumn<int>(
    'w',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lMeta = const VerificationMeta('l');
  @override
  late final GeneratedColumn<int> l = GeneratedColumn<int>(
    'l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sMeta = const VerificationMeta('s');
  @override
  late final GeneratedColumn<int> s = GeneratedColumn<int>(
    's',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hldMeta = const VerificationMeta('hld');
  @override
  late final GeneratedColumn<int> hld = GeneratedColumn<int>(
    'hld',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bsMeta = const VerificationMeta('bs');
  @override
  late final GeneratedColumn<int> bs = GeneratedColumn<int>(
    'bs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wpMeta = const VerificationMeta('wp');
  @override
  late final GeneratedColumn<int> wp = GeneratedColumn<int>(
    'wp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    playerId,
    teamId,
    gs,
    cg,
    outsRecorded,
    r,
    er,
    h,
    bb,
    hbp,
    ibb,
    k,
    w,
    l,
    s,
    hld,
    bs,
    wp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pitching_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<PitchingStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('gs')) {
      context.handle(_gsMeta, gs.isAcceptableOrUnknown(data['gs']!, _gsMeta));
    }
    if (data.containsKey('cg')) {
      context.handle(_cgMeta, cg.isAcceptableOrUnknown(data['cg']!, _cgMeta));
    }
    if (data.containsKey('outs_recorded')) {
      context.handle(
        _outsRecordedMeta,
        outsRecorded.isAcceptableOrUnknown(
          data['outs_recorded']!,
          _outsRecordedMeta,
        ),
      );
    }
    if (data.containsKey('r')) {
      context.handle(_rMeta, r.isAcceptableOrUnknown(data['r']!, _rMeta));
    }
    if (data.containsKey('er')) {
      context.handle(_erMeta, er.isAcceptableOrUnknown(data['er']!, _erMeta));
    }
    if (data.containsKey('h')) {
      context.handle(_hMeta, h.isAcceptableOrUnknown(data['h']!, _hMeta));
    }
    if (data.containsKey('bb')) {
      context.handle(_bbMeta, bb.isAcceptableOrUnknown(data['bb']!, _bbMeta));
    }
    if (data.containsKey('hbp')) {
      context.handle(
        _hbpMeta,
        hbp.isAcceptableOrUnknown(data['hbp']!, _hbpMeta),
      );
    }
    if (data.containsKey('ibb')) {
      context.handle(
        _ibbMeta,
        ibb.isAcceptableOrUnknown(data['ibb']!, _ibbMeta),
      );
    }
    if (data.containsKey('k')) {
      context.handle(_kMeta, k.isAcceptableOrUnknown(data['k']!, _kMeta));
    }
    if (data.containsKey('w')) {
      context.handle(_wMeta, w.isAcceptableOrUnknown(data['w']!, _wMeta));
    }
    if (data.containsKey('l')) {
      context.handle(_lMeta, l.isAcceptableOrUnknown(data['l']!, _lMeta));
    }
    if (data.containsKey('s')) {
      context.handle(_sMeta, s.isAcceptableOrUnknown(data['s']!, _sMeta));
    }
    if (data.containsKey('hld')) {
      context.handle(
        _hldMeta,
        hld.isAcceptableOrUnknown(data['hld']!, _hldMeta),
      );
    }
    if (data.containsKey('bs')) {
      context.handle(_bsMeta, bs.isAcceptableOrUnknown(data['bs']!, _bsMeta));
    }
    if (data.containsKey('wp')) {
      context.handle(_wpMeta, wp.isAcceptableOrUnknown(data['wp']!, _wpMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {gameId, playerId},
  ];
  @override
  PitchingStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PitchingStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      gs: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gs'],
      )!,
      cg: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cg'],
      )!,
      outsRecorded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outs_recorded'],
      )!,
      r: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}r'],
      )!,
      er: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}er'],
      )!,
      h: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}h'],
      )!,
      bb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bb'],
      )!,
      hbp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hbp'],
      )!,
      ibb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ibb'],
      )!,
      k: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}k'],
      )!,
      w: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}w'],
      )!,
      l: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}l'],
      )!,
      s: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}s'],
      )!,
      hld: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hld'],
      )!,
      bs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bs'],
      )!,
      wp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wp'],
      )!,
    );
  }

  @override
  $PitchingStatsTable createAlias(String alias) {
    return $PitchingStatsTable(attachedDatabase, alias);
  }
}

class PitchingStat extends DataClass implements Insertable<PitchingStat> {
  final int id;
  final int gameId;
  final int playerId;
  final int teamId;
  final bool gs;
  final bool cg;
  final int outsRecorded;
  final int r;
  final int er;
  final int h;
  final int bb;
  final int hbp;
  final int ibb;
  final int k;
  final int w;
  final int l;
  final int s;
  final int hld;
  final int bs;
  final int wp;
  const PitchingStat({
    required this.id,
    required this.gameId,
    required this.playerId,
    required this.teamId,
    required this.gs,
    required this.cg,
    required this.outsRecorded,
    required this.r,
    required this.er,
    required this.h,
    required this.bb,
    required this.hbp,
    required this.ibb,
    required this.k,
    required this.w,
    required this.l,
    required this.s,
    required this.hld,
    required this.bs,
    required this.wp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['player_id'] = Variable<int>(playerId);
    map['team_id'] = Variable<int>(teamId);
    map['gs'] = Variable<bool>(gs);
    map['cg'] = Variable<bool>(cg);
    map['outs_recorded'] = Variable<int>(outsRecorded);
    map['r'] = Variable<int>(r);
    map['er'] = Variable<int>(er);
    map['h'] = Variable<int>(h);
    map['bb'] = Variable<int>(bb);
    map['hbp'] = Variable<int>(hbp);
    map['ibb'] = Variable<int>(ibb);
    map['k'] = Variable<int>(k);
    map['w'] = Variable<int>(w);
    map['l'] = Variable<int>(l);
    map['s'] = Variable<int>(s);
    map['hld'] = Variable<int>(hld);
    map['bs'] = Variable<int>(bs);
    map['wp'] = Variable<int>(wp);
    return map;
  }

  PitchingStatsCompanion toCompanion(bool nullToAbsent) {
    return PitchingStatsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      playerId: Value(playerId),
      teamId: Value(teamId),
      gs: Value(gs),
      cg: Value(cg),
      outsRecorded: Value(outsRecorded),
      r: Value(r),
      er: Value(er),
      h: Value(h),
      bb: Value(bb),
      hbp: Value(hbp),
      ibb: Value(ibb),
      k: Value(k),
      w: Value(w),
      l: Value(l),
      s: Value(s),
      hld: Value(hld),
      bs: Value(bs),
      wp: Value(wp),
    );
  }

  factory PitchingStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PitchingStat(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      teamId: serializer.fromJson<int>(json['teamId']),
      gs: serializer.fromJson<bool>(json['gs']),
      cg: serializer.fromJson<bool>(json['cg']),
      outsRecorded: serializer.fromJson<int>(json['outsRecorded']),
      r: serializer.fromJson<int>(json['r']),
      er: serializer.fromJson<int>(json['er']),
      h: serializer.fromJson<int>(json['h']),
      bb: serializer.fromJson<int>(json['bb']),
      hbp: serializer.fromJson<int>(json['hbp']),
      ibb: serializer.fromJson<int>(json['ibb']),
      k: serializer.fromJson<int>(json['k']),
      w: serializer.fromJson<int>(json['w']),
      l: serializer.fromJson<int>(json['l']),
      s: serializer.fromJson<int>(json['s']),
      hld: serializer.fromJson<int>(json['hld']),
      bs: serializer.fromJson<int>(json['bs']),
      wp: serializer.fromJson<int>(json['wp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'playerId': serializer.toJson<int>(playerId),
      'teamId': serializer.toJson<int>(teamId),
      'gs': serializer.toJson<bool>(gs),
      'cg': serializer.toJson<bool>(cg),
      'outsRecorded': serializer.toJson<int>(outsRecorded),
      'r': serializer.toJson<int>(r),
      'er': serializer.toJson<int>(er),
      'h': serializer.toJson<int>(h),
      'bb': serializer.toJson<int>(bb),
      'hbp': serializer.toJson<int>(hbp),
      'ibb': serializer.toJson<int>(ibb),
      'k': serializer.toJson<int>(k),
      'w': serializer.toJson<int>(w),
      'l': serializer.toJson<int>(l),
      's': serializer.toJson<int>(s),
      'hld': serializer.toJson<int>(hld),
      'bs': serializer.toJson<int>(bs),
      'wp': serializer.toJson<int>(wp),
    };
  }

  PitchingStat copyWith({
    int? id,
    int? gameId,
    int? playerId,
    int? teamId,
    bool? gs,
    bool? cg,
    int? outsRecorded,
    int? r,
    int? er,
    int? h,
    int? bb,
    int? hbp,
    int? ibb,
    int? k,
    int? w,
    int? l,
    int? s,
    int? hld,
    int? bs,
    int? wp,
  }) => PitchingStat(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    playerId: playerId ?? this.playerId,
    teamId: teamId ?? this.teamId,
    gs: gs ?? this.gs,
    cg: cg ?? this.cg,
    outsRecorded: outsRecorded ?? this.outsRecorded,
    r: r ?? this.r,
    er: er ?? this.er,
    h: h ?? this.h,
    bb: bb ?? this.bb,
    hbp: hbp ?? this.hbp,
    ibb: ibb ?? this.ibb,
    k: k ?? this.k,
    w: w ?? this.w,
    l: l ?? this.l,
    s: s ?? this.s,
    hld: hld ?? this.hld,
    bs: bs ?? this.bs,
    wp: wp ?? this.wp,
  );
  PitchingStat copyWithCompanion(PitchingStatsCompanion data) {
    return PitchingStat(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      gs: data.gs.present ? data.gs.value : this.gs,
      cg: data.cg.present ? data.cg.value : this.cg,
      outsRecorded: data.outsRecorded.present
          ? data.outsRecorded.value
          : this.outsRecorded,
      r: data.r.present ? data.r.value : this.r,
      er: data.er.present ? data.er.value : this.er,
      h: data.h.present ? data.h.value : this.h,
      bb: data.bb.present ? data.bb.value : this.bb,
      hbp: data.hbp.present ? data.hbp.value : this.hbp,
      ibb: data.ibb.present ? data.ibb.value : this.ibb,
      k: data.k.present ? data.k.value : this.k,
      w: data.w.present ? data.w.value : this.w,
      l: data.l.present ? data.l.value : this.l,
      s: data.s.present ? data.s.value : this.s,
      hld: data.hld.present ? data.hld.value : this.hld,
      bs: data.bs.present ? data.bs.value : this.bs,
      wp: data.wp.present ? data.wp.value : this.wp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PitchingStat(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('teamId: $teamId, ')
          ..write('gs: $gs, ')
          ..write('cg: $cg, ')
          ..write('outsRecorded: $outsRecorded, ')
          ..write('r: $r, ')
          ..write('er: $er, ')
          ..write('h: $h, ')
          ..write('bb: $bb, ')
          ..write('hbp: $hbp, ')
          ..write('ibb: $ibb, ')
          ..write('k: $k, ')
          ..write('w: $w, ')
          ..write('l: $l, ')
          ..write('s: $s, ')
          ..write('hld: $hld, ')
          ..write('bs: $bs, ')
          ..write('wp: $wp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    playerId,
    teamId,
    gs,
    cg,
    outsRecorded,
    r,
    er,
    h,
    bb,
    hbp,
    ibb,
    k,
    w,
    l,
    s,
    hld,
    bs,
    wp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PitchingStat &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.playerId == this.playerId &&
          other.teamId == this.teamId &&
          other.gs == this.gs &&
          other.cg == this.cg &&
          other.outsRecorded == this.outsRecorded &&
          other.r == this.r &&
          other.er == this.er &&
          other.h == this.h &&
          other.bb == this.bb &&
          other.hbp == this.hbp &&
          other.ibb == this.ibb &&
          other.k == this.k &&
          other.w == this.w &&
          other.l == this.l &&
          other.s == this.s &&
          other.hld == this.hld &&
          other.bs == this.bs &&
          other.wp == this.wp);
}

class PitchingStatsCompanion extends UpdateCompanion<PitchingStat> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> playerId;
  final Value<int> teamId;
  final Value<bool> gs;
  final Value<bool> cg;
  final Value<int> outsRecorded;
  final Value<int> r;
  final Value<int> er;
  final Value<int> h;
  final Value<int> bb;
  final Value<int> hbp;
  final Value<int> ibb;
  final Value<int> k;
  final Value<int> w;
  final Value<int> l;
  final Value<int> s;
  final Value<int> hld;
  final Value<int> bs;
  final Value<int> wp;
  const PitchingStatsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.gs = const Value.absent(),
    this.cg = const Value.absent(),
    this.outsRecorded = const Value.absent(),
    this.r = const Value.absent(),
    this.er = const Value.absent(),
    this.h = const Value.absent(),
    this.bb = const Value.absent(),
    this.hbp = const Value.absent(),
    this.ibb = const Value.absent(),
    this.k = const Value.absent(),
    this.w = const Value.absent(),
    this.l = const Value.absent(),
    this.s = const Value.absent(),
    this.hld = const Value.absent(),
    this.bs = const Value.absent(),
    this.wp = const Value.absent(),
  });
  PitchingStatsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int playerId,
    required int teamId,
    this.gs = const Value.absent(),
    this.cg = const Value.absent(),
    this.outsRecorded = const Value.absent(),
    this.r = const Value.absent(),
    this.er = const Value.absent(),
    this.h = const Value.absent(),
    this.bb = const Value.absent(),
    this.hbp = const Value.absent(),
    this.ibb = const Value.absent(),
    this.k = const Value.absent(),
    this.w = const Value.absent(),
    this.l = const Value.absent(),
    this.s = const Value.absent(),
    this.hld = const Value.absent(),
    this.bs = const Value.absent(),
    this.wp = const Value.absent(),
  }) : gameId = Value(gameId),
       playerId = Value(playerId),
       teamId = Value(teamId);
  static Insertable<PitchingStat> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? playerId,
    Expression<int>? teamId,
    Expression<bool>? gs,
    Expression<bool>? cg,
    Expression<int>? outsRecorded,
    Expression<int>? r,
    Expression<int>? er,
    Expression<int>? h,
    Expression<int>? bb,
    Expression<int>? hbp,
    Expression<int>? ibb,
    Expression<int>? k,
    Expression<int>? w,
    Expression<int>? l,
    Expression<int>? s,
    Expression<int>? hld,
    Expression<int>? bs,
    Expression<int>? wp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (playerId != null) 'player_id': playerId,
      if (teamId != null) 'team_id': teamId,
      if (gs != null) 'gs': gs,
      if (cg != null) 'cg': cg,
      if (outsRecorded != null) 'outs_recorded': outsRecorded,
      if (r != null) 'r': r,
      if (er != null) 'er': er,
      if (h != null) 'h': h,
      if (bb != null) 'bb': bb,
      if (hbp != null) 'hbp': hbp,
      if (ibb != null) 'ibb': ibb,
      if (k != null) 'k': k,
      if (w != null) 'w': w,
      if (l != null) 'l': l,
      if (s != null) 's': s,
      if (hld != null) 'hld': hld,
      if (bs != null) 'bs': bs,
      if (wp != null) 'wp': wp,
    });
  }

  PitchingStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<int>? playerId,
    Value<int>? teamId,
    Value<bool>? gs,
    Value<bool>? cg,
    Value<int>? outsRecorded,
    Value<int>? r,
    Value<int>? er,
    Value<int>? h,
    Value<int>? bb,
    Value<int>? hbp,
    Value<int>? ibb,
    Value<int>? k,
    Value<int>? w,
    Value<int>? l,
    Value<int>? s,
    Value<int>? hld,
    Value<int>? bs,
    Value<int>? wp,
  }) {
    return PitchingStatsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      playerId: playerId ?? this.playerId,
      teamId: teamId ?? this.teamId,
      gs: gs ?? this.gs,
      cg: cg ?? this.cg,
      outsRecorded: outsRecorded ?? this.outsRecorded,
      r: r ?? this.r,
      er: er ?? this.er,
      h: h ?? this.h,
      bb: bb ?? this.bb,
      hbp: hbp ?? this.hbp,
      ibb: ibb ?? this.ibb,
      k: k ?? this.k,
      w: w ?? this.w,
      l: l ?? this.l,
      s: s ?? this.s,
      hld: hld ?? this.hld,
      bs: bs ?? this.bs,
      wp: wp ?? this.wp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (gs.present) {
      map['gs'] = Variable<bool>(gs.value);
    }
    if (cg.present) {
      map['cg'] = Variable<bool>(cg.value);
    }
    if (outsRecorded.present) {
      map['outs_recorded'] = Variable<int>(outsRecorded.value);
    }
    if (r.present) {
      map['r'] = Variable<int>(r.value);
    }
    if (er.present) {
      map['er'] = Variable<int>(er.value);
    }
    if (h.present) {
      map['h'] = Variable<int>(h.value);
    }
    if (bb.present) {
      map['bb'] = Variable<int>(bb.value);
    }
    if (hbp.present) {
      map['hbp'] = Variable<int>(hbp.value);
    }
    if (ibb.present) {
      map['ibb'] = Variable<int>(ibb.value);
    }
    if (k.present) {
      map['k'] = Variable<int>(k.value);
    }
    if (w.present) {
      map['w'] = Variable<int>(w.value);
    }
    if (l.present) {
      map['l'] = Variable<int>(l.value);
    }
    if (s.present) {
      map['s'] = Variable<int>(s.value);
    }
    if (hld.present) {
      map['hld'] = Variable<int>(hld.value);
    }
    if (bs.present) {
      map['bs'] = Variable<int>(bs.value);
    }
    if (wp.present) {
      map['wp'] = Variable<int>(wp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PitchingStatsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('teamId: $teamId, ')
          ..write('gs: $gs, ')
          ..write('cg: $cg, ')
          ..write('outsRecorded: $outsRecorded, ')
          ..write('r: $r, ')
          ..write('er: $er, ')
          ..write('h: $h, ')
          ..write('bb: $bb, ')
          ..write('hbp: $hbp, ')
          ..write('ibb: $ibb, ')
          ..write('k: $k, ')
          ..write('w: $w, ')
          ..write('l: $l, ')
          ..write('s: $s, ')
          ..write('hld: $hld, ')
          ..write('bs: $bs, ')
          ..write('wp: $wp')
          ..write(')'))
        .toString();
  }
}

class $FieldingStatsTable extends FieldingStats
    with TableInfo<$FieldingStatsTable, FieldingStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldingStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _gsMeta = const VerificationMeta('gs');
  @override
  late final GeneratedColumn<bool> gs = GeneratedColumn<bool>(
    'gs',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gs" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _outsPlayedMeta = const VerificationMeta(
    'outsPlayed',
  );
  @override
  late final GeneratedColumn<int> outsPlayed = GeneratedColumn<int>(
    'outs_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tcMeta = const VerificationMeta('tc');
  @override
  late final GeneratedColumn<int> tc = GeneratedColumn<int>(
    'tc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _poMeta = const VerificationMeta('po');
  @override
  late final GeneratedColumn<int> po = GeneratedColumn<int>(
    'po',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _aMeta = const VerificationMeta('a');
  @override
  late final GeneratedColumn<int> a = GeneratedColumn<int>(
    'a',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _eMeta = const VerificationMeta('e');
  @override
  late final GeneratedColumn<int> e = GeneratedColumn<int>(
    'e',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dpMeta = const VerificationMeta('dp');
  @override
  late final GeneratedColumn<int> dp = GeneratedColumn<int>(
    'dp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pbMeta = const VerificationMeta('pb');
  @override
  late final GeneratedColumn<int> pb = GeneratedColumn<int>(
    'pb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sbMeta = const VerificationMeta('sb');
  @override
  late final GeneratedColumn<int> sb = GeneratedColumn<int>(
    'sb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _csMeta = const VerificationMeta('cs');
  @override
  late final GeneratedColumn<int> cs = GeneratedColumn<int>(
    'cs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    playerId,
    teamId,
    gs,
    outsPlayed,
    tc,
    po,
    a,
    e,
    dp,
    pb,
    sb,
    cs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fielding_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<FieldingStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('gs')) {
      context.handle(_gsMeta, gs.isAcceptableOrUnknown(data['gs']!, _gsMeta));
    }
    if (data.containsKey('outs_played')) {
      context.handle(
        _outsPlayedMeta,
        outsPlayed.isAcceptableOrUnknown(data['outs_played']!, _outsPlayedMeta),
      );
    }
    if (data.containsKey('tc')) {
      context.handle(_tcMeta, tc.isAcceptableOrUnknown(data['tc']!, _tcMeta));
    }
    if (data.containsKey('po')) {
      context.handle(_poMeta, po.isAcceptableOrUnknown(data['po']!, _poMeta));
    }
    if (data.containsKey('a')) {
      context.handle(_aMeta, a.isAcceptableOrUnknown(data['a']!, _aMeta));
    }
    if (data.containsKey('e')) {
      context.handle(_eMeta, e.isAcceptableOrUnknown(data['e']!, _eMeta));
    }
    if (data.containsKey('dp')) {
      context.handle(_dpMeta, dp.isAcceptableOrUnknown(data['dp']!, _dpMeta));
    }
    if (data.containsKey('pb')) {
      context.handle(_pbMeta, pb.isAcceptableOrUnknown(data['pb']!, _pbMeta));
    }
    if (data.containsKey('sb')) {
      context.handle(_sbMeta, sb.isAcceptableOrUnknown(data['sb']!, _sbMeta));
    }
    if (data.containsKey('cs')) {
      context.handle(_csMeta, cs.isAcceptableOrUnknown(data['cs']!, _csMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {gameId, playerId},
  ];
  @override
  FieldingStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FieldingStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      gs: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gs'],
      )!,
      outsPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outs_played'],
      )!,
      tc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tc'],
      )!,
      po: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}po'],
      )!,
      a: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}a'],
      )!,
      e: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}e'],
      )!,
      dp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dp'],
      )!,
      pb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pb'],
      )!,
      sb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sb'],
      )!,
      cs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cs'],
      )!,
    );
  }

  @override
  $FieldingStatsTable createAlias(String alias) {
    return $FieldingStatsTable(attachedDatabase, alias);
  }
}

class FieldingStat extends DataClass implements Insertable<FieldingStat> {
  final int id;
  final int gameId;
  final int playerId;
  final int teamId;
  final bool gs;
  final int outsPlayed;
  final int tc;
  final int po;
  final int a;
  final int e;
  final int dp;
  final int pb;
  final int sb;
  final int cs;
  const FieldingStat({
    required this.id,
    required this.gameId,
    required this.playerId,
    required this.teamId,
    required this.gs,
    required this.outsPlayed,
    required this.tc,
    required this.po,
    required this.a,
    required this.e,
    required this.dp,
    required this.pb,
    required this.sb,
    required this.cs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['player_id'] = Variable<int>(playerId);
    map['team_id'] = Variable<int>(teamId);
    map['gs'] = Variable<bool>(gs);
    map['outs_played'] = Variable<int>(outsPlayed);
    map['tc'] = Variable<int>(tc);
    map['po'] = Variable<int>(po);
    map['a'] = Variable<int>(a);
    map['e'] = Variable<int>(e);
    map['dp'] = Variable<int>(dp);
    map['pb'] = Variable<int>(pb);
    map['sb'] = Variable<int>(sb);
    map['cs'] = Variable<int>(cs);
    return map;
  }

  FieldingStatsCompanion toCompanion(bool nullToAbsent) {
    return FieldingStatsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      playerId: Value(playerId),
      teamId: Value(teamId),
      gs: Value(gs),
      outsPlayed: Value(outsPlayed),
      tc: Value(tc),
      po: Value(po),
      a: Value(a),
      e: Value(e),
      dp: Value(dp),
      pb: Value(pb),
      sb: Value(sb),
      cs: Value(cs),
    );
  }

  factory FieldingStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FieldingStat(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      teamId: serializer.fromJson<int>(json['teamId']),
      gs: serializer.fromJson<bool>(json['gs']),
      outsPlayed: serializer.fromJson<int>(json['outsPlayed']),
      tc: serializer.fromJson<int>(json['tc']),
      po: serializer.fromJson<int>(json['po']),
      a: serializer.fromJson<int>(json['a']),
      e: serializer.fromJson<int>(json['e']),
      dp: serializer.fromJson<int>(json['dp']),
      pb: serializer.fromJson<int>(json['pb']),
      sb: serializer.fromJson<int>(json['sb']),
      cs: serializer.fromJson<int>(json['cs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'playerId': serializer.toJson<int>(playerId),
      'teamId': serializer.toJson<int>(teamId),
      'gs': serializer.toJson<bool>(gs),
      'outsPlayed': serializer.toJson<int>(outsPlayed),
      'tc': serializer.toJson<int>(tc),
      'po': serializer.toJson<int>(po),
      'a': serializer.toJson<int>(a),
      'e': serializer.toJson<int>(e),
      'dp': serializer.toJson<int>(dp),
      'pb': serializer.toJson<int>(pb),
      'sb': serializer.toJson<int>(sb),
      'cs': serializer.toJson<int>(cs),
    };
  }

  FieldingStat copyWith({
    int? id,
    int? gameId,
    int? playerId,
    int? teamId,
    bool? gs,
    int? outsPlayed,
    int? tc,
    int? po,
    int? a,
    int? e,
    int? dp,
    int? pb,
    int? sb,
    int? cs,
  }) => FieldingStat(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    playerId: playerId ?? this.playerId,
    teamId: teamId ?? this.teamId,
    gs: gs ?? this.gs,
    outsPlayed: outsPlayed ?? this.outsPlayed,
    tc: tc ?? this.tc,
    po: po ?? this.po,
    a: a ?? this.a,
    e: e ?? this.e,
    dp: dp ?? this.dp,
    pb: pb ?? this.pb,
    sb: sb ?? this.sb,
    cs: cs ?? this.cs,
  );
  FieldingStat copyWithCompanion(FieldingStatsCompanion data) {
    return FieldingStat(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      gs: data.gs.present ? data.gs.value : this.gs,
      outsPlayed: data.outsPlayed.present
          ? data.outsPlayed.value
          : this.outsPlayed,
      tc: data.tc.present ? data.tc.value : this.tc,
      po: data.po.present ? data.po.value : this.po,
      a: data.a.present ? data.a.value : this.a,
      e: data.e.present ? data.e.value : this.e,
      dp: data.dp.present ? data.dp.value : this.dp,
      pb: data.pb.present ? data.pb.value : this.pb,
      sb: data.sb.present ? data.sb.value : this.sb,
      cs: data.cs.present ? data.cs.value : this.cs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FieldingStat(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('teamId: $teamId, ')
          ..write('gs: $gs, ')
          ..write('outsPlayed: $outsPlayed, ')
          ..write('tc: $tc, ')
          ..write('po: $po, ')
          ..write('a: $a, ')
          ..write('e: $e, ')
          ..write('dp: $dp, ')
          ..write('pb: $pb, ')
          ..write('sb: $sb, ')
          ..write('cs: $cs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    playerId,
    teamId,
    gs,
    outsPlayed,
    tc,
    po,
    a,
    e,
    dp,
    pb,
    sb,
    cs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldingStat &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.playerId == this.playerId &&
          other.teamId == this.teamId &&
          other.gs == this.gs &&
          other.outsPlayed == this.outsPlayed &&
          other.tc == this.tc &&
          other.po == this.po &&
          other.a == this.a &&
          other.e == this.e &&
          other.dp == this.dp &&
          other.pb == this.pb &&
          other.sb == this.sb &&
          other.cs == this.cs);
}

class FieldingStatsCompanion extends UpdateCompanion<FieldingStat> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> playerId;
  final Value<int> teamId;
  final Value<bool> gs;
  final Value<int> outsPlayed;
  final Value<int> tc;
  final Value<int> po;
  final Value<int> a;
  final Value<int> e;
  final Value<int> dp;
  final Value<int> pb;
  final Value<int> sb;
  final Value<int> cs;
  const FieldingStatsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.gs = const Value.absent(),
    this.outsPlayed = const Value.absent(),
    this.tc = const Value.absent(),
    this.po = const Value.absent(),
    this.a = const Value.absent(),
    this.e = const Value.absent(),
    this.dp = const Value.absent(),
    this.pb = const Value.absent(),
    this.sb = const Value.absent(),
    this.cs = const Value.absent(),
  });
  FieldingStatsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int playerId,
    required int teamId,
    this.gs = const Value.absent(),
    this.outsPlayed = const Value.absent(),
    this.tc = const Value.absent(),
    this.po = const Value.absent(),
    this.a = const Value.absent(),
    this.e = const Value.absent(),
    this.dp = const Value.absent(),
    this.pb = const Value.absent(),
    this.sb = const Value.absent(),
    this.cs = const Value.absent(),
  }) : gameId = Value(gameId),
       playerId = Value(playerId),
       teamId = Value(teamId);
  static Insertable<FieldingStat> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? playerId,
    Expression<int>? teamId,
    Expression<bool>? gs,
    Expression<int>? outsPlayed,
    Expression<int>? tc,
    Expression<int>? po,
    Expression<int>? a,
    Expression<int>? e,
    Expression<int>? dp,
    Expression<int>? pb,
    Expression<int>? sb,
    Expression<int>? cs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (playerId != null) 'player_id': playerId,
      if (teamId != null) 'team_id': teamId,
      if (gs != null) 'gs': gs,
      if (outsPlayed != null) 'outs_played': outsPlayed,
      if (tc != null) 'tc': tc,
      if (po != null) 'po': po,
      if (a != null) 'a': a,
      if (e != null) 'e': e,
      if (dp != null) 'dp': dp,
      if (pb != null) 'pb': pb,
      if (sb != null) 'sb': sb,
      if (cs != null) 'cs': cs,
    });
  }

  FieldingStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<int>? playerId,
    Value<int>? teamId,
    Value<bool>? gs,
    Value<int>? outsPlayed,
    Value<int>? tc,
    Value<int>? po,
    Value<int>? a,
    Value<int>? e,
    Value<int>? dp,
    Value<int>? pb,
    Value<int>? sb,
    Value<int>? cs,
  }) {
    return FieldingStatsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      playerId: playerId ?? this.playerId,
      teamId: teamId ?? this.teamId,
      gs: gs ?? this.gs,
      outsPlayed: outsPlayed ?? this.outsPlayed,
      tc: tc ?? this.tc,
      po: po ?? this.po,
      a: a ?? this.a,
      e: e ?? this.e,
      dp: dp ?? this.dp,
      pb: pb ?? this.pb,
      sb: sb ?? this.sb,
      cs: cs ?? this.cs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (gs.present) {
      map['gs'] = Variable<bool>(gs.value);
    }
    if (outsPlayed.present) {
      map['outs_played'] = Variable<int>(outsPlayed.value);
    }
    if (tc.present) {
      map['tc'] = Variable<int>(tc.value);
    }
    if (po.present) {
      map['po'] = Variable<int>(po.value);
    }
    if (a.present) {
      map['a'] = Variable<int>(a.value);
    }
    if (e.present) {
      map['e'] = Variable<int>(e.value);
    }
    if (dp.present) {
      map['dp'] = Variable<int>(dp.value);
    }
    if (pb.present) {
      map['pb'] = Variable<int>(pb.value);
    }
    if (sb.present) {
      map['sb'] = Variable<int>(sb.value);
    }
    if (cs.present) {
      map['cs'] = Variable<int>(cs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldingStatsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('teamId: $teamId, ')
          ..write('gs: $gs, ')
          ..write('outsPlayed: $outsPlayed, ')
          ..write('tc: $tc, ')
          ..write('po: $po, ')
          ..write('a: $a, ')
          ..write('e: $e, ')
          ..write('dp: $dp, ')
          ..write('pb: $pb, ')
          ..write('sb: $sb, ')
          ..write('cs: $cs')
          ..write(')'))
        .toString();
  }
}

class $StandingsTable extends Standings
    with TableInfo<$StandingsTable, Standing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StandingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES seasons (id)',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _wMeta = const VerificationMeta('w');
  @override
  late final GeneratedColumn<int> w = GeneratedColumn<int>(
    'w',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lMeta = const VerificationMeta('l');
  @override
  late final GeneratedColumn<int> l = GeneratedColumn<int>(
    'l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tMeta = const VerificationMeta('t');
  @override
  late final GeneratedColumn<int> t = GeneratedColumn<int>(
    't',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pfMeta = const VerificationMeta('pf');
  @override
  late final GeneratedColumn<int> pf = GeneratedColumn<int>(
    'pf',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paMeta = const VerificationMeta('pa');
  @override
  late final GeneratedColumn<int> pa = GeneratedColumn<int>(
    'pa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, seasonId, teamId, w, l, t, pf, pa];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'standings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Standing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('w')) {
      context.handle(_wMeta, w.isAcceptableOrUnknown(data['w']!, _wMeta));
    }
    if (data.containsKey('l')) {
      context.handle(_lMeta, l.isAcceptableOrUnknown(data['l']!, _lMeta));
    }
    if (data.containsKey('t')) {
      context.handle(_tMeta, t.isAcceptableOrUnknown(data['t']!, _tMeta));
    }
    if (data.containsKey('pf')) {
      context.handle(_pfMeta, pf.isAcceptableOrUnknown(data['pf']!, _pfMeta));
    }
    if (data.containsKey('pa')) {
      context.handle(_paMeta, pa.isAcceptableOrUnknown(data['pa']!, _paMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {seasonId, teamId},
  ];
  @override
  Standing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Standing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      w: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}w'],
      )!,
      l: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}l'],
      )!,
      t: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t'],
      )!,
      pf: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pf'],
      )!,
      pa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pa'],
      )!,
    );
  }

  @override
  $StandingsTable createAlias(String alias) {
    return $StandingsTable(attachedDatabase, alias);
  }
}

class Standing extends DataClass implements Insertable<Standing> {
  final int id;
  final int seasonId;
  final int teamId;
  final int w;
  final int l;
  final int t;
  final int pf;
  final int pa;
  const Standing({
    required this.id,
    required this.seasonId,
    required this.teamId,
    required this.w,
    required this.l,
    required this.t,
    required this.pf,
    required this.pa,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['season_id'] = Variable<int>(seasonId);
    map['team_id'] = Variable<int>(teamId);
    map['w'] = Variable<int>(w);
    map['l'] = Variable<int>(l);
    map['t'] = Variable<int>(t);
    map['pf'] = Variable<int>(pf);
    map['pa'] = Variable<int>(pa);
    return map;
  }

  StandingsCompanion toCompanion(bool nullToAbsent) {
    return StandingsCompanion(
      id: Value(id),
      seasonId: Value(seasonId),
      teamId: Value(teamId),
      w: Value(w),
      l: Value(l),
      t: Value(t),
      pf: Value(pf),
      pa: Value(pa),
    );
  }

  factory Standing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Standing(
      id: serializer.fromJson<int>(json['id']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
      teamId: serializer.fromJson<int>(json['teamId']),
      w: serializer.fromJson<int>(json['w']),
      l: serializer.fromJson<int>(json['l']),
      t: serializer.fromJson<int>(json['t']),
      pf: serializer.fromJson<int>(json['pf']),
      pa: serializer.fromJson<int>(json['pa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seasonId': serializer.toJson<int>(seasonId),
      'teamId': serializer.toJson<int>(teamId),
      'w': serializer.toJson<int>(w),
      'l': serializer.toJson<int>(l),
      't': serializer.toJson<int>(t),
      'pf': serializer.toJson<int>(pf),
      'pa': serializer.toJson<int>(pa),
    };
  }

  Standing copyWith({
    int? id,
    int? seasonId,
    int? teamId,
    int? w,
    int? l,
    int? t,
    int? pf,
    int? pa,
  }) => Standing(
    id: id ?? this.id,
    seasonId: seasonId ?? this.seasonId,
    teamId: teamId ?? this.teamId,
    w: w ?? this.w,
    l: l ?? this.l,
    t: t ?? this.t,
    pf: pf ?? this.pf,
    pa: pa ?? this.pa,
  );
  Standing copyWithCompanion(StandingsCompanion data) {
    return Standing(
      id: data.id.present ? data.id.value : this.id,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      w: data.w.present ? data.w.value : this.w,
      l: data.l.present ? data.l.value : this.l,
      t: data.t.present ? data.t.value : this.t,
      pf: data.pf.present ? data.pf.value : this.pf,
      pa: data.pa.present ? data.pa.value : this.pa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Standing(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('teamId: $teamId, ')
          ..write('w: $w, ')
          ..write('l: $l, ')
          ..write('t: $t, ')
          ..write('pf: $pf, ')
          ..write('pa: $pa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, seasonId, teamId, w, l, t, pf, pa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Standing &&
          other.id == this.id &&
          other.seasonId == this.seasonId &&
          other.teamId == this.teamId &&
          other.w == this.w &&
          other.l == this.l &&
          other.t == this.t &&
          other.pf == this.pf &&
          other.pa == this.pa);
}

class StandingsCompanion extends UpdateCompanion<Standing> {
  final Value<int> id;
  final Value<int> seasonId;
  final Value<int> teamId;
  final Value<int> w;
  final Value<int> l;
  final Value<int> t;
  final Value<int> pf;
  final Value<int> pa;
  const StandingsCompanion({
    this.id = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.teamId = const Value.absent(),
    this.w = const Value.absent(),
    this.l = const Value.absent(),
    this.t = const Value.absent(),
    this.pf = const Value.absent(),
    this.pa = const Value.absent(),
  });
  StandingsCompanion.insert({
    this.id = const Value.absent(),
    required int seasonId,
    required int teamId,
    this.w = const Value.absent(),
    this.l = const Value.absent(),
    this.t = const Value.absent(),
    this.pf = const Value.absent(),
    this.pa = const Value.absent(),
  }) : seasonId = Value(seasonId),
       teamId = Value(teamId);
  static Insertable<Standing> custom({
    Expression<int>? id,
    Expression<int>? seasonId,
    Expression<int>? teamId,
    Expression<int>? w,
    Expression<int>? l,
    Expression<int>? t,
    Expression<int>? pf,
    Expression<int>? pa,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seasonId != null) 'season_id': seasonId,
      if (teamId != null) 'team_id': teamId,
      if (w != null) 'w': w,
      if (l != null) 'l': l,
      if (t != null) 't': t,
      if (pf != null) 'pf': pf,
      if (pa != null) 'pa': pa,
    });
  }

  StandingsCompanion copyWith({
    Value<int>? id,
    Value<int>? seasonId,
    Value<int>? teamId,
    Value<int>? w,
    Value<int>? l,
    Value<int>? t,
    Value<int>? pf,
    Value<int>? pa,
  }) {
    return StandingsCompanion(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      teamId: teamId ?? this.teamId,
      w: w ?? this.w,
      l: l ?? this.l,
      t: t ?? this.t,
      pf: pf ?? this.pf,
      pa: pa ?? this.pa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (w.present) {
      map['w'] = Variable<int>(w.value);
    }
    if (l.present) {
      map['l'] = Variable<int>(l.value);
    }
    if (t.present) {
      map['t'] = Variable<int>(t.value);
    }
    if (pf.present) {
      map['pf'] = Variable<int>(pf.value);
    }
    if (pa.present) {
      map['pa'] = Variable<int>(pa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StandingsCompanion(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('teamId: $teamId, ')
          ..write('w: $w, ')
          ..write('l: $l, ')
          ..write('t: $t, ')
          ..write('pf: $pf, ')
          ..write('pa: $pa')
          ..write(')'))
        .toString();
  }
}

class $TeamLineupsTable extends TeamLineups
    with TableInfo<$TeamLineupsTable, TeamLineup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamLineupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _battingOrderMeta = const VerificationMeta(
    'battingOrder',
  );
  @override
  late final GeneratedColumn<String> battingOrder = GeneratedColumn<String>(
    'batting_order',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pitcherRotationMeta = const VerificationMeta(
    'pitcherRotation',
  );
  @override
  late final GeneratedColumn<String> pitcherRotation = GeneratedColumn<String>(
    'pitcher_rotation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fielder2IdMeta = const VerificationMeta(
    'fielder2Id',
  );
  @override
  late final GeneratedColumn<int> fielder2Id = GeneratedColumn<int>(
    'fielder2_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _fielder3IdMeta = const VerificationMeta(
    'fielder3Id',
  );
  @override
  late final GeneratedColumn<int> fielder3Id = GeneratedColumn<int>(
    'fielder3_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    teamId,
    battingOrder,
    pitcherRotation,
    fielder2Id,
    fielder3Id,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_lineups';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamLineup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('batting_order')) {
      context.handle(
        _battingOrderMeta,
        battingOrder.isAcceptableOrUnknown(
          data['batting_order']!,
          _battingOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_battingOrderMeta);
    }
    if (data.containsKey('pitcher_rotation')) {
      context.handle(
        _pitcherRotationMeta,
        pitcherRotation.isAcceptableOrUnknown(
          data['pitcher_rotation']!,
          _pitcherRotationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pitcherRotationMeta);
    }
    if (data.containsKey('fielder2_id')) {
      context.handle(
        _fielder2IdMeta,
        fielder2Id.isAcceptableOrUnknown(data['fielder2_id']!, _fielder2IdMeta),
      );
    } else if (isInserting) {
      context.missing(_fielder2IdMeta);
    }
    if (data.containsKey('fielder3_id')) {
      context.handle(
        _fielder3IdMeta,
        fielder3Id.isAcceptableOrUnknown(data['fielder3_id']!, _fielder3IdMeta),
      );
    } else if (isInserting) {
      context.missing(_fielder3IdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamLineup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamLineup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      battingOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batting_order'],
      )!,
      pitcherRotation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pitcher_rotation'],
      )!,
      fielder2Id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fielder2_id'],
      )!,
      fielder3Id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fielder3_id'],
      )!,
    );
  }

  @override
  $TeamLineupsTable createAlias(String alias) {
    return $TeamLineupsTable(attachedDatabase, alias);
  }
}

class TeamLineup extends DataClass implements Insertable<TeamLineup> {
  final int id;
  final int teamId;

  /// Ordered, comma-separated playerIds — 3-5 entries, per the ruleset's
  /// batting-lineup size. Always-DH: disjoint from [pitcherRotation].
  final String battingOrder;

  /// Ordered, comma-separated playerIds — 1+ entries (starter first).
  final String pitcherRotation;
  final int fielder2Id;
  final int fielder3Id;
  const TeamLineup({
    required this.id,
    required this.teamId,
    required this.battingOrder,
    required this.pitcherRotation,
    required this.fielder2Id,
    required this.fielder3Id,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['team_id'] = Variable<int>(teamId);
    map['batting_order'] = Variable<String>(battingOrder);
    map['pitcher_rotation'] = Variable<String>(pitcherRotation);
    map['fielder2_id'] = Variable<int>(fielder2Id);
    map['fielder3_id'] = Variable<int>(fielder3Id);
    return map;
  }

  TeamLineupsCompanion toCompanion(bool nullToAbsent) {
    return TeamLineupsCompanion(
      id: Value(id),
      teamId: Value(teamId),
      battingOrder: Value(battingOrder),
      pitcherRotation: Value(pitcherRotation),
      fielder2Id: Value(fielder2Id),
      fielder3Id: Value(fielder3Id),
    );
  }

  factory TeamLineup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamLineup(
      id: serializer.fromJson<int>(json['id']),
      teamId: serializer.fromJson<int>(json['teamId']),
      battingOrder: serializer.fromJson<String>(json['battingOrder']),
      pitcherRotation: serializer.fromJson<String>(json['pitcherRotation']),
      fielder2Id: serializer.fromJson<int>(json['fielder2Id']),
      fielder3Id: serializer.fromJson<int>(json['fielder3Id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'teamId': serializer.toJson<int>(teamId),
      'battingOrder': serializer.toJson<String>(battingOrder),
      'pitcherRotation': serializer.toJson<String>(pitcherRotation),
      'fielder2Id': serializer.toJson<int>(fielder2Id),
      'fielder3Id': serializer.toJson<int>(fielder3Id),
    };
  }

  TeamLineup copyWith({
    int? id,
    int? teamId,
    String? battingOrder,
    String? pitcherRotation,
    int? fielder2Id,
    int? fielder3Id,
  }) => TeamLineup(
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    battingOrder: battingOrder ?? this.battingOrder,
    pitcherRotation: pitcherRotation ?? this.pitcherRotation,
    fielder2Id: fielder2Id ?? this.fielder2Id,
    fielder3Id: fielder3Id ?? this.fielder3Id,
  );
  TeamLineup copyWithCompanion(TeamLineupsCompanion data) {
    return TeamLineup(
      id: data.id.present ? data.id.value : this.id,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      battingOrder: data.battingOrder.present
          ? data.battingOrder.value
          : this.battingOrder,
      pitcherRotation: data.pitcherRotation.present
          ? data.pitcherRotation.value
          : this.pitcherRotation,
      fielder2Id: data.fielder2Id.present
          ? data.fielder2Id.value
          : this.fielder2Id,
      fielder3Id: data.fielder3Id.present
          ? data.fielder3Id.value
          : this.fielder3Id,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamLineup(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('battingOrder: $battingOrder, ')
          ..write('pitcherRotation: $pitcherRotation, ')
          ..write('fielder2Id: $fielder2Id, ')
          ..write('fielder3Id: $fielder3Id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    teamId,
    battingOrder,
    pitcherRotation,
    fielder2Id,
    fielder3Id,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamLineup &&
          other.id == this.id &&
          other.teamId == this.teamId &&
          other.battingOrder == this.battingOrder &&
          other.pitcherRotation == this.pitcherRotation &&
          other.fielder2Id == this.fielder2Id &&
          other.fielder3Id == this.fielder3Id);
}

class TeamLineupsCompanion extends UpdateCompanion<TeamLineup> {
  final Value<int> id;
  final Value<int> teamId;
  final Value<String> battingOrder;
  final Value<String> pitcherRotation;
  final Value<int> fielder2Id;
  final Value<int> fielder3Id;
  const TeamLineupsCompanion({
    this.id = const Value.absent(),
    this.teamId = const Value.absent(),
    this.battingOrder = const Value.absent(),
    this.pitcherRotation = const Value.absent(),
    this.fielder2Id = const Value.absent(),
    this.fielder3Id = const Value.absent(),
  });
  TeamLineupsCompanion.insert({
    this.id = const Value.absent(),
    required int teamId,
    required String battingOrder,
    required String pitcherRotation,
    required int fielder2Id,
    required int fielder3Id,
  }) : teamId = Value(teamId),
       battingOrder = Value(battingOrder),
       pitcherRotation = Value(pitcherRotation),
       fielder2Id = Value(fielder2Id),
       fielder3Id = Value(fielder3Id);
  static Insertable<TeamLineup> custom({
    Expression<int>? id,
    Expression<int>? teamId,
    Expression<String>? battingOrder,
    Expression<String>? pitcherRotation,
    Expression<int>? fielder2Id,
    Expression<int>? fielder3Id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teamId != null) 'team_id': teamId,
      if (battingOrder != null) 'batting_order': battingOrder,
      if (pitcherRotation != null) 'pitcher_rotation': pitcherRotation,
      if (fielder2Id != null) 'fielder2_id': fielder2Id,
      if (fielder3Id != null) 'fielder3_id': fielder3Id,
    });
  }

  TeamLineupsCompanion copyWith({
    Value<int>? id,
    Value<int>? teamId,
    Value<String>? battingOrder,
    Value<String>? pitcherRotation,
    Value<int>? fielder2Id,
    Value<int>? fielder3Id,
  }) {
    return TeamLineupsCompanion(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      battingOrder: battingOrder ?? this.battingOrder,
      pitcherRotation: pitcherRotation ?? this.pitcherRotation,
      fielder2Id: fielder2Id ?? this.fielder2Id,
      fielder3Id: fielder3Id ?? this.fielder3Id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (battingOrder.present) {
      map['batting_order'] = Variable<String>(battingOrder.value);
    }
    if (pitcherRotation.present) {
      map['pitcher_rotation'] = Variable<String>(pitcherRotation.value);
    }
    if (fielder2Id.present) {
      map['fielder2_id'] = Variable<int>(fielder2Id.value);
    }
    if (fielder3Id.present) {
      map['fielder3_id'] = Variable<int>(fielder3Id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamLineupsCompanion(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('battingOrder: $battingOrder, ')
          ..write('pitcherRotation: $pitcherRotation, ')
          ..write('fielder2Id: $fielder2Id, ')
          ..write('fielder3Id: $fielder3Id')
          ..write(')'))
        .toString();
  }
}

class $InjuriesTable extends Injuries with TableInfo<$InjuriesTable, Injury> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InjuriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES seasons (id)',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<InjurySeverity, int> severity =
      GeneratedColumn<int>(
        'severity',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<InjurySeverity>($InjuriesTable.$converterseverity);
  static const VerificationMeta _gamesMissedMeta = const VerificationMeta(
    'gamesMissed',
  );
  @override
  late final GeneratedColumn<int> gamesMissed = GeneratedColumn<int>(
    'games_missed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _replacementPlayerIdMeta =
      const VerificationMeta('replacementPlayerId');
  @override
  late final GeneratedColumn<int> replacementPlayerId = GeneratedColumn<int>(
    'replacement_player_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    playerId,
    seasonId,
    gameId,
    severity,
    gamesMissed,
    replacementPlayerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'injuries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Injury> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('games_missed')) {
      context.handle(
        _gamesMissedMeta,
        gamesMissed.isAcceptableOrUnknown(
          data['games_missed']!,
          _gamesMissedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gamesMissedMeta);
    }
    if (data.containsKey('replacement_player_id')) {
      context.handle(
        _replacementPlayerIdMeta,
        replacementPlayerId.isAcceptableOrUnknown(
          data['replacement_player_id']!,
          _replacementPlayerIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Injury map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Injury(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      severity: $InjuriesTable.$converterseverity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}severity'],
        )!,
      ),
      gamesMissed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_missed'],
      )!,
      replacementPlayerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}replacement_player_id'],
      ),
    );
  }

  @override
  $InjuriesTable createAlias(String alias) {
    return $InjuriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InjurySeverity, int, int> $converterseverity =
      const EnumIndexConverter<InjurySeverity>(InjurySeverity.values);
}

class Injury extends DataClass implements Insertable<Injury> {
  final int id;
  final int playerId;
  final int seasonId;
  final int gameId;
  final InjurySeverity severity;
  final int gamesMissed;
  final int? replacementPlayerId;
  const Injury({
    required this.id,
    required this.playerId,
    required this.seasonId,
    required this.gameId,
    required this.severity,
    required this.gamesMissed,
    this.replacementPlayerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['player_id'] = Variable<int>(playerId);
    map['season_id'] = Variable<int>(seasonId);
    map['game_id'] = Variable<int>(gameId);
    {
      map['severity'] = Variable<int>(
        $InjuriesTable.$converterseverity.toSql(severity),
      );
    }
    map['games_missed'] = Variable<int>(gamesMissed);
    if (!nullToAbsent || replacementPlayerId != null) {
      map['replacement_player_id'] = Variable<int>(replacementPlayerId);
    }
    return map;
  }

  InjuriesCompanion toCompanion(bool nullToAbsent) {
    return InjuriesCompanion(
      id: Value(id),
      playerId: Value(playerId),
      seasonId: Value(seasonId),
      gameId: Value(gameId),
      severity: Value(severity),
      gamesMissed: Value(gamesMissed),
      replacementPlayerId: replacementPlayerId == null && nullToAbsent
          ? const Value.absent()
          : Value(replacementPlayerId),
    );
  }

  factory Injury.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Injury(
      id: serializer.fromJson<int>(json['id']),
      playerId: serializer.fromJson<int>(json['playerId']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
      gameId: serializer.fromJson<int>(json['gameId']),
      severity: $InjuriesTable.$converterseverity.fromJson(
        serializer.fromJson<int>(json['severity']),
      ),
      gamesMissed: serializer.fromJson<int>(json['gamesMissed']),
      replacementPlayerId: serializer.fromJson<int?>(
        json['replacementPlayerId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playerId': serializer.toJson<int>(playerId),
      'seasonId': serializer.toJson<int>(seasonId),
      'gameId': serializer.toJson<int>(gameId),
      'severity': serializer.toJson<int>(
        $InjuriesTable.$converterseverity.toJson(severity),
      ),
      'gamesMissed': serializer.toJson<int>(gamesMissed),
      'replacementPlayerId': serializer.toJson<int?>(replacementPlayerId),
    };
  }

  Injury copyWith({
    int? id,
    int? playerId,
    int? seasonId,
    int? gameId,
    InjurySeverity? severity,
    int? gamesMissed,
    Value<int?> replacementPlayerId = const Value.absent(),
  }) => Injury(
    id: id ?? this.id,
    playerId: playerId ?? this.playerId,
    seasonId: seasonId ?? this.seasonId,
    gameId: gameId ?? this.gameId,
    severity: severity ?? this.severity,
    gamesMissed: gamesMissed ?? this.gamesMissed,
    replacementPlayerId: replacementPlayerId.present
        ? replacementPlayerId.value
        : this.replacementPlayerId,
  );
  Injury copyWithCompanion(InjuriesCompanion data) {
    return Injury(
      id: data.id.present ? data.id.value : this.id,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      severity: data.severity.present ? data.severity.value : this.severity,
      gamesMissed: data.gamesMissed.present
          ? data.gamesMissed.value
          : this.gamesMissed,
      replacementPlayerId: data.replacementPlayerId.present
          ? data.replacementPlayerId.value
          : this.replacementPlayerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Injury(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('seasonId: $seasonId, ')
          ..write('gameId: $gameId, ')
          ..write('severity: $severity, ')
          ..write('gamesMissed: $gamesMissed, ')
          ..write('replacementPlayerId: $replacementPlayerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    playerId,
    seasonId,
    gameId,
    severity,
    gamesMissed,
    replacementPlayerId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Injury &&
          other.id == this.id &&
          other.playerId == this.playerId &&
          other.seasonId == this.seasonId &&
          other.gameId == this.gameId &&
          other.severity == this.severity &&
          other.gamesMissed == this.gamesMissed &&
          other.replacementPlayerId == this.replacementPlayerId);
}

class InjuriesCompanion extends UpdateCompanion<Injury> {
  final Value<int> id;
  final Value<int> playerId;
  final Value<int> seasonId;
  final Value<int> gameId;
  final Value<InjurySeverity> severity;
  final Value<int> gamesMissed;
  final Value<int?> replacementPlayerId;
  const InjuriesCompanion({
    this.id = const Value.absent(),
    this.playerId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.severity = const Value.absent(),
    this.gamesMissed = const Value.absent(),
    this.replacementPlayerId = const Value.absent(),
  });
  InjuriesCompanion.insert({
    this.id = const Value.absent(),
    required int playerId,
    required int seasonId,
    required int gameId,
    required InjurySeverity severity,
    required int gamesMissed,
    this.replacementPlayerId = const Value.absent(),
  }) : playerId = Value(playerId),
       seasonId = Value(seasonId),
       gameId = Value(gameId),
       severity = Value(severity),
       gamesMissed = Value(gamesMissed);
  static Insertable<Injury> custom({
    Expression<int>? id,
    Expression<int>? playerId,
    Expression<int>? seasonId,
    Expression<int>? gameId,
    Expression<int>? severity,
    Expression<int>? gamesMissed,
    Expression<int>? replacementPlayerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playerId != null) 'player_id': playerId,
      if (seasonId != null) 'season_id': seasonId,
      if (gameId != null) 'game_id': gameId,
      if (severity != null) 'severity': severity,
      if (gamesMissed != null) 'games_missed': gamesMissed,
      if (replacementPlayerId != null)
        'replacement_player_id': replacementPlayerId,
    });
  }

  InjuriesCompanion copyWith({
    Value<int>? id,
    Value<int>? playerId,
    Value<int>? seasonId,
    Value<int>? gameId,
    Value<InjurySeverity>? severity,
    Value<int>? gamesMissed,
    Value<int?>? replacementPlayerId,
  }) {
    return InjuriesCompanion(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      seasonId: seasonId ?? this.seasonId,
      gameId: gameId ?? this.gameId,
      severity: severity ?? this.severity,
      gamesMissed: gamesMissed ?? this.gamesMissed,
      replacementPlayerId: replacementPlayerId ?? this.replacementPlayerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(
        $InjuriesTable.$converterseverity.toSql(severity.value),
      );
    }
    if (gamesMissed.present) {
      map['games_missed'] = Variable<int>(gamesMissed.value);
    }
    if (replacementPlayerId.present) {
      map['replacement_player_id'] = Variable<int>(replacementPlayerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InjuriesCompanion(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('seasonId: $seasonId, ')
          ..write('gameId: $gameId, ')
          ..write('severity: $severity, ')
          ..write('gamesMissed: $gamesMissed, ')
          ..write('replacementPlayerId: $replacementPlayerId')
          ..write(')'))
        .toString();
  }
}

class $DraftPicksTable extends DraftPicks
    with TableInfo<$DraftPicksTable, DraftPick> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DraftPicksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES seasons (id)',
    ),
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
    'round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overallPickMeta = const VerificationMeta(
    'overallPick',
  );
  @override
  late final GeneratedColumn<int> overallPick = GeneratedColumn<int>(
    'overall_pick',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seasonId,
    round,
    overallPick,
    teamId,
    playerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draft_picks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DraftPick> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    } else if (isInserting) {
      context.missing(_roundMeta);
    }
    if (data.containsKey('overall_pick')) {
      context.handle(
        _overallPickMeta,
        overallPick.isAcceptableOrUnknown(
          data['overall_pick']!,
          _overallPickMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_overallPickMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DraftPick map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftPick(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round'],
      )!,
      overallPick: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overall_pick'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
    );
  }

  @override
  $DraftPicksTable createAlias(String alias) {
    return $DraftPicksTable(attachedDatabase, alias);
  }
}

class DraftPick extends DataClass implements Insertable<DraftPick> {
  final int id;
  final int seasonId;
  final int round;

  /// 1-indexed pick number across the whole draft (not just within a round).
  final int overallPick;
  final int teamId;
  final int playerId;
  const DraftPick({
    required this.id,
    required this.seasonId,
    required this.round,
    required this.overallPick,
    required this.teamId,
    required this.playerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['season_id'] = Variable<int>(seasonId);
    map['round'] = Variable<int>(round);
    map['overall_pick'] = Variable<int>(overallPick);
    map['team_id'] = Variable<int>(teamId);
    map['player_id'] = Variable<int>(playerId);
    return map;
  }

  DraftPicksCompanion toCompanion(bool nullToAbsent) {
    return DraftPicksCompanion(
      id: Value(id),
      seasonId: Value(seasonId),
      round: Value(round),
      overallPick: Value(overallPick),
      teamId: Value(teamId),
      playerId: Value(playerId),
    );
  }

  factory DraftPick.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftPick(
      id: serializer.fromJson<int>(json['id']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
      round: serializer.fromJson<int>(json['round']),
      overallPick: serializer.fromJson<int>(json['overallPick']),
      teamId: serializer.fromJson<int>(json['teamId']),
      playerId: serializer.fromJson<int>(json['playerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seasonId': serializer.toJson<int>(seasonId),
      'round': serializer.toJson<int>(round),
      'overallPick': serializer.toJson<int>(overallPick),
      'teamId': serializer.toJson<int>(teamId),
      'playerId': serializer.toJson<int>(playerId),
    };
  }

  DraftPick copyWith({
    int? id,
    int? seasonId,
    int? round,
    int? overallPick,
    int? teamId,
    int? playerId,
  }) => DraftPick(
    id: id ?? this.id,
    seasonId: seasonId ?? this.seasonId,
    round: round ?? this.round,
    overallPick: overallPick ?? this.overallPick,
    teamId: teamId ?? this.teamId,
    playerId: playerId ?? this.playerId,
  );
  DraftPick copyWithCompanion(DraftPicksCompanion data) {
    return DraftPick(
      id: data.id.present ? data.id.value : this.id,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      round: data.round.present ? data.round.value : this.round,
      overallPick: data.overallPick.present
          ? data.overallPick.value
          : this.overallPick,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftPick(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('round: $round, ')
          ..write('overallPick: $overallPick, ')
          ..write('teamId: $teamId, ')
          ..write('playerId: $playerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, seasonId, round, overallPick, teamId, playerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftPick &&
          other.id == this.id &&
          other.seasonId == this.seasonId &&
          other.round == this.round &&
          other.overallPick == this.overallPick &&
          other.teamId == this.teamId &&
          other.playerId == this.playerId);
}

class DraftPicksCompanion extends UpdateCompanion<DraftPick> {
  final Value<int> id;
  final Value<int> seasonId;
  final Value<int> round;
  final Value<int> overallPick;
  final Value<int> teamId;
  final Value<int> playerId;
  const DraftPicksCompanion({
    this.id = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.round = const Value.absent(),
    this.overallPick = const Value.absent(),
    this.teamId = const Value.absent(),
    this.playerId = const Value.absent(),
  });
  DraftPicksCompanion.insert({
    this.id = const Value.absent(),
    required int seasonId,
    required int round,
    required int overallPick,
    required int teamId,
    required int playerId,
  }) : seasonId = Value(seasonId),
       round = Value(round),
       overallPick = Value(overallPick),
       teamId = Value(teamId),
       playerId = Value(playerId);
  static Insertable<DraftPick> custom({
    Expression<int>? id,
    Expression<int>? seasonId,
    Expression<int>? round,
    Expression<int>? overallPick,
    Expression<int>? teamId,
    Expression<int>? playerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seasonId != null) 'season_id': seasonId,
      if (round != null) 'round': round,
      if (overallPick != null) 'overall_pick': overallPick,
      if (teamId != null) 'team_id': teamId,
      if (playerId != null) 'player_id': playerId,
    });
  }

  DraftPicksCompanion copyWith({
    Value<int>? id,
    Value<int>? seasonId,
    Value<int>? round,
    Value<int>? overallPick,
    Value<int>? teamId,
    Value<int>? playerId,
  }) {
    return DraftPicksCompanion(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      round: round ?? this.round,
      overallPick: overallPick ?? this.overallPick,
      teamId: teamId ?? this.teamId,
      playerId: playerId ?? this.playerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (overallPick.present) {
      map['overall_pick'] = Variable<int>(overallPick.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftPicksCompanion(')
          ..write('id: $id, ')
          ..write('seasonId: $seasonId, ')
          ..write('round: $round, ')
          ..write('overallPick: $overallPick, ')
          ..write('teamId: $teamId, ')
          ..write('playerId: $playerId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrganizationsTable organizations = $OrganizationsTable(this);
  late final $DivisionsTable divisions = $DivisionsTable(this);
  late final $TeamsTable teams = $TeamsTable(this);
  late final $SeasonsTable seasons = $SeasonsTable(this);
  late final $PlayoffSeriesTable playoffSeries = $PlayoffSeriesTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $PlayerPitchesTable playerPitches = $PlayerPitchesTable(this);
  late final $BattingStatsTable battingStats = $BattingStatsTable(this);
  late final $PitchingStatsTable pitchingStats = $PitchingStatsTable(this);
  late final $FieldingStatsTable fieldingStats = $FieldingStatsTable(this);
  late final $StandingsTable standings = $StandingsTable(this);
  late final $TeamLineupsTable teamLineups = $TeamLineupsTable(this);
  late final $InjuriesTable injuries = $InjuriesTable(this);
  late final $DraftPicksTable draftPicks = $DraftPicksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    organizations,
    divisions,
    teams,
    seasons,
    playoffSeries,
    games,
    players,
    playerPitches,
    battingStats,
    pitchingStats,
    fieldingStats,
    standings,
    teamLineups,
    injuries,
    draftPicks,
  ];
}

typedef $$OrganizationsTableCreateCompanionBuilder =
    OrganizationsCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isPlayerControlled,
    });
typedef $$OrganizationsTableUpdateCompanionBuilder =
    OrganizationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isPlayerControlled,
    });

final class $$OrganizationsTableReferences
    extends BaseReferences<_$AppDatabase, $OrganizationsTable, Organization> {
  $$OrganizationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TeamsTable, List<Team>> _teamsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.teams,
    aliasName: 'organizations__id__teams__organization_id',
  );

  $$TeamsTableProcessedTableManager get teamsRefs {
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayersTable, List<Player>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: 'organizations__id__players__organization_id',
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrganizationsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPlayerControlled => $composableBuilder(
    column: $table.isPlayerControlled,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> teamsRefs(
    Expression<bool> Function($$TeamsTableFilterComposer f) f,
  ) {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganizationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPlayerControlled => $composableBuilder(
    column: $table.isPlayerControlled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isPlayerControlled => $composableBuilder(
    column: $table.isPlayerControlled,
    builder: (column) => column,
  );

  Expression<T> teamsRefs<T extends Object>(
    Expression<T> Function($$TeamsTableAnnotationComposer a) f,
  ) {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganizationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizationsTable,
          Organization,
          $$OrganizationsTableFilterComposer,
          $$OrganizationsTableOrderingComposer,
          $$OrganizationsTableAnnotationComposer,
          $$OrganizationsTableCreateCompanionBuilder,
          $$OrganizationsTableUpdateCompanionBuilder,
          (Organization, $$OrganizationsTableReferences),
          Organization,
          PrefetchHooks Function({bool teamsRefs, bool playersRefs})
        > {
  $$OrganizationsTableTableManager(_$AppDatabase db, $OrganizationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganizationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isPlayerControlled = const Value.absent(),
              }) => OrganizationsCompanion(
                id: id,
                name: name,
                isPlayerControlled: isPlayerControlled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isPlayerControlled = const Value.absent(),
              }) => OrganizationsCompanion.insert(
                id: id,
                name: name,
                isPlayerControlled: isPlayerControlled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrganizationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teamsRefs = false, playersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (teamsRefs) db.teams,
                if (playersRefs) db.players,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (teamsRefs)
                    await $_getPrefetchedData<
                      Organization,
                      $OrganizationsTable,
                      Team
                    >(
                      currentTable: table,
                      referencedTable: $$OrganizationsTableReferences
                          ._teamsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrganizationsTableReferences(
                            db,
                            table,
                            p0,
                          ).teamsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.organizationId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (playersRefs)
                    await $_getPrefetchedData<
                      Organization,
                      $OrganizationsTable,
                      Player
                    >(
                      currentTable: table,
                      referencedTable: $$OrganizationsTableReferences
                          ._playersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrganizationsTableReferences(
                            db,
                            table,
                            p0,
                          ).playersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.organizationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OrganizationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizationsTable,
      Organization,
      $$OrganizationsTableFilterComposer,
      $$OrganizationsTableOrderingComposer,
      $$OrganizationsTableAnnotationComposer,
      $$OrganizationsTableCreateCompanionBuilder,
      $$OrganizationsTableUpdateCompanionBuilder,
      (Organization, $$OrganizationsTableReferences),
      Organization,
      PrefetchHooks Function({bool teamsRefs, bool playersRefs})
    >;
typedef $$DivisionsTableCreateCompanionBuilder = DivisionsCompanion Function({
  Value<int> id,
  required String name,
  required Tier tier,
});
typedef $$DivisionsTableUpdateCompanionBuilder = DivisionsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<Tier> tier,
});

final class $$DivisionsTableReferences
    extends BaseReferences<_$AppDatabase, $DivisionsTable, Division> {
  $$DivisionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TeamsTable, List<Team>> _teamsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.teams,
    aliasName: 'divisions__id__teams__division_id',
  );

  $$TeamsTableProcessedTableManager get teamsRefs {
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.divisionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DivisionsTableFilterComposer
    extends Composer<_$AppDatabase, $DivisionsTable> {
  $$DivisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Tier, Tier, int> get tier =>
      $composableBuilder(
        column: $table.tier,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> teamsRefs(
    Expression<bool> Function($$TeamsTableFilterComposer f) f,
  ) {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.divisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DivisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DivisionsTable> {
  $$DivisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DivisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DivisionsTable> {
  $$DivisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Tier, int> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  Expression<T> teamsRefs<T extends Object>(
    Expression<T> Function($$TeamsTableAnnotationComposer a) f,
  ) {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.divisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DivisionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DivisionsTable,
          Division,
          $$DivisionsTableFilterComposer,
          $$DivisionsTableOrderingComposer,
          $$DivisionsTableAnnotationComposer,
          $$DivisionsTableCreateCompanionBuilder,
          $$DivisionsTableUpdateCompanionBuilder,
          (Division, $$DivisionsTableReferences),
          Division,
          PrefetchHooks Function({bool teamsRefs})
        > {
  $$DivisionsTableTableManager(_$AppDatabase db, $DivisionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DivisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DivisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DivisionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<Tier> tier = const Value.absent(),
          }) => DivisionsCompanion(id: id, name: name, tier: tier),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required Tier tier,
          }) => DivisionsCompanion.insert(id: id, name: name, tier: tier),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DivisionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teamsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (teamsRefs) db.teams],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (teamsRefs)
                    await $_getPrefetchedData<Division, $DivisionsTable, Team>(
                      currentTable: table,
                      referencedTable: $$DivisionsTableReferences
                          ._teamsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DivisionsTableReferences(db, table, p0).teamsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.divisionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DivisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DivisionsTable,
      Division,
      $$DivisionsTableFilterComposer,
      $$DivisionsTableOrderingComposer,
      $$DivisionsTableAnnotationComposer,
      $$DivisionsTableCreateCompanionBuilder,
      $$DivisionsTableUpdateCompanionBuilder,
      (Division, $$DivisionsTableReferences),
      Division,
      PrefetchHooks Function({bool teamsRefs})
    >;
typedef $$TeamsTableCreateCompanionBuilder = TeamsCompanion Function({
  Value<int> id,
  required int organizationId,
  required int divisionId,
  required String name,
});
typedef $$TeamsTableUpdateCompanionBuilder = TeamsCompanion Function({
  Value<int> id,
  Value<int> organizationId,
  Value<int> divisionId,
  Value<String> name,
});

final class $$TeamsTableReferences
    extends BaseReferences<_$AppDatabase, $TeamsTable, Team> {
  $$TeamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizationsTable _organizationIdTable(_$AppDatabase db) =>
      db.organizations.createAlias('teams__organization_id__organizations__id');

  $$OrganizationsTableProcessedTableManager get organizationId {
    final $_column = $_itemColumn<int>('organization_id')!;

    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DivisionsTable _divisionIdTable(_$AppDatabase db) =>
      db.divisions.createAlias('teams__division_id__divisions__id');

  $$DivisionsTableProcessedTableManager get divisionId {
    final $_column = $_itemColumn<int>('division_id')!;

    final manager = $$DivisionsTableTableManager(
      $_db,
      $_db.divisions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_divisionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlayoffSeriesTable, List<PlayoffSeriesRow>>
  _higherSeedSeriesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playoffSeries,
    aliasName: 'teams__id__playoff_series__higher_seed_team_id',
  );

  $$PlayoffSeriesTableProcessedTableManager get higherSeedSeries {
    final manager = $$PlayoffSeriesTableTableManager(
      $_db,
      $_db.playoffSeries,
    ).filter((f) => f.higherSeedTeamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_higherSeedSeriesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayoffSeriesTable, List<PlayoffSeriesRow>>
  _lowerSeedSeriesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playoffSeries,
    aliasName: 'teams__id__playoff_series__lower_seed_team_id',
  );

  $$PlayoffSeriesTableProcessedTableManager get lowerSeedSeries {
    final manager = $$PlayoffSeriesTableTableManager(
      $_db,
      $_db.playoffSeries,
    ).filter((f) => f.lowerSeedTeamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lowerSeedSeriesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayoffSeriesTable, List<PlayoffSeriesRow>>
  _wonSeriesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playoffSeries,
    aliasName: 'teams__id__playoff_series__winner_team_id',
  );

  $$PlayoffSeriesTableProcessedTableManager get wonSeries {
    final manager = $$PlayoffSeriesTableTableManager(
      $_db,
      $_db.playoffSeries,
    ).filter((f) => f.winnerTeamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wonSeriesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamesTable, List<Game>> _homeGamesTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.games,
    aliasName: 'teams__id__games__home_team_id',
  );

  $$GamesTableProcessedTableManager get homeGames {
    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.homeTeamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_homeGamesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamesTable, List<Game>> _awayGamesTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.games,
    aliasName: 'teams__id__games__away_team_id',
  );

  $$GamesTableProcessedTableManager get awayGames {
    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.awayTeamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_awayGamesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlayersTable, List<Player>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: 'teams__id__players__team_id',
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BattingStatsTable, List<BattingStat>>
  _battingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.battingStats,
    aliasName: 'teams__id__batting_stats__team_id',
  );

  $$BattingStatsTableProcessedTableManager get battingStatsRefs {
    final manager = $$BattingStatsTableTableManager(
      $_db,
      $_db.battingStats,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_battingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PitchingStatsTable, List<PitchingStat>>
  _pitchingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pitchingStats,
    aliasName: 'teams__id__pitching_stats__team_id',
  );

  $$PitchingStatsTableProcessedTableManager get pitchingStatsRefs {
    final manager = $$PitchingStatsTableTableManager(
      $_db,
      $_db.pitchingStats,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pitchingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FieldingStatsTable, List<FieldingStat>>
  _fieldingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fieldingStats,
    aliasName: 'teams__id__fielding_stats__team_id',
  );

  $$FieldingStatsTableProcessedTableManager get fieldingStatsRefs {
    final manager = $$FieldingStatsTableTableManager(
      $_db,
      $_db.fieldingStats,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fieldingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StandingsTable, List<Standing>>
  _standingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.standings,
    aliasName: 'teams__id__standings__team_id',
  );

  $$StandingsTableProcessedTableManager get standingsRefs {
    final manager = $$StandingsTableTableManager(
      $_db,
      $_db.standings,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_standingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TeamLineupsTable, List<TeamLineup>>
  _teamLineupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamLineups,
    aliasName: 'teams__id__team_lineups__team_id',
  );

  $$TeamLineupsTableProcessedTableManager get teamLineupsRefs {
    final manager = $$TeamLineupsTableTableManager(
      $_db,
      $_db.teamLineups,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamLineupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DraftPicksTable, List<DraftPick>>
  _draftPicksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.draftPicks,
    aliasName: 'teams__id__draft_picks__team_id',
  );

  $$DraftPicksTableProcessedTableManager get draftPicksRefs {
    final manager = $$DraftPicksTableTableManager(
      $_db,
      $_db.draftPicks,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_draftPicksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeamsTableFilterComposer extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizationsTableFilterComposer get organizationId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DivisionsTableFilterComposer get divisionId {
    final $$DivisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.divisionId,
      referencedTable: $db.divisions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableFilterComposer(
            $db: $db,
            $table: $db.divisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> higherSeedSeries(
    Expression<bool> Function($$PlayoffSeriesTableFilterComposer f) f,
  ) {
    final $$PlayoffSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.higherSeedTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableFilterComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lowerSeedSeries(
    Expression<bool> Function($$PlayoffSeriesTableFilterComposer f) f,
  ) {
    final $$PlayoffSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.lowerSeedTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableFilterComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wonSeries(
    Expression<bool> Function($$PlayoffSeriesTableFilterComposer f) f,
  ) {
    final $$PlayoffSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.winnerTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableFilterComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> homeGames(
    Expression<bool> Function($$GamesTableFilterComposer f) f,
  ) {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.homeTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> awayGames(
    Expression<bool> Function($$GamesTableFilterComposer f) f,
  ) {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.awayTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> battingStatsRefs(
    Expression<bool> Function($$BattingStatsTableFilterComposer f) f,
  ) {
    final $$BattingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battingStats,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattingStatsTableFilterComposer(
            $db: $db,
            $table: $db.battingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pitchingStatsRefs(
    Expression<bool> Function($$PitchingStatsTableFilterComposer f) f,
  ) {
    final $$PitchingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitchingStats,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitchingStatsTableFilterComposer(
            $db: $db,
            $table: $db.pitchingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fieldingStatsRefs(
    Expression<bool> Function($$FieldingStatsTableFilterComposer f) f,
  ) {
    final $$FieldingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fieldingStats,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldingStatsTableFilterComposer(
            $db: $db,
            $table: $db.fieldingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> standingsRefs(
    Expression<bool> Function($$StandingsTableFilterComposer f) f,
  ) {
    final $$StandingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.standings,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandingsTableFilterComposer(
            $db: $db,
            $table: $db.standings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> teamLineupsRefs(
    Expression<bool> Function($$TeamLineupsTableFilterComposer f) f,
  ) {
    final $$TeamLineupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamLineups,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamLineupsTableFilterComposer(
            $db: $db,
            $table: $db.teamLineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> draftPicksRefs(
    Expression<bool> Function($$DraftPicksTableFilterComposer f) f,
  ) {
    final $$DraftPicksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftPicks,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPicksTableFilterComposer(
            $db: $db,
            $table: $db.draftPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizationsTableOrderingComposer get organizationId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DivisionsTableOrderingComposer get divisionId {
    final $$DivisionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.divisionId,
      referencedTable: $db.divisions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableOrderingComposer(
            $db: $db,
            $table: $db.divisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$OrganizationsTableAnnotationComposer get organizationId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DivisionsTableAnnotationComposer get divisionId {
    final $$DivisionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.divisionId,
      referencedTable: $db.divisions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DivisionsTableAnnotationComposer(
            $db: $db,
            $table: $db.divisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> higherSeedSeries<T extends Object>(
    Expression<T> Function($$PlayoffSeriesTableAnnotationComposer a) f,
  ) {
    final $$PlayoffSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.higherSeedTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lowerSeedSeries<T extends Object>(
    Expression<T> Function($$PlayoffSeriesTableAnnotationComposer a) f,
  ) {
    final $$PlayoffSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.lowerSeedTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wonSeries<T extends Object>(
    Expression<T> Function($$PlayoffSeriesTableAnnotationComposer a) f,
  ) {
    final $$PlayoffSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.winnerTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> homeGames<T extends Object>(
    Expression<T> Function($$GamesTableAnnotationComposer a) f,
  ) {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.homeTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> awayGames<T extends Object>(
    Expression<T> Function($$GamesTableAnnotationComposer a) f,
  ) {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.awayTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> battingStatsRefs<T extends Object>(
    Expression<T> Function($$BattingStatsTableAnnotationComposer a) f,
  ) {
    final $$BattingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battingStats,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.battingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pitchingStatsRefs<T extends Object>(
    Expression<T> Function($$PitchingStatsTableAnnotationComposer a) f,
  ) {
    final $$PitchingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitchingStats,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitchingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.pitchingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fieldingStatsRefs<T extends Object>(
    Expression<T> Function($$FieldingStatsTableAnnotationComposer a) f,
  ) {
    final $$FieldingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fieldingStats,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.fieldingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> standingsRefs<T extends Object>(
    Expression<T> Function($$StandingsTableAnnotationComposer a) f,
  ) {
    final $$StandingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.standings,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandingsTableAnnotationComposer(
            $db: $db,
            $table: $db.standings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> teamLineupsRefs<T extends Object>(
    Expression<T> Function($$TeamLineupsTableAnnotationComposer a) f,
  ) {
    final $$TeamLineupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamLineups,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamLineupsTableAnnotationComposer(
            $db: $db,
            $table: $db.teamLineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> draftPicksRefs<T extends Object>(
    Expression<T> Function($$DraftPicksTableAnnotationComposer a) f,
  ) {
    final $$DraftPicksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftPicks,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPicksTableAnnotationComposer(
            $db: $db,
            $table: $db.draftPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTable,
          Team,
          $$TeamsTableFilterComposer,
          $$TeamsTableOrderingComposer,
          $$TeamsTableAnnotationComposer,
          $$TeamsTableCreateCompanionBuilder,
          $$TeamsTableUpdateCompanionBuilder,
          (Team, $$TeamsTableReferences),
          Team,
          PrefetchHooks Function({
            bool organizationId,
            bool divisionId,
            bool higherSeedSeries,
            bool lowerSeedSeries,
            bool wonSeries,
            bool homeGames,
            bool awayGames,
            bool playersRefs,
            bool battingStatsRefs,
            bool pitchingStatsRefs,
            bool fieldingStatsRefs,
            bool standingsRefs,
            bool teamLineupsRefs,
            bool draftPicksRefs,
          })
        > {
  $$TeamsTableTableManager(_$AppDatabase db, $TeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizationId = const Value.absent(),
                Value<int> divisionId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => TeamsCompanion(
                id: id,
                organizationId: organizationId,
                divisionId: divisionId,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizationId,
                required int divisionId,
                required String name,
              }) => TeamsCompanion.insert(
                id: id,
                organizationId: organizationId,
                divisionId: divisionId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TeamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organizationId = false,
                divisionId = false,
                higherSeedSeries = false,
                lowerSeedSeries = false,
                wonSeries = false,
                homeGames = false,
                awayGames = false,
                playersRefs = false,
                battingStatsRefs = false,
                pitchingStatsRefs = false,
                fieldingStatsRefs = false,
                standingsRefs = false,
                teamLineupsRefs = false,
                draftPicksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (higherSeedSeries) db.playoffSeries,
                    if (lowerSeedSeries) db.playoffSeries,
                    if (wonSeries) db.playoffSeries,
                    if (homeGames) db.games,
                    if (awayGames) db.games,
                    if (playersRefs) db.players,
                    if (battingStatsRefs) db.battingStats,
                    if (pitchingStatsRefs) db.pitchingStats,
                    if (fieldingStatsRefs) db.fieldingStats,
                    if (standingsRefs) db.standings,
                    if (teamLineupsRefs) db.teamLineups,
                    if (draftPicksRefs) db.draftPicks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (organizationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizationId,
                            referencedTable: $$TeamsTableReferences
                                ._organizationIdTable(db),
                            referencedColumn: $$TeamsTableReferences
                                ._organizationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (divisionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.divisionId,
                            referencedTable: $$TeamsTableReferences
                                ._divisionIdTable(db),
                            referencedColumn: $$TeamsTableReferences
                                ._divisionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (higherSeedSeries)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          PlayoffSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._higherSeedSeriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).higherSeedSeries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.higherSeedTeamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lowerSeedSeries)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          PlayoffSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._lowerSeedSeriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).lowerSeedSeries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lowerSeedTeamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wonSeries)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          PlayoffSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._wonSeriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(db, table, p0).wonSeries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.winnerTeamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (homeGames)
                        await $_getPrefetchedData<Team, $TeamsTable, Game>(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._homeGamesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(db, table, p0).homeGames,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.homeTeamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (awayGames)
                        await $_getPrefetchedData<Team, $TeamsTable, Game>(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._awayGamesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(db, table, p0).awayGames,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.awayTeamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playersRefs)
                        await $_getPrefetchedData<Team, $TeamsTable, Player>(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._playersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(db, table, p0).playersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (battingStatsRefs)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          BattingStat
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._battingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).battingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pitchingStatsRefs)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          PitchingStat
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._pitchingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).pitchingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fieldingStatsRefs)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          FieldingStat
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._fieldingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).fieldingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (standingsRefs)
                        await $_getPrefetchedData<Team, $TeamsTable, Standing>(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._standingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).standingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (teamLineupsRefs)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          TeamLineup
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._teamLineupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).teamLineupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (draftPicksRefs)
                        await $_getPrefetchedData<Team, $TeamsTable, DraftPick>(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._draftPicksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).draftPicksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTable,
      Team,
      $$TeamsTableFilterComposer,
      $$TeamsTableOrderingComposer,
      $$TeamsTableAnnotationComposer,
      $$TeamsTableCreateCompanionBuilder,
      $$TeamsTableUpdateCompanionBuilder,
      (Team, $$TeamsTableReferences),
      Team,
      PrefetchHooks Function({
        bool organizationId,
        bool divisionId,
        bool higherSeedSeries,
        bool lowerSeedSeries,
        bool wonSeries,
        bool homeGames,
        bool awayGames,
        bool playersRefs,
        bool battingStatsRefs,
        bool pitchingStatsRefs,
        bool fieldingStatsRefs,
        bool standingsRefs,
        bool teamLineupsRefs,
        bool draftPicksRefs,
      })
    >;
typedef $$SeasonsTableCreateCompanionBuilder = SeasonsCompanion Function({
  Value<int> id,
  required int number,
  Value<bool> isActive,
});
typedef $$SeasonsTableUpdateCompanionBuilder = SeasonsCompanion Function({
  Value<int> id,
  Value<int> number,
  Value<bool> isActive,
});

final class $$SeasonsTableReferences
    extends BaseReferences<_$AppDatabase, $SeasonsTable, Season> {
  $$SeasonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayoffSeriesTable, List<PlayoffSeriesRow>>
  _playoffSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playoffSeries,
    aliasName: 'seasons__id__playoff_series__season_id',
  );

  $$PlayoffSeriesTableProcessedTableManager get playoffSeriesRefs {
    final manager = $$PlayoffSeriesTableTableManager(
      $_db,
      $_db.playoffSeries,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playoffSeriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamesTable, List<Game>> _gamesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.games,
    aliasName: 'seasons__id__games__season_id',
  );

  $$GamesTableProcessedTableManager get gamesRefs {
    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StandingsTable, List<Standing>>
  _standingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.standings,
    aliasName: 'seasons__id__standings__season_id',
  );

  $$StandingsTableProcessedTableManager get standingsRefs {
    final manager = $$StandingsTableTableManager(
      $_db,
      $_db.standings,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_standingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InjuriesTable, List<Injury>> _injuriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.injuries,
    aliasName: 'seasons__id__injuries__season_id',
  );

  $$InjuriesTableProcessedTableManager get injuriesRefs {
    final manager = $$InjuriesTableTableManager(
      $_db,
      $_db.injuries,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_injuriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DraftPicksTable, List<DraftPick>>
  _draftPicksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.draftPicks,
    aliasName: 'seasons__id__draft_picks__season_id',
  );

  $$DraftPicksTableProcessedTableManager get draftPicksRefs {
    final manager = $$DraftPicksTableTableManager(
      $_db,
      $_db.draftPicks,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_draftPicksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SeasonsTableFilterComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playoffSeriesRefs(
    Expression<bool> Function($$PlayoffSeriesTableFilterComposer f) f,
  ) {
    final $$PlayoffSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableFilterComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gamesRefs(
    Expression<bool> Function($$GamesTableFilterComposer f) f,
  ) {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> standingsRefs(
    Expression<bool> Function($$StandingsTableFilterComposer f) f,
  ) {
    final $$StandingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.standings,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandingsTableFilterComposer(
            $db: $db,
            $table: $db.standings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> injuriesRefs(
    Expression<bool> Function($$InjuriesTableFilterComposer f) f,
  ) {
    final $$InjuriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableFilterComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> draftPicksRefs(
    Expression<bool> Function($$DraftPicksTableFilterComposer f) f,
  ) {
    final $$DraftPicksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftPicks,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPicksTableFilterComposer(
            $db: $db,
            $table: $db.draftPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeasonsTableOrderingComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeasonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeasonsTable> {
  $$SeasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> playoffSeriesRefs<T extends Object>(
    Expression<T> Function($$PlayoffSeriesTableAnnotationComposer a) f,
  ) {
    final $$PlayoffSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gamesRefs<T extends Object>(
    Expression<T> Function($$GamesTableAnnotationComposer a) f,
  ) {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> standingsRefs<T extends Object>(
    Expression<T> Function($$StandingsTableAnnotationComposer a) f,
  ) {
    final $$StandingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.standings,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandingsTableAnnotationComposer(
            $db: $db,
            $table: $db.standings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> injuriesRefs<T extends Object>(
    Expression<T> Function($$InjuriesTableAnnotationComposer a) f,
  ) {
    final $$InjuriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableAnnotationComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> draftPicksRefs<T extends Object>(
    Expression<T> Function($$DraftPicksTableAnnotationComposer a) f,
  ) {
    final $$DraftPicksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftPicks,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPicksTableAnnotationComposer(
            $db: $db,
            $table: $db.draftPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeasonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeasonsTable,
          Season,
          $$SeasonsTableFilterComposer,
          $$SeasonsTableOrderingComposer,
          $$SeasonsTableAnnotationComposer,
          $$SeasonsTableCreateCompanionBuilder,
          $$SeasonsTableUpdateCompanionBuilder,
          (Season, $$SeasonsTableReferences),
          Season,
          PrefetchHooks Function({
            bool playoffSeriesRefs,
            bool gamesRefs,
            bool standingsRefs,
            bool injuriesRefs,
            bool draftPicksRefs,
          })
        > {
  $$SeasonsTableTableManager(_$AppDatabase db, $SeasonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeasonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeasonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeasonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) => SeasonsCompanion(id: id, number: number, isActive: isActive),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int number,
                Value<bool> isActive = const Value.absent(),
              }) => SeasonsCompanion.insert(
                id: id,
                number: number,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SeasonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                playoffSeriesRefs = false,
                gamesRefs = false,
                standingsRefs = false,
                injuriesRefs = false,
                draftPicksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playoffSeriesRefs) db.playoffSeries,
                    if (gamesRefs) db.games,
                    if (standingsRefs) db.standings,
                    if (injuriesRefs) db.injuries,
                    if (draftPicksRefs) db.draftPicks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playoffSeriesRefs)
                        await $_getPrefetchedData<
                          Season,
                          $SeasonsTable,
                          PlayoffSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$SeasonsTableReferences
                              ._playoffSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeasonsTableReferences(
                                db,
                                table,
                                p0,
                              ).playoffSeriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seasonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gamesRefs)
                        await $_getPrefetchedData<Season, $SeasonsTable, Game>(
                          currentTable: table,
                          referencedTable: $$SeasonsTableReferences
                              ._gamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeasonsTableReferences(db, table, p0).gamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seasonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (standingsRefs)
                        await $_getPrefetchedData<
                          Season,
                          $SeasonsTable,
                          Standing
                        >(
                          currentTable: table,
                          referencedTable: $$SeasonsTableReferences
                              ._standingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeasonsTableReferences(
                                db,
                                table,
                                p0,
                              ).standingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seasonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (injuriesRefs)
                        await $_getPrefetchedData<
                          Season,
                          $SeasonsTable,
                          Injury
                        >(
                          currentTable: table,
                          referencedTable: $$SeasonsTableReferences
                              ._injuriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeasonsTableReferences(
                                db,
                                table,
                                p0,
                              ).injuriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seasonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (draftPicksRefs)
                        await $_getPrefetchedData<
                          Season,
                          $SeasonsTable,
                          DraftPick
                        >(
                          currentTable: table,
                          referencedTable: $$SeasonsTableReferences
                              ._draftPicksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeasonsTableReferences(
                                db,
                                table,
                                p0,
                              ).draftPicksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seasonId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SeasonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeasonsTable,
      Season,
      $$SeasonsTableFilterComposer,
      $$SeasonsTableOrderingComposer,
      $$SeasonsTableAnnotationComposer,
      $$SeasonsTableCreateCompanionBuilder,
      $$SeasonsTableUpdateCompanionBuilder,
      (Season, $$SeasonsTableReferences),
      Season,
      PrefetchHooks Function({
        bool playoffSeriesRefs,
        bool gamesRefs,
        bool standingsRefs,
        bool injuriesRefs,
        bool draftPicksRefs,
      })
    >;
typedef $$PlayoffSeriesTableCreateCompanionBuilder =
    PlayoffSeriesCompanion Function({
      Value<int> id,
      required int seasonId,
      Value<Tier> tier,
      required PlayoffRound round,
      required int higherSeedTeamId,
      required int higherSeedRank,
      required int lowerSeedTeamId,
      required int lowerSeedRank,
      required int bestOf,
      Value<int> higherSeedWins,
      Value<int> lowerSeedWins,
      Value<int?> winnerTeamId,
    });
typedef $$PlayoffSeriesTableUpdateCompanionBuilder =
    PlayoffSeriesCompanion Function({
      Value<int> id,
      Value<int> seasonId,
      Value<Tier> tier,
      Value<PlayoffRound> round,
      Value<int> higherSeedTeamId,
      Value<int> higherSeedRank,
      Value<int> lowerSeedTeamId,
      Value<int> lowerSeedRank,
      Value<int> bestOf,
      Value<int> higherSeedWins,
      Value<int> lowerSeedWins,
      Value<int?> winnerTeamId,
    });

final class $$PlayoffSeriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PlayoffSeriesTable, PlayoffSeriesRow> {
  $$PlayoffSeriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SeasonsTable _seasonIdTable(_$AppDatabase db) =>
      db.seasons.createAlias('playoff_series__season_id__seasons__id');

  $$SeasonsTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$SeasonsTableTableManager(
      $_db,
      $_db.seasons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _higherSeedTeamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('playoff_series__higher_seed_team_id__teams__id');

  $$TeamsTableProcessedTableManager get higherSeedTeamId {
    final $_column = $_itemColumn<int>('higher_seed_team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_higherSeedTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _lowerSeedTeamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('playoff_series__lower_seed_team_id__teams__id');

  $$TeamsTableProcessedTableManager get lowerSeedTeamId {
    final $_column = $_itemColumn<int>('lower_seed_team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lowerSeedTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _winnerTeamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('playoff_series__winner_team_id__teams__id');

  $$TeamsTableProcessedTableManager? get winnerTeamId {
    final $_column = $_itemColumn<int>('winner_team_id');
    if ($_column == null) return null;
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_winnerTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GamesTable, List<Game>> _gamesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.games,
    aliasName: 'playoff_series__id__games__series_id',
  );

  $$GamesTableProcessedTableManager get gamesRefs {
    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayoffSeriesTableFilterComposer
    extends Composer<_$AppDatabase, $PlayoffSeriesTable> {
  $$PlayoffSeriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Tier, Tier, int> get tier =>
      $composableBuilder(
        column: $table.tier,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<PlayoffRound, PlayoffRound, int> get round =>
      $composableBuilder(
        column: $table.round,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get higherSeedRank => $composableBuilder(
    column: $table.higherSeedRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowerSeedRank => $composableBuilder(
    column: $table.lowerSeedRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestOf => $composableBuilder(
    column: $table.bestOf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get higherSeedWins => $composableBuilder(
    column: $table.higherSeedWins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowerSeedWins => $composableBuilder(
    column: $table.lowerSeedWins,
    builder: (column) => ColumnFilters(column),
  );

  $$SeasonsTableFilterComposer get seasonId {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableFilterComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get higherSeedTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.higherSeedTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get lowerSeedTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lowerSeedTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get winnerTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.winnerTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gamesRefs(
    Expression<bool> Function($$GamesTableFilterComposer f) f,
  ) {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayoffSeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayoffSeriesTable> {
  $$PlayoffSeriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get higherSeedRank => $composableBuilder(
    column: $table.higherSeedRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowerSeedRank => $composableBuilder(
    column: $table.lowerSeedRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestOf => $composableBuilder(
    column: $table.bestOf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get higherSeedWins => $composableBuilder(
    column: $table.higherSeedWins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowerSeedWins => $composableBuilder(
    column: $table.lowerSeedWins,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeasonsTableOrderingComposer get seasonId {
    final $$SeasonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableOrderingComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get higherSeedTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.higherSeedTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get lowerSeedTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lowerSeedTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get winnerTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.winnerTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayoffSeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayoffSeriesTable> {
  $$PlayoffSeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Tier, int> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlayoffRound, int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<int> get higherSeedRank => $composableBuilder(
    column: $table.higherSeedRank,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lowerSeedRank => $composableBuilder(
    column: $table.lowerSeedRank,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestOf =>
      $composableBuilder(column: $table.bestOf, builder: (column) => column);

  GeneratedColumn<int> get higherSeedWins => $composableBuilder(
    column: $table.higherSeedWins,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lowerSeedWins => $composableBuilder(
    column: $table.lowerSeedWins,
    builder: (column) => column,
  );

  $$SeasonsTableAnnotationComposer get seasonId {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get higherSeedTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.higherSeedTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get lowerSeedTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lowerSeedTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get winnerTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.winnerTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gamesRefs<T extends Object>(
    Expression<T> Function($$GamesTableAnnotationComposer a) f,
  ) {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayoffSeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayoffSeriesTable,
          PlayoffSeriesRow,
          $$PlayoffSeriesTableFilterComposer,
          $$PlayoffSeriesTableOrderingComposer,
          $$PlayoffSeriesTableAnnotationComposer,
          $$PlayoffSeriesTableCreateCompanionBuilder,
          $$PlayoffSeriesTableUpdateCompanionBuilder,
          (PlayoffSeriesRow, $$PlayoffSeriesTableReferences),
          PlayoffSeriesRow,
          PrefetchHooks Function({
            bool seasonId,
            bool higherSeedTeamId,
            bool lowerSeedTeamId,
            bool winnerTeamId,
            bool gamesRefs,
          })
        > {
  $$PlayoffSeriesTableTableManager(_$AppDatabase db, $PlayoffSeriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayoffSeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayoffSeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayoffSeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> seasonId = const Value.absent(),
                Value<Tier> tier = const Value.absent(),
                Value<PlayoffRound> round = const Value.absent(),
                Value<int> higherSeedTeamId = const Value.absent(),
                Value<int> higherSeedRank = const Value.absent(),
                Value<int> lowerSeedTeamId = const Value.absent(),
                Value<int> lowerSeedRank = const Value.absent(),
                Value<int> bestOf = const Value.absent(),
                Value<int> higherSeedWins = const Value.absent(),
                Value<int> lowerSeedWins = const Value.absent(),
                Value<int?> winnerTeamId = const Value.absent(),
              }) => PlayoffSeriesCompanion(
                id: id,
                seasonId: seasonId,
                tier: tier,
                round: round,
                higherSeedTeamId: higherSeedTeamId,
                higherSeedRank: higherSeedRank,
                lowerSeedTeamId: lowerSeedTeamId,
                lowerSeedRank: lowerSeedRank,
                bestOf: bestOf,
                higherSeedWins: higherSeedWins,
                lowerSeedWins: lowerSeedWins,
                winnerTeamId: winnerTeamId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int seasonId,
                Value<Tier> tier = const Value.absent(),
                required PlayoffRound round,
                required int higherSeedTeamId,
                required int higherSeedRank,
                required int lowerSeedTeamId,
                required int lowerSeedRank,
                required int bestOf,
                Value<int> higherSeedWins = const Value.absent(),
                Value<int> lowerSeedWins = const Value.absent(),
                Value<int?> winnerTeamId = const Value.absent(),
              }) => PlayoffSeriesCompanion.insert(
                id: id,
                seasonId: seasonId,
                tier: tier,
                round: round,
                higherSeedTeamId: higherSeedTeamId,
                higherSeedRank: higherSeedRank,
                lowerSeedTeamId: lowerSeedTeamId,
                lowerSeedRank: lowerSeedRank,
                bestOf: bestOf,
                higherSeedWins: higherSeedWins,
                lowerSeedWins: lowerSeedWins,
                winnerTeamId: winnerTeamId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayoffSeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                seasonId = false,
                higherSeedTeamId = false,
                lowerSeedTeamId = false,
                winnerTeamId = false,
                gamesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (gamesRefs) db.games],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (seasonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.seasonId,
                            referencedTable: $$PlayoffSeriesTableReferences
                                ._seasonIdTable(db),
                            referencedColumn: $$PlayoffSeriesTableReferences
                                ._seasonIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (higherSeedTeamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.higherSeedTeamId,
                            referencedTable: $$PlayoffSeriesTableReferences
                                ._higherSeedTeamIdTable(db),
                            referencedColumn: $$PlayoffSeriesTableReferences
                                ._higherSeedTeamIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (lowerSeedTeamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.lowerSeedTeamId,
                            referencedTable: $$PlayoffSeriesTableReferences
                                ._lowerSeedTeamIdTable(db),
                            referencedColumn: $$PlayoffSeriesTableReferences
                                ._lowerSeedTeamIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (winnerTeamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.winnerTeamId,
                            referencedTable: $$PlayoffSeriesTableReferences
                                ._winnerTeamIdTable(db),
                            referencedColumn: $$PlayoffSeriesTableReferences
                                ._winnerTeamIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamesRefs)
                        await $_getPrefetchedData<
                          PlayoffSeriesRow,
                          $PlayoffSeriesTable,
                          Game
                        >(
                          currentTable: table,
                          referencedTable: $$PlayoffSeriesTableReferences
                              ._gamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayoffSeriesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlayoffSeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayoffSeriesTable,
      PlayoffSeriesRow,
      $$PlayoffSeriesTableFilterComposer,
      $$PlayoffSeriesTableOrderingComposer,
      $$PlayoffSeriesTableAnnotationComposer,
      $$PlayoffSeriesTableCreateCompanionBuilder,
      $$PlayoffSeriesTableUpdateCompanionBuilder,
      (PlayoffSeriesRow, $$PlayoffSeriesTableReferences),
      PlayoffSeriesRow,
      PrefetchHooks Function({
        bool seasonId,
        bool higherSeedTeamId,
        bool lowerSeedTeamId,
        bool winnerTeamId,
        bool gamesRefs,
      })
    >;
typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  required int seasonId,
  required Tier tier,
  required int homeTeamId,
  required int awayTeamId,
  required int gameNumber,
  Value<int?> seriesId,
  Value<GameStatus> status,
  Value<int> homeScore,
  Value<int> awayScore,
  Value<int> inningsPlayed,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  Value<int> seasonId,
  Value<Tier> tier,
  Value<int> homeTeamId,
  Value<int> awayTeamId,
  Value<int> gameNumber,
  Value<int?> seriesId,
  Value<GameStatus> status,
  Value<int> homeScore,
  Value<int> awayScore,
  Value<int> inningsPlayed,
});

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeasonsTable _seasonIdTable(_$AppDatabase db) =>
      db.seasons.createAlias('games__season_id__seasons__id');

  $$SeasonsTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$SeasonsTableTableManager(
      $_db,
      $_db.seasons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _homeTeamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('games__home_team_id__teams__id');

  $$TeamsTableProcessedTableManager get homeTeamId {
    final $_column = $_itemColumn<int>('home_team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _awayTeamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('games__away_team_id__teams__id');

  $$TeamsTableProcessedTableManager get awayTeamId {
    final $_column = $_itemColumn<int>('away_team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_awayTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayoffSeriesTable _seriesIdTable(_$AppDatabase db) =>
      db.playoffSeries.createAlias('games__series_id__playoff_series__id');

  $$PlayoffSeriesTableProcessedTableManager? get seriesId {
    final $_column = $_itemColumn<int>('series_id');
    if ($_column == null) return null;
    final manager = $$PlayoffSeriesTableTableManager(
      $_db,
      $_db.playoffSeries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BattingStatsTable, List<BattingStat>>
  _battingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.battingStats,
    aliasName: 'games__id__batting_stats__game_id',
  );

  $$BattingStatsTableProcessedTableManager get battingStatsRefs {
    final manager = $$BattingStatsTableTableManager(
      $_db,
      $_db.battingStats,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_battingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PitchingStatsTable, List<PitchingStat>>
  _pitchingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pitchingStats,
    aliasName: 'games__id__pitching_stats__game_id',
  );

  $$PitchingStatsTableProcessedTableManager get pitchingStatsRefs {
    final manager = $$PitchingStatsTableTableManager(
      $_db,
      $_db.pitchingStats,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pitchingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FieldingStatsTable, List<FieldingStat>>
  _fieldingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fieldingStats,
    aliasName: 'games__id__fielding_stats__game_id',
  );

  $$FieldingStatsTableProcessedTableManager get fieldingStatsRefs {
    final manager = $$FieldingStatsTableTableManager(
      $_db,
      $_db.fieldingStats,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fieldingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InjuriesTable, List<Injury>> _injuriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.injuries,
    aliasName: 'games__id__injuries__game_id',
  );

  $$InjuriesTableProcessedTableManager get injuriesRefs {
    final manager = $$InjuriesTableTableManager(
      $_db,
      $_db.injuries,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_injuriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Tier, Tier, int> get tier =>
      $composableBuilder(
        column: $table.tier,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get gameNumber => $composableBuilder(
    column: $table.gameNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GameStatus, GameStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inningsPlayed => $composableBuilder(
    column: $table.inningsPlayed,
    builder: (column) => ColumnFilters(column),
  );

  $$SeasonsTableFilterComposer get seasonId {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableFilterComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get homeTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get awayTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayoffSeriesTableFilterComposer get seriesId {
    final $$PlayoffSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableFilterComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> battingStatsRefs(
    Expression<bool> Function($$BattingStatsTableFilterComposer f) f,
  ) {
    final $$BattingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battingStats,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattingStatsTableFilterComposer(
            $db: $db,
            $table: $db.battingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pitchingStatsRefs(
    Expression<bool> Function($$PitchingStatsTableFilterComposer f) f,
  ) {
    final $$PitchingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitchingStats,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitchingStatsTableFilterComposer(
            $db: $db,
            $table: $db.pitchingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fieldingStatsRefs(
    Expression<bool> Function($$FieldingStatsTableFilterComposer f) f,
  ) {
    final $$FieldingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fieldingStats,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldingStatsTableFilterComposer(
            $db: $db,
            $table: $db.fieldingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> injuriesRefs(
    Expression<bool> Function($$InjuriesTableFilterComposer f) f,
  ) {
    final $$InjuriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableFilterComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameNumber => $composableBuilder(
    column: $table.gameNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inningsPlayed => $composableBuilder(
    column: $table.inningsPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeasonsTableOrderingComposer get seasonId {
    final $$SeasonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableOrderingComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get homeTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get awayTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayoffSeriesTableOrderingComposer get seriesId {
    final $$PlayoffSeriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableOrderingComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Tier, int> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get gameNumber => $composableBuilder(
    column: $table.gameNumber,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<GameStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get homeScore =>
      $composableBuilder(column: $table.homeScore, builder: (column) => column);

  GeneratedColumn<int> get awayScore =>
      $composableBuilder(column: $table.awayScore, builder: (column) => column);

  GeneratedColumn<int> get inningsPlayed => $composableBuilder(
    column: $table.inningsPlayed,
    builder: (column) => column,
  );

  $$SeasonsTableAnnotationComposer get seasonId {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get homeTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get awayTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayoffSeriesTableAnnotationComposer get seriesId {
    final $$PlayoffSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.playoffSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayoffSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.playoffSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> battingStatsRefs<T extends Object>(
    Expression<T> Function($$BattingStatsTableAnnotationComposer a) f,
  ) {
    final $$BattingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battingStats,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.battingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pitchingStatsRefs<T extends Object>(
    Expression<T> Function($$PitchingStatsTableAnnotationComposer a) f,
  ) {
    final $$PitchingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitchingStats,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitchingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.pitchingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fieldingStatsRefs<T extends Object>(
    Expression<T> Function($$FieldingStatsTableAnnotationComposer a) f,
  ) {
    final $$FieldingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fieldingStats,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.fieldingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> injuriesRefs<T extends Object>(
    Expression<T> Function($$InjuriesTableAnnotationComposer a) f,
  ) {
    final $$InjuriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableAnnotationComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({
            bool seasonId,
            bool homeTeamId,
            bool awayTeamId,
            bool seriesId,
            bool battingStatsRefs,
            bool pitchingStatsRefs,
            bool fieldingStatsRefs,
            bool injuriesRefs,
          })
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> seasonId = const Value.absent(),
                Value<Tier> tier = const Value.absent(),
                Value<int> homeTeamId = const Value.absent(),
                Value<int> awayTeamId = const Value.absent(),
                Value<int> gameNumber = const Value.absent(),
                Value<int?> seriesId = const Value.absent(),
                Value<GameStatus> status = const Value.absent(),
                Value<int> homeScore = const Value.absent(),
                Value<int> awayScore = const Value.absent(),
                Value<int> inningsPlayed = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                seasonId: seasonId,
                tier: tier,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                gameNumber: gameNumber,
                seriesId: seriesId,
                status: status,
                homeScore: homeScore,
                awayScore: awayScore,
                inningsPlayed: inningsPlayed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int seasonId,
                required Tier tier,
                required int homeTeamId,
                required int awayTeamId,
                required int gameNumber,
                Value<int?> seriesId = const Value.absent(),
                Value<GameStatus> status = const Value.absent(),
                Value<int> homeScore = const Value.absent(),
                Value<int> awayScore = const Value.absent(),
                Value<int> inningsPlayed = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                seasonId: seasonId,
                tier: tier,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                gameNumber: gameNumber,
                seriesId: seriesId,
                status: status,
                homeScore: homeScore,
                awayScore: awayScore,
                inningsPlayed: inningsPlayed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                seasonId = false,
                homeTeamId = false,
                awayTeamId = false,
                seriesId = false,
                battingStatsRefs = false,
                pitchingStatsRefs = false,
                fieldingStatsRefs = false,
                injuriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (battingStatsRefs) db.battingStats,
                    if (pitchingStatsRefs) db.pitchingStats,
                    if (fieldingStatsRefs) db.fieldingStats,
                    if (injuriesRefs) db.injuries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (seasonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.seasonId,
                            referencedTable: $$GamesTableReferences
                                ._seasonIdTable(db),
                            referencedColumn: $$GamesTableReferences
                                ._seasonIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (homeTeamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.homeTeamId,
                            referencedTable: $$GamesTableReferences
                                ._homeTeamIdTable(db),
                            referencedColumn: $$GamesTableReferences
                                ._homeTeamIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (awayTeamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.awayTeamId,
                            referencedTable: $$GamesTableReferences
                                ._awayTeamIdTable(db),
                            referencedColumn: $$GamesTableReferences
                                ._awayTeamIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (seriesId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.seriesId,
                            referencedTable: $$GamesTableReferences
                                ._seriesIdTable(db),
                            referencedColumn: $$GamesTableReferences
                                ._seriesIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (battingStatsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          BattingStat
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._battingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).battingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pitchingStatsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          PitchingStat
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._pitchingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).pitchingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fieldingStatsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          FieldingStat
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._fieldingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).fieldingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (injuriesRefs)
                        await $_getPrefetchedData<Game, $GamesTable, Injury>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._injuriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).injuriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({
        bool seasonId,
        bool homeTeamId,
        bool awayTeamId,
        bool seriesId,
        bool battingStatsRefs,
        bool pitchingStatsRefs,
        bool fieldingStatsRefs,
        bool injuriesRefs,
      })
    >;
typedef $$PlayersTableCreateCompanionBuilder = PlayersCompanion Function({
  Value<int> id,
  Value<int?> organizationId,
  Value<int?> teamId,
  Value<RosterSlot?> rosterSlot,
  required String firstName,
  required String lastName,
  required int age,
  required int contact,
  required int power,
  required int discipline,
  required int speed,
  required int control,
  required int stamina,
  required int range,
  required int hands,
  required int arm,
  required int battingPotential,
  required int pitchingPotential,
  required int fieldingPotential,
  required int speedPotential,
  Value<int> gamesUnavailable,
});
typedef $$PlayersTableUpdateCompanionBuilder = PlayersCompanion Function({
  Value<int> id,
  Value<int?> organizationId,
  Value<int?> teamId,
  Value<RosterSlot?> rosterSlot,
  Value<String> firstName,
  Value<String> lastName,
  Value<int> age,
  Value<int> contact,
  Value<int> power,
  Value<int> discipline,
  Value<int> speed,
  Value<int> control,
  Value<int> stamina,
  Value<int> range,
  Value<int> hands,
  Value<int> arm,
  Value<int> battingPotential,
  Value<int> pitchingPotential,
  Value<int> fieldingPotential,
  Value<int> speedPotential,
  Value<int> gamesUnavailable,
});

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, Player> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizationsTable _organizationIdTable(_$AppDatabase db) => db
      .organizations
      .createAlias('players__organization_id__organizations__id');

  $$OrganizationsTableProcessedTableManager? get organizationId {
    final $_column = $_itemColumn<int>('organization_id');
    if ($_column == null) return null;
    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('players__team_id__teams__id');

  $$TeamsTableProcessedTableManager? get teamId {
    final $_column = $_itemColumn<int>('team_id');
    if ($_column == null) return null;
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlayerPitchesTable, List<PlayerPitche>>
  _playerPitchesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playerPitches,
    aliasName: 'players__id__player_pitches__player_id',
  );

  $$PlayerPitchesTableProcessedTableManager get playerPitchesRefs {
    final manager = $$PlayerPitchesTableTableManager(
      $_db,
      $_db.playerPitches,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playerPitchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BattingStatsTable, List<BattingStat>>
  _battingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.battingStats,
    aliasName: 'players__id__batting_stats__player_id',
  );

  $$BattingStatsTableProcessedTableManager get battingStatsRefs {
    final manager = $$BattingStatsTableTableManager(
      $_db,
      $_db.battingStats,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_battingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PitchingStatsTable, List<PitchingStat>>
  _pitchingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pitchingStats,
    aliasName: 'players__id__pitching_stats__player_id',
  );

  $$PitchingStatsTableProcessedTableManager get pitchingStatsRefs {
    final manager = $$PitchingStatsTableTableManager(
      $_db,
      $_db.pitchingStats,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pitchingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FieldingStatsTable, List<FieldingStat>>
  _fieldingStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fieldingStats,
    aliasName: 'players__id__fielding_stats__player_id',
  );

  $$FieldingStatsTableProcessedTableManager get fieldingStatsRefs {
    final manager = $$FieldingStatsTableTableManager(
      $_db,
      $_db.fieldingStats,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fieldingStatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TeamLineupsTable, List<TeamLineup>>
  _fielder2LineupsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamLineups,
    aliasName: 'players__id__team_lineups__fielder2_id',
  );

  $$TeamLineupsTableProcessedTableManager get fielder2Lineups {
    final manager = $$TeamLineupsTableTableManager(
      $_db,
      $_db.teamLineups,
    ).filter((f) => f.fielder2Id.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fielder2LineupsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TeamLineupsTable, List<TeamLineup>>
  _fielder3LineupsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamLineups,
    aliasName: 'players__id__team_lineups__fielder3_id',
  );

  $$TeamLineupsTableProcessedTableManager get fielder3Lineups {
    final manager = $$TeamLineupsTableTableManager(
      $_db,
      $_db.teamLineups,
    ).filter((f) => f.fielder3Id.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fielder3LineupsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InjuriesTable, List<Injury>> _injuriesTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.injuries,
    aliasName: 'players__id__injuries__player_id',
  );

  $$InjuriesTableProcessedTableManager get injuries {
    final manager = $$InjuriesTableTableManager(
      $_db,
      $_db.injuries,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_injuriesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InjuriesTable, List<Injury>>
  _injuryReplacementsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.injuries,
    aliasName: 'players__id__injuries__replacement_player_id',
  );

  $$InjuriesTableProcessedTableManager get injuryReplacements {
    final manager = $$InjuriesTableTableManager($_db, $_db.injuries).filter(
      (f) => f.replacementPlayerId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_injuryReplacementsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DraftPicksTable, List<DraftPick>>
  _draftPicksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.draftPicks,
    aliasName: 'players__id__draft_picks__player_id',
  );

  $$DraftPicksTableProcessedTableManager get draftPicksRefs {
    final manager = $$DraftPicksTableTableManager(
      $_db,
      $_db.draftPicks,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_draftPicksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RosterSlot?, RosterSlot, int> get rosterSlot =>
      $composableBuilder(
        column: $table.rosterSlot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get control => $composableBuilder(
    column: $table.control,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stamina => $composableBuilder(
    column: $table.stamina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hands => $composableBuilder(
    column: $table.hands,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get arm => $composableBuilder(
    column: $table.arm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get battingPotential => $composableBuilder(
    column: $table.battingPotential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pitchingPotential => $composableBuilder(
    column: $table.pitchingPotential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fieldingPotential => $composableBuilder(
    column: $table.fieldingPotential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedPotential => $composableBuilder(
    column: $table.speedPotential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gamesUnavailable => $composableBuilder(
    column: $table.gamesUnavailable,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizationsTableFilterComposer get organizationId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> playerPitchesRefs(
    Expression<bool> Function($$PlayerPitchesTableFilterComposer f) f,
  ) {
    final $$PlayerPitchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerPitches,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerPitchesTableFilterComposer(
            $db: $db,
            $table: $db.playerPitches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> battingStatsRefs(
    Expression<bool> Function($$BattingStatsTableFilterComposer f) f,
  ) {
    final $$BattingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battingStats,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattingStatsTableFilterComposer(
            $db: $db,
            $table: $db.battingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pitchingStatsRefs(
    Expression<bool> Function($$PitchingStatsTableFilterComposer f) f,
  ) {
    final $$PitchingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitchingStats,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitchingStatsTableFilterComposer(
            $db: $db,
            $table: $db.pitchingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fieldingStatsRefs(
    Expression<bool> Function($$FieldingStatsTableFilterComposer f) f,
  ) {
    final $$FieldingStatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fieldingStats,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldingStatsTableFilterComposer(
            $db: $db,
            $table: $db.fieldingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fielder2Lineups(
    Expression<bool> Function($$TeamLineupsTableFilterComposer f) f,
  ) {
    final $$TeamLineupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamLineups,
      getReferencedColumn: (t) => t.fielder2Id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamLineupsTableFilterComposer(
            $db: $db,
            $table: $db.teamLineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> fielder3Lineups(
    Expression<bool> Function($$TeamLineupsTableFilterComposer f) f,
  ) {
    final $$TeamLineupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamLineups,
      getReferencedColumn: (t) => t.fielder3Id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamLineupsTableFilterComposer(
            $db: $db,
            $table: $db.teamLineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> injuries(
    Expression<bool> Function($$InjuriesTableFilterComposer f) f,
  ) {
    final $$InjuriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableFilterComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> injuryReplacements(
    Expression<bool> Function($$InjuriesTableFilterComposer f) f,
  ) {
    final $$InjuriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.replacementPlayerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableFilterComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> draftPicksRefs(
    Expression<bool> Function($$DraftPicksTableFilterComposer f) f,
  ) {
    final $$DraftPicksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftPicks,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPicksTableFilterComposer(
            $db: $db,
            $table: $db.draftPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rosterSlot => $composableBuilder(
    column: $table.rosterSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get control => $composableBuilder(
    column: $table.control,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stamina => $composableBuilder(
    column: $table.stamina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hands => $composableBuilder(
    column: $table.hands,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get arm => $composableBuilder(
    column: $table.arm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get battingPotential => $composableBuilder(
    column: $table.battingPotential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pitchingPotential => $composableBuilder(
    column: $table.pitchingPotential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fieldingPotential => $composableBuilder(
    column: $table.fieldingPotential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedPotential => $composableBuilder(
    column: $table.speedPotential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gamesUnavailable => $composableBuilder(
    column: $table.gamesUnavailable,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizationsTableOrderingComposer get organizationId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RosterSlot?, int> get rosterSlot =>
      $composableBuilder(
        column: $table.rosterSlot,
        builder: (column) => column,
      );

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<int> get power =>
      $composableBuilder(column: $table.power, builder: (column) => column);

  GeneratedColumn<int> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<int> get control =>
      $composableBuilder(column: $table.control, builder: (column) => column);

  GeneratedColumn<int> get stamina =>
      $composableBuilder(column: $table.stamina, builder: (column) => column);

  GeneratedColumn<int> get range =>
      $composableBuilder(column: $table.range, builder: (column) => column);

  GeneratedColumn<int> get hands =>
      $composableBuilder(column: $table.hands, builder: (column) => column);

  GeneratedColumn<int> get arm =>
      $composableBuilder(column: $table.arm, builder: (column) => column);

  GeneratedColumn<int> get battingPotential => $composableBuilder(
    column: $table.battingPotential,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pitchingPotential => $composableBuilder(
    column: $table.pitchingPotential,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fieldingPotential => $composableBuilder(
    column: $table.fieldingPotential,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speedPotential => $composableBuilder(
    column: $table.speedPotential,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gamesUnavailable => $composableBuilder(
    column: $table.gamesUnavailable,
    builder: (column) => column,
  );

  $$OrganizationsTableAnnotationComposer get organizationId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> playerPitchesRefs<T extends Object>(
    Expression<T> Function($$PlayerPitchesTableAnnotationComposer a) f,
  ) {
    final $$PlayerPitchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerPitches,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerPitchesTableAnnotationComposer(
            $db: $db,
            $table: $db.playerPitches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> battingStatsRefs<T extends Object>(
    Expression<T> Function($$BattingStatsTableAnnotationComposer a) f,
  ) {
    final $$BattingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.battingStats,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BattingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.battingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pitchingStatsRefs<T extends Object>(
    Expression<T> Function($$PitchingStatsTableAnnotationComposer a) f,
  ) {
    final $$PitchingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitchingStats,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitchingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.pitchingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fieldingStatsRefs<T extends Object>(
    Expression<T> Function($$FieldingStatsTableAnnotationComposer a) f,
  ) {
    final $$FieldingStatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fieldingStats,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FieldingStatsTableAnnotationComposer(
            $db: $db,
            $table: $db.fieldingStats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fielder2Lineups<T extends Object>(
    Expression<T> Function($$TeamLineupsTableAnnotationComposer a) f,
  ) {
    final $$TeamLineupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamLineups,
      getReferencedColumn: (t) => t.fielder2Id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamLineupsTableAnnotationComposer(
            $db: $db,
            $table: $db.teamLineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> fielder3Lineups<T extends Object>(
    Expression<T> Function($$TeamLineupsTableAnnotationComposer a) f,
  ) {
    final $$TeamLineupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamLineups,
      getReferencedColumn: (t) => t.fielder3Id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamLineupsTableAnnotationComposer(
            $db: $db,
            $table: $db.teamLineups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> injuries<T extends Object>(
    Expression<T> Function($$InjuriesTableAnnotationComposer a) f,
  ) {
    final $$InjuriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableAnnotationComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> injuryReplacements<T extends Object>(
    Expression<T> Function($$InjuriesTableAnnotationComposer a) f,
  ) {
    final $$InjuriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.injuries,
      getReferencedColumn: (t) => t.replacementPlayerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InjuriesTableAnnotationComposer(
            $db: $db,
            $table: $db.injuries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> draftPicksRefs<T extends Object>(
    Expression<T> Function($$DraftPicksTableAnnotationComposer a) f,
  ) {
    final $$DraftPicksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.draftPicks,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPicksTableAnnotationComposer(
            $db: $db,
            $table: $db.draftPicks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, $$PlayersTableReferences),
          Player,
          PrefetchHooks Function({
            bool organizationId,
            bool teamId,
            bool playerPitchesRefs,
            bool battingStatsRefs,
            bool pitchingStatsRefs,
            bool fieldingStatsRefs,
            bool fielder2Lineups,
            bool fielder3Lineups,
            bool injuries,
            bool injuryReplacements,
            bool draftPicksRefs,
          })
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> organizationId = const Value.absent(),
                Value<int?> teamId = const Value.absent(),
                Value<RosterSlot?> rosterSlot = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> contact = const Value.absent(),
                Value<int> power = const Value.absent(),
                Value<int> discipline = const Value.absent(),
                Value<int> speed = const Value.absent(),
                Value<int> control = const Value.absent(),
                Value<int> stamina = const Value.absent(),
                Value<int> range = const Value.absent(),
                Value<int> hands = const Value.absent(),
                Value<int> arm = const Value.absent(),
                Value<int> battingPotential = const Value.absent(),
                Value<int> pitchingPotential = const Value.absent(),
                Value<int> fieldingPotential = const Value.absent(),
                Value<int> speedPotential = const Value.absent(),
                Value<int> gamesUnavailable = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                organizationId: organizationId,
                teamId: teamId,
                rosterSlot: rosterSlot,
                firstName: firstName,
                lastName: lastName,
                age: age,
                contact: contact,
                power: power,
                discipline: discipline,
                speed: speed,
                control: control,
                stamina: stamina,
                range: range,
                hands: hands,
                arm: arm,
                battingPotential: battingPotential,
                pitchingPotential: pitchingPotential,
                fieldingPotential: fieldingPotential,
                speedPotential: speedPotential,
                gamesUnavailable: gamesUnavailable,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> organizationId = const Value.absent(),
                Value<int?> teamId = const Value.absent(),
                Value<RosterSlot?> rosterSlot = const Value.absent(),
                required String firstName,
                required String lastName,
                required int age,
                required int contact,
                required int power,
                required int discipline,
                required int speed,
                required int control,
                required int stamina,
                required int range,
                required int hands,
                required int arm,
                required int battingPotential,
                required int pitchingPotential,
                required int fieldingPotential,
                required int speedPotential,
                Value<int> gamesUnavailable = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                organizationId: organizationId,
                teamId: teamId,
                rosterSlot: rosterSlot,
                firstName: firstName,
                lastName: lastName,
                age: age,
                contact: contact,
                power: power,
                discipline: discipline,
                speed: speed,
                control: control,
                stamina: stamina,
                range: range,
                hands: hands,
                arm: arm,
                battingPotential: battingPotential,
                pitchingPotential: pitchingPotential,
                fieldingPotential: fieldingPotential,
                speedPotential: speedPotential,
                gamesUnavailable: gamesUnavailable,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organizationId = false,
                teamId = false,
                playerPitchesRefs = false,
                battingStatsRefs = false,
                pitchingStatsRefs = false,
                fieldingStatsRefs = false,
                fielder2Lineups = false,
                fielder3Lineups = false,
                injuries = false,
                injuryReplacements = false,
                draftPicksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playerPitchesRefs) db.playerPitches,
                    if (battingStatsRefs) db.battingStats,
                    if (pitchingStatsRefs) db.pitchingStats,
                    if (fieldingStatsRefs) db.fieldingStats,
                    if (fielder2Lineups) db.teamLineups,
                    if (fielder3Lineups) db.teamLineups,
                    if (injuries) db.injuries,
                    if (injuryReplacements) db.injuries,
                    if (draftPicksRefs) db.draftPicks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (organizationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizationId,
                            referencedTable: $$PlayersTableReferences
                                ._organizationIdTable(db),
                            referencedColumn: $$PlayersTableReferences
                                ._organizationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (teamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.teamId,
                            referencedTable: $$PlayersTableReferences
                                ._teamIdTable(db),
                            referencedColumn: $$PlayersTableReferences
                                ._teamIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playerPitchesRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          PlayerPitche
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._playerPitchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).playerPitchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (battingStatsRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          BattingStat
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._battingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).battingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pitchingStatsRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          PitchingStat
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._pitchingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).pitchingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fieldingStatsRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          FieldingStat
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._fieldingStatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).fieldingStatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fielder2Lineups)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          TeamLineup
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._fielder2LineupsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).fielder2Lineups,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fielder2Id == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fielder3Lineups)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          TeamLineup
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._fielder3LineupsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).fielder3Lineups,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fielder3Id == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (injuries)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          Injury
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._injuriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(db, table, p0).injuries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (injuryReplacements)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          Injury
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._injuryReplacementsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).injuryReplacements,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.replacementPlayerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (draftPicksRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          DraftPick
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._draftPicksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).draftPicksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, $$PlayersTableReferences),
      Player,
      PrefetchHooks Function({
        bool organizationId,
        bool teamId,
        bool playerPitchesRefs,
        bool battingStatsRefs,
        bool pitchingStatsRefs,
        bool fieldingStatsRefs,
        bool fielder2Lineups,
        bool fielder3Lineups,
        bool injuries,
        bool injuryReplacements,
        bool draftPicksRefs,
      })
    >;
typedef $$PlayerPitchesTableCreateCompanionBuilder =
    PlayerPitchesCompanion Function({
      Value<int> id,
      required int playerId,
      required PitchType pitchType,
      required int movement,
    });
typedef $$PlayerPitchesTableUpdateCompanionBuilder =
    PlayerPitchesCompanion Function({
      Value<int> id,
      Value<int> playerId,
      Value<PitchType> pitchType,
      Value<int> movement,
    });

final class $$PlayerPitchesTableReferences
    extends BaseReferences<_$AppDatabase, $PlayerPitchesTable, PlayerPitche> {
  $$PlayerPitchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('player_pitches__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayerPitchesTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerPitchesTable> {
  $$PlayerPitchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PitchType, PitchType, int> get pitchType =>
      $composableBuilder(
        column: $table.pitchType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnFilters(column),
  );

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerPitchesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerPitchesTable> {
  $$PlayerPitchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pitchType => $composableBuilder(
    column: $table.pitchType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerPitchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerPitchesTable> {
  $$PlayerPitchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PitchType, int> get pitchType =>
      $composableBuilder(column: $table.pitchType, builder: (column) => column);

  GeneratedColumn<int> get movement =>
      $composableBuilder(column: $table.movement, builder: (column) => column);

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerPitchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerPitchesTable,
          PlayerPitche,
          $$PlayerPitchesTableFilterComposer,
          $$PlayerPitchesTableOrderingComposer,
          $$PlayerPitchesTableAnnotationComposer,
          $$PlayerPitchesTableCreateCompanionBuilder,
          $$PlayerPitchesTableUpdateCompanionBuilder,
          (PlayerPitche, $$PlayerPitchesTableReferences),
          PlayerPitche,
          PrefetchHooks Function({bool playerId})
        > {
  $$PlayerPitchesTableTableManager(_$AppDatabase db, $PlayerPitchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerPitchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerPitchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerPitchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<PitchType> pitchType = const Value.absent(),
                Value<int> movement = const Value.absent(),
              }) => PlayerPitchesCompanion(
                id: id,
                playerId: playerId,
                pitchType: pitchType,
                movement: movement,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playerId,
                required PitchType pitchType,
                required int movement,
              }) => PlayerPitchesCompanion.insert(
                id: id,
                playerId: playerId,
                pitchType: pitchType,
                movement: movement,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayerPitchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playerId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.playerId,
                        referencedTable: $$PlayerPitchesTableReferences
                            ._playerIdTable(db),
                        referencedColumn: $$PlayerPitchesTableReferences
                            ._playerIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayerPitchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerPitchesTable,
      PlayerPitche,
      $$PlayerPitchesTableFilterComposer,
      $$PlayerPitchesTableOrderingComposer,
      $$PlayerPitchesTableAnnotationComposer,
      $$PlayerPitchesTableCreateCompanionBuilder,
      $$PlayerPitchesTableUpdateCompanionBuilder,
      (PlayerPitche, $$PlayerPitchesTableReferences),
      PlayerPitche,
      PrefetchHooks Function({bool playerId})
    >;
typedef $$BattingStatsTableCreateCompanionBuilder =
    BattingStatsCompanion Function({
      Value<int> id,
      required int gameId,
      required int playerId,
      required int teamId,
      Value<bool> gs,
      Value<int> pa,
      Value<int> ab,
      Value<int> r,
      Value<int> h,
      Value<int> doubles,
      Value<int> triples,
      Value<int> hr,
      Value<int> rbi,
      Value<int> bb,
      Value<int> k,
      Value<int> hbp,
      Value<int> ibb,
      Value<int> sb,
      Value<int> cs,
      Value<int> sh,
      Value<int> sf,
      Value<int> dp,
      Value<int> roe,
      Value<int> fc,
      Value<int> lob,
    });
typedef $$BattingStatsTableUpdateCompanionBuilder =
    BattingStatsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<int> playerId,
      Value<int> teamId,
      Value<bool> gs,
      Value<int> pa,
      Value<int> ab,
      Value<int> r,
      Value<int> h,
      Value<int> doubles,
      Value<int> triples,
      Value<int> hr,
      Value<int> rbi,
      Value<int> bb,
      Value<int> k,
      Value<int> hbp,
      Value<int> ibb,
      Value<int> sb,
      Value<int> cs,
      Value<int> sh,
      Value<int> sf,
      Value<int> dp,
      Value<int> roe,
      Value<int> fc,
      Value<int> lob,
    });

final class $$BattingStatsTableReferences
    extends BaseReferences<_$AppDatabase, $BattingStatsTable, BattingStat> {
  $$BattingStatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('batting_stats__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('batting_stats__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('batting_stats__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BattingStatsTableFilterComposer
    extends Composer<_$AppDatabase, $BattingStatsTable> {
  $$BattingStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gs => $composableBuilder(
    column: $table.gs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pa => $composableBuilder(
    column: $table.pa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ab => $composableBuilder(
    column: $table.ab,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get r => $composableBuilder(
    column: $table.r,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get h => $composableBuilder(
    column: $table.h,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doubles => $composableBuilder(
    column: $table.doubles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triples => $composableBuilder(
    column: $table.triples,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rbi => $composableBuilder(
    column: $table.rbi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bb => $composableBuilder(
    column: $table.bb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get k => $composableBuilder(
    column: $table.k,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hbp => $composableBuilder(
    column: $table.hbp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ibb => $composableBuilder(
    column: $table.ibb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sb => $composableBuilder(
    column: $table.sb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cs => $composableBuilder(
    column: $table.cs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sh => $composableBuilder(
    column: $table.sh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sf => $composableBuilder(
    column: $table.sf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dp => $composableBuilder(
    column: $table.dp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roe => $composableBuilder(
    column: $table.roe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fc => $composableBuilder(
    column: $table.fc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lob => $composableBuilder(
    column: $table.lob,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattingStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $BattingStatsTable> {
  $$BattingStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gs => $composableBuilder(
    column: $table.gs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pa => $composableBuilder(
    column: $table.pa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ab => $composableBuilder(
    column: $table.ab,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get r => $composableBuilder(
    column: $table.r,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get h => $composableBuilder(
    column: $table.h,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doubles => $composableBuilder(
    column: $table.doubles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triples => $composableBuilder(
    column: $table.triples,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rbi => $composableBuilder(
    column: $table.rbi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bb => $composableBuilder(
    column: $table.bb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get k => $composableBuilder(
    column: $table.k,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hbp => $composableBuilder(
    column: $table.hbp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ibb => $composableBuilder(
    column: $table.ibb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sb => $composableBuilder(
    column: $table.sb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cs => $composableBuilder(
    column: $table.cs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sh => $composableBuilder(
    column: $table.sh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sf => $composableBuilder(
    column: $table.sf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dp => $composableBuilder(
    column: $table.dp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roe => $composableBuilder(
    column: $table.roe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fc => $composableBuilder(
    column: $table.fc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lob => $composableBuilder(
    column: $table.lob,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattingStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BattingStatsTable> {
  $$BattingStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get gs =>
      $composableBuilder(column: $table.gs, builder: (column) => column);

  GeneratedColumn<int> get pa =>
      $composableBuilder(column: $table.pa, builder: (column) => column);

  GeneratedColumn<int> get ab =>
      $composableBuilder(column: $table.ab, builder: (column) => column);

  GeneratedColumn<int> get r =>
      $composableBuilder(column: $table.r, builder: (column) => column);

  GeneratedColumn<int> get h =>
      $composableBuilder(column: $table.h, builder: (column) => column);

  GeneratedColumn<int> get doubles =>
      $composableBuilder(column: $table.doubles, builder: (column) => column);

  GeneratedColumn<int> get triples =>
      $composableBuilder(column: $table.triples, builder: (column) => column);

  GeneratedColumn<int> get hr =>
      $composableBuilder(column: $table.hr, builder: (column) => column);

  GeneratedColumn<int> get rbi =>
      $composableBuilder(column: $table.rbi, builder: (column) => column);

  GeneratedColumn<int> get bb =>
      $composableBuilder(column: $table.bb, builder: (column) => column);

  GeneratedColumn<int> get k =>
      $composableBuilder(column: $table.k, builder: (column) => column);

  GeneratedColumn<int> get hbp =>
      $composableBuilder(column: $table.hbp, builder: (column) => column);

  GeneratedColumn<int> get ibb =>
      $composableBuilder(column: $table.ibb, builder: (column) => column);

  GeneratedColumn<int> get sb =>
      $composableBuilder(column: $table.sb, builder: (column) => column);

  GeneratedColumn<int> get cs =>
      $composableBuilder(column: $table.cs, builder: (column) => column);

  GeneratedColumn<int> get sh =>
      $composableBuilder(column: $table.sh, builder: (column) => column);

  GeneratedColumn<int> get sf =>
      $composableBuilder(column: $table.sf, builder: (column) => column);

  GeneratedColumn<int> get dp =>
      $composableBuilder(column: $table.dp, builder: (column) => column);

  GeneratedColumn<int> get roe =>
      $composableBuilder(column: $table.roe, builder: (column) => column);

  GeneratedColumn<int> get fc =>
      $composableBuilder(column: $table.fc, builder: (column) => column);

  GeneratedColumn<int> get lob =>
      $composableBuilder(column: $table.lob, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BattingStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BattingStatsTable,
          BattingStat,
          $$BattingStatsTableFilterComposer,
          $$BattingStatsTableOrderingComposer,
          $$BattingStatsTableAnnotationComposer,
          $$BattingStatsTableCreateCompanionBuilder,
          $$BattingStatsTableUpdateCompanionBuilder,
          (BattingStat, $$BattingStatsTableReferences),
          BattingStat,
          PrefetchHooks Function({bool gameId, bool playerId, bool teamId})
        > {
  $$BattingStatsTableTableManager(_$AppDatabase db, $BattingStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BattingStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BattingStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BattingStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<bool> gs = const Value.absent(),
                Value<int> pa = const Value.absent(),
                Value<int> ab = const Value.absent(),
                Value<int> r = const Value.absent(),
                Value<int> h = const Value.absent(),
                Value<int> doubles = const Value.absent(),
                Value<int> triples = const Value.absent(),
                Value<int> hr = const Value.absent(),
                Value<int> rbi = const Value.absent(),
                Value<int> bb = const Value.absent(),
                Value<int> k = const Value.absent(),
                Value<int> hbp = const Value.absent(),
                Value<int> ibb = const Value.absent(),
                Value<int> sb = const Value.absent(),
                Value<int> cs = const Value.absent(),
                Value<int> sh = const Value.absent(),
                Value<int> sf = const Value.absent(),
                Value<int> dp = const Value.absent(),
                Value<int> roe = const Value.absent(),
                Value<int> fc = const Value.absent(),
                Value<int> lob = const Value.absent(),
              }) => BattingStatsCompanion(
                id: id,
                gameId: gameId,
                playerId: playerId,
                teamId: teamId,
                gs: gs,
                pa: pa,
                ab: ab,
                r: r,
                h: h,
                doubles: doubles,
                triples: triples,
                hr: hr,
                rbi: rbi,
                bb: bb,
                k: k,
                hbp: hbp,
                ibb: ibb,
                sb: sb,
                cs: cs,
                sh: sh,
                sf: sf,
                dp: dp,
                roe: roe,
                fc: fc,
                lob: lob,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required int playerId,
                required int teamId,
                Value<bool> gs = const Value.absent(),
                Value<int> pa = const Value.absent(),
                Value<int> ab = const Value.absent(),
                Value<int> r = const Value.absent(),
                Value<int> h = const Value.absent(),
                Value<int> doubles = const Value.absent(),
                Value<int> triples = const Value.absent(),
                Value<int> hr = const Value.absent(),
                Value<int> rbi = const Value.absent(),
                Value<int> bb = const Value.absent(),
                Value<int> k = const Value.absent(),
                Value<int> hbp = const Value.absent(),
                Value<int> ibb = const Value.absent(),
                Value<int> sb = const Value.absent(),
                Value<int> cs = const Value.absent(),
                Value<int> sh = const Value.absent(),
                Value<int> sf = const Value.absent(),
                Value<int> dp = const Value.absent(),
                Value<int> roe = const Value.absent(),
                Value<int> fc = const Value.absent(),
                Value<int> lob = const Value.absent(),
              }) => BattingStatsCompanion.insert(
                id: id,
                gameId: gameId,
                playerId: playerId,
                teamId: teamId,
                gs: gs,
                pa: pa,
                ab: ab,
                r: r,
                h: h,
                doubles: doubles,
                triples: triples,
                hr: hr,
                rbi: rbi,
                bb: bb,
                k: k,
                hbp: hbp,
                ibb: ibb,
                sb: sb,
                cs: cs,
                sh: sh,
                sf: sf,
                dp: dp,
                roe: roe,
                fc: fc,
                lob: lob,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BattingStatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gameId = false, playerId = false, teamId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gameId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gameId,
                            referencedTable: $$BattingStatsTableReferences
                                ._gameIdTable(db),
                            referencedColumn: $$BattingStatsTableReferences
                                ._gameIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (playerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.playerId,
                            referencedTable: $$BattingStatsTableReferences
                                ._playerIdTable(db),
                            referencedColumn: $$BattingStatsTableReferences
                                ._playerIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (teamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.teamId,
                            referencedTable: $$BattingStatsTableReferences
                                ._teamIdTable(db),
                            referencedColumn: $$BattingStatsTableReferences
                                ._teamIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$BattingStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BattingStatsTable,
      BattingStat,
      $$BattingStatsTableFilterComposer,
      $$BattingStatsTableOrderingComposer,
      $$BattingStatsTableAnnotationComposer,
      $$BattingStatsTableCreateCompanionBuilder,
      $$BattingStatsTableUpdateCompanionBuilder,
      (BattingStat, $$BattingStatsTableReferences),
      BattingStat,
      PrefetchHooks Function({bool gameId, bool playerId, bool teamId})
    >;
typedef $$PitchingStatsTableCreateCompanionBuilder =
    PitchingStatsCompanion Function({
      Value<int> id,
      required int gameId,
      required int playerId,
      required int teamId,
      Value<bool> gs,
      Value<bool> cg,
      Value<int> outsRecorded,
      Value<int> r,
      Value<int> er,
      Value<int> h,
      Value<int> bb,
      Value<int> hbp,
      Value<int> ibb,
      Value<int> k,
      Value<int> w,
      Value<int> l,
      Value<int> s,
      Value<int> hld,
      Value<int> bs,
      Value<int> wp,
    });
typedef $$PitchingStatsTableUpdateCompanionBuilder =
    PitchingStatsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<int> playerId,
      Value<int> teamId,
      Value<bool> gs,
      Value<bool> cg,
      Value<int> outsRecorded,
      Value<int> r,
      Value<int> er,
      Value<int> h,
      Value<int> bb,
      Value<int> hbp,
      Value<int> ibb,
      Value<int> k,
      Value<int> w,
      Value<int> l,
      Value<int> s,
      Value<int> hld,
      Value<int> bs,
      Value<int> wp,
    });

final class $$PitchingStatsTableReferences
    extends BaseReferences<_$AppDatabase, $PitchingStatsTable, PitchingStat> {
  $$PitchingStatsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('pitching_stats__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('pitching_stats__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('pitching_stats__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PitchingStatsTableFilterComposer
    extends Composer<_$AppDatabase, $PitchingStatsTable> {
  $$PitchingStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gs => $composableBuilder(
    column: $table.gs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cg => $composableBuilder(
    column: $table.cg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outsRecorded => $composableBuilder(
    column: $table.outsRecorded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get r => $composableBuilder(
    column: $table.r,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get er => $composableBuilder(
    column: $table.er,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get h => $composableBuilder(
    column: $table.h,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bb => $composableBuilder(
    column: $table.bb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hbp => $composableBuilder(
    column: $table.hbp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ibb => $composableBuilder(
    column: $table.ibb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get k => $composableBuilder(
    column: $table.k,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get w => $composableBuilder(
    column: $table.w,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get l => $composableBuilder(
    column: $table.l,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get s => $composableBuilder(
    column: $table.s,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hld => $composableBuilder(
    column: $table.hld,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bs => $composableBuilder(
    column: $table.bs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wp => $composableBuilder(
    column: $table.wp,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PitchingStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $PitchingStatsTable> {
  $$PitchingStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gs => $composableBuilder(
    column: $table.gs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cg => $composableBuilder(
    column: $table.cg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outsRecorded => $composableBuilder(
    column: $table.outsRecorded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get r => $composableBuilder(
    column: $table.r,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get er => $composableBuilder(
    column: $table.er,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get h => $composableBuilder(
    column: $table.h,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bb => $composableBuilder(
    column: $table.bb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hbp => $composableBuilder(
    column: $table.hbp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ibb => $composableBuilder(
    column: $table.ibb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get k => $composableBuilder(
    column: $table.k,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get w => $composableBuilder(
    column: $table.w,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get l => $composableBuilder(
    column: $table.l,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get s => $composableBuilder(
    column: $table.s,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hld => $composableBuilder(
    column: $table.hld,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bs => $composableBuilder(
    column: $table.bs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wp => $composableBuilder(
    column: $table.wp,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PitchingStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PitchingStatsTable> {
  $$PitchingStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get gs =>
      $composableBuilder(column: $table.gs, builder: (column) => column);

  GeneratedColumn<bool> get cg =>
      $composableBuilder(column: $table.cg, builder: (column) => column);

  GeneratedColumn<int> get outsRecorded => $composableBuilder(
    column: $table.outsRecorded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get r =>
      $composableBuilder(column: $table.r, builder: (column) => column);

  GeneratedColumn<int> get er =>
      $composableBuilder(column: $table.er, builder: (column) => column);

  GeneratedColumn<int> get h =>
      $composableBuilder(column: $table.h, builder: (column) => column);

  GeneratedColumn<int> get bb =>
      $composableBuilder(column: $table.bb, builder: (column) => column);

  GeneratedColumn<int> get hbp =>
      $composableBuilder(column: $table.hbp, builder: (column) => column);

  GeneratedColumn<int> get ibb =>
      $composableBuilder(column: $table.ibb, builder: (column) => column);

  GeneratedColumn<int> get k =>
      $composableBuilder(column: $table.k, builder: (column) => column);

  GeneratedColumn<int> get w =>
      $composableBuilder(column: $table.w, builder: (column) => column);

  GeneratedColumn<int> get l =>
      $composableBuilder(column: $table.l, builder: (column) => column);

  GeneratedColumn<int> get s =>
      $composableBuilder(column: $table.s, builder: (column) => column);

  GeneratedColumn<int> get hld =>
      $composableBuilder(column: $table.hld, builder: (column) => column);

  GeneratedColumn<int> get bs =>
      $composableBuilder(column: $table.bs, builder: (column) => column);

  GeneratedColumn<int> get wp =>
      $composableBuilder(column: $table.wp, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PitchingStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PitchingStatsTable,
          PitchingStat,
          $$PitchingStatsTableFilterComposer,
          $$PitchingStatsTableOrderingComposer,
          $$PitchingStatsTableAnnotationComposer,
          $$PitchingStatsTableCreateCompanionBuilder,
          $$PitchingStatsTableUpdateCompanionBuilder,
          (PitchingStat, $$PitchingStatsTableReferences),
          PitchingStat,
          PrefetchHooks Function({bool gameId, bool playerId, bool teamId})
        > {
  $$PitchingStatsTableTableManager(_$AppDatabase db, $PitchingStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PitchingStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PitchingStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PitchingStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<bool> gs = const Value.absent(),
                Value<bool> cg = const Value.absent(),
                Value<int> outsRecorded = const Value.absent(),
                Value<int> r = const Value.absent(),
                Value<int> er = const Value.absent(),
                Value<int> h = const Value.absent(),
                Value<int> bb = const Value.absent(),
                Value<int> hbp = const Value.absent(),
                Value<int> ibb = const Value.absent(),
                Value<int> k = const Value.absent(),
                Value<int> w = const Value.absent(),
                Value<int> l = const Value.absent(),
                Value<int> s = const Value.absent(),
                Value<int> hld = const Value.absent(),
                Value<int> bs = const Value.absent(),
                Value<int> wp = const Value.absent(),
              }) => PitchingStatsCompanion(
                id: id,
                gameId: gameId,
                playerId: playerId,
                teamId: teamId,
                gs: gs,
                cg: cg,
                outsRecorded: outsRecorded,
                r: r,
                er: er,
                h: h,
                bb: bb,
                hbp: hbp,
                ibb: ibb,
                k: k,
                w: w,
                l: l,
                s: s,
                hld: hld,
                bs: bs,
                wp: wp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required int playerId,
                required int teamId,
                Value<bool> gs = const Value.absent(),
                Value<bool> cg = const Value.absent(),
                Value<int> outsRecorded = const Value.absent(),
                Value<int> r = const Value.absent(),
                Value<int> er = const Value.absent(),
                Value<int> h = const Value.absent(),
                Value<int> bb = const Value.absent(),
                Value<int> hbp = const Value.absent(),
                Value<int> ibb = const Value.absent(),
                Value<int> k = const Value.absent(),
                Value<int> w = const Value.absent(),
                Value<int> l = const Value.absent(),
                Value<int> s = const Value.absent(),
                Value<int> hld = const Value.absent(),
                Value<int> bs = const Value.absent(),
                Value<int> wp = const Value.absent(),
              }) => PitchingStatsCompanion.insert(
                id: id,
                gameId: gameId,
                playerId: playerId,
                teamId: teamId,
                gs: gs,
                cg: cg,
                outsRecorded: outsRecorded,
                r: r,
                er: er,
                h: h,
                bb: bb,
                hbp: hbp,
                ibb: ibb,
                k: k,
                w: w,
                l: l,
                s: s,
                hld: hld,
                bs: bs,
                wp: wp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PitchingStatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gameId = false, playerId = false, teamId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gameId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gameId,
                            referencedTable: $$PitchingStatsTableReferences
                                ._gameIdTable(db),
                            referencedColumn: $$PitchingStatsTableReferences
                                ._gameIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (playerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.playerId,
                            referencedTable: $$PitchingStatsTableReferences
                                ._playerIdTable(db),
                            referencedColumn: $$PitchingStatsTableReferences
                                ._playerIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (teamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.teamId,
                            referencedTable: $$PitchingStatsTableReferences
                                ._teamIdTable(db),
                            referencedColumn: $$PitchingStatsTableReferences
                                ._teamIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PitchingStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PitchingStatsTable,
      PitchingStat,
      $$PitchingStatsTableFilterComposer,
      $$PitchingStatsTableOrderingComposer,
      $$PitchingStatsTableAnnotationComposer,
      $$PitchingStatsTableCreateCompanionBuilder,
      $$PitchingStatsTableUpdateCompanionBuilder,
      (PitchingStat, $$PitchingStatsTableReferences),
      PitchingStat,
      PrefetchHooks Function({bool gameId, bool playerId, bool teamId})
    >;
typedef $$FieldingStatsTableCreateCompanionBuilder =
    FieldingStatsCompanion Function({
      Value<int> id,
      required int gameId,
      required int playerId,
      required int teamId,
      Value<bool> gs,
      Value<int> outsPlayed,
      Value<int> tc,
      Value<int> po,
      Value<int> a,
      Value<int> e,
      Value<int> dp,
      Value<int> pb,
      Value<int> sb,
      Value<int> cs,
    });
typedef $$FieldingStatsTableUpdateCompanionBuilder =
    FieldingStatsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<int> playerId,
      Value<int> teamId,
      Value<bool> gs,
      Value<int> outsPlayed,
      Value<int> tc,
      Value<int> po,
      Value<int> a,
      Value<int> e,
      Value<int> dp,
      Value<int> pb,
      Value<int> sb,
      Value<int> cs,
    });

final class $$FieldingStatsTableReferences
    extends BaseReferences<_$AppDatabase, $FieldingStatsTable, FieldingStat> {
  $$FieldingStatsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('fielding_stats__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('fielding_stats__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('fielding_stats__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FieldingStatsTableFilterComposer
    extends Composer<_$AppDatabase, $FieldingStatsTable> {
  $$FieldingStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gs => $composableBuilder(
    column: $table.gs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outsPlayed => $composableBuilder(
    column: $table.outsPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tc => $composableBuilder(
    column: $table.tc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get po => $composableBuilder(
    column: $table.po,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get a => $composableBuilder(
    column: $table.a,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get e => $composableBuilder(
    column: $table.e,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dp => $composableBuilder(
    column: $table.dp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pb => $composableBuilder(
    column: $table.pb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sb => $composableBuilder(
    column: $table.sb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cs => $composableBuilder(
    column: $table.cs,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FieldingStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $FieldingStatsTable> {
  $$FieldingStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gs => $composableBuilder(
    column: $table.gs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outsPlayed => $composableBuilder(
    column: $table.outsPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tc => $composableBuilder(
    column: $table.tc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get po => $composableBuilder(
    column: $table.po,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get a => $composableBuilder(
    column: $table.a,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get e => $composableBuilder(
    column: $table.e,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dp => $composableBuilder(
    column: $table.dp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pb => $composableBuilder(
    column: $table.pb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sb => $composableBuilder(
    column: $table.sb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cs => $composableBuilder(
    column: $table.cs,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FieldingStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FieldingStatsTable> {
  $$FieldingStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get gs =>
      $composableBuilder(column: $table.gs, builder: (column) => column);

  GeneratedColumn<int> get outsPlayed => $composableBuilder(
    column: $table.outsPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tc =>
      $composableBuilder(column: $table.tc, builder: (column) => column);

  GeneratedColumn<int> get po =>
      $composableBuilder(column: $table.po, builder: (column) => column);

  GeneratedColumn<int> get a =>
      $composableBuilder(column: $table.a, builder: (column) => column);

  GeneratedColumn<int> get e =>
      $composableBuilder(column: $table.e, builder: (column) => column);

  GeneratedColumn<int> get dp =>
      $composableBuilder(column: $table.dp, builder: (column) => column);

  GeneratedColumn<int> get pb =>
      $composableBuilder(column: $table.pb, builder: (column) => column);

  GeneratedColumn<int> get sb =>
      $composableBuilder(column: $table.sb, builder: (column) => column);

  GeneratedColumn<int> get cs =>
      $composableBuilder(column: $table.cs, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FieldingStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FieldingStatsTable,
          FieldingStat,
          $$FieldingStatsTableFilterComposer,
          $$FieldingStatsTableOrderingComposer,
          $$FieldingStatsTableAnnotationComposer,
          $$FieldingStatsTableCreateCompanionBuilder,
          $$FieldingStatsTableUpdateCompanionBuilder,
          (FieldingStat, $$FieldingStatsTableReferences),
          FieldingStat,
          PrefetchHooks Function({bool gameId, bool playerId, bool teamId})
        > {
  $$FieldingStatsTableTableManager(_$AppDatabase db, $FieldingStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FieldingStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FieldingStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FieldingStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<bool> gs = const Value.absent(),
                Value<int> outsPlayed = const Value.absent(),
                Value<int> tc = const Value.absent(),
                Value<int> po = const Value.absent(),
                Value<int> a = const Value.absent(),
                Value<int> e = const Value.absent(),
                Value<int> dp = const Value.absent(),
                Value<int> pb = const Value.absent(),
                Value<int> sb = const Value.absent(),
                Value<int> cs = const Value.absent(),
              }) => FieldingStatsCompanion(
                id: id,
                gameId: gameId,
                playerId: playerId,
                teamId: teamId,
                gs: gs,
                outsPlayed: outsPlayed,
                tc: tc,
                po: po,
                a: a,
                e: e,
                dp: dp,
                pb: pb,
                sb: sb,
                cs: cs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required int playerId,
                required int teamId,
                Value<bool> gs = const Value.absent(),
                Value<int> outsPlayed = const Value.absent(),
                Value<int> tc = const Value.absent(),
                Value<int> po = const Value.absent(),
                Value<int> a = const Value.absent(),
                Value<int> e = const Value.absent(),
                Value<int> dp = const Value.absent(),
                Value<int> pb = const Value.absent(),
                Value<int> sb = const Value.absent(),
                Value<int> cs = const Value.absent(),
              }) => FieldingStatsCompanion.insert(
                id: id,
                gameId: gameId,
                playerId: playerId,
                teamId: teamId,
                gs: gs,
                outsPlayed: outsPlayed,
                tc: tc,
                po: po,
                a: a,
                e: e,
                dp: dp,
                pb: pb,
                sb: sb,
                cs: cs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FieldingStatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gameId = false, playerId = false, teamId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gameId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gameId,
                            referencedTable: $$FieldingStatsTableReferences
                                ._gameIdTable(db),
                            referencedColumn: $$FieldingStatsTableReferences
                                ._gameIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (playerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.playerId,
                            referencedTable: $$FieldingStatsTableReferences
                                ._playerIdTable(db),
                            referencedColumn: $$FieldingStatsTableReferences
                                ._playerIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (teamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.teamId,
                            referencedTable: $$FieldingStatsTableReferences
                                ._teamIdTable(db),
                            referencedColumn: $$FieldingStatsTableReferences
                                ._teamIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$FieldingStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FieldingStatsTable,
      FieldingStat,
      $$FieldingStatsTableFilterComposer,
      $$FieldingStatsTableOrderingComposer,
      $$FieldingStatsTableAnnotationComposer,
      $$FieldingStatsTableCreateCompanionBuilder,
      $$FieldingStatsTableUpdateCompanionBuilder,
      (FieldingStat, $$FieldingStatsTableReferences),
      FieldingStat,
      PrefetchHooks Function({bool gameId, bool playerId, bool teamId})
    >;
typedef $$StandingsTableCreateCompanionBuilder = StandingsCompanion Function({
  Value<int> id,
  required int seasonId,
  required int teamId,
  Value<int> w,
  Value<int> l,
  Value<int> t,
  Value<int> pf,
  Value<int> pa,
});
typedef $$StandingsTableUpdateCompanionBuilder = StandingsCompanion Function({
  Value<int> id,
  Value<int> seasonId,
  Value<int> teamId,
  Value<int> w,
  Value<int> l,
  Value<int> t,
  Value<int> pf,
  Value<int> pa,
});

final class $$StandingsTableReferences
    extends BaseReferences<_$AppDatabase, $StandingsTable, Standing> {
  $$StandingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeasonsTable _seasonIdTable(_$AppDatabase db) =>
      db.seasons.createAlias('standings__season_id__seasons__id');

  $$SeasonsTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$SeasonsTableTableManager(
      $_db,
      $_db.seasons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('standings__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StandingsTableFilterComposer
    extends Composer<_$AppDatabase, $StandingsTable> {
  $$StandingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get w => $composableBuilder(
    column: $table.w,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get l => $composableBuilder(
    column: $table.l,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pf => $composableBuilder(
    column: $table.pf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pa => $composableBuilder(
    column: $table.pa,
    builder: (column) => ColumnFilters(column),
  );

  $$SeasonsTableFilterComposer get seasonId {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableFilterComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StandingsTableOrderingComposer
    extends Composer<_$AppDatabase, $StandingsTable> {
  $$StandingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get w => $composableBuilder(
    column: $table.w,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get l => $composableBuilder(
    column: $table.l,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pf => $composableBuilder(
    column: $table.pf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pa => $composableBuilder(
    column: $table.pa,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeasonsTableOrderingComposer get seasonId {
    final $$SeasonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableOrderingComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StandingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StandingsTable> {
  $$StandingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get w =>
      $composableBuilder(column: $table.w, builder: (column) => column);

  GeneratedColumn<int> get l =>
      $composableBuilder(column: $table.l, builder: (column) => column);

  GeneratedColumn<int> get t =>
      $composableBuilder(column: $table.t, builder: (column) => column);

  GeneratedColumn<int> get pf =>
      $composableBuilder(column: $table.pf, builder: (column) => column);

  GeneratedColumn<int> get pa =>
      $composableBuilder(column: $table.pa, builder: (column) => column);

  $$SeasonsTableAnnotationComposer get seasonId {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StandingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StandingsTable,
          Standing,
          $$StandingsTableFilterComposer,
          $$StandingsTableOrderingComposer,
          $$StandingsTableAnnotationComposer,
          $$StandingsTableCreateCompanionBuilder,
          $$StandingsTableUpdateCompanionBuilder,
          (Standing, $$StandingsTableReferences),
          Standing,
          PrefetchHooks Function({bool seasonId, bool teamId})
        > {
  $$StandingsTableTableManager(_$AppDatabase db, $StandingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StandingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StandingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StandingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> seasonId = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<int> w = const Value.absent(),
                Value<int> l = const Value.absent(),
                Value<int> t = const Value.absent(),
                Value<int> pf = const Value.absent(),
                Value<int> pa = const Value.absent(),
              }) => StandingsCompanion(
                id: id,
                seasonId: seasonId,
                teamId: teamId,
                w: w,
                l: l,
                t: t,
                pf: pf,
                pa: pa,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int seasonId,
                required int teamId,
                Value<int> w = const Value.absent(),
                Value<int> l = const Value.absent(),
                Value<int> t = const Value.absent(),
                Value<int> pf = const Value.absent(),
                Value<int> pa = const Value.absent(),
              }) => StandingsCompanion.insert(
                id: id,
                seasonId: seasonId,
                teamId: teamId,
                w: w,
                l: l,
                t: t,
                pf: pf,
                pa: pa,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StandingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seasonId = false, teamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (seasonId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.seasonId,
                        referencedTable: $$StandingsTableReferences
                            ._seasonIdTable(db),
                        referencedColumn: $$StandingsTableReferences
                            ._seasonIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (teamId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.teamId,
                        referencedTable: $$StandingsTableReferences
                            ._teamIdTable(db),
                        referencedColumn: $$StandingsTableReferences
                            ._teamIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StandingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StandingsTable,
      Standing,
      $$StandingsTableFilterComposer,
      $$StandingsTableOrderingComposer,
      $$StandingsTableAnnotationComposer,
      $$StandingsTableCreateCompanionBuilder,
      $$StandingsTableUpdateCompanionBuilder,
      (Standing, $$StandingsTableReferences),
      Standing,
      PrefetchHooks Function({bool seasonId, bool teamId})
    >;
typedef $$TeamLineupsTableCreateCompanionBuilder =
    TeamLineupsCompanion Function({
      Value<int> id,
      required int teamId,
      required String battingOrder,
      required String pitcherRotation,
      required int fielder2Id,
      required int fielder3Id,
    });
typedef $$TeamLineupsTableUpdateCompanionBuilder =
    TeamLineupsCompanion Function({
      Value<int> id,
      Value<int> teamId,
      Value<String> battingOrder,
      Value<String> pitcherRotation,
      Value<int> fielder2Id,
      Value<int> fielder3Id,
    });

final class $$TeamLineupsTableReferences
    extends BaseReferences<_$AppDatabase, $TeamLineupsTable, TeamLineup> {
  $$TeamLineupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('team_lineups__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _fielder2IdTable(_$AppDatabase db) =>
      db.players.createAlias('team_lineups__fielder2_id__players__id');

  $$PlayersTableProcessedTableManager get fielder2Id {
    final $_column = $_itemColumn<int>('fielder2_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fielder2IdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _fielder3IdTable(_$AppDatabase db) =>
      db.players.createAlias('team_lineups__fielder3_id__players__id');

  $$PlayersTableProcessedTableManager get fielder3Id {
    final $_column = $_itemColumn<int>('fielder3_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fielder3IdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeamLineupsTableFilterComposer
    extends Composer<_$AppDatabase, $TeamLineupsTable> {
  $$TeamLineupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get battingOrder => $composableBuilder(
    column: $table.battingOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pitcherRotation => $composableBuilder(
    column: $table.pitcherRotation,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get fielder2Id {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fielder2Id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get fielder3Id {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fielder3Id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamLineupsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamLineupsTable> {
  $$TeamLineupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get battingOrder => $composableBuilder(
    column: $table.battingOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pitcherRotation => $composableBuilder(
    column: $table.pitcherRotation,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get fielder2Id {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fielder2Id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get fielder3Id {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fielder3Id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamLineupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamLineupsTable> {
  $$TeamLineupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get battingOrder => $composableBuilder(
    column: $table.battingOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pitcherRotation => $composableBuilder(
    column: $table.pitcherRotation,
    builder: (column) => column,
  );

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get fielder2Id {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fielder2Id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get fielder3Id {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fielder3Id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamLineupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamLineupsTable,
          TeamLineup,
          $$TeamLineupsTableFilterComposer,
          $$TeamLineupsTableOrderingComposer,
          $$TeamLineupsTableAnnotationComposer,
          $$TeamLineupsTableCreateCompanionBuilder,
          $$TeamLineupsTableUpdateCompanionBuilder,
          (TeamLineup, $$TeamLineupsTableReferences),
          TeamLineup,
          PrefetchHooks Function({
            bool teamId,
            bool fielder2Id,
            bool fielder3Id,
          })
        > {
  $$TeamLineupsTableTableManager(_$AppDatabase db, $TeamLineupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamLineupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamLineupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamLineupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<String> battingOrder = const Value.absent(),
                Value<String> pitcherRotation = const Value.absent(),
                Value<int> fielder2Id = const Value.absent(),
                Value<int> fielder3Id = const Value.absent(),
              }) => TeamLineupsCompanion(
                id: id,
                teamId: teamId,
                battingOrder: battingOrder,
                pitcherRotation: pitcherRotation,
                fielder2Id: fielder2Id,
                fielder3Id: fielder3Id,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int teamId,
                required String battingOrder,
                required String pitcherRotation,
                required int fielder2Id,
                required int fielder3Id,
              }) => TeamLineupsCompanion.insert(
                id: id,
                teamId: teamId,
                battingOrder: battingOrder,
                pitcherRotation: pitcherRotation,
                fielder2Id: fielder2Id,
                fielder3Id: fielder3Id,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeamLineupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({teamId = false, fielder2Id = false, fielder3Id = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (teamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.teamId,
                            referencedTable: $$TeamLineupsTableReferences
                                ._teamIdTable(db),
                            referencedColumn: $$TeamLineupsTableReferences
                                ._teamIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (fielder2Id) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.fielder2Id,
                            referencedTable: $$TeamLineupsTableReferences
                                ._fielder2IdTable(db),
                            referencedColumn: $$TeamLineupsTableReferences
                                ._fielder2IdTable(db)
                                .id,
                          ) as T;
                        }
                        if (fielder3Id) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.fielder3Id,
                            referencedTable: $$TeamLineupsTableReferences
                                ._fielder3IdTable(db),
                            referencedColumn: $$TeamLineupsTableReferences
                                ._fielder3IdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TeamLineupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamLineupsTable,
      TeamLineup,
      $$TeamLineupsTableFilterComposer,
      $$TeamLineupsTableOrderingComposer,
      $$TeamLineupsTableAnnotationComposer,
      $$TeamLineupsTableCreateCompanionBuilder,
      $$TeamLineupsTableUpdateCompanionBuilder,
      (TeamLineup, $$TeamLineupsTableReferences),
      TeamLineup,
      PrefetchHooks Function({bool teamId, bool fielder2Id, bool fielder3Id})
    >;
typedef $$InjuriesTableCreateCompanionBuilder = InjuriesCompanion Function({
  Value<int> id,
  required int playerId,
  required int seasonId,
  required int gameId,
  required InjurySeverity severity,
  required int gamesMissed,
  Value<int?> replacementPlayerId,
});
typedef $$InjuriesTableUpdateCompanionBuilder = InjuriesCompanion Function({
  Value<int> id,
  Value<int> playerId,
  Value<int> seasonId,
  Value<int> gameId,
  Value<InjurySeverity> severity,
  Value<int> gamesMissed,
  Value<int?> replacementPlayerId,
});

final class $$InjuriesTableReferences
    extends BaseReferences<_$AppDatabase, $InjuriesTable, Injury> {
  $$InjuriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('injuries__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SeasonsTable _seasonIdTable(_$AppDatabase db) =>
      db.seasons.createAlias('injuries__season_id__seasons__id');

  $$SeasonsTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$SeasonsTableTableManager(
      $_db,
      $_db.seasons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('injuries__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _replacementPlayerIdTable(_$AppDatabase db) =>
      db.players.createAlias('injuries__replacement_player_id__players__id');

  $$PlayersTableProcessedTableManager? get replacementPlayerId {
    final $_column = $_itemColumn<int>('replacement_player_id');
    if ($_column == null) return null;
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_replacementPlayerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InjuriesTableFilterComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InjurySeverity, InjurySeverity, int>
  get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get gamesMissed => $composableBuilder(
    column: $table.gamesMissed,
    builder: (column) => ColumnFilters(column),
  );

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeasonsTableFilterComposer get seasonId {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableFilterComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get replacementPlayerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.replacementPlayerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InjuriesTableOrderingComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gamesMissed => $composableBuilder(
    column: $table.gamesMissed,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeasonsTableOrderingComposer get seasonId {
    final $$SeasonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableOrderingComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get replacementPlayerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.replacementPlayerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InjuriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InjuriesTable> {
  $$InjuriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InjurySeverity, int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<int> get gamesMissed => $composableBuilder(
    column: $table.gamesMissed,
    builder: (column) => column,
  );

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeasonsTableAnnotationComposer get seasonId {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get replacementPlayerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.replacementPlayerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InjuriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InjuriesTable,
          Injury,
          $$InjuriesTableFilterComposer,
          $$InjuriesTableOrderingComposer,
          $$InjuriesTableAnnotationComposer,
          $$InjuriesTableCreateCompanionBuilder,
          $$InjuriesTableUpdateCompanionBuilder,
          (Injury, $$InjuriesTableReferences),
          Injury,
          PrefetchHooks Function({
            bool playerId,
            bool seasonId,
            bool gameId,
            bool replacementPlayerId,
          })
        > {
  $$InjuriesTableTableManager(_$AppDatabase db, $InjuriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InjuriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InjuriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InjuriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> seasonId = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<InjurySeverity> severity = const Value.absent(),
                Value<int> gamesMissed = const Value.absent(),
                Value<int?> replacementPlayerId = const Value.absent(),
              }) => InjuriesCompanion(
                id: id,
                playerId: playerId,
                seasonId: seasonId,
                gameId: gameId,
                severity: severity,
                gamesMissed: gamesMissed,
                replacementPlayerId: replacementPlayerId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playerId,
                required int seasonId,
                required int gameId,
                required InjurySeverity severity,
                required int gamesMissed,
                Value<int?> replacementPlayerId = const Value.absent(),
              }) => InjuriesCompanion.insert(
                id: id,
                playerId: playerId,
                seasonId: seasonId,
                gameId: gameId,
                severity: severity,
                gamesMissed: gamesMissed,
                replacementPlayerId: replacementPlayerId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InjuriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                playerId = false,
                seasonId = false,
                gameId = false,
                replacementPlayerId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (playerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.playerId,
                            referencedTable: $$InjuriesTableReferences
                                ._playerIdTable(db),
                            referencedColumn: $$InjuriesTableReferences
                                ._playerIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (seasonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.seasonId,
                            referencedTable: $$InjuriesTableReferences
                                ._seasonIdTable(db),
                            referencedColumn: $$InjuriesTableReferences
                                ._seasonIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (gameId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gameId,
                            referencedTable: $$InjuriesTableReferences
                                ._gameIdTable(db),
                            referencedColumn: $$InjuriesTableReferences
                                ._gameIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (replacementPlayerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.replacementPlayerId,
                            referencedTable: $$InjuriesTableReferences
                                ._replacementPlayerIdTable(db),
                            referencedColumn: $$InjuriesTableReferences
                                ._replacementPlayerIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$InjuriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InjuriesTable,
      Injury,
      $$InjuriesTableFilterComposer,
      $$InjuriesTableOrderingComposer,
      $$InjuriesTableAnnotationComposer,
      $$InjuriesTableCreateCompanionBuilder,
      $$InjuriesTableUpdateCompanionBuilder,
      (Injury, $$InjuriesTableReferences),
      Injury,
      PrefetchHooks Function({
        bool playerId,
        bool seasonId,
        bool gameId,
        bool replacementPlayerId,
      })
    >;
typedef $$DraftPicksTableCreateCompanionBuilder = DraftPicksCompanion Function({
  Value<int> id,
  required int seasonId,
  required int round,
  required int overallPick,
  required int teamId,
  required int playerId,
});
typedef $$DraftPicksTableUpdateCompanionBuilder = DraftPicksCompanion Function({
  Value<int> id,
  Value<int> seasonId,
  Value<int> round,
  Value<int> overallPick,
  Value<int> teamId,
  Value<int> playerId,
});

final class $$DraftPicksTableReferences
    extends BaseReferences<_$AppDatabase, $DraftPicksTable, DraftPick> {
  $$DraftPicksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeasonsTable _seasonIdTable(_$AppDatabase db) =>
      db.seasons.createAlias('draft_picks__season_id__seasons__id');

  $$SeasonsTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$SeasonsTableTableManager(
      $_db,
      $_db.seasons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('draft_picks__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('draft_picks__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DraftPicksTableFilterComposer
    extends Composer<_$AppDatabase, $DraftPicksTable> {
  $$DraftPicksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overallPick => $composableBuilder(
    column: $table.overallPick,
    builder: (column) => ColumnFilters(column),
  );

  $$SeasonsTableFilterComposer get seasonId {
    final $$SeasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableFilterComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftPicksTableOrderingComposer
    extends Composer<_$AppDatabase, $DraftPicksTable> {
  $$DraftPicksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overallPick => $composableBuilder(
    column: $table.overallPick,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeasonsTableOrderingComposer get seasonId {
    final $$SeasonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableOrderingComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftPicksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DraftPicksTable> {
  $$DraftPicksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<int> get overallPick => $composableBuilder(
    column: $table.overallPick,
    builder: (column) => column,
  );

  $$SeasonsTableAnnotationComposer get seasonId {
    final $$SeasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.seasons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.seasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftPicksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DraftPicksTable,
          DraftPick,
          $$DraftPicksTableFilterComposer,
          $$DraftPicksTableOrderingComposer,
          $$DraftPicksTableAnnotationComposer,
          $$DraftPicksTableCreateCompanionBuilder,
          $$DraftPicksTableUpdateCompanionBuilder,
          (DraftPick, $$DraftPicksTableReferences),
          DraftPick,
          PrefetchHooks Function({bool seasonId, bool teamId, bool playerId})
        > {
  $$DraftPicksTableTableManager(_$AppDatabase db, $DraftPicksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DraftPicksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DraftPicksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DraftPicksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> seasonId = const Value.absent(),
                Value<int> round = const Value.absent(),
                Value<int> overallPick = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
              }) => DraftPicksCompanion(
                id: id,
                seasonId: seasonId,
                round: round,
                overallPick: overallPick,
                teamId: teamId,
                playerId: playerId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int seasonId,
                required int round,
                required int overallPick,
                required int teamId,
                required int playerId,
              }) => DraftPicksCompanion.insert(
                id: id,
                seasonId: seasonId,
                round: round,
                overallPick: overallPick,
                teamId: teamId,
                playerId: playerId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DraftPicksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({seasonId = false, teamId = false, playerId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (seasonId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.seasonId,
                            referencedTable: $$DraftPicksTableReferences
                                ._seasonIdTable(db),
                            referencedColumn: $$DraftPicksTableReferences
                                ._seasonIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (teamId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.teamId,
                            referencedTable: $$DraftPicksTableReferences
                                ._teamIdTable(db),
                            referencedColumn: $$DraftPicksTableReferences
                                ._teamIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (playerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.playerId,
                            referencedTable: $$DraftPicksTableReferences
                                ._playerIdTable(db),
                            referencedColumn: $$DraftPicksTableReferences
                                ._playerIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$DraftPicksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DraftPicksTable,
      DraftPick,
      $$DraftPicksTableFilterComposer,
      $$DraftPicksTableOrderingComposer,
      $$DraftPicksTableAnnotationComposer,
      $$DraftPicksTableCreateCompanionBuilder,
      $$DraftPicksTableUpdateCompanionBuilder,
      (DraftPick, $$DraftPicksTableReferences),
      DraftPick,
      PrefetchHooks Function({bool seasonId, bool teamId, bool playerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrganizationsTableTableManager get organizations =>
      $$OrganizationsTableTableManager(_db, _db.organizations);
  $$DivisionsTableTableManager get divisions =>
      $$DivisionsTableTableManager(_db, _db.divisions);
  $$TeamsTableTableManager get teams =>
      $$TeamsTableTableManager(_db, _db.teams);
  $$SeasonsTableTableManager get seasons =>
      $$SeasonsTableTableManager(_db, _db.seasons);
  $$PlayoffSeriesTableTableManager get playoffSeries =>
      $$PlayoffSeriesTableTableManager(_db, _db.playoffSeries);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$PlayerPitchesTableTableManager get playerPitches =>
      $$PlayerPitchesTableTableManager(_db, _db.playerPitches);
  $$BattingStatsTableTableManager get battingStats =>
      $$BattingStatsTableTableManager(_db, _db.battingStats);
  $$PitchingStatsTableTableManager get pitchingStats =>
      $$PitchingStatsTableTableManager(_db, _db.pitchingStats);
  $$FieldingStatsTableTableManager get fieldingStats =>
      $$FieldingStatsTableTableManager(_db, _db.fieldingStats);
  $$StandingsTableTableManager get standings =>
      $$StandingsTableTableManager(_db, _db.standings);
  $$TeamLineupsTableTableManager get teamLineups =>
      $$TeamLineupsTableTableManager(_db, _db.teamLineups);
  $$InjuriesTableTableManager get injuries =>
      $$InjuriesTableTableManager(_db, _db.injuries);
  $$DraftPicksTableTableManager get draftPicks =>
      $$DraftPicksTableTableManager(_db, _db.draftPicks);
}
