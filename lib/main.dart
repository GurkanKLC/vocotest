
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocotest/HomePage/login_page.dart';
import 'package:vocotest/HomePage/user_list.dart';
import 'Controller/providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
  ErrorWidget.builder=(FlutterErrorDetails details){
    bool inDebug=false;
    assert((){
      inDebug=true;
      return true;
    }());
    if(inDebug){
      return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child:  Text(details.exception.toString(),style: const TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 20)),
      );
    }
    return Container(
      alignment: Alignment.center,
      child: const Text("Beklenmedik bir hata oluştu!",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 20)),
    );
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voco Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(

          labelStyle: TextStyle(
            color: Colors.white,
          ),
          errorStyle: TextStyle(
            color: Colors.red
          ),

          focusedBorder: UnderlineInputBorder(

            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Colors.white,
              width: 3
            ),
          ),
        ),

        useMaterial3: true,
      ),
      home: const SafeArea(child: MyHomePage()),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});


  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {

  @override
  Widget build(BuildContext context) {

  return ref.watch(userLoginCheck).when(
      data:((data){
        if(!data){
          return const LoginPage();
        }
        return const ListUsers();
      }),
      error:((err,stc){
        return Container();
      }),
      loading:()=>const CircularProgressIndicator()
  );

  }
}
