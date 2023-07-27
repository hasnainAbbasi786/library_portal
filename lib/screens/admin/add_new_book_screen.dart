import 'package:flutter/material.dart';
import 'package:library_portal/data/generic_response_model.dart';
import 'package:library_portal/screens/admin/booklist_screen.dart';
import 'package:library_portal/screens/functions.dart';

import '../../models/books_model.dart';

class AddNewBookScreen extends StatefulWidget {
  const AddNewBookScreen({Key? key}) : super(key: key);

  @override
  State<AddNewBookScreen> createState() => _AddNewBookScreenState();
}

class _AddNewBookScreenState extends State<AddNewBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAvailable = true;

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _validate() async {

    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text.trim();
      final String author = _authorController.text.trim();
      final String description = _descriptionController.text.trim();
      bool isAvailable = _isAvailable;

      if (title.isEmpty) {
        _showSnackBar(context, "Title is required");
      } else if (author.isEmpty) {
        _showSnackBar(context, "Author name is required");
      }
      else if (description.isEmpty) {
        _showSnackBar(context, "Description is required");
      }
      else {

        await FirebaseOperation.addBook(bookName: title, authorName: author, description: description, isAvailable: isAvailable,callBack: (Response response){
          if(response==200){
          _showSnackBar(context, response.message.toString());

          }else{
            _showSnackBar(context, response.message.toString());
          }
        }).whenComplete(() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BookListScreen()));
        }).catchError((e){
          _showSnackBar(context, e.message.toString());
        });
   
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Book',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const Text('Availability:'),
                    const SizedBox(width: 10.0),
                    Switch(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _validate();
                        },
                        child: const Text('Add Book'),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}






