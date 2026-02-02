import 'package:equatable/equatable.dart';

class ClassHWDelModel extends Equatable {
  final dynamic dataTable;
  final dynamic dataTables;
  final dynamic outputParams;
  final int errorId;
  final String errorMsg;
  final bool success;

  const ClassHWDelModel({
    required this.dataTable,
    required this.dataTables,
    required this.outputParams,
    required this.errorId,
    required this.errorMsg,
    required this.success,
  });

  factory ClassHWDelModel.fromJson(Map<String, dynamic> json) {
    final data = json['Data'] ?? {};
    return ClassHWDelModel(
      dataTable: data['dataTable'],
      dataTables: data['dataTables'],
      outputParams: data['outputparams'],
      errorId: data['errorid'] ?? 0,
      errorMsg: data['errormsg'] ?? '',
      success: data['Success'] ?? false,
    );
  }

  @override
  List<Object?> get props => [dataTable, dataTables, outputParams, errorId, errorMsg, success];
}
