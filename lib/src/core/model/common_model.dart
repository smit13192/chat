import 'package:chat/src/core/entity/common_entity.dart';

class CommonModel<T> extends CommonEntity<T> {
  CommonModel({
    required super.statusCode,
    required super.success,
    super.message,
    super.data,
  });

  factory CommonModel.fromMap(
    Map<String, dynamic> data, {
    T Function(dynamic data)? handler,
  }) {
    return CommonModel(
      statusCode: data['statusCode'],
      success: data['success'],
      message: data['message'],
      data: data['data'] == null ? null : handler?.call(data['data']),
    );
  }
}
