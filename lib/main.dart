import 'dart:async';

import 'package:counsller_flutter_app/HelperFunctions/HelperFunctions.dart';
import 'package:counsller_flutter_app/screens/Dashboard/dashboard_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Sign_up/Login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcmToken $fcmToken');
  
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.dark // dark text for status bar
      ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Counsllor App'),
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
  bool? userIsLoggedIn;
  getLoggedInState() async {
    await HelperFunctions.getuserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () async {
      final pref = await SharedPreferences.getInstance();
      var user_id = pref.getString('user_id');
      print(user_id);
      if (user_id != null) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => dashboard_page(),
            ));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      }
      // var userID = await HelperFunctions.getuserID();
      // userID != null
      // ? userIsLoggedIn!
      // ignore: use_build_context_synchronously
      // ? Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => dashboard_page()))
      // // ignore: use_build_context_synchronously
      // : Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const LoginScreen()));
      // : Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const LoginScreen()));

      //   Navigator.push(
      // context, MaterialPageRoute(builder: (context) => Login_page()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("images/councellor.jpeg"),
                )),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Let's Discuss",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0096bb))),
                  TextSpan(
                    text: "  , Your Feelings",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffaa2516)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "With --",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0096bb))),
                  TextSpan(
                    text: " My CounSellor",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffaa2516)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
