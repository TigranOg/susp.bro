import 'package:floor/floor.dart';
import 'package:suspension_setup/db/susp_entity.dart';

@dao
abstract class SuspEntityDao {
  @Query('SELECT * FROM SuspEntity WHERE id = :id')
  Future<SuspEntity?> findSuspEntityById(int id);

  @insert
  Future<void> insertSuspEntity(SuspEntity suspEntity);

  @update
  Future<int> updateSuspEntity(SuspEntity suspEntity);

  @delete
  Future<int> deleteSuspEntity(SuspEntity suspEntity);
}