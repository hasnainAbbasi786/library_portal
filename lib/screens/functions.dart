import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/generic_response_model.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class FirebaseOperation {

  //function to add user detail into collection
  static Future<Response> addUser({
    required bool isAdmin,
     Function? callBack,
    String? uid,
  }) async {

    final CollectionReference _Collection = _firestore.collection('UserDetail');

    Response response = Response();
    DocumentReference documentReferencer =
    _Collection.doc(uid);

    Map<String, dynamic> userData = <String, dynamic>{

      "isAdmin" : isAdmin
    };

    var result = await documentReferencer
        .set(userData)
        .whenComplete(() {
      response.code = 200;
      response.message = "Register User Successfully";
      callBack!(response);
    })
        .catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  //Function to add book

  static Future<Response> addBook({
    required String bookName,
    required String authorName,
    required String description,
    required bool isAvailable,
    bool isRequested = false,
    String? allocateTo,
    String? studentName,
    Function? callBack,
  }) async {
    final CollectionReference _Collection = _firestore.collection('Book');
    Response response = Response();
    DocumentReference documentReferencer =
    _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "book name": bookName,
      "author name": authorName,
      "description" : description,
      "isAvailable" : isAvailable,
      "isRequested": isRequested,
      "allocateTo" : allocateTo,
      "studentName":studentName,
    };

    var result = await documentReferencer
        .set(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
      callBack!(response);
    })
        .catchError((e) {
      response.code = 500;
      response.message = e;
      callBack!(response);
    });


    return response;
  }

  //read all data where

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchAvailableBooksWhere() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Book')
        .where('isAvailable', isEqualTo: true).where("isRequested",isEqualTo: false)
        .get();

    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchUserRequestedBooksWhere(String? uid) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Book')
        .where("isRequested",isEqualTo: true).where("allocateTo",isEqualTo: uid)
        .get();

    return querySnapshot.docs;
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchAllRequestedBooksWhere() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Book')
        .where("isRequested",isEqualTo: true).where("isAvailable",isEqualTo: true)
        .get();

    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchMyBooksWhere(String? uid) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Book')
        .where("isRequested",isEqualTo: false).where("allocateTo",isEqualTo: uid)
        .get();

    return querySnapshot.docs;
  }
  //read all data
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchAllBooks() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Book')
        .get();

    return querySnapshot.docs;
  }

  //update

  static Future<Response> updateBook({
    required String bookName,
    required String authorName,
    required String description,
    required bool isAvailable,
    required String docId,
    required bool isRequested,
    String? allocateTo,
    String? studentName,
    Function? callBack,


  }) async {

print(docId);
    final CollectionReference _Collection = _firestore.collection('Book');
    Response response = Response();
    DocumentReference documentReferencer =
    _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "book name": bookName,
      "author name": authorName,
      "description" : description,
      "isAvailable" : isAvailable,
      "isRequested": isRequested,
      "allocateTo" : allocateTo,
      "studentName":studentName,

    };
    print(data);

    await documentReferencer
        .update(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Book";
      callBack!(response);
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
      callBack!(response);
    });

    return response;
  }

  static Future<Response> deleteBook({
    required String docId,
  }) async {
    final CollectionReference _Collection = _firestore.collection('Book');
    Response response = Response();
    DocumentReference documentReferencer =
    _Collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete((){
      response.code = 200;
      response.message = "Sucessfully Deleted Employee";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

}