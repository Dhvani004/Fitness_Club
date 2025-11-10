import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_club_app/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';
import 'signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Club App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const Home();
    } else {
      return const LoginPage();
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Drawing App')),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.dumbbell,
                  color: Colors.black,
                  size: 40,
                ),
                SizedBox(height: 30),
                Text(
                  "FITNESS CLUB",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 100),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 60),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text("SIGN IN"),
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    child: Text("SIGN UP"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
