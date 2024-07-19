import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player/pages/home.dart';
import 'package:youtube_player/pages/RegisterScreen.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool passwordVisible = false;

  void login() async {
    String email = _email.text.trim();
    String password = _password.text.trim();

    if (email == "" || password == "") {
      const snackbar = SnackBar(content: Text("Please fill all the details"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          const snackbar = SnackBar(
            content: Text("Login successfully!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } on FirebaseAuthException catch (ex) {
        final snackbar = SnackBar(
          content: Text(ex.code.toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 143, 108),
        title: Text(
          "Login",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: 400,
              child: Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.email),
                      // suffixIcon: Icon(Icons.remove_red_eye_rounded),
                      hintText: "Enter your email address",
                      filled: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        alignLabelWithHint: false,
                        filled: true,
                        hintText: "Enter your password"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text("Login")),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Registerscreen()));
              },
              child: Text("Create an account"),
            )
          ],
        ),
      ),
    );
  }
}
