import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../functions.dart';

class RequestedBookScreen extends StatefulWidget {
String? userId;

RequestedBookScreen(this.userId);

  @override
  State<RequestedBookScreen> createState() => _RequestedBookScreenState();
}

class _RequestedBookScreenState extends State<RequestedBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requested Book"),
        centerTitle: true,
      ),
        body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: FirebaseOperation().fetchUserRequestedBooksWhere(widget.userId),
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
                      child: Text("Requested"),
                    ),
                    leading: IconButton(onPressed: () async {
                    },icon: Icon(Icons.circle,color: Colors.red,)),
                    // Add additional widgets or cus{}tomize the ListTile as needed
                  );
                },
              );
            }
          },
        )    );
  }
}