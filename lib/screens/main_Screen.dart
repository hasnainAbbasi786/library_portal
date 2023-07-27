import 'package:flutter/material.dart';
import 'package:library_portal/screens/admin/add_new_book_screen.dart';
import 'package:library_portal/screens/registration/login.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Portal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/library_logo.png",height: height*0.2),
            SizedBox(
              height: height*0.08,
            ),
            const Text(
              'Welcome to the Library Portal!',
              style: TextStyle(fontSize: 24.0,
              fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  LoginScreen(),
                  ),
                );
              },
              child: const Text('Student'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewBookScreen(),
                  ),
                );
              },
              child: const Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
