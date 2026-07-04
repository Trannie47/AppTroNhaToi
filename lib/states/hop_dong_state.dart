import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';

sealed class HopDongState {}
class HopDongInitial extends HopDongState{}
class HopDongLoading extends HopDongState{}
class HopDongSuccess extends HopDongState{
  final List<HopDongDTO> listHD;
  HopDongSuccess(this.listHD);
}
class HopDongError extends HopDongState{
  final String errorMessage;
  HopDongError(this.errorMessage);
}