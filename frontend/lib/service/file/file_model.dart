/// code : 0
/// msg : "Success"
/// success : true
/// data : {"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNTk3MTQ3Njk3N0AxNjMuY29tIiwiZXhwIjoxNzAxNDE0NzkxfQ.xMI4GcAtH6nB-xM5gta_n2-ejPhnnIqCUz5cqpJnx1E","token_type":"Bearer"}
library;

class FileUpload {
  FileUpload({int? code, String? msg, bool? success, FileInfo? data}) {
    _code = code;
    _msg = msg;
    _success = success;
    _data = data;
  }

  FileUpload.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _success = json['success'];
    _data = json['data'] != null ? FileInfo.fromJson(json['data']) : null;
  }

  int? _code;
  String? _msg;
  bool? _success;
  FileInfo? _data;

  FileUpload copyWith(
          {int? code, String? msg, bool? success, FileInfo? data}) =>
      FileUpload(
        code: code ?? _code,
        msg: msg ?? _msg,
        success: success ?? _success,
        data: data ?? _data,
      );

  int? get code => _code;

  String? get msg => _msg;

  bool? get success => _success;

  FileInfo? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// access_token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNTk3MTQ3Njk3N0AxNjMuY29tIiwiZXhwIjoxNzAxNDE0NzkxfQ.xMI4GcAtH6nB-xM5gta_n2-ejPhnnIqCUz5cqpJnx1E"
/// token_type : "Bearer"
/// user_id : 1

class FileInfo {
  FileInfo({String? fileName, String? resId}) {
    _fileName = fileName;
    _resId = resId;
  }

  FileInfo.fromJson(dynamic json) {
    _fileName = json['file_name'];
    _resId = json['res_id'];
  }

  String? _fileName;
  String? _resId;

  FileInfo copyWith({String? fileName, String? resId}) => FileInfo(
        fileName: fileName ?? _fileName,
        resId: resId ?? _resId,
      );

  String? get fileName => _fileName;

  String? get resId => _resId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file_name'] = _fileName;
    map['res_id'] = _resId;
    return map;
  }
}
