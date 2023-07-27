class Book {
  String? uid;
  final String title;
  final String author;
  final String description;
  final bool isAvailable;
  final bool isRequested;
  final String allocatedTo;
  final String studentName;


  Book({
     this.uid,
    required this.title,
    required this.author,
    required this.description,
    required this.isAvailable,
    required this.isRequested,
    required this.allocatedTo,
    required this.studentName,
  });
}