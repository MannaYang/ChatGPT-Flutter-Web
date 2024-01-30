///
/// Chat - MessageList
///
class ChatMessageInfo {
  ChatMessageInfo(
      {this.id,
      this.content,
      this.role,
      this.image,
      this.file,
      this.audio,
      this.createTime,
      this.updateTime});

  ChatMessageInfo.fromJson(dynamic json) {
    id = json['id'];
    content = json['content'];
    role = json['role'];
    image = json['image'];
    audio = json['audio'];
    file = json['file'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  int? id;
  String? content;
  String? role;
  String? image;
  String? audio;
  String? file;
  String? createTime;
  String? updateTime;

  ChatMessageInfo copyWith(
          {int? id,
          String? content,
          String? role,
          String? image,
          String? audio,
          String? file,
          String? createTime,
          String? updateTime}) =>
      ChatMessageInfo(
        id: id ?? this.id,
        content: content ?? this.content,
        role: role ?? this.role,
        image: image ?? this.image,
        audio: audio ?? this.audio,
        file: file ?? this.file,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['content'] = content;
    map['role'] = role;
    map['image'] = image;
    map['file'] = file;
    map['audio'] = audio;
    map['create_time'] = createTime;
    map['update_time'] = updateTime;
    return map;
  }
}
