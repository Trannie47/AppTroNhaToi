import 'package:AppTroNhaToi/models/hop_dong.dart';

sealed class HopDongUpdateState {}
class HopDongUpdateInitial extends HopDongUpdateState{}
class HopDongUpdateLoading extends HopDongUpdateState{}
class HopDongUpdateSuccess extends HopDongUpdateState{
  final HopDong data;
  HopDongUpdateSuccess(this.data);
}
class HopDongUpdateError extends HopDongUpdateState{
  final String errorMessage;
  HopDongUpdateError(this.errorMessage);
}