// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fileRepositoryHash() => r'4dad17e841a8bb7d2c0c94f1b1c174c563f59d6f';

///
/// ```dart
///   ref.read(fileRepositoryProvider).uploadFile
/// ```
/// - [uploadFile] -> image / docs
/// - [uploadFileUrl] -> record audio
/// - [checkMultiModalStatus] :-> multi-modal-config
///
///
/// Copied from [FileRepository].
@ProviderFor(FileRepository)
final fileRepositoryProvider = NotifierProvider<FileRepository, void>.internal(
  FileRepository.new,
  name: r'fileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FileRepository = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
