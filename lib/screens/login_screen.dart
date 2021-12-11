import 'package:construto/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/urban-skyscrapers-background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(child: Image.asset('images/looney-sign-up-form.png')),
                Text(
                  'Login',
                  style: GoogleFonts.dancingScript(
                      textStyle: const TextStyle(
                          fontSize: 100.0, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black54),
                  onChanged: (value) {},
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  style: const TextStyle(color: Colors.black54),
                  obscureText: true,
                  onChanged: (value) {},
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.password)),
                ),
                MyButton(colour: kYellow, text: 'Login', onPress: (){}),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Go to Homepage. ",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 12.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
