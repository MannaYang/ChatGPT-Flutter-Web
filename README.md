# Flutter-ChatGPT

Based on Flutter cross-platform and FastApi lightweight ChatGPT Web multimodal project. Use JWT, Mysql, Redis, Sqlalchemy to realize user signing and chat data storage; use Celery, Flower to execute and monitor the background tasks.

## Features

- [x] Supported flutter stable(v3.16.8)and pub latest version | dart stable(v3.2.5)
- [x] Supported Riverpod(v2.4.3)state manager ｜ Go_Router handle global routers
- [x] Supported websocket | recording and player | markdown display text/audio/image messgae list
- [x] Supported JWT signing｜ FastApi middleware handle CORS、Exception、Request interceptor
- [x] Supported Sqlalchemy、mysql、redis data storage API ｜ use Celery、Flower to execute and monitor the background tasks
- [x] Supported Pinecone vector db ｜ RetrievalAgent vector docs
- [x] Supported docker-compose deploy
- [x] Supported flutter web localizations | yaml file all choose to support multi-platform applications
- [ ] Supported Android/iOS/MacOS/Windows | mobile adaptation requires UI/UX changes

## QuickStart

#### Clone project backend and modify env file

> .env
>
> .env.prod

1. Set OpenAI api key : https://platform.openai.com/api-keys
2. Set Pinecone vector db api key : https://www.pinecone.io/
3. Modify Mysql url and args config if necessary, DATABASE_URL default localhost
4. Modify Redis url and args config if necessary, REDIS_URL default localhost
5. Modify Celery url if necessary, CELERY_BROKER，CELERY_BACKEND default localhost

#### Base on docker deploy，If not installed, please download : https://www.docker.com/

Start docker,cd ChatGPT-Flutter-Web

```docker
docker-compose up -d --build
```

If need to view which containers started successfully, run

```docker
docker-compose ps
```

**If running successfully will be show like this**

![docker-compose.png](screenshot%2Fen%2Fdocker-compose.png)

Your can view logs within docker, run

```docker
docker-compose logs backend

docker-compose logs frontend

docker-compose logs celery
...
```

root directory docker-compose.yml will be scan and execute frontend/backend each Dockerfile，backend directory init.sql to init database

#### Visit frontend/backend/flower after successful deployment

- frontend : 127.0.0.1:3000
- backend : 127.0.0.1:8000/docs
- flower : 127.0.0.1:5555

If fails, check docker logs or modify docker-compse config or project code, then run

```docker
docker-compose down
docker-compse up -d --build
```

## Project Structure

#### Root Project Structure

ChatGPT-Flutter-Web

```
├── backend
├── frontend
├── README.md
├── README_zh.md
├── LICENSE
├── docker-compsoe.yml
└── screenshot
```

#### Backend Project Structure

- data : Stores the default vectorized document
- app/attach : Stores the uploaded and downloaded file
- db : Handle Sqlalchemy db and table define

```
├── app
│   ├── api
│   │   ├── **/*.py
│   ├── attach
│   ├── core
│   ├── db
│   ├── main.py
├── data
├── Dockerfile
├── init.sql
├── requirements.txt
└── .gitignore
```

#### Frontend Project Structure

- pages : Stores Widget pages
- service : Common service
- widget : Custom Widget
- theme : Config material color

```
├── lib
│   ├── pages
│   │   ├── **/*.dart
│   ├── service
│   ├── theme
│   ├── widget
│   ├── routers.dart
│   ├── app.dart
│   ├── main.dart
├── assets
├── Dockerfile
├── nginx.conf
├── pubspec.yaml
├── web
├── android
├── ios
├── macos
├── windows
├── linux
└── .gitignore
```

## Version Description

#### requirements.txt if occor problem,please modify it to the latest version

> langchain v0.1.3 : With previous version the package name level aggregation has changed, please note!
>
> pinecone-client v3.0.2 : With previous version the package name level aggregation has changed, please note!
>
> openai v1.9.0 : With previous version the package name level aggregation has changed, please note!

#### pubspec.yaml if occor problem,please modify it to the latest version

> Currently tested and choosed pub latest version repository, if occur problems please write issue with me.

## Custom Markdown display image and audio tag

Markdown Library : https://github.com/dart-lang/markdown

at frontend/lib/widget package [custom_markdown.dart](frontend%2Flib%2Fwidget%2Fcustom_markdown.dart)
```dart
///
/// Custom chat message display [markdown] style
/// - [CustomMarkdown]
/// - [CustomAudioTagSyntax]
/// - [CustomAudioBuilder]
/// - [CustomSyntaxHighlighter]
///
class CustomMarkdown extends StatelessWidget {
  ...
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
```
Project implements a simple handling of the backend to return the text with the audio tag, which is used to display the audio and click to play; 
and a simple definition of the code style.
> CustomAudioTagSyntax
>
> CustomAudioBuilder
>
> CustomSyntaxHighlighter - Code Highlighte


## Flutter Web TextField dynamic height calculation
TextField follows the text length automatic line feeds，when copying and pasting the cursor will be scroll to end
[multi_modal_input.dart](frontend%2Flib%2Fpages%2Fchat%2Fview%2Finput%2Fmulti_modal_input.dart)
```dart
  ///
  /// Calculate input height
  /// [TextPainter.maxWidth] Dynamically calculates the width based on your text characters
  ///
  (double, double) inputHeight(String value) {
    final textPainter = TextPainter(
        text: TextSpan(text: value, style: const TextStyle(height: 22)),
        textDirection: TextDirection.ltr,
        maxLines: null)
      // ..layout(maxWidth: widget.maxWidth - 16 * 2 - 128);
      ..layout(maxWidth: 400);
    final lineList = textPainter.computeLineMetrics();
    final lines = lineList.length;
    var lineHeight = lineList.fold(0.0,
        (previousValue, element) => previousValue.toDouble() + element.height);
    final totalHeight = minInputHeight * (lines == 0 ? 1 : lines);
    if (totalHeight > 152) return (152, lineHeight * lines);
    return (totalHeight, lineHeight * lines);
  }
```
Modify the maxWidth and height if necessary, then use riverpod refresh UI state.

## Deployment Flutter Web Screenshot

[screenshot](screenshot)

<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/1.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/3.png" width="375" height="206" />
<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/4.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/5.png" width="375" height="206" />
<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/6.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/7.png" width="375" height="206" />
<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/8.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/docker-compose.png" width="375" height="206" />

## LICENSE
[LICENSE](LICENSE)

