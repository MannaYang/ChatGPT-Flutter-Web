# Flutter-ChatGPT
    
基于Flutter跨平台和FastApi轻量级的ChatGPT Web多模态项目,
使用JWT、Mysql、Redis、Sqlalchemy实现用户验签及聊天数据存储;使用Celery、Flower执行并监控后台任务.

## Features

- [x] 支持flutter stable(v3.16.8)及使用的pub最新版本 | dart stable(v3.2.5)
- [x] 支持Riverpod(v2.4.3)版本状态管理 ｜ Go_Router处理全局路由
- [x] 支持websocket通信 | record录音及player | markdown 展示文本/语音/图片等消息列表
- [x] 支持JWT验签 ｜ FastApi中间件处理CORS、Exception、Request请求拦截
- [x] 支持Sqlalchemy、mysql、redis存储及缓存用户信息与对话消息API ｜ 采用Celery执行后台任务
- [x] 支持Pinecone向量数据库 ｜ RetrievalAgent检索向量文档
- [x] 支持docker-compose部署
- [x] 支持flutter web多语言展示，yaml文件中的pub库均选择支持多平台应用
- [ ] 支持Android/iOS/MacOS/Windows,移动端适配需要修改UI/UX

## QuickStart

#### Clone项目并修改backend目录下环境配置文件

> .env
>
> .env.prod

1. 设置OpenAI api key : https://platform.openai.com/api-keys
2. 设置Pinecone向量数据库 api key : https://www.pinecone.io/
3. 根据项目需求修改mysql连接地址及其参数配置，DATABASE_URL默认本地地址
4. 根据项目需求修改redis连接地址，REDIS_URL默认本地地址
5. 根据项目需求修改Celery缓存地址，CELERY_BROKER，CELERY_BACKEND

#### 基于docker部署，如果未安装请先下载 : https://www.docker.com/

启动docker,进入项目ChatGPT-Flutter-Web

```docker
docker-compose up -d --build
```

如果需要查看哪些容器启动成功，执行

```docker
docker-compose ps
```

**执行成功后如下图所示**

![docker-compose.png](screenshot%2Fen%2Fdocker-compose.png)

可在docker内查看各容器服务的运行日志

```docker
docker-compose logs backend

docker-compose logs frontend

docker-compose logs celery
...
```

frontend/backend目录下分别有各自的Dockerfile,根目录的docker-compose.yml会执行该配置，backend目录下
提供init.sql用于初始化数据库

#### 部署成功后访问 frontend/backend/flower

- frontend : 127.0.0.1:3000
- backend : 127.0.0.1:8000/docs
- flower : 127.0.0.1:5555

如果部署失败，请根据日志重新修改docker-compose或是项目调整代码，再次执行

```docker
docker-compose down
docker-compse up -d --build
```

## Project Structure

#### 根目录工程结构

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

#### 后端backend工程结构，其中

- data 目录存放默认的向量化文档，
- app/attach 用于存储上传下载的文件
- db 用于处理Sqlalchemy数据库及表定义操作

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

#### 前端frontend工程结构，其中

- pages 目录存放Widget pages
- service 公用服务
- widget 自定义目录存放Widget
- theme 设置Material color

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

#### requirements.txt 中如遇版本安装问题，请及时修改为最新版本

> langchain v0.1.3,较之前的版本官方有包名级别聚合变更，请注意！
>
> pinecone-client v3.0.2,较之前的版本官方有包名级别聚合变更，请注意！
>
> openai v1.9.0,较之前的版本官方有包名级别聚合变更，请注意！

#### pubspec.yaml 中如遇版本安装问题，请及时修改为最新版本

> 目前已测试并调整为pub仓库最新版本，如有问题请及时提issue

## 自定义Markdown展示图片及语音Tag

官方文档地址 : https://github.com/dart-lang/markdown

在frontend/lib/widget模块下[custom_markdown.dart](frontend%2Flib%2Fwidget%2Fcustom_markdown.dart)
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
项目中实现了简便的处理backend返回带有audio标签tag的文本，用于展示audio并点击播放；同时简便定义code style
> CustomAudioTagSyntax
> 
> CustomAudioBuilder
> 
> CustomSyntaxHighlighter - 代码高亮


## Flutter Web输入框动态高度计算
输入框跟随文本长度自动换行，复制粘贴时光标滚动到文本末尾[multi_modal_input.dart](frontend%2Flib%2Fpages%2Fchat%2Fview%2Finput%2Fmulti_modal_input.dart)
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
请根据实际需要修改响应阈值，并调用Riverpod刷新UI状态

## 部署后访问Flutter Web效果截图

[screenshot](screenshot)

<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/1.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/3.png" width="375" height="206" />
<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/4.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/5.png" width="375" height="206" />
<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/6.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/7.png" width="375" height="206" />
<img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/8.png" width="375" height="206" /><img src="https://github.com/MannaYang/ChatGPT-Flutter-Web/blob/main/screenshot/zh/docker-compose.png" width="375" height="206" />

## LICENSE
[LICENSE](LICENSE)

