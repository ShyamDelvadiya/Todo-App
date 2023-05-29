import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/Postmodel.dart';
import 'add_todo.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  void initState() {
    GetData();

    super.initState();
  }

  List items = [];
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
         await Navigator.push(
              context, MaterialPageRoute(builder: (context) => add_todo()));
         setState(() {
           _isLoading =true;
         });

         GetData();

        },
        label: Text(
          "Add",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Visibility(
        visible: _isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: GetData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("Todo List is empty",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
            child: ListView.builder(
              padding: EdgeInsets.all(10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    
                    child: ListTile(
                      
                      trailing: PopupMenuButton(
                        onSelected: (value) async{
                          if (value == 'edit') {
                           await  Navigator.push(context, MaterialPageRoute(builder: (context)=>add_todo(item:item)));
                            setState(() {
                              _isLoading =true;
                            });
                            GetData();
                          }
                          else if (value == 'delete') {

                            deleteById(id);

                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(value: 'edit', child: Text("Edit")),
                            PopupMenuItem(value: 'delete', child: Text("Delete"))
                          ];
                        },
                      ),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.black,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<void> GetData() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> deleteById(String id) async{
  //  for deleting from server
    final url='https://api.nstack.in/v1/todos/$id';
    final uri= Uri.parse(url);
    final respone = await http.delete(uri);
    if(respone.statusCode==200){
      final filtered= items.where((element) => element['_id'] !=id).toList();
      setState(() {
        items=filtered;
      });

    }

  }
}
