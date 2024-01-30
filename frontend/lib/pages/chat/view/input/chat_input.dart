import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/model/chat_attach_info.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/pages/chat/view/input/multi_modal_input.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// Chat message input, related multi-modal-tools
///
class ChatInput extends ConsumerWidget {
  ChatInput({super.key});

  late final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(conversationSelectedProvider);
    final configValue = ref.watch(settingMultiModalProvider);
    return Visibility(
        visible: selected.$2,
        child: MultiModalInput(
            controller,
            (str, attach) => handleInputStr(
                str, selected.$1, selected.$3, attach, ref, configValue)));
  }

  ///
  /// 处理输入框内容[handle input str]
  ///
  void handleInputStr(String inputStr, selectedId, rolePlay,
      List<ChatAttachInfo> attachList, WidgetRef ref, int configValue) async {
    final sendInputStr = inputStr.trim();
    if (sendInputStr.isEmpty) return;

    /// Send chat params
    var chatParams = chatMessageData(
        inputStr, selectedId, rolePlay, attachList, ref, configValue);
    if (chatParams.isEmpty) return;
    ref.read(sendProvider).sink.add(chatParams);

    /// Listen send action status
    ref.read(sendContentProvider.notifier).updateStatus(Random().nextDouble());

    /// Clear attach file
    ref.read(attachFileProvider.notifier).clearFile();
  }

  ///
  /// Combine input and attach info
  /// - [rolePlay] - If current conversation is [ChatPromptTemplate] type, it will
  ///               be actual role
  ///
  String chatMessageData(inputStr, selectedId, String rolePlay,
      List<ChatAttachInfo> attachList, WidgetRef ref, int configValue) {
    var msgData = {"input": inputStr};

    /// Image choose data
    final checkImage =
        ref.read(settingMultiModalProvider.notifier).checkImage(configValue);
    if (checkImage.$1) {
      var image = attachList.where((e) => isImage(e.ext));
      if (checkImage.$2 && image.isEmpty) {
        showSnackBar(
            "If choose image-to-image,you should upload one image file");
        return "";
      }
      msgData["image"] = checkImage.$2 ? image.first.resId : "${checkImage.$3}";
    } else {
      msgData["image"] = "";
    }

    /// File choose data
    final checkFile =
        ref.read(settingMultiModalProvider.notifier).checkFile(configValue);
    if (checkFile.$1) {
      msgData["file"] =
          ref.read(settingMultiModalProvider.notifier).getMultiModalConfig();
    } else {
      msgData["file"] = "";
    }

    /// Audio choose data
    final checkAudio =
        ref.read(settingMultiModalProvider.notifier).checkAudio(configValue);
    if (checkAudio.$1) {
      var audio = attachList.where((e) => isAudio(e.ext));
      if (checkAudio.$2 && audio.isEmpty) {
        showSnackBar(
            "If choose speech-to-text,you should upload one audio file");
        return "";
      }
      msgData["audio"] = checkAudio.$2 ? audio.first.resId : "${checkAudio.$3}";
    } else {
      msgData["audio"] = "";
    }
    msgData["role"] = "user";

    var chatData = {
      "conversationId": selectedId,
      "message": msgData,
      "rolePlay": rolePlay
    };
    return jsonEncode(chatData);
  }
}
