import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/auth/model/auth_sign.dart';
import 'package:frontend/pages/auth/model/user_info.dart';
import 'package:frontend/pages/auth/repository/auth_repository.dart';
import 'package:frontend/service/utils/sp_provider.dart';
import 'package:frontend/service/utils/status_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Password extends _$Password {
  @override
  bool build() => false;

  void updateState() {
    state = !state;
  }
}

@riverpod
class Auth extends _$Auth {
  ///
  /// User sign in / sign up
  /// User info
  ///
  ///

  ///
  /// [int] code
  /// [String] msg
  /// [SignInfo] signIn result
  /// [UserInfo] getUserInfo result
  ///
  @override
  (int, String, SignInfo?, UserInfo) build() =>
      (StatusProvider.stateDefault, '', null, UserInfo());

  Future<void> signIn(Map<String, String> params) async {
    state = (StatusProvider.state_1, t.auth.auth_sign_loading, null, state.$4);
    final result = await ref.read(authRepositoryProvider.notifier).sign(params);
    if (result.code != 0) {
      state = (result.code ?? -1, result.msg ?? '', null, state.$4);
      return;
    }
    var token =
        await ref.read(authRepositoryProvider.notifier).cacheUserInfo(result);
    if (token.isEmpty) {
      state = (result.code ?? -1, 'Token is null or empty', null, state.$4);
      return;
    }
    state = (StatusProvider.state_0, result.msg ?? '', result.data, state.$4);
  }

  void getUserInfo() async {
    if (state.$4.id != null) {
      state = (state.$1, state.$2, state.$3, state.$4);
      return;
    }
    final result =
        await ref.read(authRepositoryProvider.notifier).getUserInfo();
    if (result.data != null) {
      state = (StatusProvider.state_0, '', state.$3, result.data!);
    }
  }

  void signOut(String email) async {
    final result =
        await ref.read(authRepositoryProvider.notifier).signOut(email);
    if (result.code == 0) {
      await SpProvider().setString("token", "");
      await SpProvider().setString("userId", "");
      state = (result.code, result.msg, state.$3, state.$4);
      Future.delayed(Durations.short1,
          () => ref.read(tokenExpiredProvider.notifier).build());
      return;
    }
    state = (result.code, result.msg, state.$3, state.$4);
  }
}

@riverpod
class TokenExpired extends _$TokenExpired {
  @override
  bool build() {
    final token = SpProvider().getString('token', defValue: '');
    if (token.isEmpty) {
      state = true;
      return true;
    }
    state = false;
    return false;
  }
}
