class PhuongTienPreviewDTO {
  final int id;
  final String bienSo;
  final String hangXe;
  final String chuXe;
  double price;
  bool isEnabled;

  PhuongTienPreviewDTO({
    required this.id,
    required this.bienSo,
    required this.hangXe,
    required this.chuXe,
    required this.price,
    this.isEnabled = true,
  });

  factory PhuongTienPreviewDTO.fromMap(Map<String, dynamic> map) {
    return PhuongTienPreviewDTO(
      id: map['id'] ?? 0,
      bienSo: map['bienSo'] ?? '',
      hangXe: map['hangXe'] ?? 'Xe máy',
      chuXe: map['chuXe'] ?? 'Khách thuê',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      isEnabled: true,
    );
  }
}
