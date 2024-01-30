// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpRequestHash() => r'27d5e7c104e8ee66042685868b4cc73f0b78fe8b';

///
/// ```dart
///   ref.read(httpRequestProvider).get()
/// ```
/// - [post] -> http
/// - [get] -> http
/// - [multipartFile] -> http
/// - [multipartFileUrl] -> http
///
///
/// Copied from [HttpRequest].
@ProviderFor(HttpRequest)
final httpRequestProvider = NotifierProvider<HttpRequest, void>.internal(
  HttpRequest.new,
  name: r'httpRequestProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$httpRequestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HttpRequest = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
