import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_portal/screens/registration/login.dart';

import '../../models/books_model.dart';
import '../../models/library_model.dart';
import '../admin/edit_book_screen.dart';
import '../functions.dart';

class MyBooksScreen extends StatefulWidget {
String? userId;

MyBooksScreen(this.userId);

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requested Book"),
        centerTitle: true,
      ),
        body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: FirebaseOperation().fetchMyBooksWhere(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>>?
              availableBooks = snapshot.data;
              if (availableBooks == null || availableBooks.isEmpty) {
                return Center(
                  child: Text('No available books found.'),
                );
              }
              return ListView.builder(
                itemCount: availableBooks.length,
                itemBuilder: (context, index) {
                  // Extract data from the DocumentSnapshot
                  Map<String, dynamic> bookData = availableBooks[index].data();

                  return ListTile(
                    title: Text(bookData['book name']),
                    subtitle: Text(bookData['author name']),
                    trailing: ElevatedButton(
                      onPressed: null,
                      child: Text("Accepted"),
                    ),
                    leading: IconButton(onPressed: () async {
                    },icon: Icon(Icons.circle,color: Colors.green,)),
                    // Add additional widgets or cus{}tomize the ListTile as needed
                  );
                },
              );
            }
          },
        )    );
  }
}