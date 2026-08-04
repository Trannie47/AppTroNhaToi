import 'dart:convert';

class RoomAvailableDTO {
  final int id;
  final String tenPhong;
  final double giaPhongGoc;

  RoomAvailableDTO({
    required this.id,
    required this.tenPhong,
    required this.giaPhongGoc,
  });

  factory RoomAvailableDTO.fromJson(Map<String, dynamic> json) {
    return RoomAvailableDTO(
      id: json['id'] as int,
      tenPhong: json['tenPhong'] as String,
      giaPhongGoc: double.parse(json['giaPhongGoc'].toString()),
    );
  }
}
