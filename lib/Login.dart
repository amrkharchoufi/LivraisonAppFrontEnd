import 'package:flutter/material.dart';
import 'package:foodie2/backend.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController passwd = TextEditingController();
  GlobalKey<FormState> mykey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final String data = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Form(
          key: mykey,
          child: Column(
            children: [
              Image.asset("asset/foodielogo.png"),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: double.infinity,
                child: const Text(
                  "Hello,\nWelcome Back !",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  height: 80,
                  child: TextFormField(
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*E-mail Required';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 56, 54, 54),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                        size: 30,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      hintText: "E-mail",
                      hintStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontSize: 20),
                    ),
                    style: const TextStyle(color: Colors.white),
                  )),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: 80,
                  child: TextFormField(
                    controller: passwd,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*password Required';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 56, 54, 54),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 30,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontSize: 20),
                    ),
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (mykey.currentState!.validate()) {
                        setState(() {
                          login(context, email.text.trim(), passwd.text.trim(),
                              data);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 95, 53),
                      minimumSize: const Size.fromHeight(
                          50), // Match height with TextFormField
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(27), // Same border radius
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w900,
                          fontSize: 25),
                    ),
                  )),
              //sign-up
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: double.infinity, // Match width to the TextFormField
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(
                          50), // Match height with TextFormField
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(27), // Same border radius
                      ),
                    ),
                    child: const Text(
                      "Create account",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w900,
                          fontSize: 25),
                    ),
                  )),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
