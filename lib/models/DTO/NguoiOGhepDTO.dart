class NguoiOGhepDTO {
  final String cccd;
  final String? hoTen;
  final String? sdt;
  final String? quanHeVoiDaiDien;
  final String? hopDongId;
  final bool isDelete;

  const NguoiOGhepDTO({
    required this.cccd,
    this.hoTen,
    this.sdt,
    this.quanHeVoiDaiDien,
    this.hopDongId,
    this.isDelete = false,
  });

  factory NguoiOGhepDTO.fromMap(Map<String, dynamic> json) {
    return NguoiOGhepDTO(
      cccd: json['cccd']?.toString() ?? '',
      hoTen: json['hoTen'] as String?,
      sdt: json['sdt'] as String?,
      quanHeVoiDaiDien: json['quanHeVoiDaiDien'] as String?,
      hopDongId: json['hopDongId'] as String?,
      isDelete: json['isDelete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'cccd': cccd,
    if (hoTen != null && hoTen!.trim().isNotEmpty) 'hoTen': hoTen,
    if (sdt != null && sdt!.trim().isNotEmpty) 'sdt': sdt,
    if (quanHeVoiDaiDien != null && quanHeVoiDaiDien!.trim().isNotEmpty)
      'quanHeVoiDaiDien': quanHeVoiDaiDien,
  };
}
