import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suspension_setup/db/susp_entity.dart';
import 'package:suspension_setup/db/susp_entity_dao.dart';

part 'susp_state.dart';

class SuspCubit extends Cubit<SuspState> {
  final SuspEntityDao dao;

  SuspCubit(this.dao): super(SuspInitial());

  Future<void> getSuspFromDB(int id) async {
    emit(SuspLoading());
    await Future.delayed(Duration(seconds: 1));
    SuspEntity? suspEntity = await dao.findSuspEntityById(id);
    print("Susp from DB" + suspEntity.toString());
    if (suspEntity == null) {
      suspEntity = SuspEntity.getDefault();
      dao.insertSuspEntity(SuspEntity.getDefault());
    }
    emit(SuspLoaded(suspEntity));
  }

  Future<void> getSuspFromDBNoLoading(int id) async {
    final SuspEntity? suspEntity = await dao.findSuspEntityById(id);
    emit(SuspLoaded(suspEntity));
  }
}