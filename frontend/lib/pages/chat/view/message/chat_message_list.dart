import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/model/chat_message_info.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/pages/message/message_bot.dart';
import 'package:frontend/pages/message/message_user.dart';
import 'package:frontend/service/model/base_result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

///
/// Chat message list view
/// - [ListView.separated]
///
class ChatMessageList extends ConsumerStatefulWidget {
  const ChatMessageList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ChatMessageListState();
  }
}

class ChatMessageListState extends ConsumerState<ChatMessageList> {
  final ScrollController controller = ScrollController();

  /// User input and send action
  final sendList = <double>[];

  /// Current selected conversation
  var selectedId = (0, false, "");

  /// Message List
  final List<ChatMessageInfo> list = [];

  ///
  /// [ScrollController,scroll content to end]
  ///
  void scrollEnd() {
    if (controller.positions.isEmpty) return;
    controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    /// Init message socket stream
    initStreamListen();

    /// Chat message list
    final messages = ref.watch(chatMessagesProvider);

    /// When user input message and click send button
    ref.listen(sendContentProvider, (previous, next) {
      sendList.add(next);
    });

    /// Listen message list and scroll to end
    ref.listen(chatMessagesProvider, (_, next) {
      if (next.$3 == null || next.$3!.isEmpty) return;
      Future.delayed(Durations.short2, () => scrollEnd());
    });

    /// Websocket stream listen status
    final streamListen = ref.watch(streamListenProvider);

    /// Conversation selected status
    ref.listen(conversationSelectedProvider, (previous, next) {
      if (selectedId.$1 == next.$1) return;
      selectedId = next;

      /// If listen status all false
      if (streamListen.$1 == 0 && streamListen.$2 == 0) {
        ref.read(streamListenProvider.notifier).updateStatus((1, 1));
      }

      /// When conversation selected，add [String] event
      ref.read(sendProvider).sink.add(_chatMessageData(next.$1, next.$3));
    });

    return ListView.separated(
        controller: controller,
        shrinkWrap: true,
        itemCount: (messages.$3?.length ?? 0) + sendList.length,
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        itemBuilder: (_, index) {
          final list = messages.$3!;
          if (index >= list.length) {
            /// If socket add completed,clear it
            sendList.clear();

            /// Get system return stream event
            final receiveParams =
                _getReceiveStream(selectedId.$1, selectedId.$3, list.last);
            ref.read(receiveProvider).sink.add(receiveParams);

            /// Message bot view
            return MessageBotView("", "", true, controller);
          }

          /// Message bot view
          final chatMessage = list[index];
          final displayMsg = chatMessage.content ?? '';
          final displayTime = chatMessage.updateTime ?? '';
          return chatMessage.role == 'user'
              ? MessageUserView(displayMsg, displayTime)
              : MessageBotView(displayMsg, displayTime, false, controller);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 24));
  }

  ///
  /// User Message Stream Listen
  ///
  _userMessageStreamListen() {
    ref.read(sendProvider).stream.listen(
      (jsonData) {
        var data = json.decode(jsonData);
        var result = BaseResult<List<ChatMessageInfo>>.fromJson(
            data,
            (jsonT) => (jsonT as List<dynamic>)
                .map((item) => ChatMessageInfo.fromJson(item))
                .toList());
        result.data != null && result.data!.length == 1
            ? ref.read(chatMessagesProvider.notifier).insertMessageList(result)
            : ref.read(chatMessagesProvider.notifier).selectMessageList(result);
      },
      onDone: () {
        retryUserSocket();
      },
      onError: (error) {
        Logger().d('WebSocket error: $error');
      },
    );
  }

  ///
  /// System Message Stream Listen
  ///
  _systemMessageStreamListen() {
    ref.read(receiveProvider).stream.listen(
      (event) {
        if (!((event as String).startsWith("{") && (event).endsWith("}"))) {
          ref.read(streamControlProvider).add(event);
          return;
        }
        //Stream - Last Message
        var result = BaseResult<List<ChatMessageInfo>>.fromJson(
            jsonDecode(event),
            (jsonT) => (jsonT as List<dynamic>)
                .map((item) => ChatMessageInfo.fromJson(item))
                .toList());
        ref.read(chatMessagesProvider.notifier).insertMessageList(result);
        ref
            .read(chatConversationsProvider.notifier)
            .updateSubTitle(result.data?[0].content ?? '', selectedId.$1);
      },
      onDone: () {
        retryUserSocket();
      },
      onError: (error) {
        Logger().d('WebSocket error: $error');
      },
    );
  }

  ///
  /// Websocket stream listen
  ///
  initStreamListen() {
    ref.listen(streamListenProvider, (previous, next) {
      if (next.$1 == 1 && next.$2 == 1) {

        ///User Message Stream
        _userMessageStreamListen();

        ///System Message Stream
        _systemMessageStreamListen();

        ///Stream Has Listen,Update Status
        ref.read(streamListenProvider.notifier).updateStatus((2, 2));
      }
    });
  }

  ///
  /// Websocket [send] connection retry
  ///
  retryUserSocket() {
    Logger().d('WebSocket disconnect retry connect it...');
    Future.delayed(const Duration(seconds: 5), () {
      ref.invalidate(sendProvider);
      _userMessageStreamListen();
    });
  }

  ///
  /// Websocket [receive] connection retry
  ///
  retrySystemSocket() {
    Logger().d('WebSocket disconnect retry connect it...');
    Future.delayed(const Duration(seconds: 5), () {
      ref.invalidate(receiveProvider);
      _systemMessageStreamListen();
    });
  }

  ///
  /// Combine conversation and message info
  ///
  String _chatMessageData(int selectedId, String rolePlay) {
    var chatData = {
      "conversationId": selectedId,
      "message": null,
      "rolePlay": rolePlay
    };
    return jsonEncode(chatData);
  }

  String _getReceiveStream(
      int selectedId, String rolePlay, ChatMessageInfo info) {
    var chatData = {
      "conversationId": selectedId,
      "rolePlay": rolePlay,
      "message": {
        "input": info.content,
        "image": info.image ?? "",
        "file": info.file ?? "",
        "audio": info.audio ?? "",
        "role": "ai"
      }
    };
    return jsonEncode(chatData);
  }
}
