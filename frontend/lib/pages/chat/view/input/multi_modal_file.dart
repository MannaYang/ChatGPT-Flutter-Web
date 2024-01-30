import 'dart:convert';
import 'dart:math';

import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/service/file/file_model.dart';
import 'package:frontend/service/file/file_provider.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

///
/// Display files
///
class MultiModalFile extends ConsumerWidget {
  const MultiModalFile(this.maxInputHeight, this.minInputHeight, {super.key});

  final double maxInputHeight;
  final double minInputHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Current conversation
    final selected = ref.watch(conversationSelectedProvider);

    /// Attach file list
    final attachFile = ref.watch(attachFileProvider.select((value) => value));
    ref.listen(attachFileProvider, (_, next) => attachFileListen(next, ref));

    /// Multi modal config
    final configValue = ref.watch(settingMultiModalProvider);

    /// Upload file status tip
    ref.listen(
        uploadFileProvider,
        (_, next) =>
            uploadFileListen(next, ref, selected.$1, selected.$3, configValue));

    return Visibility(
        visible: attachFile.isNotEmpty,
        child: ListView.separated(
            itemCount: attachFile.length,
            itemBuilder: (_, index) {
              final fileInfo = attachFile[index];
              return attachChild(ref, fileInfo);
            },
            separatorBuilder: (_, __) => const SizedBox.shrink()));
  }

  Widget attachChild(WidgetRef ref, FileInfo fileInfo) {
    return Container(
      height: 64,
      width: 128,
      margin: const EdgeInsets.only(top: 8),
      child: Stack(children: [
        Container(
            width: 128,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 4, right: 12),
            decoration: BoxDecoration(
                color: color80,
                borderRadius: BorderRadius.circular(4),
                border: const Border()),
            child: Row(children: [
              const SizedBox(width: 4),
              getDisplayIcon(fileInfo.fileName ?? '').$1,
              const SizedBox(width: 4),
              Expanded(
                  child: Text(
                fileInfo.fileName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              )),
            ])),
        Align(
          alignment: Alignment.topRight,
          child: Container(
              height: 16,
              width: 16,
              margin: const EdgeInsets.only(right: 4),
              child: IconButton.filled(
                  onPressed: () {
                    ref.read(attachFileProvider.notifier).deleteFile(fileInfo);
                  },
                  iconSize: 16,
                  color: Colors.grey,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close, color: Colors.white))),
        )
      ]),
    );
  }

  ///
  /// When you upload success, change the chat message input height
  ///
  void attachFileListen(List<FileInfo> next, WidgetRef ref) {
    if (next.isEmpty) {
      ref.read(modalInputProvider.notifier).updateHeight(minInputHeight);
    }
  }

  ///
  /// When you upload success, change the chat message input height
  ///
  void uploadFileListen(FileUpload next, WidgetRef ref, int id, String rolePlay,
      int configValue) {
    showSnackBar(next.msg ?? "");
    switch (next.code) {
      case 1:
        ref.read(allowInputProvider.notifier).updateStatus(false);
      case 0:
        ref.read(modalInputProvider.notifier).updateHeight(maxInputHeight);
        ref.read(allowInputProvider.notifier).updateStatus(true);
        if (getDisplayIcon(next.data?.fileName ?? '').$2 != 3) {
          ref.read(attachFileProvider.notifier).addFile(next.data);
          return;
        }

        /// If upload audio , send directly
        sendAudioDirectly(
            ref, configValue, chatMessageData(next.data, id, rolePlay));
    }
  }

  ///
  /// Display icon with file .ext
  ///
  (Icon, int) getDisplayIcon(String fileName) {
    final String extension = fileName.split('.').last;
    var data = switch (extension) {
      "" => (Icons.image_outlined, 0),
      "jpg" || "jpeg" || "png" || "webP" => (Icons.edit_document, 1),
      "pdf" || "docx" || "txt" || "md" => (Icons.edit_document, 2),
      _ => (Icons.audio_file_outlined, 3)
    };
    return (Icon(data.$1, size: 16, color: Colors.white), data.$2);
  }

  ///
  /// Record audio
  ///
  void sendAudioDirectly(
      WidgetRef ref, int configValue, String chatParams) async {
    /// Send chat params
    ref.read(sendProvider).sink.add(chatParams);

    /// Listen send action status
    ref.read(sendContentProvider.notifier).updateStatus(Random().nextDouble());

    /// Clear attach file
    ref.read(attachFileProvider.notifier).clearFile();
  }

  ///
  /// Combine chat message data
  /// - [rolePlay] If you selected one of PromptTemplate role play, it will be actual role
  /// - [role] message type, only use to distinguish message type is AI or Human
  ///
  String chatMessageData(FileInfo? next, int id, String rolePlay) {
    var chatData = {
      "conversationId": id,
      "rolePlay": rolePlay,
      "message": {
        "input": "",
        "image": "",
        "file": "",
        "audio": next?.resId,
        "role": "user"
      }
    };
    return jsonEncode(chatData);
  }
}
