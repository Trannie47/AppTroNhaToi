import 'package:AppTroNhaToi/models/hop_dong.dart';

sealed class ChiTietNguoiThueState {}

class ChiTietNguoiThueLoading extends ChiTietNguoiThueState {}

class ChiTietNguoiThueSuccess extends ChiTietNguoiThueState {
  final List<HopDong> listHD;
  ChiTietNguoiThueSuccess(this.listHD);
}

class ChiTietNguoithueError extends ChiTietNguoiThueState {
  final String message;
  ChiTietNguoithueError(this.message);
}
