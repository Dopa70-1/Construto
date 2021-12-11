import 'package:construto/screens/registration_screen.dart';
import 'package:construto/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:construto/constants.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('images/taxi-construction.png'),
            const Text(
              'Let\'s start!!',
              style: TextStyle(
                fontSize: 100.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyButton(colour: kYellow, text: 'Create an account', onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const RegistrationScreen();
              }));
            }),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Already have an account?",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                child: const Text(
                  'click here.',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12.0,
                  ),
                ),
              )
            ]),
            Expanded(child: Image.asset('images/macaroni-road.png')),
          ],
        ),
      ),
    );
  }
}
