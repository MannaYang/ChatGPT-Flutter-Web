import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/service/file/file_model.dart';
import 'package:frontend/service/utils/status_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'file_repository.dart';

part 'file_provider.g.dart';

///
/// ```dart
///   UploadFile = ref.watch(uploadFileProvider)
/// ```
/// - [uploadFile] -> image / docs
/// - [uploadFileUrl] -> audio
/// - [checkMultiModalStatus] :-> multi-modal-config
///
@riverpod
class UploadFile extends _$UploadFile {
  @override
  FileUpload build() => FileUpload();

  /// openai api - must be .png
  final List<String> imageExt = ['png'];

  ///PDF·DOCX·TXT·EXCEL·PPT·MD
  final List<String> fileExt = ['pdf', 'docx', 'txt', 'md'];

  ///wav·mp3
  final List<String> audioExt = ['wav'];

  final String tipEmpty =
      "Your multi-modal-config is unselect any one,can not operation this";

  final String tipImage =
      "Your multi-modal-config is selected text-to-image,do not operation this";

  final String tipAudio =
      "Your multi-modal-config is selected text-to-speech,do not operation this";

  ///
  /// Upload file
  /// extType - imageExt/fileExt
  ///
  Future<void> uploadFile() async {
    final params = checkMultiModalStatus();
    if (params.$1) {
      state = FileUpload(code: StatusProvider.stateDefault, msg: params.$2);
      return;
    }
    try {
      final isImage =
          ref.read(settingMultiModalProvider.notifier).isImage(params.$3);
      final isFile =
          ref.read(settingMultiModalProvider.notifier).isFile(params.$3);
      var ext = isImage
          ? imageExt
          : isFile
              ? fileExt
              : audioExt;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          withData: true,
          type: FileType.custom,
          allowedExtensions: ext);
      if (result != null) {
        state =
            FileUpload(code: StatusProvider.state_1, msg: t.app.uploading);
        await ref
            .read(fileRepositoryProvider.notifier)
            .uploadFile(result.files.first, (data) {
          final code = data['code'];
          final msg = data['msg'];
          if (code != 0) {
            state = FileUpload(code: code, msg: msg);
            return;
          }
          state = FileUpload(
              code: StatusProvider.state_0,
              msg: msg,
              data: FileInfo.fromJson(data['data']));
        });
      }
    } catch (e) {
      state = FileUpload(
          code: StatusProvider.stateDefault, msg: e.toString());
    }
  }

  ///
  /// Upload audio
  ///
  Future<void> uploadFileUrl(Uint8List data) async {
    try {
      state =
          FileUpload(code: StatusProvider.state_1, msg: t.app.uploading);
      await ref
          .read(fileRepositoryProvider.notifier)
          .uploadFileUrl("audio.wav", data, (data) {
        final code = data['code'];
        final msg = data['msg'];
        if (code != 0) {
          state = FileUpload(code: code, msg: msg);
          return;
        }
        var temp = FileInfo.fromJson(data['data']);
        state = FileUpload(code: StatusProvider.state_0, msg: msg, data: temp);
      });
    } catch (e) {
      state = FileUpload(code: StatusProvider.stateDefault, msg: e.toString());
    }
  }

  ///
  /// Check multi-modal-config status
  /// [checkAudio] is diff file or audio
  /// [value] is multi-modal-config value
  ///
  (bool, String, int) checkMultiModalStatus() {
    final value = ref.read(settingMultiModalProvider.notifier).state;
    var tip = "";
    if (value == 0) tip = tipEmpty;
    final checkImage =
        ref.read(settingMultiModalProvider.notifier).checkImage(value);
    if (checkImage.$1) {
      tip = checkImage.$2 ? "" : tipImage;
    }
    final checkFile =
        ref.read(settingMultiModalProvider.notifier).checkFile(value);
    if (checkFile.$1) tip = "";
    final checkAudio =
        ref.read(settingMultiModalProvider.notifier).checkAudio(value);
    if (checkAudio.$1) {
      tip = checkAudio.$2 ? "" : tipAudio;
    }
    return (tip.isNotEmpty, tip, value);
  }
}
