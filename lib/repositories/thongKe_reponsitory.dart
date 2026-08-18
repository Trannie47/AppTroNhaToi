import 'package:AppTroNhaToi/core/network/ThongKeApiClient.dart';
import 'package:AppTroNhaToi/models/DTO/ThongKeDTO.dart';

class ThongKeRepository {
  final ThongKeApiClient thongKeApiClient = ThongKeApiClient();

  Future<ThongKeDTO?> getThongKe({int? thang, int? nam}) async {
    final now = DateTime.now();

    return await thongKeApiClient.getThongKe(
      thang: thang ?? now.month,
      nam: nam ?? now.year,
    );
  }

  Future<List<NguoiHayNoModel>> getNguoiHayNo({int top = 10}) async {
    return await thongKeApiClient.getNguoiHayNo(top: top);
  }
}
