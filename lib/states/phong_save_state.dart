sealed class PhongSaveState {}
class PhongSaveInitial extends PhongSaveState{}
class PhongSaveLoading extends PhongSaveState {}
class PhongSaveSuccess extends PhongSaveState{}
class PhongSaveError extends  PhongSaveState{
  final String messageError;
  PhongSaveError(this.messageError);
}