
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:git_hub_mobile_app/pages/repositories/home.page.dart';
import 'package:http/http.dart' as http;
class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String? query;
  bool notVisible = false;
 TextEditingController queryTextEditingController = TextEditingController();
 dynamic data;
 int currentPage=0;
 int totalPages=0;
 int pageSize=20;
 List<dynamic> items=[];
 ScrollController scrollController =  new ScrollController();
  void _search(String? query) {
    var url="https://api.github.com/search/users?q=${query}&per_page=${pageSize}&page=${currentPage}";
    http.get(Uri.parse(url))
        .then((value){
          setState(() {
            this.data=jsonDecode(value.body);
            this.items.addAll(data['items']);
            if(data['total_count']%pageSize == 0) {
              totalPages = data['total_count']~/pageSize;
            }else{
              totalPages = (data['total_count']/pageSize).floor() +1;
            }
          });
    })
        .catchError((err){
      print(err);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        setState(() {
          if(currentPage<totalPages-1) {
            ++currentPage;
            _search(query);
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Users => ${query}=>$currentPage/ $totalPages"),
      ),
      body: Center(
          child: Column(
            children: [
             Row(
               children: [
                 Expanded(
                     child:Container(
                       padding: EdgeInsets.all(10),
                       child: TextFormField(
                         obscureText: notVisible,
                         onChanged: (v){
                           this.query=v;
                         },
                         controller: queryTextEditingController,
                         decoration: InputDecoration(
                             suffixIcon: IconButton(
                               onPressed: (){
                                 setState(() {
                                   notVisible=!notVisible;
                                 });
                               },
                             icon: Icon(
                                 notVisible == true ?Icons.visibility_off : Icons.visibility),
                             ),
                             contentPadding: EdgeInsets.only(left: 20),
                             border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(50),
                                 borderSide: const BorderSide(
                                     width: 1,color: Colors.deepOrange
                                 )
                             )
                         ),
                       ),
                     )
                 ),
                 IconButton(onPressed: ()async{

                   setState(() {
                     items=[];
                     currentPage=0;
                     this.query= queryTextEditingController.text;
                     _search(query);

                   });
                 }, icon: Icon(Icons.search, color: Colors.deepOrange,))
               ],
             ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(height: 2,color: Colors.deepOrange,),
                  controller: scrollController,
                  itemCount:items.length,
                itemBuilder: (context,index){
                    return ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context)=>GitRepositories(login: items[index]["login"],avatarUrl: items[index]["avatar_url"],)));
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(items[index]['avatar_url']),
                              radius: 40,
                            ),
                            SizedBox(width: 20,),
                            Text("${items[index]['login']}"),


                          ],
                        ),
                          CircleAvatar(
                            child:  Text("${items[index]['score']}") ,
                          )
                        ]
                      ),
                    );
                    }
                ),
              )
            ],
          )
      ),
    );
  }

  
}