part of 'susp_cubit.dart';

abstract class SuspState {
  const SuspState();
}

class SuspInitial extends SuspState {
  const SuspInitial();
}

class SuspLoading extends SuspState {
  const SuspLoading();
}

class SuspSettingsChanged extends SuspState {
  const SuspSettingsChanged();
}

class SuspLoaded extends SuspState {
  final SuspEntity? suspEntity;
  const SuspLoaded(this.suspEntity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuspLoaded &&
          runtimeType == other.runtimeType &&
          suspEntity == other.suspEntity;

  @override
  int get hashCode => suspEntity.hashCode;
}