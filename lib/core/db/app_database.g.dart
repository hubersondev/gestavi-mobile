// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientUuid,
    organisationId,
    type,
    payload,
    recordedAt,
    status,
    message,
    subjectId,
    attempts,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientUuid};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String clientUuid;
  final int organisationId;
  final String type;
  final String payload;
  final DateTime recordedAt;
  final String status;
  final String? message;
  final int? subjectId;
  final int attempts;
  final DateTime? syncedAt;
  const SyncQueueData({
    required this.clientUuid,
    required this.organisationId,
    required this.type,
    required this.payload,
    required this.recordedAt,
    required this.status,
    this.message,
    this.subjectId,
    required this.attempts,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_uuid'] = Variable<String>(clientUuid);
    map['organisation_id'] = Variable<int>(organisationId);
    map['type'] = Variable<String>(type);
    map['payload'] = Variable<String>(payload);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      clientUuid: Value(clientUuid),
      organisationId: Value(organisationId),
      type: Value(type),
      payload: Value(payload),
      recordedAt: Value(recordedAt),
      status: Value(status),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      attempts: Value(attempts),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      type: serializer.fromJson<String>(json['type']),
      payload: serializer.fromJson<String>(json['payload']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      status: serializer.fromJson<String>(json['status']),
      message: serializer.fromJson<String?>(json['message']),
      subjectId: serializer.fromJson<int?>(json['subjectId']),
      attempts: serializer.fromJson<int>(json['attempts']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientUuid': serializer.toJson<String>(clientUuid),
      'organisationId': serializer.toJson<int>(organisationId),
      'type': serializer.toJson<String>(type),
      'payload': serializer.toJson<String>(payload),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'status': serializer.toJson<String>(status),
      'message': serializer.toJson<String?>(message),
      'subjectId': serializer.toJson<int?>(subjectId),
      'attempts': serializer.toJson<int>(attempts),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SyncQueueData copyWith({
    String? clientUuid,
    int? organisationId,
    String? type,
    String? payload,
    DateTime? recordedAt,
    String? status,
    Value<String?> message = const Value.absent(),
    Value<int?> subjectId = const Value.absent(),
    int? attempts,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => SyncQueueData(
    clientUuid: clientUuid ?? this.clientUuid,
    organisationId: organisationId ?? this.organisationId,
    type: type ?? this.type,
    payload: payload ?? this.payload,
    recordedAt: recordedAt ?? this.recordedAt,
    status: status ?? this.status,
    message: message.present ? message.value : this.message,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    attempts: attempts ?? this.attempts,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      status: data.status.present ? data.status.value : this.status,
      message: data.message.present ? data.message.value : this.message,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('clientUuid: $clientUuid, ')
          ..write('organisationId: $organisationId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('status: $status, ')
          ..write('message: $message, ')
          ..write('subjectId: $subjectId, ')
          ..write('attempts: $attempts, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientUuid,
    organisationId,
    type,
    payload,
    recordedAt,
    status,
    message,
    subjectId,
    attempts,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.clientUuid == this.clientUuid &&
          other.organisationId == this.organisationId &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.recordedAt == this.recordedAt &&
          other.status == this.status &&
          other.message == this.message &&
          other.subjectId == this.subjectId &&
          other.attempts == this.attempts &&
          other.syncedAt == this.syncedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> clientUuid;
  final Value<int> organisationId;
  final Value<String> type;
  final Value<String> payload;
  final Value<DateTime> recordedAt;
  final Value<String> status;
  final Value<String?> message;
  final Value<int?> subjectId;
  final Value<int> attempts;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.clientUuid = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.message = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String clientUuid,
    required int organisationId,
    required String type,
    required String payload,
    required DateTime recordedAt,
    this.status = const Value.absent(),
    this.message = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientUuid = Value(clientUuid),
       organisationId = Value(organisationId),
       type = Value(type),
       payload = Value(payload),
       recordedAt = Value(recordedAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? clientUuid,
    Expression<int>? organisationId,
    Expression<String>? type,
    Expression<String>? payload,
    Expression<DateTime>? recordedAt,
    Expression<String>? status,
    Expression<String>? message,
    Expression<int>? subjectId,
    Expression<int>? attempts,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (organisationId != null) 'organisation_id': organisationId,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (status != null) 'status': status,
      if (message != null) 'message': message,
      if (subjectId != null) 'subject_id': subjectId,
      if (attempts != null) 'attempts': attempts,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? clientUuid,
    Value<int>? organisationId,
    Value<String>? type,
    Value<String>? payload,
    Value<DateTime>? recordedAt,
    Value<String>? status,
    Value<String?>? message,
    Value<int?>? subjectId,
    Value<int>? attempts,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      clientUuid: clientUuid ?? this.clientUuid,
      organisationId: organisationId ?? this.organisationId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      recordedAt: recordedAt ?? this.recordedAt,
      status: status ?? this.status,
      message: message ?? this.message,
      subjectId: subjectId ?? this.subjectId,
      attempts: attempts ?? this.attempts,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('clientUuid: $clientUuid, ')
          ..write('organisationId: $organisationId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('status: $status, ')
          ..write('message: $message, ')
          ..write('subjectId: $subjectId, ')
          ..write('attempts: $attempts, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedFlocksTable extends CachedFlocks
    with TableInfo<$CachedFlocksTable, CachedFlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<int> farmId = GeneratedColumn<int>(
    'farm_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _farmNameMeta = const VerificationMeta(
    'farmName',
  );
  @override
  late final GeneratedColumn<String> farmName = GeneratedColumn<String>(
    'farm_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tracksEggsMeta = const VerificationMeta(
    'tracksEggs',
  );
  @override
  late final GeneratedColumn<bool> tracksEggs = GeneratedColumn<bool>(
    'tracks_eggs',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tracks_eggs" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tracksWeightMeta = const VerificationMeta(
    'tracksWeight',
  );
  @override
  late final GeneratedColumn<bool> tracksWeight = GeneratedColumn<bool>(
    'tracks_weight',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tracks_weight" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quantityCurrentMeta = const VerificationMeta(
    'quantityCurrent',
  );
  @override
  late final GeneratedColumn<int> quantityCurrent = GeneratedColumn<int>(
    'quantity_current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ageDaysMeta = const VerificationMeta(
    'ageDays',
  );
  @override
  late final GeneratedColumn<int> ageDays = GeneratedColumn<int>(
    'age_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastRecordDateMeta = const VerificationMeta(
    'lastRecordDate',
  );
  @override
  late final GeneratedColumn<String> lastRecordDate = GeneratedColumn<String>(
    'last_record_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organisationId,
    farmId,
    code,
    name,
    farmName,
    kind,
    tracksEggs,
    tracksWeight,
    quantityCurrent,
    ageDays,
    lastRecordDate,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_flocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(
        _farmIdMeta,
        farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('farm_name')) {
      context.handle(
        _farmNameMeta,
        farmName.isAcceptableOrUnknown(data['farm_name']!, _farmNameMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('tracks_eggs')) {
      context.handle(
        _tracksEggsMeta,
        tracksEggs.isAcceptableOrUnknown(data['tracks_eggs']!, _tracksEggsMeta),
      );
    }
    if (data.containsKey('tracks_weight')) {
      context.handle(
        _tracksWeightMeta,
        tracksWeight.isAcceptableOrUnknown(
          data['tracks_weight']!,
          _tracksWeightMeta,
        ),
      );
    }
    if (data.containsKey('quantity_current')) {
      context.handle(
        _quantityCurrentMeta,
        quantityCurrent.isAcceptableOrUnknown(
          data['quantity_current']!,
          _quantityCurrentMeta,
        ),
      );
    }
    if (data.containsKey('age_days')) {
      context.handle(
        _ageDaysMeta,
        ageDays.isAcceptableOrUnknown(data['age_days']!, _ageDaysMeta),
      );
    }
    if (data.containsKey('last_record_date')) {
      context.handle(
        _lastRecordDateMeta,
        lastRecordDate.isAcceptableOrUnknown(
          data['last_record_date']!,
          _lastRecordDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedFlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFlock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      farmId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}farm_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      farmName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}farm_name'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      tracksEggs: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tracks_eggs'],
      )!,
      tracksWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tracks_weight'],
      )!,
      quantityCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_current'],
      )!,
      ageDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_days'],
      ),
      lastRecordDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_record_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $CachedFlocksTable createAlias(String alias) {
    return $CachedFlocksTable(attachedDatabase, alias);
  }
}

class CachedFlock extends DataClass implements Insertable<CachedFlock> {
  final int id;
  final int organisationId;
  final int? farmId;
  final String code;
  final String? name;
  final String? farmName;
  final String kind;
  final bool tracksEggs;
  final bool tracksWeight;
  final int quantityCurrent;
  final int? ageDays;
  final String? lastRecordDate;
  final String status;
  const CachedFlock({
    required this.id,
    required this.organisationId,
    this.farmId,
    required this.code,
    this.name,
    this.farmName,
    required this.kind,
    required this.tracksEggs,
    required this.tracksWeight,
    required this.quantityCurrent,
    this.ageDays,
    this.lastRecordDate,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organisation_id'] = Variable<int>(organisationId);
    if (!nullToAbsent || farmId != null) {
      map['farm_id'] = Variable<int>(farmId);
    }
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || farmName != null) {
      map['farm_name'] = Variable<String>(farmName);
    }
    map['kind'] = Variable<String>(kind);
    map['tracks_eggs'] = Variable<bool>(tracksEggs);
    map['tracks_weight'] = Variable<bool>(tracksWeight);
    map['quantity_current'] = Variable<int>(quantityCurrent);
    if (!nullToAbsent || ageDays != null) {
      map['age_days'] = Variable<int>(ageDays);
    }
    if (!nullToAbsent || lastRecordDate != null) {
      map['last_record_date'] = Variable<String>(lastRecordDate);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  CachedFlocksCompanion toCompanion(bool nullToAbsent) {
    return CachedFlocksCompanion(
      id: Value(id),
      organisationId: Value(organisationId),
      farmId: farmId == null && nullToAbsent
          ? const Value.absent()
          : Value(farmId),
      code: Value(code),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      farmName: farmName == null && nullToAbsent
          ? const Value.absent()
          : Value(farmName),
      kind: Value(kind),
      tracksEggs: Value(tracksEggs),
      tracksWeight: Value(tracksWeight),
      quantityCurrent: Value(quantityCurrent),
      ageDays: ageDays == null && nullToAbsent
          ? const Value.absent()
          : Value(ageDays),
      lastRecordDate: lastRecordDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRecordDate),
      status: Value(status),
    );
  }

  factory CachedFlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFlock(
      id: serializer.fromJson<int>(json['id']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      farmId: serializer.fromJson<int?>(json['farmId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String?>(json['name']),
      farmName: serializer.fromJson<String?>(json['farmName']),
      kind: serializer.fromJson<String>(json['kind']),
      tracksEggs: serializer.fromJson<bool>(json['tracksEggs']),
      tracksWeight: serializer.fromJson<bool>(json['tracksWeight']),
      quantityCurrent: serializer.fromJson<int>(json['quantityCurrent']),
      ageDays: serializer.fromJson<int?>(json['ageDays']),
      lastRecordDate: serializer.fromJson<String?>(json['lastRecordDate']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organisationId': serializer.toJson<int>(organisationId),
      'farmId': serializer.toJson<int?>(farmId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String?>(name),
      'farmName': serializer.toJson<String?>(farmName),
      'kind': serializer.toJson<String>(kind),
      'tracksEggs': serializer.toJson<bool>(tracksEggs),
      'tracksWeight': serializer.toJson<bool>(tracksWeight),
      'quantityCurrent': serializer.toJson<int>(quantityCurrent),
      'ageDays': serializer.toJson<int?>(ageDays),
      'lastRecordDate': serializer.toJson<String?>(lastRecordDate),
      'status': serializer.toJson<String>(status),
    };
  }

  CachedFlock copyWith({
    int? id,
    int? organisationId,
    Value<int?> farmId = const Value.absent(),
    String? code,
    Value<String?> name = const Value.absent(),
    Value<String?> farmName = const Value.absent(),
    String? kind,
    bool? tracksEggs,
    bool? tracksWeight,
    int? quantityCurrent,
    Value<int?> ageDays = const Value.absent(),
    Value<String?> lastRecordDate = const Value.absent(),
    String? status,
  }) => CachedFlock(
    id: id ?? this.id,
    organisationId: organisationId ?? this.organisationId,
    farmId: farmId.present ? farmId.value : this.farmId,
    code: code ?? this.code,
    name: name.present ? name.value : this.name,
    farmName: farmName.present ? farmName.value : this.farmName,
    kind: kind ?? this.kind,
    tracksEggs: tracksEggs ?? this.tracksEggs,
    tracksWeight: tracksWeight ?? this.tracksWeight,
    quantityCurrent: quantityCurrent ?? this.quantityCurrent,
    ageDays: ageDays.present ? ageDays.value : this.ageDays,
    lastRecordDate: lastRecordDate.present
        ? lastRecordDate.value
        : this.lastRecordDate,
    status: status ?? this.status,
  );
  CachedFlock copyWithCompanion(CachedFlocksCompanion data) {
    return CachedFlock(
      id: data.id.present ? data.id.value : this.id,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      farmName: data.farmName.present ? data.farmName.value : this.farmName,
      kind: data.kind.present ? data.kind.value : this.kind,
      tracksEggs: data.tracksEggs.present
          ? data.tracksEggs.value
          : this.tracksEggs,
      tracksWeight: data.tracksWeight.present
          ? data.tracksWeight.value
          : this.tracksWeight,
      quantityCurrent: data.quantityCurrent.present
          ? data.quantityCurrent.value
          : this.quantityCurrent,
      ageDays: data.ageDays.present ? data.ageDays.value : this.ageDays,
      lastRecordDate: data.lastRecordDate.present
          ? data.lastRecordDate.value
          : this.lastRecordDate,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFlock(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('farmId: $farmId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('farmName: $farmName, ')
          ..write('kind: $kind, ')
          ..write('tracksEggs: $tracksEggs, ')
          ..write('tracksWeight: $tracksWeight, ')
          ..write('quantityCurrent: $quantityCurrent, ')
          ..write('ageDays: $ageDays, ')
          ..write('lastRecordDate: $lastRecordDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organisationId,
    farmId,
    code,
    name,
    farmName,
    kind,
    tracksEggs,
    tracksWeight,
    quantityCurrent,
    ageDays,
    lastRecordDate,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFlock &&
          other.id == this.id &&
          other.organisationId == this.organisationId &&
          other.farmId == this.farmId &&
          other.code == this.code &&
          other.name == this.name &&
          other.farmName == this.farmName &&
          other.kind == this.kind &&
          other.tracksEggs == this.tracksEggs &&
          other.tracksWeight == this.tracksWeight &&
          other.quantityCurrent == this.quantityCurrent &&
          other.ageDays == this.ageDays &&
          other.lastRecordDate == this.lastRecordDate &&
          other.status == this.status);
}

class CachedFlocksCompanion extends UpdateCompanion<CachedFlock> {
  final Value<int> id;
  final Value<int> organisationId;
  final Value<int?> farmId;
  final Value<String> code;
  final Value<String?> name;
  final Value<String?> farmName;
  final Value<String> kind;
  final Value<bool> tracksEggs;
  final Value<bool> tracksWeight;
  final Value<int> quantityCurrent;
  final Value<int?> ageDays;
  final Value<String?> lastRecordDate;
  final Value<String> status;
  const CachedFlocksCompanion({
    this.id = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.farmId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.farmName = const Value.absent(),
    this.kind = const Value.absent(),
    this.tracksEggs = const Value.absent(),
    this.tracksWeight = const Value.absent(),
    this.quantityCurrent = const Value.absent(),
    this.ageDays = const Value.absent(),
    this.lastRecordDate = const Value.absent(),
    this.status = const Value.absent(),
  });
  CachedFlocksCompanion.insert({
    this.id = const Value.absent(),
    required int organisationId,
    this.farmId = const Value.absent(),
    required String code,
    this.name = const Value.absent(),
    this.farmName = const Value.absent(),
    required String kind,
    this.tracksEggs = const Value.absent(),
    this.tracksWeight = const Value.absent(),
    this.quantityCurrent = const Value.absent(),
    this.ageDays = const Value.absent(),
    this.lastRecordDate = const Value.absent(),
    required String status,
  }) : organisationId = Value(organisationId),
       code = Value(code),
       kind = Value(kind),
       status = Value(status);
  static Insertable<CachedFlock> custom({
    Expression<int>? id,
    Expression<int>? organisationId,
    Expression<int>? farmId,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? farmName,
    Expression<String>? kind,
    Expression<bool>? tracksEggs,
    Expression<bool>? tracksWeight,
    Expression<int>? quantityCurrent,
    Expression<int>? ageDays,
    Expression<String>? lastRecordDate,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organisationId != null) 'organisation_id': organisationId,
      if (farmId != null) 'farm_id': farmId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (farmName != null) 'farm_name': farmName,
      if (kind != null) 'kind': kind,
      if (tracksEggs != null) 'tracks_eggs': tracksEggs,
      if (tracksWeight != null) 'tracks_weight': tracksWeight,
      if (quantityCurrent != null) 'quantity_current': quantityCurrent,
      if (ageDays != null) 'age_days': ageDays,
      if (lastRecordDate != null) 'last_record_date': lastRecordDate,
      if (status != null) 'status': status,
    });
  }

  CachedFlocksCompanion copyWith({
    Value<int>? id,
    Value<int>? organisationId,
    Value<int?>? farmId,
    Value<String>? code,
    Value<String?>? name,
    Value<String?>? farmName,
    Value<String>? kind,
    Value<bool>? tracksEggs,
    Value<bool>? tracksWeight,
    Value<int>? quantityCurrent,
    Value<int?>? ageDays,
    Value<String?>? lastRecordDate,
    Value<String>? status,
  }) {
    return CachedFlocksCompanion(
      id: id ?? this.id,
      organisationId: organisationId ?? this.organisationId,
      farmId: farmId ?? this.farmId,
      code: code ?? this.code,
      name: name ?? this.name,
      farmName: farmName ?? this.farmName,
      kind: kind ?? this.kind,
      tracksEggs: tracksEggs ?? this.tracksEggs,
      tracksWeight: tracksWeight ?? this.tracksWeight,
      quantityCurrent: quantityCurrent ?? this.quantityCurrent,
      ageDays: ageDays ?? this.ageDays,
      lastRecordDate: lastRecordDate ?? this.lastRecordDate,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<int>(farmId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (farmName.present) {
      map['farm_name'] = Variable<String>(farmName.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (tracksEggs.present) {
      map['tracks_eggs'] = Variable<bool>(tracksEggs.value);
    }
    if (tracksWeight.present) {
      map['tracks_weight'] = Variable<bool>(tracksWeight.value);
    }
    if (quantityCurrent.present) {
      map['quantity_current'] = Variable<int>(quantityCurrent.value);
    }
    if (ageDays.present) {
      map['age_days'] = Variable<int>(ageDays.value);
    }
    if (lastRecordDate.present) {
      map['last_record_date'] = Variable<String>(lastRecordDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFlocksCompanion(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('farmId: $farmId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('farmName: $farmName, ')
          ..write('kind: $kind, ')
          ..write('tracksEggs: $tracksEggs, ')
          ..write('tracksWeight: $tracksWeight, ')
          ..write('quantityCurrent: $quantityCurrent, ')
          ..write('ageDays: $ageDays, ')
          ..write('lastRecordDate: $lastRecordDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $CachedCustomersTable extends CachedCustomers
    with TableInfo<$CachedCustomersTable, CachedCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, organisationId, name, code, phone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCustomer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCustomer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
    );
  }

  @override
  $CachedCustomersTable createAlias(String alias) {
    return $CachedCustomersTable(attachedDatabase, alias);
  }
}

class CachedCustomer extends DataClass implements Insertable<CachedCustomer> {
  final int id;
  final int organisationId;
  final String name;
  final String? code;
  final String? phone;
  const CachedCustomer({
    required this.id,
    required this.organisationId,
    required this.name,
    this.code,
    this.phone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organisation_id'] = Variable<int>(organisationId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    return map;
  }

  CachedCustomersCompanion toCompanion(bool nullToAbsent) {
    return CachedCustomersCompanion(
      id: Value(id),
      organisationId: Value(organisationId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
    );
  }

  factory CachedCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCustomer(
      id: serializer.fromJson<int>(json['id']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      phone: serializer.fromJson<String?>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organisationId': serializer.toJson<int>(organisationId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'phone': serializer.toJson<String?>(phone),
    };
  }

  CachedCustomer copyWith({
    int? id,
    int? organisationId,
    String? name,
    Value<String?> code = const Value.absent(),
    Value<String?> phone = const Value.absent(),
  }) => CachedCustomer(
    id: id ?? this.id,
    organisationId: organisationId ?? this.organisationId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    phone: phone.present ? phone.value : this.phone,
  );
  CachedCustomer copyWithCompanion(CachedCustomersCompanion data) {
    return CachedCustomer(
      id: data.id.present ? data.id.value : this.id,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomer(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, organisationId, name, code, phone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCustomer &&
          other.id == this.id &&
          other.organisationId == this.organisationId &&
          other.name == this.name &&
          other.code == this.code &&
          other.phone == this.phone);
}

class CachedCustomersCompanion extends UpdateCompanion<CachedCustomer> {
  final Value<int> id;
  final Value<int> organisationId;
  final Value<String> name;
  final Value<String?> code;
  final Value<String?> phone;
  const CachedCustomersCompanion({
    this.id = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.phone = const Value.absent(),
  });
  CachedCustomersCompanion.insert({
    this.id = const Value.absent(),
    required int organisationId,
    required String name,
    this.code = const Value.absent(),
    this.phone = const Value.absent(),
  }) : organisationId = Value(organisationId),
       name = Value(name);
  static Insertable<CachedCustomer> custom({
    Expression<int>? id,
    Expression<int>? organisationId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? phone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organisationId != null) 'organisation_id': organisationId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (phone != null) 'phone': phone,
    });
  }

  CachedCustomersCompanion copyWith({
    Value<int>? id,
    Value<int>? organisationId,
    Value<String>? name,
    Value<String?>? code,
    Value<String?>? phone,
  }) {
    return CachedCustomersCompanion(
      id: id ?? this.id,
      organisationId: organisationId ?? this.organisationId,
      name: name ?? this.name,
      code: code ?? this.code,
      phone: phone ?? this.phone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomersCompanion(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }
}

class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxPercentMeta = const VerificationMeta(
    'taxPercent',
  );
  @override
  late final GeneratedColumn<double> taxPercent = GeneratedColumn<double>(
    'tax_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLiveBirdsMeta = const VerificationMeta(
    'isLiveBirds',
  );
  @override
  late final GeneratedColumn<bool> isLiveBirds = GeneratedColumn<bool>(
    'is_live_birds',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_live_birds" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organisationId,
    name,
    unit,
    unitPrice,
    taxPercent,
    isLiveBirds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('tax_percent')) {
      context.handle(
        _taxPercentMeta,
        taxPercent.isAcceptableOrUnknown(data['tax_percent']!, _taxPercentMeta),
      );
    }
    if (data.containsKey('is_live_birds')) {
      context.handle(
        _isLiveBirdsMeta,
        isLiveBirds.isAcceptableOrUnknown(
          data['is_live_birds']!,
          _isLiveBirdsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      taxPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_percent'],
      )!,
      isLiveBirds: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_live_birds'],
      )!,
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final int id;
  final int organisationId;
  final String name;
  final String? unit;
  final double unitPrice;
  final double taxPercent;
  final bool isLiveBirds;
  const CachedProduct({
    required this.id,
    required this.organisationId,
    required this.name,
    this.unit,
    required this.unitPrice,
    required this.taxPercent,
    required this.isLiveBirds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organisation_id'] = Variable<int>(organisationId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['unit_price'] = Variable<double>(unitPrice);
    map['tax_percent'] = Variable<double>(taxPercent);
    map['is_live_birds'] = Variable<bool>(isLiveBirds);
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      id: Value(id),
      organisationId: Value(organisationId),
      name: Value(name),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      unitPrice: Value(unitPrice),
      taxPercent: Value(taxPercent),
      isLiveBirds: Value(isLiveBirds),
    );
  }

  factory CachedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      id: serializer.fromJson<int>(json['id']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String?>(json['unit']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      taxPercent: serializer.fromJson<double>(json['taxPercent']),
      isLiveBirds: serializer.fromJson<bool>(json['isLiveBirds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organisationId': serializer.toJson<int>(organisationId),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String?>(unit),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'taxPercent': serializer.toJson<double>(taxPercent),
      'isLiveBirds': serializer.toJson<bool>(isLiveBirds),
    };
  }

  CachedProduct copyWith({
    int? id,
    int? organisationId,
    String? name,
    Value<String?> unit = const Value.absent(),
    double? unitPrice,
    double? taxPercent,
    bool? isLiveBirds,
  }) => CachedProduct(
    id: id ?? this.id,
    organisationId: organisationId ?? this.organisationId,
    name: name ?? this.name,
    unit: unit.present ? unit.value : this.unit,
    unitPrice: unitPrice ?? this.unitPrice,
    taxPercent: taxPercent ?? this.taxPercent,
    isLiveBirds: isLiveBirds ?? this.isLiveBirds,
  );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      id: data.id.present ? data.id.value : this.id,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      taxPercent: data.taxPercent.present
          ? data.taxPercent.value
          : this.taxPercent,
      isLiveBirds: data.isLiveBirds.present
          ? data.isLiveBirds.value
          : this.isLiveBirds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxPercent: $taxPercent, ')
          ..write('isLiveBirds: $isLiveBirds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organisationId,
    name,
    unit,
    unitPrice,
    taxPercent,
    isLiveBirds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.id == this.id &&
          other.organisationId == this.organisationId &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.unitPrice == this.unitPrice &&
          other.taxPercent == this.taxPercent &&
          other.isLiveBirds == this.isLiveBirds);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<int> id;
  final Value<int> organisationId;
  final Value<String> name;
  final Value<String?> unit;
  final Value<double> unitPrice;
  final Value<double> taxPercent;
  final Value<bool> isLiveBirds;
  const CachedProductsCompanion({
    this.id = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.taxPercent = const Value.absent(),
    this.isLiveBirds = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    this.id = const Value.absent(),
    required int organisationId,
    required String name,
    this.unit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.taxPercent = const Value.absent(),
    this.isLiveBirds = const Value.absent(),
  }) : organisationId = Value(organisationId),
       name = Value(name);
  static Insertable<CachedProduct> custom({
    Expression<int>? id,
    Expression<int>? organisationId,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? unitPrice,
    Expression<double>? taxPercent,
    Expression<bool>? isLiveBirds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organisationId != null) 'organisation_id': organisationId,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (taxPercent != null) 'tax_percent': taxPercent,
      if (isLiveBirds != null) 'is_live_birds': isLiveBirds,
    });
  }

  CachedProductsCompanion copyWith({
    Value<int>? id,
    Value<int>? organisationId,
    Value<String>? name,
    Value<String?>? unit,
    Value<double>? unitPrice,
    Value<double>? taxPercent,
    Value<bool>? isLiveBirds,
  }) {
    return CachedProductsCompanion(
      id: id ?? this.id,
      organisationId: organisationId ?? this.organisationId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      taxPercent: taxPercent ?? this.taxPercent,
      isLiveBirds: isLiveBirds ?? this.isLiveBirds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (taxPercent.present) {
      map['tax_percent'] = Variable<double>(taxPercent.value);
    }
    if (isLiveBirds.present) {
      map['is_live_birds'] = Variable<bool>(isLiveBirds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxPercent: $taxPercent, ')
          ..write('isLiveBirds: $isLiveBirds')
          ..write(')'))
        .toString();
  }
}

class $CachedStocksTable extends CachedStocks
    with TableInfo<$CachedStocksTable, CachedStock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedStocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<int> farmId = GeneratedColumn<int>(
    'farm_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minQuantityMeta = const VerificationMeta(
    'minQuantity',
  );
  @override
  late final GeneratedColumn<double> minQuantity = GeneratedColumn<double>(
    'min_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organisationId,
    farmId,
    name,
    category,
    unit,
    quantity,
    minQuantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_stocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedStock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(
        _farmIdMeta,
        farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('min_quantity')) {
      context.handle(
        _minQuantityMeta,
        minQuantity.isAcceptableOrUnknown(
          data['min_quantity']!,
          _minQuantityMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedStock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedStock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      farmId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}farm_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      minQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_quantity'],
      )!,
    );
  }

  @override
  $CachedStocksTable createAlias(String alias) {
    return $CachedStocksTable(attachedDatabase, alias);
  }
}

class CachedStock extends DataClass implements Insertable<CachedStock> {
  final int id;
  final int organisationId;
  final int? farmId;
  final String name;
  final String? category;
  final String unit;
  final double quantity;
  final double minQuantity;
  const CachedStock({
    required this.id,
    required this.organisationId,
    this.farmId,
    required this.name,
    this.category,
    required this.unit,
    required this.quantity,
    required this.minQuantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organisation_id'] = Variable<int>(organisationId);
    if (!nullToAbsent || farmId != null) {
      map['farm_id'] = Variable<int>(farmId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['unit'] = Variable<String>(unit);
    map['quantity'] = Variable<double>(quantity);
    map['min_quantity'] = Variable<double>(minQuantity);
    return map;
  }

  CachedStocksCompanion toCompanion(bool nullToAbsent) {
    return CachedStocksCompanion(
      id: Value(id),
      organisationId: Value(organisationId),
      farmId: farmId == null && nullToAbsent
          ? const Value.absent()
          : Value(farmId),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      unit: Value(unit),
      quantity: Value(quantity),
      minQuantity: Value(minQuantity),
    );
  }

  factory CachedStock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedStock(
      id: serializer.fromJson<int>(json['id']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      farmId: serializer.fromJson<int?>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      unit: serializer.fromJson<String>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      minQuantity: serializer.fromJson<double>(json['minQuantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organisationId': serializer.toJson<int>(organisationId),
      'farmId': serializer.toJson<int?>(farmId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'unit': serializer.toJson<String>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'minQuantity': serializer.toJson<double>(minQuantity),
    };
  }

  CachedStock copyWith({
    int? id,
    int? organisationId,
    Value<int?> farmId = const Value.absent(),
    String? name,
    Value<String?> category = const Value.absent(),
    String? unit,
    double? quantity,
    double? minQuantity,
  }) => CachedStock(
    id: id ?? this.id,
    organisationId: organisationId ?? this.organisationId,
    farmId: farmId.present ? farmId.value : this.farmId,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    unit: unit ?? this.unit,
    quantity: quantity ?? this.quantity,
    minQuantity: minQuantity ?? this.minQuantity,
  );
  CachedStock copyWithCompanion(CachedStocksCompanion data) {
    return CachedStock(
      id: data.id.present ? data.id.value : this.id,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      minQuantity: data.minQuantity.present
          ? data.minQuantity.value
          : this.minQuantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedStock(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('minQuantity: $minQuantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organisationId,
    farmId,
    name,
    category,
    unit,
    quantity,
    minQuantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedStock &&
          other.id == this.id &&
          other.organisationId == this.organisationId &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.minQuantity == this.minQuantity);
}

class CachedStocksCompanion extends UpdateCompanion<CachedStock> {
  final Value<int> id;
  final Value<int> organisationId;
  final Value<int?> farmId;
  final Value<String> name;
  final Value<String?> category;
  final Value<String> unit;
  final Value<double> quantity;
  final Value<double> minQuantity;
  const CachedStocksCompanion({
    this.id = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.minQuantity = const Value.absent(),
  });
  CachedStocksCompanion.insert({
    this.id = const Value.absent(),
    required int organisationId,
    this.farmId = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    required String unit,
    this.quantity = const Value.absent(),
    this.minQuantity = const Value.absent(),
  }) : organisationId = Value(organisationId),
       name = Value(name),
       unit = Value(unit);
  static Insertable<CachedStock> custom({
    Expression<int>? id,
    Expression<int>? organisationId,
    Expression<int>? farmId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<double>? minQuantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organisationId != null) 'organisation_id': organisationId,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (minQuantity != null) 'min_quantity': minQuantity,
    });
  }

  CachedStocksCompanion copyWith({
    Value<int>? id,
    Value<int>? organisationId,
    Value<int?>? farmId,
    Value<String>? name,
    Value<String?>? category,
    Value<String>? unit,
    Value<double>? quantity,
    Value<double>? minQuantity,
  }) {
    return CachedStocksCompanion(
      id: id ?? this.id,
      organisationId: organisationId ?? this.organisationId,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<int>(farmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (minQuantity.present) {
      map['min_quantity'] = Variable<double>(minQuantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedStocksCompanion(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('minQuantity: $minQuantity')
          ..write(')'))
        .toString();
  }
}

class $CachedSalesTable extends CachedSales
    with TableInfo<$CachedSalesTable, CachedSale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<int> farmId = GeneratedColumn<int>(
    'farm_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saleDateMeta = const VerificationMeta(
    'saleDate',
  );
  @override
  late final GeneratedColumn<String> saleDate = GeneratedColumn<String>(
    'sale_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<double> paid = GeneratedColumn<double>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    organisationId,
    farmId,
    serverId,
    clientUuid,
    invoiceNumber,
    saleDate,
    customerName,
    total,
    paid,
    status,
    summary,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(
        _farmIdMeta,
        farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('sale_date')) {
      context.handle(
        _saleDateMeta,
        saleDate.isAcceptableOrUnknown(data['sale_date']!, _saleDateMeta),
      );
    } else if (isInserting) {
      context.missing(_saleDateMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CachedSale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSale(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      farmId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}farm_id'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      ),
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      ),
      saleDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_date'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedSalesTable createAlias(String alias) {
    return $CachedSalesTable(attachedDatabase, alias);
  }
}

class CachedSale extends DataClass implements Insertable<CachedSale> {
  final String key;
  final int organisationId;
  final int? farmId;
  final int? serverId;
  final String? clientUuid;
  final String? invoiceNumber;
  final String saleDate;
  final String? customerName;
  final double total;
  final double paid;
  final String status;
  final String? summary;
  final DateTime updatedAt;
  const CachedSale({
    required this.key,
    required this.organisationId,
    this.farmId,
    this.serverId,
    this.clientUuid,
    this.invoiceNumber,
    required this.saleDate,
    this.customerName,
    required this.total,
    required this.paid,
    required this.status,
    this.summary,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['organisation_id'] = Variable<int>(organisationId);
    if (!nullToAbsent || farmId != null) {
      map['farm_id'] = Variable<int>(farmId);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || clientUuid != null) {
      map['client_uuid'] = Variable<String>(clientUuid);
    }
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    map['sale_date'] = Variable<String>(saleDate);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['total'] = Variable<double>(total);
    map['paid'] = Variable<double>(paid);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedSalesCompanion toCompanion(bool nullToAbsent) {
    return CachedSalesCompanion(
      key: Value(key),
      organisationId: Value(organisationId),
      farmId: farmId == null && nullToAbsent
          ? const Value.absent()
          : Value(farmId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      clientUuid: clientUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(clientUuid),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      saleDate: Value(saleDate),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      total: Value(total),
      paid: Value(paid),
      status: Value(status),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedSale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSale(
      key: serializer.fromJson<String>(json['key']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      farmId: serializer.fromJson<int?>(json['farmId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      clientUuid: serializer.fromJson<String?>(json['clientUuid']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      saleDate: serializer.fromJson<String>(json['saleDate']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      total: serializer.fromJson<double>(json['total']),
      paid: serializer.fromJson<double>(json['paid']),
      status: serializer.fromJson<String>(json['status']),
      summary: serializer.fromJson<String?>(json['summary']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'organisationId': serializer.toJson<int>(organisationId),
      'farmId': serializer.toJson<int?>(farmId),
      'serverId': serializer.toJson<int?>(serverId),
      'clientUuid': serializer.toJson<String?>(clientUuid),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'saleDate': serializer.toJson<String>(saleDate),
      'customerName': serializer.toJson<String?>(customerName),
      'total': serializer.toJson<double>(total),
      'paid': serializer.toJson<double>(paid),
      'status': serializer.toJson<String>(status),
      'summary': serializer.toJson<String?>(summary),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedSale copyWith({
    String? key,
    int? organisationId,
    Value<int?> farmId = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    Value<String?> clientUuid = const Value.absent(),
    Value<String?> invoiceNumber = const Value.absent(),
    String? saleDate,
    Value<String?> customerName = const Value.absent(),
    double? total,
    double? paid,
    String? status,
    Value<String?> summary = const Value.absent(),
    DateTime? updatedAt,
  }) => CachedSale(
    key: key ?? this.key,
    organisationId: organisationId ?? this.organisationId,
    farmId: farmId.present ? farmId.value : this.farmId,
    serverId: serverId.present ? serverId.value : this.serverId,
    clientUuid: clientUuid.present ? clientUuid.value : this.clientUuid,
    invoiceNumber: invoiceNumber.present
        ? invoiceNumber.value
        : this.invoiceNumber,
    saleDate: saleDate ?? this.saleDate,
    customerName: customerName.present ? customerName.value : this.customerName,
    total: total ?? this.total,
    paid: paid ?? this.paid,
    status: status ?? this.status,
    summary: summary.present ? summary.value : this.summary,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedSale copyWithCompanion(CachedSalesCompanion data) {
    return CachedSale(
      key: data.key.present ? data.key.value : this.key,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      saleDate: data.saleDate.present ? data.saleDate.value : this.saleDate,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      total: data.total.present ? data.total.value : this.total,
      paid: data.paid.present ? data.paid.value : this.paid,
      status: data.status.present ? data.status.value : this.status,
      summary: data.summary.present ? data.summary.value : this.summary,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSale(')
          ..write('key: $key, ')
          ..write('organisationId: $organisationId, ')
          ..write('farmId: $farmId, ')
          ..write('serverId: $serverId, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('saleDate: $saleDate, ')
          ..write('customerName: $customerName, ')
          ..write('total: $total, ')
          ..write('paid: $paid, ')
          ..write('status: $status, ')
          ..write('summary: $summary, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    organisationId,
    farmId,
    serverId,
    clientUuid,
    invoiceNumber,
    saleDate,
    customerName,
    total,
    paid,
    status,
    summary,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSale &&
          other.key == this.key &&
          other.organisationId == this.organisationId &&
          other.farmId == this.farmId &&
          other.serverId == this.serverId &&
          other.clientUuid == this.clientUuid &&
          other.invoiceNumber == this.invoiceNumber &&
          other.saleDate == this.saleDate &&
          other.customerName == this.customerName &&
          other.total == this.total &&
          other.paid == this.paid &&
          other.status == this.status &&
          other.summary == this.summary &&
          other.updatedAt == this.updatedAt);
}

class CachedSalesCompanion extends UpdateCompanion<CachedSale> {
  final Value<String> key;
  final Value<int> organisationId;
  final Value<int?> farmId;
  final Value<int?> serverId;
  final Value<String?> clientUuid;
  final Value<String?> invoiceNumber;
  final Value<String> saleDate;
  final Value<String?> customerName;
  final Value<double> total;
  final Value<double> paid;
  final Value<String> status;
  final Value<String?> summary;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedSalesCompanion({
    this.key = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.farmId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.saleDate = const Value.absent(),
    this.customerName = const Value.absent(),
    this.total = const Value.absent(),
    this.paid = const Value.absent(),
    this.status = const Value.absent(),
    this.summary = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSalesCompanion.insert({
    required String key,
    required int organisationId,
    this.farmId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    required String saleDate,
    this.customerName = const Value.absent(),
    this.total = const Value.absent(),
    this.paid = const Value.absent(),
    required String status,
    this.summary = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       organisationId = Value(organisationId),
       saleDate = Value(saleDate),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<CachedSale> custom({
    Expression<String>? key,
    Expression<int>? organisationId,
    Expression<int>? farmId,
    Expression<int>? serverId,
    Expression<String>? clientUuid,
    Expression<String>? invoiceNumber,
    Expression<String>? saleDate,
    Expression<String>? customerName,
    Expression<double>? total,
    Expression<double>? paid,
    Expression<String>? status,
    Expression<String>? summary,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (organisationId != null) 'organisation_id': organisationId,
      if (farmId != null) 'farm_id': farmId,
      if (serverId != null) 'server_id': serverId,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (saleDate != null) 'sale_date': saleDate,
      if (customerName != null) 'customer_name': customerName,
      if (total != null) 'total': total,
      if (paid != null) 'paid': paid,
      if (status != null) 'status': status,
      if (summary != null) 'summary': summary,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSalesCompanion copyWith({
    Value<String>? key,
    Value<int>? organisationId,
    Value<int?>? farmId,
    Value<int?>? serverId,
    Value<String?>? clientUuid,
    Value<String?>? invoiceNumber,
    Value<String>? saleDate,
    Value<String?>? customerName,
    Value<double>? total,
    Value<double>? paid,
    Value<String>? status,
    Value<String?>? summary,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedSalesCompanion(
      key: key ?? this.key,
      organisationId: organisationId ?? this.organisationId,
      farmId: farmId ?? this.farmId,
      serverId: serverId ?? this.serverId,
      clientUuid: clientUuid ?? this.clientUuid,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      saleDate: saleDate ?? this.saleDate,
      customerName: customerName ?? this.customerName,
      total: total ?? this.total,
      paid: paid ?? this.paid,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<int>(farmId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (saleDate.present) {
      map['sale_date'] = Variable<String>(saleDate.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (paid.present) {
      map['paid'] = Variable<double>(paid.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSalesCompanion(')
          ..write('key: $key, ')
          ..write('organisationId: $organisationId, ')
          ..write('farmId: $farmId, ')
          ..write('serverId: $serverId, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('saleDate: $saleDate, ')
          ..write('customerName: $customerName, ')
          ..write('total: $total, ')
          ..write('paid: $paid, ')
          ..write('status: $status, ')
          ..write('summary: $summary, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedNotificationsTable extends CachedNotifications
    with TableInfo<$CachedNotificationsTable, CachedNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    status,
    url,
    readAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CachedNotificationsTable createAlias(String alias) {
    return $CachedNotificationsTable(attachedDatabase, alias);
  }
}

class CachedNotification extends DataClass
    implements Insertable<CachedNotification> {
  final String id;
  final String? title;
  final String? body;
  final String? status;
  final String? url;
  final DateTime? readAt;
  final DateTime createdAt;
  const CachedNotification({
    required this.id,
    this.title,
    this.body,
    this.status,
    this.url,
    this.readAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CachedNotificationsCompanion toCompanion(bool nullToAbsent) {
    return CachedNotificationsCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      createdAt: Value(createdAt),
    );
  }

  factory CachedNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedNotification(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      status: serializer.fromJson<String?>(json['status']),
      url: serializer.fromJson<String?>(json['url']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String?>(body),
      'status': serializer.toJson<String?>(status),
      'url': serializer.toJson<String?>(url),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CachedNotification copyWith({
    String? id,
    Value<String?> title = const Value.absent(),
    Value<String?> body = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<DateTime?> readAt = const Value.absent(),
    DateTime? createdAt,
  }) => CachedNotification(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    body: body.present ? body.value : this.body,
    status: status.present ? status.value : this.status,
    url: url.present ? url.value : this.url,
    readAt: readAt.present ? readAt.value : this.readAt,
    createdAt: createdAt ?? this.createdAt,
  );
  CachedNotification copyWithCompanion(CachedNotificationsCompanion data) {
    return CachedNotification(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      status: data.status.present ? data.status.value : this.status,
      url: data.url.present ? data.url.value : this.url,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedNotification(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('url: $url, ')
          ..write('readAt: $readAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, status, url, readAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedNotification &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.status == this.status &&
          other.url == this.url &&
          other.readAt == this.readAt &&
          other.createdAt == this.createdAt);
}

class CachedNotificationsCompanion extends UpdateCompanion<CachedNotification> {
  final Value<String> id;
  final Value<String?> title;
  final Value<String?> body;
  final Value<String?> status;
  final Value<String?> url;
  final Value<DateTime?> readAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CachedNotificationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.status = const Value.absent(),
    this.url = const Value.absent(),
    this.readAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedNotificationsCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.status = const Value.absent(),
    this.url = const Value.absent(),
    this.readAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt);
  static Insertable<CachedNotification> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? status,
    Expression<String>? url,
    Expression<DateTime>? readAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (status != null) 'status': status,
      if (url != null) 'url': url,
      if (readAt != null) 'read_at': readAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String?>? title,
    Value<String?>? body,
    Value<String?>? status,
    Value<String?>? url,
    Value<DateTime?>? readAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CachedNotificationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      status: status ?? this.status,
      url: url ?? this.url,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('url: $url, ')
          ..write('readAt: $readAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedVaccinationsTable extends CachedVaccinations
    with TableInfo<$CachedVaccinationsTable, CachedVaccination> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedVaccinationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organisationIdMeta = const VerificationMeta(
    'organisationId',
  );
  @override
  late final GeneratedColumn<int> organisationId = GeneratedColumn<int>(
    'organisation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flockIdMeta = const VerificationMeta(
    'flockId',
  );
  @override
  late final GeneratedColumn<int> flockId = GeneratedColumn<int>(
    'flock_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<int> farmId = GeneratedColumn<int>(
    'farm_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flockCodeMeta = const VerificationMeta(
    'flockCode',
  );
  @override
  late final GeneratedColumn<String> flockCode = GeneratedColumn<String>(
    'flock_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _treatmentNameMeta = const VerificationMeta(
    'treatmentName',
  );
  @override
  late final GeneratedColumn<String> treatmentName = GeneratedColumn<String>(
    'treatment_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _treatmentTypeMeta = const VerificationMeta(
    'treatmentType',
  );
  @override
  late final GeneratedColumn<String> treatmentType = GeneratedColumn<String>(
    'treatment_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _administrationRouteMeta =
      const VerificationMeta('administrationRoute');
  @override
  late final GeneratedColumn<String> administrationRoute =
      GeneratedColumn<String>(
        'administration_route',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<String> scheduledDate = GeneratedColumn<String>(
    'scheduled_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _administeredDateMeta = const VerificationMeta(
    'administeredDate',
  );
  @override
  late final GeneratedColumn<String> administeredDate = GeneratedColumn<String>(
    'administered_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOverdueMeta = const VerificationMeta(
    'isOverdue',
  );
  @override
  late final GeneratedColumn<bool> isOverdue = GeneratedColumn<bool>(
    'is_overdue',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_overdue" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organisationId,
    flockId,
    farmId,
    flockCode,
    treatmentName,
    treatmentType,
    administrationRoute,
    dosage,
    scheduledDate,
    administeredDate,
    status,
    isOverdue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_vaccinations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedVaccination> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organisation_id')) {
      context.handle(
        _organisationIdMeta,
        organisationId.isAcceptableOrUnknown(
          data['organisation_id']!,
          _organisationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisationIdMeta);
    }
    if (data.containsKey('flock_id')) {
      context.handle(
        _flockIdMeta,
        flockId.isAcceptableOrUnknown(data['flock_id']!, _flockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_flockIdMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(
        _farmIdMeta,
        farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta),
      );
    }
    if (data.containsKey('flock_code')) {
      context.handle(
        _flockCodeMeta,
        flockCode.isAcceptableOrUnknown(data['flock_code']!, _flockCodeMeta),
      );
    }
    if (data.containsKey('treatment_name')) {
      context.handle(
        _treatmentNameMeta,
        treatmentName.isAcceptableOrUnknown(
          data['treatment_name']!,
          _treatmentNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_treatmentNameMeta);
    }
    if (data.containsKey('treatment_type')) {
      context.handle(
        _treatmentTypeMeta,
        treatmentType.isAcceptableOrUnknown(
          data['treatment_type']!,
          _treatmentTypeMeta,
        ),
      );
    }
    if (data.containsKey('administration_route')) {
      context.handle(
        _administrationRouteMeta,
        administrationRoute.isAcceptableOrUnknown(
          data['administration_route']!,
          _administrationRouteMeta,
        ),
      );
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('administered_date')) {
      context.handle(
        _administeredDateMeta,
        administeredDate.isAcceptableOrUnknown(
          data['administered_date']!,
          _administeredDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_overdue')) {
      context.handle(
        _isOverdueMeta,
        isOverdue.isAcceptableOrUnknown(data['is_overdue']!, _isOverdueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedVaccination map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedVaccination(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organisationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organisation_id'],
      )!,
      flockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flock_id'],
      )!,
      farmId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}farm_id'],
      ),
      flockCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flock_code'],
      ),
      treatmentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}treatment_name'],
      )!,
      treatmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}treatment_type'],
      ),
      administrationRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}administration_route'],
      ),
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      ),
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_date'],
      )!,
      administeredDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}administered_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isOverdue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_overdue'],
      )!,
    );
  }

  @override
  $CachedVaccinationsTable createAlias(String alias) {
    return $CachedVaccinationsTable(attachedDatabase, alias);
  }
}

class CachedVaccination extends DataClass
    implements Insertable<CachedVaccination> {
  final int id;
  final int organisationId;
  final int flockId;
  final int? farmId;
  final String? flockCode;
  final String treatmentName;
  final String? treatmentType;
  final String? administrationRoute;
  final String? dosage;
  final String scheduledDate;
  final String? administeredDate;
  final String status;
  final bool isOverdue;
  const CachedVaccination({
    required this.id,
    required this.organisationId,
    required this.flockId,
    this.farmId,
    this.flockCode,
    required this.treatmentName,
    this.treatmentType,
    this.administrationRoute,
    this.dosage,
    required this.scheduledDate,
    this.administeredDate,
    required this.status,
    required this.isOverdue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organisation_id'] = Variable<int>(organisationId);
    map['flock_id'] = Variable<int>(flockId);
    if (!nullToAbsent || farmId != null) {
      map['farm_id'] = Variable<int>(farmId);
    }
    if (!nullToAbsent || flockCode != null) {
      map['flock_code'] = Variable<String>(flockCode);
    }
    map['treatment_name'] = Variable<String>(treatmentName);
    if (!nullToAbsent || treatmentType != null) {
      map['treatment_type'] = Variable<String>(treatmentType);
    }
    if (!nullToAbsent || administrationRoute != null) {
      map['administration_route'] = Variable<String>(administrationRoute);
    }
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    map['scheduled_date'] = Variable<String>(scheduledDate);
    if (!nullToAbsent || administeredDate != null) {
      map['administered_date'] = Variable<String>(administeredDate);
    }
    map['status'] = Variable<String>(status);
    map['is_overdue'] = Variable<bool>(isOverdue);
    return map;
  }

  CachedVaccinationsCompanion toCompanion(bool nullToAbsent) {
    return CachedVaccinationsCompanion(
      id: Value(id),
      organisationId: Value(organisationId),
      flockId: Value(flockId),
      farmId: farmId == null && nullToAbsent
          ? const Value.absent()
          : Value(farmId),
      flockCode: flockCode == null && nullToAbsent
          ? const Value.absent()
          : Value(flockCode),
      treatmentName: Value(treatmentName),
      treatmentType: treatmentType == null && nullToAbsent
          ? const Value.absent()
          : Value(treatmentType),
      administrationRoute: administrationRoute == null && nullToAbsent
          ? const Value.absent()
          : Value(administrationRoute),
      dosage: dosage == null && nullToAbsent
          ? const Value.absent()
          : Value(dosage),
      scheduledDate: Value(scheduledDate),
      administeredDate: administeredDate == null && nullToAbsent
          ? const Value.absent()
          : Value(administeredDate),
      status: Value(status),
      isOverdue: Value(isOverdue),
    );
  }

  factory CachedVaccination.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedVaccination(
      id: serializer.fromJson<int>(json['id']),
      organisationId: serializer.fromJson<int>(json['organisationId']),
      flockId: serializer.fromJson<int>(json['flockId']),
      farmId: serializer.fromJson<int?>(json['farmId']),
      flockCode: serializer.fromJson<String?>(json['flockCode']),
      treatmentName: serializer.fromJson<String>(json['treatmentName']),
      treatmentType: serializer.fromJson<String?>(json['treatmentType']),
      administrationRoute: serializer.fromJson<String?>(
        json['administrationRoute'],
      ),
      dosage: serializer.fromJson<String?>(json['dosage']),
      scheduledDate: serializer.fromJson<String>(json['scheduledDate']),
      administeredDate: serializer.fromJson<String?>(json['administeredDate']),
      status: serializer.fromJson<String>(json['status']),
      isOverdue: serializer.fromJson<bool>(json['isOverdue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organisationId': serializer.toJson<int>(organisationId),
      'flockId': serializer.toJson<int>(flockId),
      'farmId': serializer.toJson<int?>(farmId),
      'flockCode': serializer.toJson<String?>(flockCode),
      'treatmentName': serializer.toJson<String>(treatmentName),
      'treatmentType': serializer.toJson<String?>(treatmentType),
      'administrationRoute': serializer.toJson<String?>(administrationRoute),
      'dosage': serializer.toJson<String?>(dosage),
      'scheduledDate': serializer.toJson<String>(scheduledDate),
      'administeredDate': serializer.toJson<String?>(administeredDate),
      'status': serializer.toJson<String>(status),
      'isOverdue': serializer.toJson<bool>(isOverdue),
    };
  }

  CachedVaccination copyWith({
    int? id,
    int? organisationId,
    int? flockId,
    Value<int?> farmId = const Value.absent(),
    Value<String?> flockCode = const Value.absent(),
    String? treatmentName,
    Value<String?> treatmentType = const Value.absent(),
    Value<String?> administrationRoute = const Value.absent(),
    Value<String?> dosage = const Value.absent(),
    String? scheduledDate,
    Value<String?> administeredDate = const Value.absent(),
    String? status,
    bool? isOverdue,
  }) => CachedVaccination(
    id: id ?? this.id,
    organisationId: organisationId ?? this.organisationId,
    flockId: flockId ?? this.flockId,
    farmId: farmId.present ? farmId.value : this.farmId,
    flockCode: flockCode.present ? flockCode.value : this.flockCode,
    treatmentName: treatmentName ?? this.treatmentName,
    treatmentType: treatmentType.present
        ? treatmentType.value
        : this.treatmentType,
    administrationRoute: administrationRoute.present
        ? administrationRoute.value
        : this.administrationRoute,
    dosage: dosage.present ? dosage.value : this.dosage,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    administeredDate: administeredDate.present
        ? administeredDate.value
        : this.administeredDate,
    status: status ?? this.status,
    isOverdue: isOverdue ?? this.isOverdue,
  );
  CachedVaccination copyWithCompanion(CachedVaccinationsCompanion data) {
    return CachedVaccination(
      id: data.id.present ? data.id.value : this.id,
      organisationId: data.organisationId.present
          ? data.organisationId.value
          : this.organisationId,
      flockId: data.flockId.present ? data.flockId.value : this.flockId,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      flockCode: data.flockCode.present ? data.flockCode.value : this.flockCode,
      treatmentName: data.treatmentName.present
          ? data.treatmentName.value
          : this.treatmentName,
      treatmentType: data.treatmentType.present
          ? data.treatmentType.value
          : this.treatmentType,
      administrationRoute: data.administrationRoute.present
          ? data.administrationRoute.value
          : this.administrationRoute,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      administeredDate: data.administeredDate.present
          ? data.administeredDate.value
          : this.administeredDate,
      status: data.status.present ? data.status.value : this.status,
      isOverdue: data.isOverdue.present ? data.isOverdue.value : this.isOverdue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedVaccination(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('flockId: $flockId, ')
          ..write('farmId: $farmId, ')
          ..write('flockCode: $flockCode, ')
          ..write('treatmentName: $treatmentName, ')
          ..write('treatmentType: $treatmentType, ')
          ..write('administrationRoute: $administrationRoute, ')
          ..write('dosage: $dosage, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('administeredDate: $administeredDate, ')
          ..write('status: $status, ')
          ..write('isOverdue: $isOverdue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organisationId,
    flockId,
    farmId,
    flockCode,
    treatmentName,
    treatmentType,
    administrationRoute,
    dosage,
    scheduledDate,
    administeredDate,
    status,
    isOverdue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedVaccination &&
          other.id == this.id &&
          other.organisationId == this.organisationId &&
          other.flockId == this.flockId &&
          other.farmId == this.farmId &&
          other.flockCode == this.flockCode &&
          other.treatmentName == this.treatmentName &&
          other.treatmentType == this.treatmentType &&
          other.administrationRoute == this.administrationRoute &&
          other.dosage == this.dosage &&
          other.scheduledDate == this.scheduledDate &&
          other.administeredDate == this.administeredDate &&
          other.status == this.status &&
          other.isOverdue == this.isOverdue);
}

class CachedVaccinationsCompanion extends UpdateCompanion<CachedVaccination> {
  final Value<int> id;
  final Value<int> organisationId;
  final Value<int> flockId;
  final Value<int?> farmId;
  final Value<String?> flockCode;
  final Value<String> treatmentName;
  final Value<String?> treatmentType;
  final Value<String?> administrationRoute;
  final Value<String?> dosage;
  final Value<String> scheduledDate;
  final Value<String?> administeredDate;
  final Value<String> status;
  final Value<bool> isOverdue;
  const CachedVaccinationsCompanion({
    this.id = const Value.absent(),
    this.organisationId = const Value.absent(),
    this.flockId = const Value.absent(),
    this.farmId = const Value.absent(),
    this.flockCode = const Value.absent(),
    this.treatmentName = const Value.absent(),
    this.treatmentType = const Value.absent(),
    this.administrationRoute = const Value.absent(),
    this.dosage = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.administeredDate = const Value.absent(),
    this.status = const Value.absent(),
    this.isOverdue = const Value.absent(),
  });
  CachedVaccinationsCompanion.insert({
    this.id = const Value.absent(),
    required int organisationId,
    required int flockId,
    this.farmId = const Value.absent(),
    this.flockCode = const Value.absent(),
    required String treatmentName,
    this.treatmentType = const Value.absent(),
    this.administrationRoute = const Value.absent(),
    this.dosage = const Value.absent(),
    required String scheduledDate,
    this.administeredDate = const Value.absent(),
    required String status,
    this.isOverdue = const Value.absent(),
  }) : organisationId = Value(organisationId),
       flockId = Value(flockId),
       treatmentName = Value(treatmentName),
       scheduledDate = Value(scheduledDate),
       status = Value(status);
  static Insertable<CachedVaccination> custom({
    Expression<int>? id,
    Expression<int>? organisationId,
    Expression<int>? flockId,
    Expression<int>? farmId,
    Expression<String>? flockCode,
    Expression<String>? treatmentName,
    Expression<String>? treatmentType,
    Expression<String>? administrationRoute,
    Expression<String>? dosage,
    Expression<String>? scheduledDate,
    Expression<String>? administeredDate,
    Expression<String>? status,
    Expression<bool>? isOverdue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organisationId != null) 'organisation_id': organisationId,
      if (flockId != null) 'flock_id': flockId,
      if (farmId != null) 'farm_id': farmId,
      if (flockCode != null) 'flock_code': flockCode,
      if (treatmentName != null) 'treatment_name': treatmentName,
      if (treatmentType != null) 'treatment_type': treatmentType,
      if (administrationRoute != null)
        'administration_route': administrationRoute,
      if (dosage != null) 'dosage': dosage,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (administeredDate != null) 'administered_date': administeredDate,
      if (status != null) 'status': status,
      if (isOverdue != null) 'is_overdue': isOverdue,
    });
  }

  CachedVaccinationsCompanion copyWith({
    Value<int>? id,
    Value<int>? organisationId,
    Value<int>? flockId,
    Value<int?>? farmId,
    Value<String?>? flockCode,
    Value<String>? treatmentName,
    Value<String?>? treatmentType,
    Value<String?>? administrationRoute,
    Value<String?>? dosage,
    Value<String>? scheduledDate,
    Value<String?>? administeredDate,
    Value<String>? status,
    Value<bool>? isOverdue,
  }) {
    return CachedVaccinationsCompanion(
      id: id ?? this.id,
      organisationId: organisationId ?? this.organisationId,
      flockId: flockId ?? this.flockId,
      farmId: farmId ?? this.farmId,
      flockCode: flockCode ?? this.flockCode,
      treatmentName: treatmentName ?? this.treatmentName,
      treatmentType: treatmentType ?? this.treatmentType,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      dosage: dosage ?? this.dosage,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      administeredDate: administeredDate ?? this.administeredDate,
      status: status ?? this.status,
      isOverdue: isOverdue ?? this.isOverdue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organisationId.present) {
      map['organisation_id'] = Variable<int>(organisationId.value);
    }
    if (flockId.present) {
      map['flock_id'] = Variable<int>(flockId.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<int>(farmId.value);
    }
    if (flockCode.present) {
      map['flock_code'] = Variable<String>(flockCode.value);
    }
    if (treatmentName.present) {
      map['treatment_name'] = Variable<String>(treatmentName.value);
    }
    if (treatmentType.present) {
      map['treatment_type'] = Variable<String>(treatmentType.value);
    }
    if (administrationRoute.present) {
      map['administration_route'] = Variable<String>(administrationRoute.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<String>(scheduledDate.value);
    }
    if (administeredDate.present) {
      map['administered_date'] = Variable<String>(administeredDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isOverdue.present) {
      map['is_overdue'] = Variable<bool>(isOverdue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedVaccinationsCompanion(')
          ..write('id: $id, ')
          ..write('organisationId: $organisationId, ')
          ..write('flockId: $flockId, ')
          ..write('farmId: $farmId, ')
          ..write('flockCode: $flockCode, ')
          ..write('treatmentName: $treatmentName, ')
          ..write('treatmentType: $treatmentType, ')
          ..write('administrationRoute: $administrationRoute, ')
          ..write('dosage: $dosage, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('administeredDate: $administeredDate, ')
          ..write('status: $status, ')
          ..write('isOverdue: $isOverdue')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $CachedFlocksTable cachedFlocks = $CachedFlocksTable(this);
  late final $CachedCustomersTable cachedCustomers = $CachedCustomersTable(
    this,
  );
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $CachedStocksTable cachedStocks = $CachedStocksTable(this);
  late final $CachedSalesTable cachedSales = $CachedSalesTable(this);
  late final $CachedNotificationsTable cachedNotifications =
      $CachedNotificationsTable(this);
  late final $CachedVaccinationsTable cachedVaccinations =
      $CachedVaccinationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncQueue,
    settings,
    cachedFlocks,
    cachedCustomers,
    cachedProducts,
    cachedStocks,
    cachedSales,
    cachedNotifications,
    cachedVaccinations,
  ];
}

typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String clientUuid,
  required int organisationId,
  required String type,
  required String payload,
  required DateTime recordedAt,
  Value<String> status,
  Value<String?> message,
  Value<int?> subjectId,
  Value<int> attempts,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> clientUuid,
  Value<int> organisationId,
  Value<String> type,
  Value<String> payload,
  Value<DateTime> recordedAt,
  Value<String> status,
  Value<String?> message,
  Value<int?> subjectId,
  Value<int> attempts,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientUuid = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<int?> subjectId = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                clientUuid: clientUuid,
                organisationId: organisationId,
                type: type,
                payload: payload,
                recordedAt: recordedAt,
                status: status,
                message: message,
                subjectId: subjectId,
                attempts: attempts,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientUuid,
                required int organisationId,
                required String type,
                required String payload,
                required DateTime recordedAt,
                Value<String> status = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<int?> subjectId = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                clientUuid: clientUuid,
                organisationId: organisationId,
                type: type,
                payload: payload,
                recordedAt: recordedAt,
                status: status,
                message: message,
                subjectId: subjectId,
                attempts: attempts,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueData>(table),
                  BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$CachedFlocksTableCreateCompanionBuilder =
    CachedFlocksCompanion Function({
      Value<int> id,
      required int organisationId,
      Value<int?> farmId,
      required String code,
      Value<String?> name,
      Value<String?> farmName,
      required String kind,
      Value<bool> tracksEggs,
      Value<bool> tracksWeight,
      Value<int> quantityCurrent,
      Value<int?> ageDays,
      Value<String?> lastRecordDate,
      required String status,
    });
typedef $$CachedFlocksTableUpdateCompanionBuilder =
    CachedFlocksCompanion Function({
      Value<int> id,
      Value<int> organisationId,
      Value<int?> farmId,
      Value<String> code,
      Value<String?> name,
      Value<String?> farmName,
      Value<String> kind,
      Value<bool> tracksEggs,
      Value<bool> tracksWeight,
      Value<int> quantityCurrent,
      Value<int?> ageDays,
      Value<String?> lastRecordDate,
      Value<String> status,
    });

class $$CachedFlocksTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFlocksTable> {
  $$CachedFlocksTableFilterComposer({
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

  ColumnFilters<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get farmName => $composableBuilder(
    column: $table.farmName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tracksEggs => $composableBuilder(
    column: $table.tracksEggs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tracksWeight => $composableBuilder(
    column: $table.tracksWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityCurrent => $composableBuilder(
    column: $table.quantityCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ageDays => $composableBuilder(
    column: $table.ageDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastRecordDate => $composableBuilder(
    column: $table.lastRecordDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedFlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFlocksTable> {
  $$CachedFlocksTableOrderingComposer({
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

  ColumnOrderings<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get farmName => $composableBuilder(
    column: $table.farmName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tracksEggs => $composableBuilder(
    column: $table.tracksEggs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tracksWeight => $composableBuilder(
    column: $table.tracksWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityCurrent => $composableBuilder(
    column: $table.quantityCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ageDays => $composableBuilder(
    column: $table.ageDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastRecordDate => $composableBuilder(
    column: $table.lastRecordDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedFlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFlocksTable> {
  $$CachedFlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get farmName =>
      $composableBuilder(column: $table.farmName, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get tracksEggs => $composableBuilder(
    column: $table.tracksEggs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get tracksWeight => $composableBuilder(
    column: $table.tracksWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityCurrent => $composableBuilder(
    column: $table.quantityCurrent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ageDays =>
      $composableBuilder(column: $table.ageDays, builder: (column) => column);

  GeneratedColumn<String> get lastRecordDate => $composableBuilder(
    column: $table.lastRecordDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$CachedFlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFlocksTable,
          CachedFlock,
          $$CachedFlocksTableFilterComposer,
          $$CachedFlocksTableOrderingComposer,
          $$CachedFlocksTableAnnotationComposer,
          $$CachedFlocksTableCreateCompanionBuilder,
          $$CachedFlocksTableUpdateCompanionBuilder,
          (
            CachedFlock,
            BaseReferences<_$AppDatabase, $CachedFlocksTable, CachedFlock>,
          ),
          CachedFlock,
          PrefetchHooks Function()
        > {
  $$CachedFlocksTableTableManager(_$AppDatabase db, $CachedFlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<int?> farmId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> farmName = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> tracksEggs = const Value.absent(),
                Value<bool> tracksWeight = const Value.absent(),
                Value<int> quantityCurrent = const Value.absent(),
                Value<int?> ageDays = const Value.absent(),
                Value<String?> lastRecordDate = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => CachedFlocksCompanion(
                id: id,
                organisationId: organisationId,
                farmId: farmId,
                code: code,
                name: name,
                farmName: farmName,
                kind: kind,
                tracksEggs: tracksEggs,
                tracksWeight: tracksWeight,
                quantityCurrent: quantityCurrent,
                ageDays: ageDays,
                lastRecordDate: lastRecordDate,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organisationId,
                Value<int?> farmId = const Value.absent(),
                required String code,
                Value<String?> name = const Value.absent(),
                Value<String?> farmName = const Value.absent(),
                required String kind,
                Value<bool> tracksEggs = const Value.absent(),
                Value<bool> tracksWeight = const Value.absent(),
                Value<int> quantityCurrent = const Value.absent(),
                Value<int?> ageDays = const Value.absent(),
                Value<String?> lastRecordDate = const Value.absent(),
                required String status,
              }) => CachedFlocksCompanion.insert(
                id: id,
                organisationId: organisationId,
                farmId: farmId,
                code: code,
                name: name,
                farmName: farmName,
                kind: kind,
                tracksEggs: tracksEggs,
                tracksWeight: tracksWeight,
                quantityCurrent: quantityCurrent,
                ageDays: ageDays,
                lastRecordDate: lastRecordDate,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedFlocksTable, CachedFlock>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedFlocksTable,
                    CachedFlock
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedFlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFlocksTable,
      CachedFlock,
      $$CachedFlocksTableFilterComposer,
      $$CachedFlocksTableOrderingComposer,
      $$CachedFlocksTableAnnotationComposer,
      $$CachedFlocksTableCreateCompanionBuilder,
      $$CachedFlocksTableUpdateCompanionBuilder,
      (
        CachedFlock,
        BaseReferences<_$AppDatabase, $CachedFlocksTable, CachedFlock>,
      ),
      CachedFlock,
      PrefetchHooks Function()
    >;
typedef $$CachedCustomersTableCreateCompanionBuilder =
    CachedCustomersCompanion Function({
      Value<int> id,
      required int organisationId,
      required String name,
      Value<String?> code,
      Value<String?> phone,
    });
typedef $$CachedCustomersTableUpdateCompanionBuilder =
    CachedCustomersCompanion Function({
      Value<int> id,
      Value<int> organisationId,
      Value<String> name,
      Value<String?> code,
      Value<String?> phone,
    });

class $$CachedCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableFilterComposer({
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

  ColumnFilters<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableOrderingComposer({
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

  ColumnOrderings<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);
}

class $$CachedCustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCustomersTable,
          CachedCustomer,
          $$CachedCustomersTableFilterComposer,
          $$CachedCustomersTableOrderingComposer,
          $$CachedCustomersTableAnnotationComposer,
          $$CachedCustomersTableCreateCompanionBuilder,
          $$CachedCustomersTableUpdateCompanionBuilder,
          (
            CachedCustomer,
            BaseReferences<
              _$AppDatabase,
              $CachedCustomersTable,
              CachedCustomer
            >,
          ),
          CachedCustomer,
          PrefetchHooks Function()
        > {
  $$CachedCustomersTableTableManager(
    _$AppDatabase db,
    $CachedCustomersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> phone = const Value.absent(),
              }) => CachedCustomersCompanion(
                id: id,
                organisationId: organisationId,
                name: name,
                code: code,
                phone: phone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organisationId,
                required String name,
                Value<String?> code = const Value.absent(),
                Value<String?> phone = const Value.absent(),
              }) => CachedCustomersCompanion.insert(
                id: id,
                organisationId: organisationId,
                name: name,
                code: code,
                phone: phone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedCustomersTable, CachedCustomer>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedCustomersTable,
                    CachedCustomer
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCustomersTable,
      CachedCustomer,
      $$CachedCustomersTableFilterComposer,
      $$CachedCustomersTableOrderingComposer,
      $$CachedCustomersTableAnnotationComposer,
      $$CachedCustomersTableCreateCompanionBuilder,
      $$CachedCustomersTableUpdateCompanionBuilder,
      (
        CachedCustomer,
        BaseReferences<_$AppDatabase, $CachedCustomersTable, CachedCustomer>,
      ),
      CachedCustomer,
      PrefetchHooks Function()
    >;
typedef $$CachedProductsTableCreateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<int> id,
      required int organisationId,
      required String name,
      Value<String?> unit,
      Value<double> unitPrice,
      Value<double> taxPercent,
      Value<bool> isLiveBirds,
    });
typedef $$CachedProductsTableUpdateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<int> id,
      Value<int> organisationId,
      Value<String> name,
      Value<String?> unit,
      Value<double> unitPrice,
      Value<double> taxPercent,
      Value<bool> isLiveBirds,
    });

class $$CachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
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

  ColumnFilters<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxPercent => $composableBuilder(
    column: $table.taxPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLiveBirds => $composableBuilder(
    column: $table.isLiveBirds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
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

  ColumnOrderings<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxPercent => $composableBuilder(
    column: $table.taxPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLiveBirds => $composableBuilder(
    column: $table.isLiveBirds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get taxPercent => $composableBuilder(
    column: $table.taxPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLiveBirds => $composableBuilder(
    column: $table.isLiveBirds,
    builder: (column) => column,
  );
}

class $$CachedProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedProductsTable,
          CachedProduct,
          $$CachedProductsTableFilterComposer,
          $$CachedProductsTableOrderingComposer,
          $$CachedProductsTableAnnotationComposer,
          $$CachedProductsTableCreateCompanionBuilder,
          $$CachedProductsTableUpdateCompanionBuilder,
          (
            CachedProduct,
            BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
          ),
          CachedProduct,
          PrefetchHooks Function()
        > {
  $$CachedProductsTableTableManager(
    _$AppDatabase db,
    $CachedProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> taxPercent = const Value.absent(),
                Value<bool> isLiveBirds = const Value.absent(),
              }) => CachedProductsCompanion(
                id: id,
                organisationId: organisationId,
                name: name,
                unit: unit,
                unitPrice: unitPrice,
                taxPercent: taxPercent,
                isLiveBirds: isLiveBirds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organisationId,
                required String name,
                Value<String?> unit = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> taxPercent = const Value.absent(),
                Value<bool> isLiveBirds = const Value.absent(),
              }) => CachedProductsCompanion.insert(
                id: id,
                organisationId: organisationId,
                name: name,
                unit: unit,
                unitPrice: unitPrice,
                taxPercent: taxPercent,
                isLiveBirds: isLiveBirds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedProductsTable, CachedProduct>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedProductsTable,
                    CachedProduct
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedProductsTable,
      CachedProduct,
      $$CachedProductsTableFilterComposer,
      $$CachedProductsTableOrderingComposer,
      $$CachedProductsTableAnnotationComposer,
      $$CachedProductsTableCreateCompanionBuilder,
      $$CachedProductsTableUpdateCompanionBuilder,
      (
        CachedProduct,
        BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
      ),
      CachedProduct,
      PrefetchHooks Function()
    >;
typedef $$CachedStocksTableCreateCompanionBuilder =
    CachedStocksCompanion Function({
      Value<int> id,
      required int organisationId,
      Value<int?> farmId,
      required String name,
      Value<String?> category,
      required String unit,
      Value<double> quantity,
      Value<double> minQuantity,
    });
typedef $$CachedStocksTableUpdateCompanionBuilder =
    CachedStocksCompanion Function({
      Value<int> id,
      Value<int> organisationId,
      Value<int?> farmId,
      Value<String> name,
      Value<String?> category,
      Value<String> unit,
      Value<double> quantity,
      Value<double> minQuantity,
    });

class $$CachedStocksTableFilterComposer
    extends Composer<_$AppDatabase, $CachedStocksTable> {
  $$CachedStocksTableFilterComposer({
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

  ColumnFilters<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minQuantity => $composableBuilder(
    column: $table.minQuantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedStocksTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedStocksTable> {
  $$CachedStocksTableOrderingComposer({
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

  ColumnOrderings<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minQuantity => $composableBuilder(
    column: $table.minQuantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedStocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedStocksTable> {
  $$CachedStocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get minQuantity => $composableBuilder(
    column: $table.minQuantity,
    builder: (column) => column,
  );
}

class $$CachedStocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedStocksTable,
          CachedStock,
          $$CachedStocksTableFilterComposer,
          $$CachedStocksTableOrderingComposer,
          $$CachedStocksTableAnnotationComposer,
          $$CachedStocksTableCreateCompanionBuilder,
          $$CachedStocksTableUpdateCompanionBuilder,
          (
            CachedStock,
            BaseReferences<_$AppDatabase, $CachedStocksTable, CachedStock>,
          ),
          CachedStock,
          PrefetchHooks Function()
        > {
  $$CachedStocksTableTableManager(_$AppDatabase db, $CachedStocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedStocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedStocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedStocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<int?> farmId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> minQuantity = const Value.absent(),
              }) => CachedStocksCompanion(
                id: id,
                organisationId: organisationId,
                farmId: farmId,
                name: name,
                category: category,
                unit: unit,
                quantity: quantity,
                minQuantity: minQuantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organisationId,
                Value<int?> farmId = const Value.absent(),
                required String name,
                Value<String?> category = const Value.absent(),
                required String unit,
                Value<double> quantity = const Value.absent(),
                Value<double> minQuantity = const Value.absent(),
              }) => CachedStocksCompanion.insert(
                id: id,
                organisationId: organisationId,
                farmId: farmId,
                name: name,
                category: category,
                unit: unit,
                quantity: quantity,
                minQuantity: minQuantity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedStocksTable, CachedStock>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedStocksTable,
                    CachedStock
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedStocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedStocksTable,
      CachedStock,
      $$CachedStocksTableFilterComposer,
      $$CachedStocksTableOrderingComposer,
      $$CachedStocksTableAnnotationComposer,
      $$CachedStocksTableCreateCompanionBuilder,
      $$CachedStocksTableUpdateCompanionBuilder,
      (
        CachedStock,
        BaseReferences<_$AppDatabase, $CachedStocksTable, CachedStock>,
      ),
      CachedStock,
      PrefetchHooks Function()
    >;
typedef $$CachedSalesTableCreateCompanionBuilder =
    CachedSalesCompanion Function({
      required String key,
      required int organisationId,
      Value<int?> farmId,
      Value<int?> serverId,
      Value<String?> clientUuid,
      Value<String?> invoiceNumber,
      required String saleDate,
      Value<String?> customerName,
      Value<double> total,
      Value<double> paid,
      required String status,
      Value<String?> summary,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CachedSalesTableUpdateCompanionBuilder =
    CachedSalesCompanion Function({
      Value<String> key,
      Value<int> organisationId,
      Value<int?> farmId,
      Value<int?> serverId,
      Value<String?> clientUuid,
      Value<String?> invoiceNumber,
      Value<String> saleDate,
      Value<String?> customerName,
      Value<double> total,
      Value<double> paid,
      Value<String> status,
      Value<String?> summary,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedSalesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSalesTable> {
  $$CachedSalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSalesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSalesTable> {
  $$CachedSalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSalesTable> {
  $$CachedSalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get saleDate =>
      $composableBuilder(column: $table.saleDate, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedSalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSalesTable,
          CachedSale,
          $$CachedSalesTableFilterComposer,
          $$CachedSalesTableOrderingComposer,
          $$CachedSalesTableAnnotationComposer,
          $$CachedSalesTableCreateCompanionBuilder,
          $$CachedSalesTableUpdateCompanionBuilder,
          (
            CachedSale,
            BaseReferences<_$AppDatabase, $CachedSalesTable, CachedSale>,
          ),
          CachedSale,
          PrefetchHooks Function()
        > {
  $$CachedSalesTableTableManager(_$AppDatabase db, $CachedSalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<int?> farmId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String?> clientUuid = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<String> saleDate = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<double> paid = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSalesCompanion(
                key: key,
                organisationId: organisationId,
                farmId: farmId,
                serverId: serverId,
                clientUuid: clientUuid,
                invoiceNumber: invoiceNumber,
                saleDate: saleDate,
                customerName: customerName,
                total: total,
                paid: paid,
                status: status,
                summary: summary,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required int organisationId,
                Value<int?> farmId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String?> clientUuid = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                required String saleDate,
                Value<String?> customerName = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<double> paid = const Value.absent(),
                required String status,
                Value<String?> summary = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedSalesCompanion.insert(
                key: key,
                organisationId: organisationId,
                farmId: farmId,
                serverId: serverId,
                clientUuid: clientUuid,
                invoiceNumber: invoiceNumber,
                saleDate: saleDate,
                customerName: customerName,
                total: total,
                paid: paid,
                status: status,
                summary: summary,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedSalesTable, CachedSale>(table),
                  BaseReferences<_$AppDatabase, $CachedSalesTable, CachedSale>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSalesTable,
      CachedSale,
      $$CachedSalesTableFilterComposer,
      $$CachedSalesTableOrderingComposer,
      $$CachedSalesTableAnnotationComposer,
      $$CachedSalesTableCreateCompanionBuilder,
      $$CachedSalesTableUpdateCompanionBuilder,
      (
        CachedSale,
        BaseReferences<_$AppDatabase, $CachedSalesTable, CachedSale>,
      ),
      CachedSale,
      PrefetchHooks Function()
    >;
typedef $$CachedNotificationsTableCreateCompanionBuilder =
    CachedNotificationsCompanion Function({
      required String id,
      Value<String?> title,
      Value<String?> body,
      Value<String?> status,
      Value<String?> url,
      Value<DateTime?> readAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CachedNotificationsTableUpdateCompanionBuilder =
    CachedNotificationsCompanion Function({
      Value<String> id,
      Value<String?> title,
      Value<String?> body,
      Value<String?> status,
      Value<String?> url,
      Value<DateTime?> readAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CachedNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedNotificationsTable> {
  $$CachedNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedNotificationsTable> {
  $$CachedNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedNotificationsTable> {
  $$CachedNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CachedNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedNotificationsTable,
          CachedNotification,
          $$CachedNotificationsTableFilterComposer,
          $$CachedNotificationsTableOrderingComposer,
          $$CachedNotificationsTableAnnotationComposer,
          $$CachedNotificationsTableCreateCompanionBuilder,
          $$CachedNotificationsTableUpdateCompanionBuilder,
          (
            CachedNotification,
            BaseReferences<
              _$AppDatabase,
              $CachedNotificationsTable,
              CachedNotification
            >,
          ),
          CachedNotification,
          PrefetchHooks Function()
        > {
  $$CachedNotificationsTableTableManager(
    _$AppDatabase db,
    $CachedNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedNotificationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedNotificationsCompanion(
                id: id,
                title: title,
                body: body,
                status: status,
                url: url,
                readAt: readAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedNotificationsCompanion.insert(
                id: id,
                title: title,
                body: body,
                status: status,
                url: url,
                readAt: readAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedNotificationsTable, CachedNotification>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedNotificationsTable,
                    CachedNotification
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedNotificationsTable,
      CachedNotification,
      $$CachedNotificationsTableFilterComposer,
      $$CachedNotificationsTableOrderingComposer,
      $$CachedNotificationsTableAnnotationComposer,
      $$CachedNotificationsTableCreateCompanionBuilder,
      $$CachedNotificationsTableUpdateCompanionBuilder,
      (
        CachedNotification,
        BaseReferences<
          _$AppDatabase,
          $CachedNotificationsTable,
          CachedNotification
        >,
      ),
      CachedNotification,
      PrefetchHooks Function()
    >;
typedef $$CachedVaccinationsTableCreateCompanionBuilder =
    CachedVaccinationsCompanion Function({
      Value<int> id,
      required int organisationId,
      required int flockId,
      Value<int?> farmId,
      Value<String?> flockCode,
      required String treatmentName,
      Value<String?> treatmentType,
      Value<String?> administrationRoute,
      Value<String?> dosage,
      required String scheduledDate,
      Value<String?> administeredDate,
      required String status,
      Value<bool> isOverdue,
    });
typedef $$CachedVaccinationsTableUpdateCompanionBuilder =
    CachedVaccinationsCompanion Function({
      Value<int> id,
      Value<int> organisationId,
      Value<int> flockId,
      Value<int?> farmId,
      Value<String?> flockCode,
      Value<String> treatmentName,
      Value<String?> treatmentType,
      Value<String?> administrationRoute,
      Value<String?> dosage,
      Value<String> scheduledDate,
      Value<String?> administeredDate,
      Value<String> status,
      Value<bool> isOverdue,
    });

class $$CachedVaccinationsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedVaccinationsTable> {
  $$CachedVaccinationsTableFilterComposer({
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

  ColumnFilters<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flockId => $composableBuilder(
    column: $table.flockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flockCode => $composableBuilder(
    column: $table.flockCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get treatmentName => $composableBuilder(
    column: $table.treatmentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get treatmentType => $composableBuilder(
    column: $table.treatmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get administrationRoute => $composableBuilder(
    column: $table.administrationRoute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get administeredDate => $composableBuilder(
    column: $table.administeredDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOverdue => $composableBuilder(
    column: $table.isOverdue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedVaccinationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedVaccinationsTable> {
  $$CachedVaccinationsTableOrderingComposer({
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

  ColumnOrderings<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flockId => $composableBuilder(
    column: $table.flockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get farmId => $composableBuilder(
    column: $table.farmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flockCode => $composableBuilder(
    column: $table.flockCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get treatmentName => $composableBuilder(
    column: $table.treatmentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get treatmentType => $composableBuilder(
    column: $table.treatmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get administrationRoute => $composableBuilder(
    column: $table.administrationRoute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get administeredDate => $composableBuilder(
    column: $table.administeredDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOverdue => $composableBuilder(
    column: $table.isOverdue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedVaccinationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedVaccinationsTable> {
  $$CachedVaccinationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get organisationId => $composableBuilder(
    column: $table.organisationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get flockId =>
      $composableBuilder(column: $table.flockId, builder: (column) => column);

  GeneratedColumn<int> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get flockCode =>
      $composableBuilder(column: $table.flockCode, builder: (column) => column);

  GeneratedColumn<String> get treatmentName => $composableBuilder(
    column: $table.treatmentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get treatmentType => $composableBuilder(
    column: $table.treatmentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get administrationRoute => $composableBuilder(
    column: $table.administrationRoute,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get administeredDate => $composableBuilder(
    column: $table.administeredDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isOverdue =>
      $composableBuilder(column: $table.isOverdue, builder: (column) => column);
}

class $$CachedVaccinationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedVaccinationsTable,
          CachedVaccination,
          $$CachedVaccinationsTableFilterComposer,
          $$CachedVaccinationsTableOrderingComposer,
          $$CachedVaccinationsTableAnnotationComposer,
          $$CachedVaccinationsTableCreateCompanionBuilder,
          $$CachedVaccinationsTableUpdateCompanionBuilder,
          (
            CachedVaccination,
            BaseReferences<
              _$AppDatabase,
              $CachedVaccinationsTable,
              CachedVaccination
            >,
          ),
          CachedVaccination,
          PrefetchHooks Function()
        > {
  $$CachedVaccinationsTableTableManager(
    _$AppDatabase db,
    $CachedVaccinationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedVaccinationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedVaccinationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedVaccinationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organisationId = const Value.absent(),
                Value<int> flockId = const Value.absent(),
                Value<int?> farmId = const Value.absent(),
                Value<String?> flockCode = const Value.absent(),
                Value<String> treatmentName = const Value.absent(),
                Value<String?> treatmentType = const Value.absent(),
                Value<String?> administrationRoute = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<String> scheduledDate = const Value.absent(),
                Value<String?> administeredDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isOverdue = const Value.absent(),
              }) => CachedVaccinationsCompanion(
                id: id,
                organisationId: organisationId,
                flockId: flockId,
                farmId: farmId,
                flockCode: flockCode,
                treatmentName: treatmentName,
                treatmentType: treatmentType,
                administrationRoute: administrationRoute,
                dosage: dosage,
                scheduledDate: scheduledDate,
                administeredDate: administeredDate,
                status: status,
                isOverdue: isOverdue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organisationId,
                required int flockId,
                Value<int?> farmId = const Value.absent(),
                Value<String?> flockCode = const Value.absent(),
                required String treatmentName,
                Value<String?> treatmentType = const Value.absent(),
                Value<String?> administrationRoute = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                required String scheduledDate,
                Value<String?> administeredDate = const Value.absent(),
                required String status,
                Value<bool> isOverdue = const Value.absent(),
              }) => CachedVaccinationsCompanion.insert(
                id: id,
                organisationId: organisationId,
                flockId: flockId,
                farmId: farmId,
                flockCode: flockCode,
                treatmentName: treatmentName,
                treatmentType: treatmentType,
                administrationRoute: administrationRoute,
                dosage: dosage,
                scheduledDate: scheduledDate,
                administeredDate: administeredDate,
                status: status,
                isOverdue: isOverdue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedVaccinationsTable, CachedVaccination>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedVaccinationsTable,
                    CachedVaccination
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedVaccinationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedVaccinationsTable,
      CachedVaccination,
      $$CachedVaccinationsTableFilterComposer,
      $$CachedVaccinationsTableOrderingComposer,
      $$CachedVaccinationsTableAnnotationComposer,
      $$CachedVaccinationsTableCreateCompanionBuilder,
      $$CachedVaccinationsTableUpdateCompanionBuilder,
      (
        CachedVaccination,
        BaseReferences<
          _$AppDatabase,
          $CachedVaccinationsTable,
          CachedVaccination
        >,
      ),
      CachedVaccination,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$CachedFlocksTableTableManager get cachedFlocks =>
      $$CachedFlocksTableTableManager(_db, _db.cachedFlocks);
  $$CachedCustomersTableTableManager get cachedCustomers =>
      $$CachedCustomersTableTableManager(_db, _db.cachedCustomers);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$CachedStocksTableTableManager get cachedStocks =>
      $$CachedStocksTableTableManager(_db, _db.cachedStocks);
  $$CachedSalesTableTableManager get cachedSales =>
      $$CachedSalesTableTableManager(_db, _db.cachedSales);
  $$CachedNotificationsTableTableManager get cachedNotifications =>
      $$CachedNotificationsTableTableManager(_db, _db.cachedNotifications);
  $$CachedVaccinationsTableTableManager get cachedVaccinations =>
      $$CachedVaccinationsTableTableManager(_db, _db.cachedVaccinations);
}
