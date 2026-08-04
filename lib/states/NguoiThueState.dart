import 'package:AppTroNhaToi/models/nguoi_thue.dart';

sealed class NguoiThueState {}

class NguoiThueLoading extends NguoiThueState {}

class NguoiThueSuccess extends NguoiThueState {
  final List<NguoiThue> listNguoithue;
  NguoiThueSuccess(this.listNguoithue);
}

class NguoiThueError extends NguoiThueState {
  final String errorMessage;
  NguoiThueError(this.errorMessage);
}
