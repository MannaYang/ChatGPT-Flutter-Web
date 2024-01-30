///
/// Http - BaseResult
///
class BaseResult<T> {
  int code;
  String msg;
  bool success;
  T? data;

  BaseResult({
    this.code = -1,
    this.msg = "",
    this.success = false,
    this.data,
  });

  factory BaseResult.fromJson(
      Map<String, dynamic> json, T? Function(dynamic) fromJsonData) {
    return BaseResult<T>(
      code: json['code'] as int,
      msg: json['msg'] as String,
      success: json['success'] as bool,
      data: fromJsonData(json['data']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T?) toJsonData) {
    return {
      'code': code,
      'msg': msg,
      'success': success,
      'data': toJsonData(data),
    };
  }
}
