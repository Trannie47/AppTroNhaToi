import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';

class ThuCongNoFormModel {
  final NguoiThue nguoiThue;
  final double tongCongNoTapHoa;

  ThuCongNoFormModel({
    required this.nguoiThue,
    required this.tongCongNoTapHoa,
  });

  factory ThuCongNoFormModel.fromMap(Map<String, dynamic> map) {
    return ThuCongNoFormModel(
      nguoiThue: NguoiThue.fromMap(map),
      tongCongNoTapHoa: numOf(map['tongCongNoTapHoa']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...nguoiThue.toMap(),
      'tongCongNoTapHoa': tongCongNoTapHoa,
    };
  }

  ThuCongNoFormModel copyWith({
    NguoiThue? nguoiThue,
    double? tongCongNoTapHoa,
  }) {
    return ThuCongNoFormModel(
      nguoiThue: nguoiThue ?? this.nguoiThue,
      tongCongNoTapHoa:
          tongCongNoTapHoa ?? this.tongCongNoTapHoa,
    );
  }

  @override
  String toString() {
    return 'ThuCongNo(nguoiThue: $nguoiThue, tongCongNoTapHoa: $tongCongNoTapHoa)';
  }
}