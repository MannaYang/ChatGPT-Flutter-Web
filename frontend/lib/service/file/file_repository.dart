import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:frontend/service/http/http_provider.dart';
import 'package:frontend/service/utils/api_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_repository.g.dart';

///
/// ```dart
///   ref.read(fileRepositoryProvider).uploadFile
/// ```
/// - [uploadFile] -> image / docs
/// - [uploadFileUrl] -> record audio
/// - [checkMultiModalStatus] :-> multi-modal-config
///
@Riverpod(keepAlive: true)
class FileRepository extends _$FileRepository {
  // static final FileRepository _singleton = FileRepository._();
  //
  // static FileRepository get instance => _singleton;
  //
  // FileRepository._();

  @override
  void build() {}

  ///
  /// Upload image / docx
  ///
  Future uploadFile(
      PlatformFile file, Function(Map<String, dynamic> parans) onUpload) async {
    final bytes = file.bytes;
    try {
      var uri = Uri.http(ApiProvider.backendUrl, 'api/llm/v1/file/upload');
      final response = await ref
          .read(httpRequestProvider.notifier)
          .multipartFile(uri, file.name, bytes);
      await for (var data in response.stream.transform(utf8.decoder)) {
        Logger().d('data = $data');
        final result = jsonDecode(data);
        onUpload(result);
      }
    } catch (e) {
      onUpload({'msg': 'File upload error = $e', 'code': -1});
    }
  }

  ///
  /// Upload audio
  ///
  Future uploadFileUrl(String fileName, Uint8List data,
      Function(Map<String, dynamic> parans) onUpload) async {
    try {
      var uri = Uri.http(ApiProvider.backendUrl, 'api/llm/v1/file/upload');
      final response = await ref
          .read(httpRequestProvider.notifier)
          .multipartFileUrl(uri, fileName, data);
      await for (var data in response.stream.transform(utf8.decoder)) {
        Logger().d('data = $data');
        final result = jsonDecode(data);
        onUpload(result);
      }
    } catch (e) {
      onUpload({'msg': 'File upload error = $e', 'code': -1});
    }
  }
}
