import 'dart:convert';

import 'package:frontend/pages/auth/model/auth_sign.dart';
import 'package:frontend/pages/auth/model/user_info.dart';
import 'package:frontend/service/http/http_provider.dart';
import 'package:frontend/service/model/base_result.dart';
import 'package:frontend/service/utils/api_provider.dart';
import 'package:frontend/service/utils/sp_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
class AuthRepository extends _$AuthRepository {
  // static final AuthRepository _singleton = AuthRepository._();
  //
  // static AuthRepository get instance => _singleton;
  //
  // AuthRepository._();

  @override
  void build() {}

  ///
  /// Sign in / Sign up
  ///
  Future<AuthSign> sign(Map<String, String> params) async {
    var uri = Uri.http(ApiProvider.backendUrl, "api/llm/v1/auth/signin");
    try {
      final response =
          await ref.read(httpRequestProvider.notifier).post(uri, body: params);
      final authInfo =
          AuthSign.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return authInfo;
    } on Exception catch (e) {
      return AuthSign(code: -1, msg: e.toString());
    }
  }

  Future<BaseResult<UserInfo>> getUserInfo() async {
    var userId = SpProvider().getInt("userId");
    var uri = Uri.http(
        ApiProvider.backendUrl, "api/llm/v1/auth/user", {"user_id": "$userId"});
    try {
      final response = await ref.read(httpRequestProvider.notifier).get(uri);
      final data = BaseResult<UserInfo>.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)),
          (jsonData) => UserInfo.fromJson(jsonData));
      return data;
    } on Exception catch (e) {
      return BaseResult(
          code: -1, msg: e.toString(), success: false, data: null);
    }
  }

  Future<BaseResult<bool>> signOut(String email) async {
    var uri = Uri.http(ApiProvider.backendUrl, "api/llm/v1/auth/signOut");
    try {
      final response = await ref
          .read(httpRequestProvider.notifier)
          .post(uri, body: {"email": email});
      final data = BaseResult<bool>.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)),
          (jsonData) => jsonData as bool);
      return data;
    } on Exception catch (e) {
      return BaseResult(
          code: -1, msg: e.toString(), success: false, data: false);
    }
  }

  ///
  /// Save user token / user id
  ///
  Future<String> cacheUserInfo(AuthSign result) async {
    var tokenType = result.data?.tokenType ?? "";
    var token = result.data?.accessToken ?? "";
    var authorization = "$tokenType $token";
    var userId = result.data?.userId ?? -1;
    await SpProvider().setString('token', authorization);
    await SpProvider().setInt('userId', userId);
    Logger().d("CacheUserInfo token = $authorization");
    Logger().d("CacheUserInfo userId = $userId");
    return token;
  }
}
