import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_portal/screens/registration/login.dart';

import '../../models/books_model.dart';
import '../../models/library_model.dart';
import '../admin/edit_book_screen.dart';
import '../functions.dart';

class RequestBooksScreen extends StatefulWidget {


  @override
  State<RequestBooksScreen> createState() => _RequestBooksScreenState();
}

class _RequestBooksScreenState extends State<RequestBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requested Book"),
        centerTitle: true,
      ),
        body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: FirebaseOperation().fetchAllRequestedBooksWhere(),
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

                    title: Text(bookData['studentName']+"  Want ",style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    subtitle: Text(bookData['book name']+" by "+ bookData['author name']),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                           FirebaseOperation.updateBook(bookName: bookData["book name"], authorName: bookData["author name"], description: bookData["description"], isAvailable: false, docId: snapshot.data?[index].id??"", isRequested: false,studentName: bookData["studentName"],allocateTo: bookData["allocateTo"]);

                        });
                      },
                      child: Text("Accept"),
                    ),
                    leading: IconButton(onPressed: () async {
                      setState(() {
                        FirebaseOperation.updateBook(bookName: bookData["book name"], authorName: bookData["author name"], description: bookData["description"], isAvailable: true, docId: snapshot.data?[index].id??"", isRequested: false,);

                      });
                    },icon: Icon(Icons.close,color: Colors.red,)),
                    // Add additional widgets or cus{}tomize the ListTile as needed
                  );
                },
              );
            }
          },
        )    );
  }
}