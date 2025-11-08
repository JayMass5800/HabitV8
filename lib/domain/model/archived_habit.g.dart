// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archived_habit.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetArchivedHabitCollection on Isar {
  IsarCollection<ArchivedHabit> get archivedHabits => this.collection();
}

const ArchivedHabitSchema = CollectionSchema(
  name: r'ArchivedHabit',
  id: -1492858465343790587,
  properties: {
    r'archivedAt': PropertySchema(
      id: 0,
      name: r'archivedAt',
      type: IsarType.dateTime,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'colorValue': PropertySchema(
      id: 2,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'completions': PropertySchema(
      id: 3,
      name: r'completions',
      type: IsarType.dateTimeList,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 5,
      name: r'description',
      type: IsarType.string,
    ),
    r'dtStart': PropertySchema(
      id: 6,
      name: r'dtStart',
      type: IsarType.dateTime,
    ),
    r'finalCurrentStreak': PropertySchema(
      id: 7,
      name: r'finalCurrentStreak',
      type: IsarType.long,
    ),
    r'finalLongestStreak': PropertySchema(
      id: 8,
      name: r'finalLongestStreak',
      type: IsarType.long,
    ),
    r'hasCompletions': PropertySchema(
      id: 9,
      name: r'hasCompletions',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 10,
      name: r'id',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'rruleString': PropertySchema(
      id: 12,
      name: r'rruleString',
      type: IsarType.string,
    ),
    r'totalCompletions': PropertySchema(
      id: 13,
      name: r'totalCompletions',
      type: IsarType.long,
    ),
    r'usedRRule': PropertySchema(
      id: 14,
      name: r'usedRRule',
      type: IsarType.bool,
    )
  },
  estimateSize: _archivedHabitEstimateSize,
  serialize: _archivedHabitSerialize,
  deserialize: _archivedHabitDeserialize,
  deserializeProp: _archivedHabitDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _archivedHabitGetId,
  getLinks: _archivedHabitGetLinks,
  attach: _archivedHabitAttach,
  version: '3.1.0+1',
);

int _archivedHabitEstimateSize(
  ArchivedHabit object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.completions.length * 8;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.rruleString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _archivedHabitSerialize(
  ArchivedHabit object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.archivedAt);
  writer.writeString(offsets[1], object.category);
  writer.writeLong(offsets[2], object.colorValue);
  writer.writeDateTimeList(offsets[3], object.completions);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.description);
  writer.writeDateTime(offsets[6], object.dtStart);
  writer.writeLong(offsets[7], object.finalCurrentStreak);
  writer.writeLong(offsets[8], object.finalLongestStreak);
  writer.writeBool(offsets[9], object.hasCompletions);
  writer.writeString(offsets[10], object.id);
  writer.writeString(offsets[11], object.name);
  writer.writeString(offsets[12], object.rruleString);
  writer.writeLong(offsets[13], object.totalCompletions);
  writer.writeBool(offsets[14], object.usedRRule);
}

ArchivedHabit _archivedHabitDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ArchivedHabit();
  object.archivedAt = reader.readDateTime(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.colorValue = reader.readLong(offsets[2]);
  object.completions = reader.readDateTimeList(offsets[3]) ?? [];
  object.createdAt = reader.readDateTime(offsets[4]);
  object.description = reader.readStringOrNull(offsets[5]);
  object.dtStart = reader.readDateTimeOrNull(offsets[6]);
  object.finalCurrentStreak = reader.readLong(offsets[7]);
  object.finalLongestStreak = reader.readLong(offsets[8]);
  object.id = reader.readString(offsets[10]);
  object.isarId = id;
  object.name = reader.readString(offsets[11]);
  object.rruleString = reader.readStringOrNull(offsets[12]);
  object.usedRRule = reader.readBool(offsets[14]);
  return object;
}

P _archivedHabitDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTimeList(offset) ?? []) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _archivedHabitGetId(ArchivedHabit object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _archivedHabitGetLinks(ArchivedHabit object) {
  return [];
}

void _archivedHabitAttach(
    IsarCollection<dynamic> col, Id id, ArchivedHabit object) {
  object.isarId = id;
}

extension ArchivedHabitByIndex on IsarCollection<ArchivedHabit> {
  Future<ArchivedHabit?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  ArchivedHabit? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<ArchivedHabit?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<ArchivedHabit?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(ArchivedHabit object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(ArchivedHabit object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<ArchivedHabit> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<ArchivedHabit> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension ArchivedHabitQueryWhereSort
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QWhere> {
  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ArchivedHabitQueryWhere
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QWhereClause> {
  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ArchivedHabitQueryFilter
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QFilterCondition> {
  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      archivedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archivedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      archivedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'archivedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      archivedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'archivedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      archivedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'archivedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completions',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completions',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completions',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      completionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      dtStartIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dtStart',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      dtStartIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dtStart',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      dtStartEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dtStart',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      dtStartGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dtStart',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      dtStartLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dtStart',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      dtStartBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dtStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalCurrentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalCurrentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalCurrentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalCurrentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalCurrentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalCurrentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalCurrentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalCurrentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalLongestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalLongestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalLongestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalLongestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalLongestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalLongestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      finalLongestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalLongestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      hasCompletionsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasCompletions',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rruleString',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rruleString',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rruleString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rruleString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rruleString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rruleString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rruleString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rruleString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rruleString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rruleString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rruleString',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      rruleStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rruleString',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      totalCompletionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCompletions',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      totalCompletionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCompletions',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      totalCompletionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCompletions',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      totalCompletionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCompletions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterFilterCondition>
      usedRRuleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'usedRRule',
        value: value,
      ));
    });
  }
}

extension ArchivedHabitQueryObject
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QFilterCondition> {}

extension ArchivedHabitQueryLinks
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QFilterCondition> {}

extension ArchivedHabitQuerySortBy
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QSortBy> {
  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByArchivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByArchivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByDtStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtStart', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByDtStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtStart', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByFinalCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCurrentStreak', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByFinalCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCurrentStreak', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByFinalLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLongestStreak', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByFinalLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLongestStreak', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByHasCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletions', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByHasCompletionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletions', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByRruleString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rruleString', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByRruleStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rruleString', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByTotalCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByTotalCompletionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> sortByUsedRRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedRRule', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      sortByUsedRRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedRRule', Sort.desc);
    });
  }
}

