import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/view/prompt/chat_prompt_template.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend/routers.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

///
/// Main Container
///
class HomePage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage(this.navigationShell, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        key: scaffoldKey,
        // drawer: NavigationDrawerWidget(navigationShell),
        endDrawer: const ChatPromptTemplate(),
        // appBar: AppBar(
        //     leadingWidth: 68,
        //     titleSpacing: 0,
        //     leading: IconButton(
        //       tooltip: 'Open Drawer Menu',
        //       padding: const EdgeInsets.all(8),
        //       onPressed: () => scaffoldKey.currentState!.openDrawer(),
        //       icon: const Icon(Icons.menu),
        //     ),
        //     centerTitle: true,
        //     title: MenuTitle(navigationShell.currentIndex),
        //     actions: [
        //       Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 36),
        //           child: AnimatedTextKit(animatedTexts: [
        //             WavyAnimatedText(t.home.appbar_action, textStyle: style16)
        //           ], repeatForever: true)),
        //     ]),
        body: navigationShell);
  }
}

///Menu Name
class MenuTitle extends ConsumerWidget {
  const MenuTitle(this.currentIndex, {super.key});

  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(menuNameList[currentIndex],
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500));
  }
}
