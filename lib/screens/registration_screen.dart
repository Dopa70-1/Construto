import 'package:construto/screens/registration_screen2.dart';
import 'package:construto/widgets/my_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  late String name;
  late String email;

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
                  style: const TextStyle(color: Colors.black54),
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.edit)),
                ),
                const SizedBox(
                  height: 20.0,
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
                  height: 30.0,
                ),
                MyButton(colour: kYellow, text: 'Next', onPress: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RegistrationScreen2(name, email);
                  }));
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
