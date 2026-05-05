class CongNo {
  final String name;
  final String room;
  final double amount;

  CongNo({required this.name, required this.room, required this.amount});

  factory CongNo.fromMap(Map<String, dynamic> map) {
    return CongNo(
      name: map['name'] as String,
      room: map['room'] as String,
      amount: map['amount'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'room': room, 'amount': amount};
  }

  CongNo copyWith({String? name, String? room, double? amount}) {
    return CongNo(
      name: name ?? this.name,
      room: room ?? this.room,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() {
    return 'CongNo(name: $name, '
        'room: $room, amount: $amount)';
  }
}
