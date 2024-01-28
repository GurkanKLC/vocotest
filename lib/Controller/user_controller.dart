import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/api_return_value.dart';
import 'providers.dart';
import '../Models/user.dart';

class UserState extends StateNotifier<User> {
  UserState(super.state);
  void setUser({required String token, required String? email}) {
    state.token = token;
    UserData userData = UserData(email: email, avatar: null, firstName: null, id: null, lastName: null);
    state.userData = userData;
  }

  Future<ApiReturnValue> loginUser(dynamic ref) async {
    return await User().apiPost(selectedApi: User().login, params: {"email": ref.watch(emailControllerProvider).text.toString(), "password": ref.watch(passwordControllerProvider).text.toString()}).then((value) async {
      if (value.dataStatus == true) {
        setUser(token: value.data!['token']!.toString(), email: ref.watch(emailControllerProvider).text);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', value.data!['token']!.toString());
        return ApiReturnValue(dataStatus: true, data: null, statusMessage: "Giriş Başarılı", statusCode: value.statusCode);
      } else {
        return ApiReturnValue(dataStatus: false, data: null, statusMessage: "Giriş başarısız", statusCode: value.statusCode);
      }
    });
  }
  Future<ApiReturnValue> registerUser(dynamic ref) async {
    return await User().apiPost(selectedApi: User().register, params: {"email": ref.watch(emailControllerProvider).text.toString(), "password": ref.watch(passwordControllerProvider).text.toString()}).then((value) async {
      if (value.dataStatus == true) {
        setUser(token: value.data!['token']!.toString(), email: ref.watch(emailControllerProvider).text);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', value.data!['token']!.toString());
        return ApiReturnValue(dataStatus: true, data: null, statusMessage: "Giriş Başarılı", statusCode: value.statusCode);
      } else {
        return ApiReturnValue(dataStatus: false, data: null, statusMessage: "Giriş başarısız", statusCode: value.statusCode);
      }
    });
  }
}

class UserListState extends StateNotifier<UserList> {
  UserListState(super.state);

  void addElement(UserList data) {
    if (state.data!.isEmpty) {
      state.page = data.page;
      state.data = data.data;
      state.total = data.total;
      state.totalPages = data.totalPages;
      state.perPage = data.perPage;
      state.support = data.support;
    } else {
      state.page = data.page;
      state.data!.addAll(data.data!);
    }
  }

  void remove() {
    state = UserList(
      data: [],
      page: 0,
      perPage: 0,
      support: Support(),
      total: 0,
      totalPages: 0,
    );
  }
}

class UserListPageNumberStateNotifier extends StateNotifier<int> {
  UserListPageNumberStateNotifier(super.state);

  void increment() {
    state = state + 1;
  }
}
