
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class GitRepositories extends StatefulWidget {
  String? login;
  String? avatarUrl;
  GitRepositories({this.login, this.avatarUrl});

  @override
  State<GitRepositories> createState() => _GitRepositoriesState();
}

class _GitRepositoriesState extends State<GitRepositories> {
  dynamic dataRepo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   loadRepositories();
  }
  void loadRepositories()async{
    String url="https://api.github.com/users/${widget.login}/repos";
    http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      setState(() {
        dataRepo=json.decode(response.body);
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Repositories ${widget.login}"),
        actions: [CircleAvatar(
          backgroundImage: NetworkImage(widget.avatarUrl ?? "")),

        ],
      ),
      body: Center(
        child: ListView.separated(
            itemBuilder:(context, index) => ListTile(
              title: Text("${dataRepo[index]['name']}"),
            ),
            separatorBuilder: (context,index)=>Divider(
              height: 2,color: Colors.deepOrange,
            ),
            itemCount: dataRepo==null?0:dataRepo.length)
      ),
    );
  }
}