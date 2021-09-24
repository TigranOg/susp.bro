// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SuspEntityDao? _suspDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SuspEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `forkPsi` INTEGER, `forkTokens` INTEGER, `forkHSRebound` INTEGER, `forkHSRebMaxClick` INTEGER, `forkLSReb` INTEGER, `forkLSRebMaxClick` INTEGER, `forkHSComp` INTEGER, `forkHSCompMaxClick` INTEGER, `forkLSComp` INTEGER, `forkLSCompMaxClick` INTEGER, `shockPsi` INTEGER, `shockTokens` INTEGER, `shockHSRebound` INTEGER, `shockHSRebMaxClick` INTEGER, `shockLSReb` INTEGER, `shockLSRebMaxClick` INTEGER, `shockHSComp` INTEGER, `shockHSCompMaxClick` INTEGER, `shockLSComp` INTEGER, `shockLSCompMaxClick` INTEGER, `showTutorial` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SuspEntityDao get suspDao {
    return _suspDaoInstance ??= _$SuspEntityDao(database, changeListener);
  }
}

class _$SuspEntityDao extends SuspEntityDao {
  _$SuspEntityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _suspEntityInsertionAdapter = InsertionAdapter(
            database,
            'SuspEntity',
            (SuspEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'forkPsi': item.forkPsi,
                  'forkTokens': item.forkTokens,
                  'forkHSRebound': item.forkHSRebound,
                  'forkHSRebMaxClick': item.forkHSRebMaxClick,
                  'forkLSReb': item.forkLSReb,
                  'forkLSRebMaxClick': item.forkLSRebMaxClick,
                  'forkHSComp': item.forkHSComp,
                  'forkHSCompMaxClick': item.forkHSCompMaxClick,
                  'forkLSComp': item.forkLSComp,
                  'forkLSCompMaxClick': item.forkLSCompMaxClick,
                  'shockPsi': item.shockPsi,
                  'shockTokens': item.shockTokens,
                  'shockHSRebound': item.shockHSRebound,
                  'shockHSRebMaxClick': item.shockHSRebMaxClick,
                  'shockLSReb': item.shockLSReb,
                  'shockLSRebMaxClick': item.shockLSRebMaxClick,
                  'shockHSComp': item.shockHSComp,
                  'shockHSCompMaxClick': item.shockHSCompMaxClick,
                  'shockLSComp': item.shockLSComp,
                  'shockLSCompMaxClick': item.shockLSCompMaxClick,
                  'showTutorial': item.showTutorial == null
                      ? null
                      : (item.showTutorial! ? 1 : 0)
                }),
        _suspEntityUpdateAdapter = UpdateAdapter(
            database,
            'SuspEntity',
            ['id'],
            (SuspEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'forkPsi': item.forkPsi,
                  'forkTokens': item.forkTokens,
                  'forkHSRebound': item.forkHSRebound,
                  'forkHSRebMaxClick': item.forkHSRebMaxClick,
                  'forkLSReb': item.forkLSReb,
                  'forkLSRebMaxClick': item.forkLSRebMaxClick,
                  'forkHSComp': item.forkHSComp,
                  'forkHSCompMaxClick': item.forkHSCompMaxClick,
                  'forkLSComp': item.forkLSComp,
                  'forkLSCompMaxClick': item.forkLSCompMaxClick,
                  'shockPsi': item.shockPsi,
                  'shockTokens': item.shockTokens,
                  'shockHSRebound': item.shockHSRebound,
                  'shockHSRebMaxClick': item.shockHSRebMaxClick,
                  'shockLSReb': item.shockLSReb,
                  'shockLSRebMaxClick': item.shockLSRebMaxClick,
                  'shockHSComp': item.shockHSComp,
                  'shockHSCompMaxClick': item.shockHSCompMaxClick,
                  'shockLSComp': item.shockLSComp,
                  'shockLSCompMaxClick': item.shockLSCompMaxClick,
                  'showTutorial': item.showTutorial == null
                      ? null
                      : (item.showTutorial! ? 1 : 0)
                }),
        _suspEntityDeletionAdapter = DeletionAdapter(
            database,
            'SuspEntity',
            ['id'],
            (SuspEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'forkPsi': item.forkPsi,
                  'forkTokens': item.forkTokens,
                  'forkHSRebound': item.forkHSRebound,
                  'forkHSRebMaxClick': item.forkHSRebMaxClick,
                  'forkLSReb': item.forkLSReb,
                  'forkLSRebMaxClick': item.forkLSRebMaxClick,
                  'forkHSComp': item.forkHSComp,
                  'forkHSCompMaxClick': item.forkHSCompMaxClick,
                  'forkLSComp': item.forkLSComp,
                  'forkLSCompMaxClick': item.forkLSCompMaxClick,
                  'shockPsi': item.shockPsi,
                  'shockTokens': item.shockTokens,
                  'shockHSRebound': item.shockHSRebound,
                  'shockHSRebMaxClick': item.shockHSRebMaxClick,
                  'shockLSReb': item.shockLSReb,
                  'shockLSRebMaxClick': item.shockLSRebMaxClick,
                  'shockHSComp': item.shockHSComp,
                  'shockHSCompMaxClick': item.shockHSCompMaxClick,
                  'shockLSComp': item.shockLSComp,
                  'shockLSCompMaxClick': item.shockLSCompMaxClick,
                  'showTutorial': item.showTutorial == null
                      ? null
                      : (item.showTutorial! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SuspEntity> _suspEntityInsertionAdapter;

  final UpdateAdapter<SuspEntity> _suspEntityUpdateAdapter;

  final DeletionAdapter<SuspEntity> _suspEntityDeletionAdapter;

  @override
  Future<SuspEntity?> findSuspEntityById(int id) async {
    return _queryAdapter.query('SELECT * FROM SuspEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SuspEntity(
            id: row['id'] as int?,
            name: row['name'] as String?,
            forkPsi: row['forkPsi'] as int?,
            forkTokens: row['forkTokens'] as int?,
            forkHSRebound: row['forkHSRebound'] as int?,
            forkHSRebMaxClick: row['forkHSRebMaxClick'] as int?,
            forkLSReb: row['forkLSReb'] as int?,
            forkLSRebMaxClick: row['forkLSRebMaxClick'] as int?,
            forkHSComp: row['forkHSComp'] as int?,
            forkHSCompMaxClick: row['forkHSCompMaxClick'] as int?,
            forkLSComp: row['forkLSComp'] as int?,
            forkLSCompMaxClick: row['forkLSCompMaxClick'] as int?,
            shockPsi: row['shockPsi'] as int?,
            shockTokens: row['shockTokens'] as int?,
            shockHSRebound: row['shockHSRebound'] as int?,
            shockHSRebMaxClick: row['shockHSRebMaxClick'] as int?,
            shockLSReb: row['shockLSReb'] as int?,
            shockLSRebMaxClick: row['shockLSRebMaxClick'] as int?,
            shockHSComp: row['shockHSComp'] as int?,
            shockHSCompMaxClick: row['shockHSCompMaxClick'] as int?,
            shockLSComp: row['shockLSComp'] as int?,
            shockLSCompMaxClick: row['shockLSCompMaxClick'] as int?,
            showTutorial: row['showTutorial'] == null
                ? null
                : (row['showTutorial'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> insertSuspEntity(SuspEntity suspEntity) async {
    await _suspEntityInsertionAdapter.insert(
        suspEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSuspEntity(SuspEntity suspEntity) {
    return _suspEntityUpdateAdapter.updateAndReturnChangedRows(
        suspEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteSuspEntity(SuspEntity suspEntity) {
    return _suspEntityDeletionAdapter.deleteAndReturnChangedRows(suspEntity);
  }
}
