import 'dart:convert';

import 'package:equatable/equatable.dart';

class ParentBalanceModel extends Equatable {
  final int parentCode;
  final double balance;

  const ParentBalanceModel({required this.parentCode, required this.balance});

  factory ParentBalanceModel.fromJson(Map<String, dynamic> json) {
    return ParentBalanceModel(
      parentCode: json['PARENT_CODE'] as int? ?? 0,
      balance: (json['P_BALANCE'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'PARENT_CODE': parentCode, 'P_BALANCE': balance};
  }

  /// لتحويل Data String إلى List<ParentBalanceModel>
  static List<ParentBalanceModel> listFromDataString(String data) {
    if (data.isEmpty || data == "[]") return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => ParentBalanceModel.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [parentCode, balance];
}
