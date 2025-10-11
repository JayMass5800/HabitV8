// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_notification.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScheduledNotificationCollection on Isar {
  IsarCollection<ScheduledNotification> get scheduledNotifications =>
      this.collection();
}

const ScheduledNotificationSchema = CollectionSchema(
  name: r'ScheduledNotification',
  id: -7228265165637064202,
  properties: {
    r'body': PropertySchema(
      id: 0,
      name: r'body',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdAtMillis': PropertySchema(
      id: 2,
      name: r'createdAtMillis',
      type: IsarType.long,
    ),
    r'habitId': PropertySchema(
      id: 3,
      name: r'habitId',
      type: IsarType.string,
    ),
    r'isAlarm': PropertySchema(
      id: 4,
      name: r'isAlarm',
      type: IsarType.bool,
    ),
    r'isFuture': PropertySchema(
      id: 5,
      name: r'isFuture',
      type: IsarType.bool,
    ),
    r'isPast': PropertySchema(
      id: 6,
      name: r'isPast',
      type: IsarType.bool,
    ),
    r'notificationId': PropertySchema(
      id: 7,
      name: r'notificationId',
      type: IsarType.long,
    ),
    r'scheduledTime': PropertySchema(
      id: 8,
      name: r'scheduledTime',
      type: IsarType.dateTime,
    ),
    r'scheduledTimeMillis': PropertySchema(
      id: 9,
      name: r'scheduledTimeMillis',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 10,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _scheduledNotificationEstimateSize,
  serialize: _scheduledNotificationSerialize,
  deserialize: _scheduledNotificationDeserialize,
  deserializeProp: _scheduledNotificationDeserializeProp,
  idName: r'id',
  indexes: {
    r'habitId': IndexSchema(
      id: 1000409552522198739,
      name: r'habitId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'habitId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'scheduledTimeMillis': IndexSchema(
      id: -7537892538028316581,
      name: r'scheduledTimeMillis',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scheduledTimeMillis',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _scheduledNotificationGetId,
  getLinks: _scheduledNotificationGetLinks,
  attach: _scheduledNotificationAttach,
  version: '3.1.0+1',
);

int _scheduledNotificationEstimateSize(
  ScheduledNotification object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.body.length * 3;
  bytesCount += 3 + object.habitId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _scheduledNotificationSerialize(
  ScheduledNotification object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.body);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.createdAtMillis);
  writer.writeString(offsets[3], object.habitId);
  writer.writeBool(offsets[4], object.isAlarm);
  writer.writeBool(offsets[5], object.isFuture);
  writer.writeBool(offsets[6], object.isPast);
  writer.writeLong(offsets[7], object.notificationId);
  writer.writeDateTime(offsets[8], object.scheduledTime);
  writer.writeLong(offsets[9], object.scheduledTimeMillis);
  writer.writeString(offsets[10], object.title);
}

ScheduledNotification _scheduledNotificationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScheduledNotification(
    body: reader.readString(offsets[0]),
    createdAtMillis: reader.readLong(offsets[2]),
    habitId: reader.readString(offsets[3]),
    id: id,
    isAlarm: reader.readBoolOrNull(offsets[4]) ?? false,
    notificationId: reader.readLong(offsets[7]),
    scheduledTimeMillis: reader.readLong(offsets[9]),
    title: reader.readString(offsets[10]),
  );
  return object;
}

P _scheduledNotificationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scheduledNotificationGetId(ScheduledNotification object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scheduledNotificationGetLinks(
    ScheduledNotification object) {
  return [];
}

void _scheduledNotificationAttach(
    IsarCollection<dynamic> col, Id id, ScheduledNotification object) {
  object.id = id;
}

extension ScheduledNotificationQueryWhereSort
    on QueryBuilder<ScheduledNotification, ScheduledNotification, QWhere> {
  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhere>
      anyScheduledTimeMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'scheduledTimeMillis'),
      );
    });
  }
}

