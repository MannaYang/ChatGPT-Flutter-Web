import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/auth/provider/auth_provider.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// User profile
///
class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends ConsumerState<UserProfile> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Durations.short1, () => ref.read(authProvider.notifier).getUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    /// Get user info from api
    final userInfo = ref.watch(authProvider);

    /// When you click sign out
    ref.listen(authProvider, (previous, next) {
      showSnackBar(next.$2);
    });
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(bottom: 16),
        height: 56,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SelectableText('AI.MANNA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          // IconButton(
          //   tooltip: 'Open Drawer Menu',
          //     padding: const EdgeInsets.all(8),
          //     onPressed: () {},
          //     icon: const Icon(Icons.menu),
          //   )
          TextButton.icon(
            onPressed: () => showSignOutDialog(userInfo.$4.email ?? ""),
            icon: Icon(Icons.manage_accounts_outlined,
                color: Theme.of(context).colorScheme.secondary),
            label: Text(
              extraText(userInfo.$4.email ?? ""),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ]));
  }

  String extraText(String email) {
    if (email.isEmpty ||
        !email.contains("@") ||
        email.split("@")[0].length < 3) {
      return email;
    }
    var extraStr = email.split("@")[0];
    return "${extraStr.substring(0, 3)}...";
  }

  showSignOutDialog(String email) {
    if (email.isEmpty) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              elevation: 0,
              title: const Text("Sign Out", style: styleWeight18),
              content: SelectableText("Your current account : $email, confirm sign out?"),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(t.app.cancel,
                        style: const TextStyle(color: Colors.black))),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).signOut(email);
                      Navigator.of(context).pop();
                    },
                    child: Text(t.app.confirm))
              ]);
        });
  }
}
