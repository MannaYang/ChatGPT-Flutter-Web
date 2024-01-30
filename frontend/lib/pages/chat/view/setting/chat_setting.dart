import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';

import 'setting_multi_modal.dart';

///
/// 1.Image generate
/// 2.Docs vector
/// 3.Speech-to-text
///
class ChatSetting extends StatelessWidget {
  const ChatSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 16),
      Container(
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(children: [
            const SelectableText('Prompt Template',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Expanded(
                child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () =>
                            scaffoldKey.currentState!.openEndDrawer(),
                        icon: const Icon(Icons.menu_open_rounded))))
          ])),
      Expanded(
          child: Container(
              constraints: const BoxConstraints(minWidth: 268),
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: const EdgeInsets.only(
                  bottom: 24, top: 16, right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 0.2),
                  color:
                      Theme.of(context).navigationDrawerTheme.surfaceTintColor),
              child: const SettingMultiModal()))
    ]);
  }
}
