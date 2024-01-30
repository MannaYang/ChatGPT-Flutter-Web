import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/service/utils/regexp_provider.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/auth_provider.dart';

///
/// Auth form
///
class AuthForm extends ConsumerWidget {
  AuthForm({super.key});

  final Map<String, String> formParams = {'email': '', 'password': ''};
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sign = ref.watch(authProvider);
    ref.listen(authProvider, (previous, next) {
      switch (next.$1) {
        case 0:
          ref.read(tokenExpiredProvider.notifier).build();
          showSnackBar(next.$2);
          break;
        default:
          showSnackBar(next.$2);
          break;
      }
    });
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///title
          SelectableText(t.auth.auth_title,
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 44)),
          const SizedBox(height: 34),

          ///email title
          Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(t.auth.auth_email_title, style: styleWeight20)),
          const SizedBox(height: 16),

          ///email input
          SizedBox(
            height: 68,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: t.auth.auth_email_hint,
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: const Icon(Icons.email_outlined)),
              maxLength: 30,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              showCursor: true,
              onChanged: (str) => formParams['email'] = str,
              validator: (input) => validateEmail(input),
            ),
          ),
          const SizedBox(height: 34),

          ///password title
          Row(children: [
            SelectableText(t.auth.auth_password_title, style: styleWeight20),
            SelectableText(t.auth.auth_password_title_label, style: labelLarge(context))
          ]),
          const SizedBox(height: 16),

          ///password input
          SizedBox(
            height: 68,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: t.auth.auth_password_hint,
                  prefixIcon: const Icon(Icons.password_outlined),
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                      onPressed: () =>
                          ref.read(passwordProvider.notifier).updateState(),
                      icon: ref.watch(passwordProvider)
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined))),
              maxLength: 20,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              obscureText: !ref.watch(passwordProvider),
              showCursor: true,
              onChanged: (str) => formParams["password"] = str,
              validator: (value) => validatePassword(value),
            ),
          ),
          const SizedBox(height: 68),

          ///sign in/sign up button
          sign.$1 == 1
              ? const SizedBox(
                  width: 36, height: 36, child: CircularProgressIndicator())
              : SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            onSecondaryContainer(context))),
                    onPressed: () => handleSubmit(ref),
                    child: Text(t.auth.auth_submit, style: style18),
                  ),
                ),
          const SizedBox(height: 16),

          ///tips
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.tips_and_updates_outlined, color: primary(context)),
            SelectableText(t.auth.auth_submit_tips,
                style: TextStyle(color: primary(context)))
          ])
          // RichText(
          //   text: TextSpan(text: "Don't have an account? ", children: [
          //     TextSpan(
          //         text: ' Sign Up',
          //         style: const TextStyle(decoration: TextDecoration.underline,height: 4),
          //         recognizer: TapGestureRecognizer()
          //           ..onTap = () {
          //             showSnackBar('Sign Up');
          //           })
          //   ]),
          // )
        ],
      ),
    );
  }

  validateEmail(value) {
    if (value == null || value.isEmpty) {
      return 'Please input your E-mail address';
    }
    if (!RegExpProvider.isEmail(value)) {
      return 'Incorrect input of E-mail format';
    }
    return null;
  }

  validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please set your password';
    }
    if (value.length < 8) {
      return 'At least 8 bits in length';
    }
    if (!RegExpProvider.isLetterNumber(value)) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  handleSubmit(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).signIn(formParams);
    }
  }
}
