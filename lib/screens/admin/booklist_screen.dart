import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_portal/screens/admin/add_new_book_screen.dart';
import 'package:library_portal/screens/admin/edit_book_screen.dart';
import 'package:library_portal/screens/admin/request_book_screen.dart';
import 'package:library_portal/screens/functions.dart';
import 'package:library_portal/screens/registration/login.dart';

import '../../models/books_model.dart';

class BookListScreen extends StatefulWidget {


  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Panel'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNewBookScreen()));
                },
                icon: Icon(Icons.add_box))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Admin"),
                accountEmail: Text("admin@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Book Request"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestBooksScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: FirebaseOperation().fetchAllBooks(),
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
                    trailing: IconButton(onPressed: () async {
                      setState(() {
                         FirebaseOperation.deleteBook(docId: snapshot.data?[index].id??"");
                      });

                    },icon: Icon(Icons.delete,color: Colors.red,)),
                    leading: IconButton(onPressed: () async {
                    await  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditBookScreen(book: Book(
                        uid:snapshot.data?[index].id,
                        description: bookData['description'],
                        title: bookData['book name'],
                        author: bookData['author name'],
                        isAvailable: bookData['isAvailable'],
                      isRequested: bookData["isRequested"],
                      allocatedTo: bookData["allocatedTo"]??"",
                      studentName: bookData["studentName"]??""


                      ))));
                    },icon: Icon(Icons.edit)),
                    // Add additional widgets or cus{}tomize the ListTile as needed
                  );
                },
              );
            }
          },
        ));
  }
}
