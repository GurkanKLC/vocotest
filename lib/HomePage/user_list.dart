import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controller/providers.dart';

class ListUsers extends ConsumerStatefulWidget {
  const ListUsers({super.key});

  @override
  ConsumerState<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends ConsumerState<ListUsers> {
  @override
  Widget build(BuildContext context) {
   return PopScope(
     canPop: true,
     onPopInvoked: (bool didPop) {
       if (didPop) {
         ref.watch(userListStateProvider.notifier).remove();
         return;
       }


     },
     child: Scaffold(
       appBar: AppBar(
     title: const Text('Katılımcılar Listesi'),
      backgroundColor: Colors.teal,
      elevation: 0.0,

      centerTitle: true,

      ),
       body:Container(
         decoration: const BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topRight,
             end: Alignment.bottomLeft,
             colors: [
               Color.fromARGB(255, 15, 32, 39),
               Color.fromARGB(255, 32, 58, 67),
             ],
           ),
         ),
         child: ref.watch(userListFutureProvider).when(data:(data){
           return ListView.builder(itemBuilder:((context,index){
             if(index!=ref.watch(userListStateProvider).data!.length){
               return Card(
                 margin: const EdgeInsets.all(5),
                 child: ListTile(
                   title: Text("${ref.watch(userListStateProvider).data![index].firstName} ${ref.watch(userListStateProvider).data![index].lastName}"),
                   subtitle: Text(ref.watch(userListStateProvider).data![index].email.toString()),
                   leading: ClipOval(
                     child: SizedBox(
                       width: 50,
                       height: 50,
                       child: Image.network(ref.watch(userListStateProvider).data![index].avatar.toString(),
                         loadingBuilder: (BuildContext context, Widget child,
                             ImageChunkEvent? loadingProgress) {
                           if (loadingProgress == null) return child;
                           return Center(
                             child: CircularProgressIndicator(
                               color: Colors.teal,
                               value: loadingProgress.expectedTotalBytes != null
                                   ? loadingProgress.cumulativeBytesLoaded /
                                   loadingProgress.expectedTotalBytes!
                                   : null,
                             ),
                           );
                         },
                       ),
                     ),
                   ),
                 ),);
             }else{
               if(ref.watch(userListStateProvider).page<ref.watch(userListStateProvider).totalPages) {
                 return Center(child: IconButton(
                 onPressed: (){

                   ref.watch(userListPageNumberChangeNotifier.notifier).increment();
                   ref.invalidate(userListFutureProvider);
                 },
                 icon: const Icon(Icons.add,size: 36,color: Colors.white,),
               ),
               );
               }
             }
             return null;
           }),itemCount: ref.watch(userListStateProvider).data!.length+1,);
         }, error:(err,stc){
           return const Center(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Opss..."),
                 Text("Bir sorun ile karışlaştık"),
               ],
             ),
           );
         }, loading:(){
           return const Center(child: CircularProgressIndicator());
         }),
       ),
     ),
   );
  }
}
