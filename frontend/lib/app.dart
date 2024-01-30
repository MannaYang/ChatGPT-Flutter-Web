
import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/auth/provider/auth_provider.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend/routers.dart';
import 'package:frontend/theme/color_schemes.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

///
/// Application
///
class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(tokenExpiredProvider, (previous, next) {
      if (next) showSnackBar('Your token has expired . Please sign in again .');
    });
    return MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: GoRouter(
            observers: [RouterObserver()],
            initialLocation:
                ref.watch(tokenExpiredProvider) ? '/auth' : '/chat',
                // '/chat',
            debugLogDiagnostics: true,
            routes: <RouteBase>[
              StatefulShellRoute.indexedStack(
                  builder: (_, __, statefulChild) => HomePage(statefulChild),
                  branches: createStatefulShellBranch())
            ]),
        themeMode: ThemeMode.light,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        title: t.app.name,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        debugShowCheckedModeBanner: false);
  }
}
