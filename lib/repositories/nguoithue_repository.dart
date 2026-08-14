import 'package:AppTroNhaToi/core/network/NguoiThueApiClient.dart';
import 'package:AppTroNhaToi/models/DTO/NguoiThueAvailableDTO.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThuCongNoForm/thuCongNoFormModel.dart';

import '../models/nguoi_thue.dart';

class NguoithueRepository {
  final NguoiThueApiClient nguoiThueApiClient = NguoiThueApiClient();

  Future<List<NguoiThue>> getListNguoiThue() async {
    return await nguoiThueApiClient.getListNguoiThue();
  }

  Future<bool> themNguoiThue(NguoiThue nguoiThue) async {
    return await nguoiThueApiClient.themNguoiThue(nguoiThue);
  }

  Future<bool> xoaNguoiThue(int idnt) async {
    return await nguoiThueApiClient.xoaNguoiThue(idnt);
  }

  Future<NguoiThue?> updateNguoiThue(int idnt, NguoiThue nguoiThue) async {
    return await nguoiThueApiClient.updateNguoiThue(idnt, nguoiThue);
  }

  Future<List<NguoiThue>> getListNguoiThueFromIdPhong(int idPhong) async {
    return await nguoiThueApiClient.getListNguoiThueFromIdPhong(idPhong);
  }

  Future<List<NguoiThue>> getListNguoiThueAvailableForContract() {
    return nguoiThueApiClient.getNguoiThueAvailableForContract();
  }

  Future<List<NguoiThueAvailableDTO>> getAvailableRepresentatives({
    DateTime? ngayKy,
    int? phongId,
  }) {
    return nguoiThueApiClient.getAvailableRepresentatives(
      ngayKy: ngayKy,
      phongId: phongId,
    );
  }

  Future<List<ThuCongNoFormModel>> getNguoiThueCongNoTapHoa() async {
    return await nguoiThueApiClient.getNguoiThueCongNoTapHoa();
  }
}
