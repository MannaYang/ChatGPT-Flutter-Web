// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passwordHash() => r'83edb81e47778b50eaa2210f16b0be5f6ae2288b';

/// See also [Password].
@ProviderFor(Password)
final passwordProvider = AutoDisposeNotifierProvider<Password, bool>.internal(
  Password.new,
  name: r'passwordProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$passwordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Password = AutoDisposeNotifier<bool>;
String _$authHash() => r'4c647f38d695e7b682cf3065cfe55b6623268f73';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = AutoDisposeNotifierProvider<Auth,
    (int, String, SignInfo?, UserInfo)>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AutoDisposeNotifier<(int, String, SignInfo?, UserInfo)>;
String _$tokenExpiredHash() => r'f2c3c2faf85917be6a91c8ade42f3c7a92f897c8';

/// See also [TokenExpired].
@ProviderFor(TokenExpired)
final tokenExpiredProvider =
    AutoDisposeNotifierProvider<TokenExpired, bool>.internal(
  TokenExpired.new,
  name: r'tokenExpiredProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tokenExpiredHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TokenExpired = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
