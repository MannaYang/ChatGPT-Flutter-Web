import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/gen/strings.g.dart';

///
/// 消息生成Loading文本[Generative Text Loading Widget]
///
class MessageLoading extends StatelessWidget {
  const MessageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('${t.home.content_action}  '),
      SpinKitThreeBounce(
          color: Theme.of(context).colorScheme.secondary, size: 18)
    ]);
  }
}
