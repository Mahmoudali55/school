import 'package:equatable/equatable.dart';

class EventsDelModel extends Equatable {
  final EventsDelData data;

  const EventsDelModel({required this.data});

  factory EventsDelModel.fromJson(Map<String, dynamic> json) {
    return EventsDelModel(data: EventsDelData.fromJson(json['Data']));
  }

  Map<String, dynamic> toJson() {
    return {'Data': data.toJson()};
  }

  @override
  List<Object?> get props => [data];
}

class EventsDelData extends Equatable {
  final dynamic dataTable;
  final dynamic dataTables;
  final Map<String, dynamic> outputParams;
  final int errorId;
  final String errorMsg;
  final bool success;

  const EventsDelData({
    required this.dataTable,
    required this.dataTables,
    required this.outputParams,
    required this.errorId,
    required this.errorMsg,
    required this.success,
  });

  factory EventsDelData.fromJson(Map<String, dynamic> json) {
    return EventsDelData(
      dataTable: json['dataTable'],
      dataTables: json['dataTables'],
      outputParams: Map<String, dynamic>.from(json['outputparams'] ?? {}),
      errorId: json['errorid'] as int,
      errorMsg: json['errormsg'] as String,
      success: json['Success'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataTable': dataTable,
      'dataTables': dataTables,
      'outputparams': outputParams,
      'errorid': errorId,
      'errormsg': errorMsg,
      'Success': success,
    };
  }

  @override
  List<Object?> get props => [dataTable, dataTables, outputParams, errorId, errorMsg, success];
}
