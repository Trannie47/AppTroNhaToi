import 'package:AppTroNhaToi/models/hop_dong.dart';

sealed class CreateContractState {}
class CreateContractInitial extends CreateContractState{}
class CreateContractLoading extends CreateContractState{}
class CreateContractSuccess extends CreateContractState{
  final HopDong hopDong;
  CreateContractSuccess(this.hopDong);
}
class CreateContractError extends CreateContractState{
  final String errorMessage;
  CreateContractError(this.errorMessage);
}
