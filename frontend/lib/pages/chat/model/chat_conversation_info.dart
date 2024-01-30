///
/// Chat - ConversationList
///
class ChatConversationInfo {
  ChatConversationInfo({this.id, this.title, this.subTitle, this.rolePlay});

  ChatConversationInfo.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    rolePlay = json['role_play'];
  }

  int? id;
  String? title;
  String? subTitle;
  String? rolePlay;

  ChatConversationInfo copyWith(
          {int? id, String? title, String? subTitle, String? rolePlay}) =>
      ChatConversationInfo(
        id: id ?? this.id,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        rolePlay: rolePlay ?? this.rolePlay,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['sub_title'] = subTitle;
    map['role_play'] = rolePlay;
    return map;
  }
}