extension ScheduledNotificationQueryWhere on QueryBuilder<ScheduledNotification,
    ScheduledNotification, QWhereClause> {
  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      habitIdEqualTo(String habitId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'habitId',
        value: [habitId],
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      habitIdNotEqualTo(String habitId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      scheduledTimeMillisEqualTo(int scheduledTimeMillis) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scheduledTimeMillis',
        value: [scheduledTimeMillis],
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      scheduledTimeMillisNotEqualTo(int scheduledTimeMillis) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTimeMillis',
              lower: [],
              upper: [scheduledTimeMillis],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTimeMillis',
              lower: [scheduledTimeMillis],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTimeMillis',
              lower: [scheduledTimeMillis],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledTimeMillis',
              lower: [],
              upper: [scheduledTimeMillis],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      scheduledTimeMillisGreaterThan(
    int scheduledTimeMillis, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledTimeMillis',
        lower: [scheduledTimeMillis],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      scheduledTimeMillisLessThan(
    int scheduledTimeMillis, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledTimeMillis',
        lower: [],
        upper: [scheduledTimeMillis],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterWhereClause>
      scheduledTimeMillisBetween(
    int lowerScheduledTimeMillis,
    int upperScheduledTimeMillis, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledTimeMillis',
        lower: [lowerScheduledTimeMillis],
        includeLower: includeLower,
        upper: [upperScheduledTimeMillis],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScheduledNotificationQueryFilter on QueryBuilder<
    ScheduledNotification, ScheduledNotification, QFilterCondition> {
  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
          QAfterFilterCondition>
      bodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
          QAfterFilterCondition>
      bodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtMillisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtMillisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAtMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtMillisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAtMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> createdAtMillisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAtMillis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'habitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
          QAfterFilterCondition>
      habitIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
          QAfterFilterCondition>
      habitIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'habitId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> habitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'habitId',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> isAlarmEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAlarm',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> isFutureEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFuture',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> isPastEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPast',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> notificationIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> notificationIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> notificationIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> notificationIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeMillisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTimeMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeMillisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTimeMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeMillisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTimeMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> scheduledTimeMillisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTimeMillis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension ScheduledNotificationQueryObject on QueryBuilder<
    ScheduledNotification, ScheduledNotification, QFilterCondition> {}

extension ScheduledNotificationQueryLinks on QueryBuilder<ScheduledNotification,
    ScheduledNotification, QFilterCondition> {}

extension ScheduledNotificationQuerySortBy
    on QueryBuilder<ScheduledNotification, ScheduledNotification, QSortBy> {
  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByCreatedAtMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMillis', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByCreatedAtMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMillis', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByIsAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByIsAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByIsFuture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByIsFutureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByIsPast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByIsPastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByScheduledTimeMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTimeMillis', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByScheduledTimeMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTimeMillis', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ScheduledNotificationQuerySortThenBy
    on QueryBuilder<ScheduledNotification, ScheduledNotification, QSortThenBy> {
  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByCreatedAtMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMillis', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByCreatedAtMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMillis', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByIsAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByIsAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByIsFuture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByIsFutureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFuture', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByIsPast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByIsPastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPast', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByScheduledTimeMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTimeMillis', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByScheduledTimeMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTimeMillis', Sort.desc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ScheduledNotificationQueryWhereDistinct
    on QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct> {
  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByBody({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByCreatedAtMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtMillis');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByHabitId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByIsAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAlarm');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByIsFuture() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFuture');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByIsPast() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPast');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationId');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTime');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByScheduledTimeMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTimeMillis');
    });
  }

  QueryBuilder<ScheduledNotification, ScheduledNotification, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension ScheduledNotificationQueryProperty on QueryBuilder<
    ScheduledNotification, ScheduledNotification, QQueryProperty> {
  QueryBuilder<ScheduledNotification, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScheduledNotification, String, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<ScheduledNotification, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ScheduledNotification, int, QQueryOperations>
      createdAtMillisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtMillis');
    });
  }

  QueryBuilder<ScheduledNotification, String, QQueryOperations>
      habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }

  QueryBuilder<ScheduledNotification, bool, QQueryOperations>
      isAlarmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAlarm');
    });
  }

  QueryBuilder<ScheduledNotification, bool, QQueryOperations>
      isFutureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFuture');
    });
  }

  QueryBuilder<ScheduledNotification, bool, QQueryOperations> isPastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPast');
    });
  }

  QueryBuilder<ScheduledNotification, int, QQueryOperations>
      notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationId');
    });
  }

  QueryBuilder<ScheduledNotification, DateTime, QQueryOperations>
      scheduledTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTime');
    });
  }

  QueryBuilder<ScheduledNotification, int, QQueryOperations>
      scheduledTimeMillisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTimeMillis');
    });
  }

  QueryBuilder<ScheduledNotification, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
