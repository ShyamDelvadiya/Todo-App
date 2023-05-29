import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class add_todo extends StatefulWidget {
  final Map? item;

  add_todo({Key? key, this.item}) : super(key: key);

  @override
  State<add_todo> createState() => _add_todoState();
}

class _add_todoState extends State<add_todo> {
  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      _isEdit = true;
      final title = item['title'];
      final description = item['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? "Edit Todo" : "Add Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Title"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(hintText: "Decoration"),
                minLines: 5,
                maxLines: 8,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(19.0),
              child: ElevatedButton(
                  onPressed: _isEdit ? updatedata : submitdata,
                  child: Text(_isEdit ? "Update" : "Submit")),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updatedata() async {
    final item = widget.item;
    if (item == null) {
      print("you cannot call update method without data");
      return;
    }
    final id = item['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final Apibody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(Apibody),
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      titleController.clear();
      descriptionController.clear();
      print("Success");
      showSuccessMessage('Todo Updated');
    } else {
      print("Creation not added");
      showFailerMessage("Failed To Update todo");
    }
  }

  Future<void> submitdata() async {
    //get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final Apibody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    //  submit data to server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(Apibody),
        headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    print(response.body);

    //  show success or fail message
    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      print("Success");
      showSuccessMessage('Todo Added');
    } else {
      print("Creation not added");
      showFailerMessage("Failed To add todo");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailerMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
