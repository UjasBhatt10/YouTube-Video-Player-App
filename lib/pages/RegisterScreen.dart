import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player/pages/home.dart';
import 'package:youtube_player/pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conpassword = TextEditingController();
  bool passwordVisible = false;
  bool cpasswordVisible = false;
  void createAccount() async {
    String email = _email.text.trim();
    String password = _password.text.trim();
    String cpassword = _conpassword.text.trim();

    if (email == "" || password == "" || cpassword == "") {
      const snackbar = SnackBar(
        content: Text("Please fill all the details!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else if (password != cpassword) {
      const snackbar = SnackBar(
        content: Text("Passwords do not match!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          const snackbar = SnackBar(
            content: Text("Account created successfully!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
          "Register",
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
                      suffixIcon: Icon(Icons.remove_red_eye_rounded),
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
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _conpassword,
                    obscureText: !cpasswordVisible,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(cpasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                cpasswordVisible = !cpasswordVisible;
                              },
                            );
                          },
                        ),
                        alignLabelWithHint: false,
                        filled: true,
                        hintText: "Enter your confirm password"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  createAccount();
                },
                child: Text("Register")),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Loginscreen()));
              },
              child: Text("Already have an account"),
            )
          ],
        ),
      ),
    );
  }
}
