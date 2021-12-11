import 'package:construto/screens/home_screen.dart';
import 'package:construto/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';

class RegistrationScreen2 extends StatefulWidget {

  final String name;
  final String email;

  RegistrationScreen2(this.name, this.email);

  @override
  _RegistrationScreen2State createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {

  final _auth = FirebaseAuth.instance;
  late String password;
  late String cnfmPassword;

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
                Flexible(child: Image.asset('images/flame-1208.png')),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black54),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.password)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black54),
                  onChanged: (value) {
                    cnfmPassword = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Confirm password',
                      prefixIcon: const Icon(Icons.security)),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                MyButton(colour: kYellow, text: 'Register', onPress: () async{
                  if(password==cnfmPassword){
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: widget.email, password: password);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      }));
                    }
                    catch(e){
                      print(e);
                    }
                  }
                }),
                const SizedBox(
                  height: 15.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.blue.shade900, size: 15,),
                    Text(
                      'Go back',
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 15.0
                      ),
                    )
                  ],
                ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
