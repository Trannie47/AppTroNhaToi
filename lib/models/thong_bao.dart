class ThongBao {
  final String title;
  final String subtitle;
  final DateTime date;

  ThongBao({required this.title, required this.subtitle, required this.date});

  factory ThongBao.fromMap(Map<String, dynamic> map) {
    return ThongBao(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      date: DateTime.tryParse(map['Date'] as String) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'Date': date.toIso8601String().split('T').first,
    };
  }

  ThongBao copyWith({String? title, String? subtitle, DateTime? date}) {
    return ThongBao(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'ThongBao(title: $title, subtitle: $subtitle, date: $date)';
  }
}
