// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$uploadFileHash() => r'4060ddd139431d5109b8ae563f900735e53cefea';

///
/// ```dart
///   UploadFile = ref.watch(uploadFileProvider)
/// ```
/// - [uploadFile] -> image / docs
/// - [uploadFileUrl] -> audio
/// - [checkMultiModalStatus] :-> multi-modal-config
///
///
/// Copied from [UploadFile].
@ProviderFor(UploadFile)
final uploadFileProvider =
    AutoDisposeNotifierProvider<UploadFile, FileUpload>.internal(
  UploadFile.new,
  name: r'uploadFileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$uploadFileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UploadFile = AutoDisposeNotifier<FileUpload>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
