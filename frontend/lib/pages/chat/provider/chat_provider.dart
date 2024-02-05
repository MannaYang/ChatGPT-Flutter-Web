import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:frontend/pages/chat/model/chat_conversation_info.dart';
import 'package:frontend/pages/chat/model/chat_message_info.dart';
import 'package:frontend/pages/chat/repository/chat_repository.dart';
import 'package:frontend/service/file/file_model.dart';
import 'package:frontend/service/model/base_result.dart';
import 'package:frontend/service/utils/api_provider.dart';
import 'package:frontend/service/utils/sp_provider.dart';
import 'package:frontend/service/utils/status_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'chat_provider.g.dart';

// dart run build_runner watch

///
/// Token Provider
///
@Riverpod(keepAlive: true)
String token(TokenRef ref) {
  final token = SpProvider().getString('token');
  return token;
}

///
/// Audio Players
///
@Riverpod(keepAlive: true)
AudioPlayer audio(AudioRef ref) {
  final player = AudioPlayer();
  return player;
}

@riverpod
StreamController<dynamic> streamControl(StreamControlRef ref) {
  final streamController = StreamController<String>.broadcast(onListen: () {
    Logger().d("StreamControl Listen");
  });
  return streamController;
}

///
/// Send Socket
///
// @Riverpod(keepAlive: true)
@riverpod
WebSocketChannel send(SendRef ref) {
  const backendWebSocketUrl =
      String.fromEnvironment('BACKEND_WS_URL', defaultValue: ApiProvider.wsUrl);
  return WebSocketChannel.connect(
    Uri.parse(
        "${backendWebSocketUrl}chat/receive?token=${ref.watch(tokenProvider)}"),
  );
}

///
/// Receive Socket
///
// @Riverpod(keepAlive: true)
@riverpod
WebSocketChannel receive(ReceiveRef ref) {
  const backendWebSocketUrl =
      String.fromEnvironment('BACKEND_WS_URL', defaultValue: ApiProvider.wsUrl);
  return WebSocketChannel.connect(
    Uri.parse(
        "${backendWebSocketUrl}chat/send?token=${ref.watch(tokenProvider)}"),
  );
}

@riverpod
class StreamListen extends _$StreamListen {
  ///
  /// StreamListen [WebSocketChannel send] - [WebSocketChannel receive]
  ///
  @override
  (int sendListen, int receiveListen) build() => (0, 0);

  ///
  /// If Stream<String> has listen,record it
  ///
  void updateStatus((int sendListen, int receiveListen) status) {
    state = status;
  }
}

///
/// Chat Stream Response
///
@riverpod
Stream<BaseResult<List<ChatMessageInfo>?>> sendStream(
    SendStreamRef ref) async* {
  final channel = ref.watch(sendProvider);
  await for (final jsonData in channel.stream.cast()) {
    Logger().d('sendStream， $jsonData');
    var data = json.decode(jsonData);
    var result = BaseResult<List<ChatMessageInfo>>.fromJson(
        data,
        (jsonData) => (jsonData as List<dynamic>)
            .map((item) => ChatMessageInfo.fromJson(item))
            .toList());
    yield result;
  }
}

@riverpod
class ModalInput extends _$ModalInput {
  ///
  /// Multi-Modal-Input height
  ///
  @override
  double build() => 56;

  void updateHeight(double height) {
    state = height;
  }
}

@riverpod
class AllowInput extends _$AllowInput {
  ///
  /// TextField State Switch
  ///
  @override
  bool build() => true;

  void updateStatus(bool isAllow) {
    state = isAllow;
  }
}

@riverpod
class AttachFile extends _$AttachFile {
  ///
  /// Attach File Display（Image\File\Audio）
  ///
  @override
  List<FileInfo> build() => [];

  void addFile(FileInfo? file) {
    if (file == null) return;
    state = [...state, file];
  }

  void deleteFile(FileInfo file) {
    final newState = List<FileInfo>.from(state);
    newState.remove(file);
    state = newState;
  }

  void clearFile() {
    final newState = List<FileInfo>.from(state);
    newState.clear();
    state = newState;
  }
}

@riverpod
class AllowRecord extends _$AllowRecord {
  ///
  /// Audio Record State Switch
  ///
  @override
  bool build() => false;

  void updateStatus(bool isAllow) {
    state = isAllow;
  }
}

@riverpod
class ChatConversations extends _$ChatConversations {
  ///
  /// Conversation List , Like Select\Insert\Update\Delete
  ///
  @override
  (int, String, List<ChatConversationInfo>?) build() =>
      (StatusProvider.stateDefault, '', null);

