import 'package:besafe/map.dart';
import 'package:besafe/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.transparent,

        body: Container(
      alignment: Alignment.center,
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/image.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(30.0),
          ),
          const Text(
            "BESAFE",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 100.0,
              fontFamily: "Oswald",
              fontWeight: FontWeight.w700,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(60.0),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 60.0, right: 20),
            child: Text(
              "We can safe your life",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 50.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 200.0, right: 100.0),
            // ignore: unnecessary_const
            child: ElevatedButton(
              child: Text('Get started'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapTask()),
                );
              },
              //s,
            ),
          )
        ],
      ),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
