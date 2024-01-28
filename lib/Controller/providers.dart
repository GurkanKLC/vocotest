import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocotest/Models/user.dart';
import 'user_controller.dart';

final emailControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final passwordControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController( ));
final emailRegisterControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final passwordRegisterControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final formGlobalKey = Provider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());
final formRegisterGlobalKey = Provider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());

final userListProvider = Provider<UserList>((ref) => UserList());

final userListPageNumberChangeNotifier = StateNotifierProvider.autoDispose<UserListPageNumberStateNotifier, int>((ref) {
  return UserListPageNumberStateNotifier(1);
});
final userLoginCheck = FutureProvider.autoDispose<bool>((ref) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      ref.watch(userStateProvider.notifier).setUser(token: token, email: null);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
});

final userListFutureProvider = FutureProvider.autoDispose<UserList>((ref) async {
  UserList data = await UserList().getApi<UserList>(endpoint: UserList().userEndpoint, params: {"page": ref.watch(userListPageNumberChangeNotifier)}, fromJson: (json) => UserList.fromJson(json)).then((value) {
    ref.watch(userListStateProvider.notifier).addElement(value);
    return value;
  });
  return data;
});

final userStateProvider = StateNotifierProvider.autoDispose<UserState, User>((ref) {
  return UserState(User());
});
final userListStateProvider = StateNotifierProvider<UserListState, UserList>((ref) {
  return UserListState(UserList(
    data: [],
    page: 0,
    perPage: 0,
    support: Support(),
    total: 0,
    totalPages: 0,
  ));
});
