import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/view/user_profile.dart';
import 'package:frontend/pages/chat/view/conversation/conversation_list.dart';

import 'conversation_action.dart';

///
/// Conversation list container
///
class ChatConversation extends StatelessWidget {
  const ChatConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 256,
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(bottom: 24, top: 16, left: 30, right: 30),
        color: Theme.of(context).navigationDrawerTheme.surfaceTintColor,
        child: Column(children: [
          const UserProfile(),
          Container(
              height: 48,
              alignment: Alignment.centerLeft,
              child: const ConversationAction()),
          const SizedBox(height: 8),
          const Expanded(child: ConversationList())
        ]));
  }
}