extension ArchivedHabitQuerySortThenBy
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QSortThenBy> {
  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByArchivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByArchivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByDtStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtStart', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByDtStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dtStart', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByFinalCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCurrentStreak', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByFinalCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCurrentStreak', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByFinalLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLongestStreak', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByFinalLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLongestStreak', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByHasCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletions', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByHasCompletionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletions', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByRruleString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rruleString', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByRruleStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rruleString', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByTotalCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByTotalCompletionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.desc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy> thenByUsedRRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedRRule', Sort.asc);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QAfterSortBy>
      thenByUsedRRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedRRule', Sort.desc);
    });
  }
}

extension ArchivedHabitQueryWhereDistinct
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> {
  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByArchivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archivedAt');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct>
      distinctByCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completions');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByDtStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dtStart');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct>
      distinctByFinalCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalCurrentStreak');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct>
      distinctByFinalLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalLongestStreak');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct>
      distinctByHasCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasCompletions');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByRruleString(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rruleString', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct>
      distinctByTotalCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCompletions');
    });
  }

  QueryBuilder<ArchivedHabit, ArchivedHabit, QDistinct> distinctByUsedRRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usedRRule');
    });
  }
}

extension ArchivedHabitQueryProperty
    on QueryBuilder<ArchivedHabit, ArchivedHabit, QQueryProperty> {
  QueryBuilder<ArchivedHabit, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ArchivedHabit, DateTime, QQueryOperations> archivedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archivedAt');
    });
  }

  QueryBuilder<ArchivedHabit, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<ArchivedHabit, int, QQueryOperations> colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<ArchivedHabit, List<DateTime>, QQueryOperations>
      completionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completions');
    });
  }

  QueryBuilder<ArchivedHabit, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ArchivedHabit, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<ArchivedHabit, DateTime?, QQueryOperations> dtStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dtStart');
    });
  }

  QueryBuilder<ArchivedHabit, int, QQueryOperations>
      finalCurrentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalCurrentStreak');
    });
  }

  QueryBuilder<ArchivedHabit, int, QQueryOperations>
      finalLongestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalLongestStreak');
    });
  }

  QueryBuilder<ArchivedHabit, bool, QQueryOperations> hasCompletionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasCompletions');
    });
  }

  QueryBuilder<ArchivedHabit, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ArchivedHabit, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ArchivedHabit, String?, QQueryOperations> rruleStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rruleString');
    });
  }

  QueryBuilder<ArchivedHabit, int, QQueryOperations>
      totalCompletionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCompletions');
    });
  }

  QueryBuilder<ArchivedHabit, bool, QQueryOperations> usedRRuleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usedRRule');
    });
  }
}
