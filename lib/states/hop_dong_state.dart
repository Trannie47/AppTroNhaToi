import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';

sealed class HopDongState {}

class HopDongInitial extends HopDongState {}

class HopDongLoading extends HopDongState {}

class HopDongSuccess<T> extends HopDongState {
  final List<T> data;
  HopDongSuccess(this.data);
}

class HopDongError extends HopDongState {
  final String errorMessage;
  HopDongError(this.errorMessage);
}
