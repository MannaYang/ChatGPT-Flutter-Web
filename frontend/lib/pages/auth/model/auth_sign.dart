/// code : 0
/// msg : "Success"
/// success : true
/// data : {"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNTk3MTQ3Njk3N0AxNjMuY29tIiwiZXhwIjoxNzAxNDE0NzkxfQ.xMI4GcAtH6nB-xM5gta_n2-ejPhnnIqCUz5cqpJnx1E","token_type":"Bearer"}
library;

class AuthSign {
  AuthSign({int? code, String? msg, bool? success, SignInfo? data}) {
    _code = code;
    _msg = msg;
    _success = success;
    _data = data;
  }

  AuthSign.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _success = json['success'];
    _data = json['data'] != null ? SignInfo.fromJson(json['data']) : null;
  }

  int? _code;
  String? _msg;
  bool? _success;
  SignInfo? _data;

  AuthSign copyWith({int? code, String? msg, bool? success, SignInfo? data}) =>
      AuthSign(
        code: code ?? _code,
        msg: msg ?? _msg,
        success: success ?? _success,
        data: data ?? _data,
      );

  int? get code => _code;

  String? get msg => _msg;

  bool? get success => _success;

  SignInfo? get data => _data;

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

class SignInfo {
  SignInfo({String? accessToken, String? tokenType, int? userId}) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    _userId = userId;
  }

  SignInfo.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _tokenType = json['token_type'];
    _userId = json['user_id'];
  }

  String? _accessToken;
  String? _tokenType;
  int? _userId;

  SignInfo copyWith({String? accessToken, String? tokenType, int? userId}) =>
      SignInfo(
        accessToken: accessToken ?? _accessToken,
        tokenType: tokenType ?? _tokenType,
        userId: userId ?? _userId,
      );

  String? get accessToken => _accessToken;

  String? get tokenType => _tokenType;

  int? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['token_type'] = _tokenType;
    map['user_id'] = _userId;
    return map;
  }
}
