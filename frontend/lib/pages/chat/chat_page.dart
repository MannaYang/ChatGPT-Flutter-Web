import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/view/setting/chat_setting.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend/pages/chat/view/conversation/chat_conversation.dart';
import 'package:frontend/pages/chat/view/message/chat_message.dart';

///
/// AI-Conversation
///
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends ConsumerState<ChatPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        /// Chat Conversations
        Expanded(flex: 2, child: ChatConversation()),

        /// Chat Messages
        Expanded(flex: 5, child: ChatMessage()),

        /// Chat Settings
        Expanded(flex: 2, child: ChatSetting())
      ])),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
