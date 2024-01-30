import 'dart:convert';

import 'package:frontend/pages/chat/model/chat_conversation_info.dart';
import 'package:frontend/service/http/http_provider.dart';
import 'package:frontend/service/model/base_result.dart';
import 'package:frontend/service/utils/api_provider.dart';
import 'package:frontend/service/utils/sp_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

@Riverpod(keepAlive: true)
class ChatRepository extends _$ChatRepository {
  // static final ChatRepository _singleton = ChatRepository._();
  //
  // static ChatRepository get instance => _singleton;
  //
  // ChatRepository._();

  ///
  /// Chat module repository methods
  ///
  /// [selectConversationList]
  /// [insertConversation]
  /// [updateConversation]
  /// [deleteConversation]
  /// [cacheMultiModalConfig]
  /// [getMultiModalConfig]
  ///

  @override
  void build() {}

  ///
  /// Get conversation list
  ///
  Future<BaseResult<List<ChatConversationInfo>>>
      selectConversationList() async {
    var uri = Uri.http(ApiProvider.backendUrl, 'api/llm/v1/conversation/list');
    try {
      final response = await ref.read(httpRequestProvider.notifier).get(uri);
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      var data = BaseResult<List<ChatConversationInfo>>.fromJson(
          json,
          (jsonData) => (jsonData as List<dynamic>)
              .map((item) => ChatConversationInfo.fromJson(item))
              .toList());
      return data;
    } catch (e) {
      return BaseResult(
          code: -1, msg: e.toString(), success: false, data: null);
    }
  }

  ///
  /// Add conversation Record[title.subTitle]
  ///
  Future<BaseResult> insertConversation(Map<String, dynamic> params) async {
    var uri = Uri.http(ApiProvider.backendUrl, 'api/llm/v1/conversation/add');
    try {
      final response =
          await ref.read(httpRequestProvider.notifier).post(uri, body: params);
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      var data = BaseResult.fromJson(json, (p0) => p0 as int?);
      return data;
    } catch (e) {
      return BaseResult(
          code: -1, msg: e.toString(), success: false, data: null);
    }
  }

  ///
  /// Update conversation Record[title.subTitle.id]
  ///
  Future<BaseResult> updateConversation(Map<String, dynamic> params) async {
    var uri =
        Uri.http(ApiProvider.backendUrl, 'api/llm/v1/conversation/update');
    try {
      final response =
          await ref.read(httpRequestProvider.notifier).post(uri, body: params);
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      var data = BaseResult.fromJson(json, (p0) => null);
      return data;
    } catch (e) {
      return BaseResult(
          code: -1, msg: e.toString(), success: false, data: null);
    }
  }

  ///
  /// Delete conversation Record[id]
  ///
  Future<BaseResult> deleteConversation(Map<String, dynamic> params) async {
    var uri =
        Uri.http(ApiProvider.backendUrl, 'api/llm/v1/conversation/delete');
    try {
      final response =
          await ref.read(httpRequestProvider.notifier).post(uri, body: params);
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      var data = BaseResult.fromJson(json, (p0) => null);
      return data;
    } catch (e) {
      return BaseResult(
          code: -1, msg: e.toString(), success: false, data: null);
    }
  }

  ///
  /// Multi-Modal-Config
  ///
  Future<bool> cacheMultiModalConfig(String configKey, int configValue) async {
    return await SpProvider().setInt(configKey, configValue);
  }

  int getMultiModalConfig(String configKey) {
    return SpProvider().getInt(configKey);
  }

  ///
  /// Select prompt template（RolePlay keys）
  ///
  Future<BaseResult<Map<String, String>>> selectPromptTemplate() async {
    var uri = Uri.http(ApiProvider.backendUrl, 'api/llm/v1/prompt/template');
    try {
      final response = await ref.read(httpRequestProvider.notifier).get(uri);
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      var data = BaseResult<Map<String, String>>.fromJson(
          json, (p0) => Map<String, String>.from(p0));
      return data;
    } catch (e) {
      return BaseResult(
          code: -1, msg: e.toString(), success: false, data: null);
    }
  }
}
