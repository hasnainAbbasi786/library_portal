import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_portal/screens/registration/login.dart';
import 'package:library_portal/screens/student/my_books_screen.dart';
import 'package:library_portal/screens/student/requested_book_screen.dart';

import '../../models/books_model.dart';
import '../../models/library_model.dart';
import '../admin/edit_book_screen.dart';
import '../functions.dart';

class HomeScreen extends StatefulWidget {
String? userId;
String? userEmail;

HomeScreen(this.userId,this.userEmail);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.userId??""),
              accountEmail: Text(widget.userEmail??""),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book_sharp), title: Text("My Books"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBooksScreen(widget.userId)));
              },
            ),
            ListTile(
              leading: Icon(Icons.request_page), title: Text("Requested Books"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestedBookScreen(widget.userId)));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout), title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
            ),
          ],
        ),
      ),
        body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: FirebaseOperation().fetchAvailableBooksWhere(),
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
                      onPressed: () async {
                        setState(() {

                        });
                       await FirebaseOperation.updateBook(bookName: bookData['book name'], authorName: bookData['author name'], description: bookData['description'], isAvailable: bookData['isAvailable'], docId: snapshot.data?[index].id??"",studentName: widget.userEmail,isRequested: true,allocateTo: widget.userId);

                      },
                      child: Text("Request To Get"),
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