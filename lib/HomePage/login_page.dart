
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndialog/ndialog.dart';
import 'package:vocotest/HomePage/user_list.dart';
import 'package:vocotest/Models/custom_regex.dart';

import '../Controller/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context,[bool mounted = true]) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voco Test'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 15, 32, 39),
                Color.fromARGB(255, 32, 58, 67),
              ],
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Giriş",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 48,color: Colors.grey)),
            const SizedBox(height: 30,),
             const LoginMaterials(isRegister: false,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                       NAlertDialog(
                        title: const Text("Üye Ol"),
                        blur: 20,
                        backgroundColor: Colors.transparent,
                        dialogStyle: DialogStyle(
                          backgroundColor: Colors.transparent,
                          titleDivider: true,
                          titleTextStyle: const TextStyle(color: Colors.white,fontSize: 24),
                        ),

                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LoginMaterials(isRegister: true),
                          ],
                        ),
                         actions: [
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                             ElevatedButton(
                               onPressed: () async {
                                Navigator.pop(context);
                               },
                               child: const Text('İptal'),
                             ),
                             ElevatedButton(
                               onPressed: () async {
                                 if (ref.watch(formRegisterGlobalKey).currentState!.validate()) {
                                   await ref.watch(userStateProvider.notifier).registerUser(ref).showProgressDialog(context, message: const Text("Lütfen bekleyiniz"), title: const Text("Giriş Yapılıyor"), dismissable: false).then((value) {
                                     if (value!.dataStatus == false) {
                                       if(value.statusCode==600){
                                         const NAlertDialog(
                                           title: Text("İnternet Bağtınızı Kontrol Ediniz"),
                                         ).show(context);
                                       }else{
                                         const NAlertDialog(
                                           title: Text("Üye Olma Başarısız"),
                                         ).show(context);
                                       }

                                     } else {
                                       const NAlertDialog(
                                         title: Text("Üye Olma Başarılı"),
                                       ).show(context);
                                     }
                                   });
                                 }
                               },
                               child: const Text('Üye Ol'),
                             ),
                           ],)
                         ],
                      ).show(context);
                    },
                    child: const Text('Üye Ol'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (ref.watch(formGlobalKey).currentState!.validate()) {
                        await ref.watch(userStateProvider.notifier).loginUser(ref).showProgressDialog(context, message: const Text("Lütfen bekleyiniz"), title: const Text("Giriş Yapılıyor"), dismissable: false).then((value) async {
                          if (value!.dataStatus == false) {
                            if(value.statusCode==600){
                              const NAlertDialog(
                                title: Text("İnternet Bağtınızı Kontrol Ediniz"),
                              ).show(context);
                            }else{
                              const NAlertDialog(
                                title: Text("Giriş Başarısız"),
                              ).show(context);
                            }

                          } else {
                            const NAlertDialog(
                              title: Text("Giriş Başarılı"),
                              dismissable: false,
                            ).show(context);
                            await Future.delayed(const Duration(seconds: 1));
                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  const ListUsers()),
                            );
                          }
                        });
                      }
                    },
                    child: const Text('Giriş'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginMaterials extends ConsumerWidget {
   const LoginMaterials({
    super.key,
    required this.isRegister
  });

 final bool? isRegister;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Align(
      alignment: Alignment.center,
      child: Form(
        key: isRegister==true?ref.watch(formRegisterGlobalKey):ref.watch(formGlobalKey),
        child: Container(
          width: MediaQuery.of(context).size.width * .9,
          height: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 15, 32, 39),
                  Color.fromARGB(255, 32, 58, 67),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.white.withOpacity(.5), offset: const Offset(0, 0),
                  blurStyle: BlurStyle.normal, blurRadius: 6)]
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: isRegister==true?ref.watch(emailRegisterControllerProvider):ref.watch(emailControllerProvider),
                  decoration: const InputDecoration(labelText: 'E-posta'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) => input!.isValidEmail(),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  controller: isRegister==true?ref.watch(passwordRegisterControllerProvider):ref.watch(passwordControllerProvider),
                  decoration: const InputDecoration(labelText: 'Şifre'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) => input!.isValidPassword(),
                ),
                const SizedBox(height: 16.0),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
