import 'package:construto/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';
import 'package:construto/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  const AssetImage('images/urban-skyscrapers-background.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      child: Image.asset('images/looney-sign-up-form.png')),
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
                    onChanged: (value) {
                      email = value;
                    },
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
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.password)),
                  ),
                  MyButton(
                      colour: kYellow,
                      text: 'Login',
                      onPress: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MyHomePage();
                          }));
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      }),
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
      ),
    );
  }
}
