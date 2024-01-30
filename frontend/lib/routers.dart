import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/auth_page.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/chat/chat_page.dart';
import 'package:frontend/gen/strings.g.dart';

///
/// 全局路由配置页面[Global Routers Config]
///
final menuNameList = [t.chat.menuName, t.auth.authName];
final menuRouterList = ['/chat', '/auth'];

const menuPageList = <Widget>[ChatPage(), AuthPage()];

final navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>();

final globalRouter = GoRouter(
    observers: [RouterObserver()],
    initialLocation: '/chat',
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
          builder: (context, state, statefulChild) {
            return HomePage(statefulChild);
          },
          branches: createStatefulShellBranch())
    ]);

///
/// 构建抽屉菜单功能导航分支
/// [Building Drawer Menu Functional Navigation Branches]
///
List<StatefulShellBranch> createStatefulShellBranch() {
  final branchList = <StatefulShellBranch>[];
  for (var i = 0; i < menuNameList.length; i++) {
    var branch = StatefulShellBranch(routes: <RouteBase>[
      GoRoute(
          path: menuRouterList[i],
          name: menuNameList[i],
          builder: (context, state) => menuPageList[i])
    ]);
    branchList.add(branch);
  }
  return branchList;
}

///
/// 路由栈监听 - Go_Router
/// [Router Stack Observer]
///
class RouterObserver extends NavigatorObserver {
  @override
  void didStopUserGesture() {
    debugPrint('| [GoRouter] didStopUserGesture');
  }

  @override
  void didStartUserGesture(
      Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint(
        '| [GoRouter] didStartUserGesture : ${route.toString()} , previousRoute : ${previousRoute.toString()}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint(
        '| [GoRouter] didReplace : newRoute = ${newRoute.toString()} , oldRoute = ${oldRoute.toString()}');
  }

  @override
  void didRemove(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint(
        '| [GoRouter] didRemove : route = ${route.toString()} , previousRoute = ${previousRoute.toString()}');
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint(
        '| [GoRouter] didPop : route = ${route.toString()} , previousRoute = ${previousRoute.toString()}');
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint(
        '| [GoRouter] didPush : route = ${route.toString()} , previousRoute = ${previousRoute.toString()}');
  }
}
