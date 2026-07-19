import 'package:AppTroNhaToi/models/dien_nuoc.dart';

import '../core/network/DienNuocApiClient.dart';

class DienNuocRepository {
  final DienNuocApiClient _apiClient= DienNuocApiClient();

  Future<DienNuocInitResult> getInitData(int phongId, String thangNam) async {
    try {
      final rawData = await _apiClient.getInitData(phongId, thangNam);

      final mode = rawData['mode'] as String? ?? 'CREATE';
      final dataMap = rawData['data'] as Map<String, dynamic>? ?? {};
      final isFirstTime = dataMap['isFirstTime'] as bool? ?? false;

      final dienNuoc = DienNuoc.fromMap(dataMap);

      return DienNuocInitResult(
        mode: mode,
        isFirstTime: isFirstTime,
        dienNuoc: dienNuoc,
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception("Lỗi DienNuocRepository.fetchInitData: $e");
    }
  }
  Future<DienNuoc> createDienNuoc(
      DienNuoc dienNuoc, {
        String? anhDienCuPath,
        String? anhDienMoiPath,
        String? anhNuocCuPath,
        String? anhNuocMoiPath,
      }) async {
    try {
      final rawData = await _apiClient.createDienNuoc(
        dienNuoc,
        anhDienCuPath: anhDienCuPath,
        anhDienMoiPath: anhDienMoiPath,
        anhNuocCuPath: anhNuocCuPath,
        anhNuocMoiPath: anhNuocMoiPath,
      );

      return DienNuoc.fromMap(rawData);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception("Lỗi DienNuocRepository.createDienNuoc: $e");
    }
  }
  Future<DienNuoc?> updateDienNuoc(
      DienNuoc dienNuoc, {
        String? anhDienCuPath,
        String? anhDienMoiPath,
        String? anhNuocCuPath,
        String? anhNuocMoiPath,
      }) async {
    final response = await _apiClient.updateDienNuoc(
      dienNuoc,
      anhDienCuPath: anhDienCuPath,
      anhDienMoiPath: anhDienMoiPath,
      anhNuocCuPath: anhNuocCuPath,
      anhNuocMoiPath: anhNuocMoiPath,
    );

    return DienNuoc.fromMap(response);
  }
}


class DienNuocInitResult {
  final String mode;// trả về giữ từ khóa update hay là create để hiển thị UI cho phù hợp
  final bool isFirstTime; // đánh dấu phòng mới chưa ghi bao giờ
  final DienNuoc dienNuoc;

  DienNuocInitResult({
    required this.mode,
    required this.isFirstTime,
    required this.dienNuoc,
  });
}