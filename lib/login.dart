import 'package:besafe/main.dart';
import 'package:besafe/sigin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool isLoggingIn = false;

  _logInWithFacebook() async {
    setState(() {
      isLoggingIn = true;
    });

    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final facebookAuthCredentials = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredentials);
      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'imageUrl': userData['picture']['data']['url'],
        'name': userData['name']
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => MyHomePage(title: "dupa")), (route) => false);
    } on FirebaseAuthException catch (e) {
      var title = '';

      switch (e.code) {
        case 'account-exists-with-different-credentials':
          title = 'This accoutn exists with a different sign in provider';
          break;
        case 'invalid-credentials':
          title = 'Unknown error has occured';
          break;
        case 'operation-not-allowed':
          title = 'This operation is not allowed';
          break;
        case 'user-disabled':
          title = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          title = 'The user you tried to log into was not found';
          break;
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Log in with facebook failed'),
            content: Text(title),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          ));
    } finally {
      setState(() {
        isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(50.0),
            ),
            const Text(
              "Log in to\n Account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50.0,
                fontFamily: "Oswald",
                fontWeight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(100.0),
            ),
            //username textfield
            SizedBox(
              width: 300,
              height: 70,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Username',
                ),
                obscureText: false,
                showCursor: false,
              ),
            ),
            //password textbox
            SizedBox(
              width: 300,
              height: 70,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Password',
                ),
                obscureText: true,
                showCursor: false,
              ),
            ),
            //signin button #00565Bcolor
            //Color.fromRGBO(0, 86, 91,1)
            SizedBox(
              width: 200,
              height:40,
              child:ElevatedButton(
                onPressed: null,
                child: Text('Log in'),
                style: ElevatedButton.styleFrom( 
                    backgroundColor: Color.fromRGBO(0, 86, 91, 1), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
              ),           
            ),
            
            
            FacebookAuthButton(
              onPressed: _logInWithFacebook
            ),
            TextButton(
              child: Text("I dont have account"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
