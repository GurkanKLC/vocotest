import 'package:vocotest/Controller/api_controller.dart';
import 'package:vocotest/Models/urls.dart';

class User extends ApiProcessFunctions with UserUrl {
  UserData? userData;
  String? token;
  Support? support;

  User({this.userData, this.token, this.support});
  User.fromJson(Map<String, dynamic> json) {
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
    token = json['token'];
    support = json['support'] != null ? Support.fromJson(json['support']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    data['token'] = token;
    if (support != null) {
      data['support'] = support!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'User{userData: $userData, token: $token, support: $support}';
  }
}

class UserData {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  UserData({this.id, this.email, this.firstName, this.lastName, this.avatar});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['avatar'] = avatar;
    return data;
  }

  @override
  String toString() {
    return 'UserData{id: $id, email: $email, firstName: $firstName, lastName: $lastName, avatar: $avatar}';
  }
}

class Support {
  String? url;
  String? text;

  @override
  String toString() {
    return 'Support{url: $url, text: $text}';
  }

  Support({this.url, this.text});

  Support.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['text'] = text;
    return data;
  }
}

class UserList extends ApiProcessFunctions with UserUrl {
  int page = 0;
  int perPage = 0;
  int total = 0;
  int totalPages = 0;
  List<UserData>? data;
  Support? support;

  UserList({this.page = 0, this.perPage = 0, this.total = 0, this.totalPages = 0, this.data, this.support});

  UserList.fromJson(Map<String, dynamic> json) {
    page = json['page'] ?? 0;
    perPage = json['per_page'] ?? 0;
    total = json['total'] ?? 0;
    totalPages = json['total_pages'] ?? 0;
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    support = json['support'] != null ? Support.fromJson(json['support']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['per_page'] = perPage;
    data['total'] = total;
    data['total_pages'] = totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (support != null) {
      data['support'] = support!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'UserList{page: $page, perPage: $perPage, total: $total, totalPages: $totalPages, data: $data, support: $support}';
  }
}
