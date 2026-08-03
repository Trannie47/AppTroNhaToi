import 'package:AppTroNhaToi/models/loai_phong.dart';

sealed class LoaiphongState {}

class LoaiPhongLoading extends LoaiphongState {}

class LoaiPhongSuccess extends LoaiphongState {
  final List<LoaiPhong> listLoaiPhong;
  LoaiPhongSuccess(this.listLoaiPhong);
}

class LoaiPhongError extends LoaiphongState {
  final String messageError;
  LoaiPhongError(this.messageError);
}
