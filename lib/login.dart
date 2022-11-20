import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              onPressed: (() {
                
              }),
            ),
            TextButton(
              child: Text('I already have an account'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
