import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/service/utils/sp_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

///
/// Custom chat message display [markdown] style
/// - [CustomMarkdown]
/// - [CustomAudioTagSyntax]
/// - [CustomAudioBuilder]
/// - [CustomSyntaxHighlighter]
///
class CustomMarkdown extends StatelessWidget {
  CustomMarkdown(this.displayMsg, {super.key});

  final String displayMsg;
  final AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: displayMsg,
      selectable: true,
      fitContent: true,
      syntaxHighlighter: CustomSyntaxHighlighter(),
      styleSheet: MarkdownStyleSheet(
          codeblockDecoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(8))),
      onTapLink: (String text, String? href, String title) {
        if (href == null || href.isEmpty) return;
        launchUrl(Uri.parse(href));
      },
      imageBuilder: (Uri uri, String? title, String? alt) {
        var header = {'Authorization': SpProvider().getString('token')};
        return Container(
            alignment: Alignment.topLeft,
            width: 128,
            height: 128,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.network(uri.toString(), headers: header)));
      },
      extensionSet: md.ExtensionSet(md.ExtensionSet.gitHubWeb.blockSyntaxes, [
        ...md.ExtensionSet.gitHubWeb.inlineSyntaxes,
        CustomAudioTagSyntax()
      ]),
      builders: {'audio': CustomAudioBuilder(player)},
    );
  }
}

///
/// Custom audio tag syntax,
/// to parse <audio>https://localhost:8000/static/audio/xxxx.wav</audio>
///
class CustomAudioTagSyntax extends md.InlineSyntax {
  CustomAudioTagSyntax() : super(r'\s*<audio>(.*?)<\/audio>\s*');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    var el = md.Element.withTag('audio');
    el.attributes['src'] = match[1]!.trim();
    parser.addNode(el);
    return true;
  }
}

///
/// Custom audio widget,
/// to show audio name and click play it
///
class CustomAudioBuilder extends MarkdownElementBuilder {
  CustomAudioBuilder(this.player) : super();

  final AudioPlayer player;

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var src = element.attributes['src'];
    if (src == null) return const SizedBox();
    return TextButton.icon(
      onPressed: () {
        player.play(
            UrlSource("$src?Authorization=${SpProvider().getString('token')}"));
      },
      icon: const Icon(Icons.play_circle_outline_rounded),
      label: Text(
        src.split("audio/")[1],
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

///
/// Custom syntax high light keywords,you can add others(key and style)
///
const Map<String, TextStyle> _keywordsStyle = {
  'class': TextStyle(color: Colors.blue),
  'Widget': TextStyle(color: Colors.blue),
  'BuildContext': TextStyle(color: Colors.blue),
  'void': TextStyle(color: Colors.blueAccent),
  'build': TextStyle(color: Colors.blueAccent),
  'var': TextStyle(color: Colors.green),
  'int': TextStyle(color: Colors.green),
  'String': TextStyle(color: Colors.green),
  'bool': TextStyle(color: Colors.green),
  'Future': TextStyle(color: Colors.purple),
  'Stream': TextStyle(color: Colors.purple),
  'if': TextStyle(color: Colors.orange),
  'else': TextStyle(color: Colors.orange),
  'return': TextStyle(color: Colors.orange),
  // ... Other keywords
};

///
/// TextSpan regExp,you can add others
///
final RegExp _regExp = RegExp(
  r'\b(class|Widget|BuildContext|build|void|var|int|String|bool|Future|Stream|if|else|return)\b',
  multiLine: true,
);

///
/// Custom syntax high light
///
class CustomSyntaxHighlighter extends SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    List<TextSpan> spans = [];
    int lastMatchEnd = 0;
    for (final match in _regExp.allMatches(source)) {
      final String beforeMatch = source.substring(lastMatchEnd, match.start);
      final String matchString = match[0]!;
      spans.add(TextSpan(text: beforeMatch));
      spans
          .add(TextSpan(text: matchString, style: _keywordsStyle[matchString]));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < source.length) {
      spans.add(TextSpan(text: source.substring(lastMatchEnd)));
    }
    return TextSpan(children: spans);
  }
}
