import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_portal/screens/functions.dart';
import '../../data/generic_response_model.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void initState() {
    _emailController.text = "";
    _passwordController.text = "";
    super.initState();
  }

  bool showProgress = false;

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _validate() {
    setState(() {
      showProgress = false;
    });
    showProgress = false;
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      if (email.isEmpty) {
        _showSnackBar(context, "Email is required");
      } else if (password.isEmpty) {
        _showSnackBar(context, "Password is required");
      } else {
//Register with email and password
        _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((user) {
          //Add user Detail into collection in order to manage student and admin role
          FirebaseOperation.addUser(
              isAdmin: false,
              callBack: (Response response) {
                if (response.code == 200) {
                  _showSnackBar(context, response.message.toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                } else {
                  _showSnackBar(context, response.message.toString());
                }
              },
              uid: user.user?.uid);
        }).catchError((error) {
          _showSnackBar(context, error.message);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/library_logo.png",
                      height: height * 0.2),
                  TextFormField(
                    controller: _emailController,
                    // validator: _validateEmail,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    // validator: _validatePassword,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  showProgress
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            _validate();
                          },
                          child: const Text('Register'),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
