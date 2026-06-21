import 'package:AppTroNhaToi/models/phong.dart';

sealed class PhongSaveState {}
class PhongSaveInitial extends PhongSaveState{}
class PhongSaveLoading extends PhongSaveState {}
class PhongSaveSuccess extends PhongSaveState{
  final Phong phong;
  PhongSaveSuccess(this.phong);
}
class PhongSaveError extends  PhongSaveState{
  final String messageError;
  PhongSaveError(this.messageError);
}