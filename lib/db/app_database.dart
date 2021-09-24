// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'susp_entity_dao.dart';
import 'susp_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [SuspEntity])
abstract class AppDatabase extends FloorDatabase {
  SuspEntityDao get suspDao;
}