  void selectConversationList() async {
    var result = await ref
        .read(chatRepositoryProvider.notifier)
        .selectConversationList();
    Logger().d("selectConversationList - $result");
    state = (result.code, result.msg, result.data ?? <ChatConversationInfo>[]);
  }

  Future<int> insertConversation(Map<String, dynamic> params) async {
    var result = await ref
        .read(chatRepositoryProvider.notifier)
        .insertConversation(params);
    state = (result.code, result.msg, state.$3);
    if (result.code == 0) {
      selectConversationList();
      return result.data;
    }
    return result.code;
  }

  void updateConversation(Map<String, dynamic> params) async {
    var result = await ref
        .read(chatRepositoryProvider.notifier)
        .updateConversation(params);
    state = (result.code, result.msg, state.$3);
    selectConversationList();
  }

  void updateSubTitle(String subTitle, int selectedId) async {
    Logger().d("当前Message - $subTitle, , $selectedId");
    var list = List<ChatConversationInfo>.from(state.$3!);
    for (var element in list) {
      if (element.id == selectedId) {
        var length = subTitle.length < 36 ? subTitle.length : 36;
        element.subTitle = subTitle.substring(0, length);
      }
    }
    state = (0, "success", list);
  }

  void deleteConversation(Map<String, dynamic> params) async {
    var result = await ref
        .read(chatRepositoryProvider.notifier)
        .deleteConversation(params);
    state = (result.code, result.msg, state.$3);
    selectConversationList();
  }
}

@riverpod
class ChatMessages extends _$ChatMessages {
  ///
  /// Message List , Like Select\Insert\Update\Delete
  ///
  @override
  (int, String, List<ChatMessageInfo>?) build() =>
      (StatusProvider.stateDefault, '', null);

  void selectMessageList(BaseResult<List<ChatMessageInfo>> result) async {
    state = (result.code, result.msg, result.data ?? <ChatMessageInfo>[]);
  }

  void insertMessageList(BaseResult<List<ChatMessageInfo>> result) async {
    (int, String, List<ChatMessageInfo>?) data =
        (state.$1, state.$2, state.$3 ?? <ChatMessageInfo>[]);
    data.$3?.addAll(result.data ?? <ChatMessageInfo>[]);
    state = data;
  }
}

@riverpod
class SendContent extends _$SendContent {
  ///
  /// Audio Record State Switch
  ///
  @override
  double build() => 0;

  void updateStatus(double value) {
    state = value;
  }
}

@riverpod
class ConversationSelected extends _$ConversationSelected {
  ///
  /// Conversation Selected Status
  ///
  @override
  (int conversationId, bool showInput, String rolePlay) build() =>
      (0, false, "");

  void updateStatus((int, bool, String) params) {
    state = params;
  }
}

@riverpod
class SettingMultiModal extends _$SettingMultiModal {
  ///
  /// Multi-Modal-Config state switch
  ///
  @override
  int build() {
    final configValue = SpProvider().getInt(configKey);
    return configValue;
  }

  String get configKey => "multi-modal-config";

  bool isAudio(int value) => [6, 7].contains(value);

  bool isFile(int value) => [3, 4, 5].contains(value);

  bool isImage(int value) => [1, 2].contains(value);

  (bool, bool, int) checkImage(int value) {
    var isContain = isImage(value);
    var isUpload = value == 2;
    return (isContain, isUpload, 2);
  }

  (bool, int) checkFile(int value) {
    var isContain = isFile(value);
    return (isContain, 3);
  }

  (bool, bool, int) checkAudio(int value) {
    var isContain = isAudio(value);
    var isUpload = value == 6;
    return (isContain, isUpload, 6);
  }

  void updateStatus(int configValue) async {
    await ref
        .read(chatRepositoryProvider.notifier)
        .cacheMultiModalConfig(configKey, configValue);
    state = configValue;
  }

  int getMultiModalConfig() {
    return ref
        .read(chatRepositoryProvider.notifier)
        .getMultiModalConfig(configKey);
  }
}

@Riverpod(keepAlive: true)
class PromptTemplate extends _$PromptTemplate {
  ///
  /// Message List , Like Select\Insert\Update\Delete
  ///
  @override
  (int, String, Map<String, String>) build() =>
      (StatusProvider.stateDefault, '', {});

  void selectMessageList() async {
    if (state.$3.isNotEmpty) {
      state = (state.$1, state.$2, state.$3);
      return;
    }
    var result =
        await ref.read(chatRepositoryProvider.notifier).selectPromptTemplate();
    state = (result.code, result.msg, result.data ?? {});
  }
}
