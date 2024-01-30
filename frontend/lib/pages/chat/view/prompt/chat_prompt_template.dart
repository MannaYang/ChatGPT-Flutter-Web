import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/chat/model/chat_prompt_info.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// Navigation end drawer menu
/// - [createDrawerHeader]
/// - [createPromptTemplate]
/// - [createPromptContent]
///
class ChatPromptTemplate extends ConsumerStatefulWidget {
  const ChatPromptTemplate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ChatPromptTemplateState();
  }
}

class ChatPromptTemplateState extends ConsumerState<ChatPromptTemplate> {
  final drawerContent = <Widget>[];

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.short1,
        () => ref.read(promptTemplateProvider.notifier).selectMessageList());
  }

  @override
  Widget build(BuildContext context) {
    final promptTemplate = ref.watch(promptTemplateProvider);
    return NavigationDrawer(
      backgroundColor: Colors.white,
      elevation: 0.2,
      children: createPromptTemplate(context, promptTemplate.$3, (data, index) {
        var rolePlay = promptTemplate.$3.isEmpty
            ? ""
            : promptTemplate.$3.keys.elementAt(index);
        insertConversation(data.topic, data.content, rolePlay);
      }),
    );
  }

  ///
  /// Drawer header
  ///
  Widget createDrawerHeader() {
    return Container(
        height: 80,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 8, top: 16),
        child: Column(children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    mouseCursor: SystemMouseCursors.click,
                    tooltip: 'Close Drawer Menu',
                    onPressed: () => scaffoldKey.currentState!.closeEndDrawer(),
                    icon: const Icon(Icons.close_rounded)),
                const SizedBox(width: 16),
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      SizedBox(height: 4),
                      SelectableText('Prompt Template',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ])),
                IconButton(
                    mouseCursor: SystemMouseCursors.click,
                    tooltip: 'Edit system prompt not yet available',
                    onPressed: () {},
                    icon: const Icon(Icons.edit_note_rounded)),
                const SizedBox(width: 16),
              ]),
          SelectableText(t.home.drawer_subtitle)
        ]));
  }

  ///
  /// Prompt template list
  ///
  List<Widget> createPromptTemplate(BuildContext context,
      Map<String, String> prompt, Function(ChatPromptInfo, int) onTap) {
    drawerContent.clear();
    drawerContent.add(createDrawerHeader());
    if (prompt.isEmpty) return drawerContent;
    for (var index = 0; index < promptTemplateList.length; index++) {
      ChatPromptInfo data = promptTemplateList[index];
      final content = Container(
          height: 128,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.2),
              color: Theme.of(context).navigationDrawerTheme.surfaceTintColor,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: InkWell(
              onTap: () => onTap(data, index),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: createPromptContent(
                  data, prompt.values.elementAt(index), context)));
      drawerContent.add(content);
    }
    drawerContent.add(const SizedBox(height: 16));
    return drawerContent;
  }

  ///
  /// Prompt template content
  ///
  Widget createPromptContent(
      ChatPromptInfo data, String promptSystem, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                tooltip: data.topic,
                icon: const Icon(Icons.topic)),
            const SizedBox(width: 8),
            Expanded(
                child: Text(data.topic,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                tooltip: promptSystem,
                icon: const Icon(Icons.info_outline),
                iconSize: 20),
          ]),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(data.content, style: style15))),
          Align(
            alignment: Alignment.bottomRight,
            child: FilledButton.tonal(
              onPressed: () {},
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 8)),
                  minimumSize:
                      const MaterialStatePropertyAll<Size>(Size(40, 34))),
              child: Text(data.label, style: style13),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Add conversation
  /// - [rolePlay] Your choose role
  ///
  insertConversation(String title, String content, String rolePlay) async {
    var params = {"title": title, "sub_title": content, "role_play": rolePlay};
    var conversationId = await ref
        .read(chatConversationsProvider.notifier)
        .insertConversation(params);
    ref
        .read(conversationSelectedProvider.notifier)
        .updateStatus((conversationId, true, rolePlay));
    ref.read(settingMultiModalProvider.notifier).updateStatus(0);
    scaffoldKey.currentState!.closeEndDrawer();
  }
}
