///
/// Auth - Sign Info
///
class UserInfo {
  UserInfo(
      {this.id, this.email, this.isActive, this.createTime, this.updateTime});

  UserInfo.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    isActive = json['is_active'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  int? id;
  String? email;
  bool? isActive;
  String? createTime;
  String? updateTime;

  UserInfo copyWith(
          {int? id,
          String? email,
          bool? isActive,
          String? createTime,
          String? updateTime}) =>
      UserInfo(
        id: id ?? this.id,
        email: email ?? this.email,
        isActive: isActive ?? this.isActive,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['is_active'] = isActive;
    map['create_time'] = createTime;
    map['update_time'] = updateTime;
    return map;
  }
}
