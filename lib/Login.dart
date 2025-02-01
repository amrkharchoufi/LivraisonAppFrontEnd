import 'package:animate_do/animate_do.dart';
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
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: FadeInRight(
                  duration: Duration(milliseconds: 700),
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset("asset/images/circlered.png")),
                )),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: mykey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeInUp(
                          duration: Duration(milliseconds: 800),
                          child: SizedBox(
                              width: 250,
                              height: 250,
                              child: Image.asset("asset/images/foodiebig.png")),
                        ),
                        FadeInRight(
                          duration: Duration(milliseconds: 900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Doesn't Have Account |",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: "Poppin",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed("/Signup");
                                    },
                                    child: Text(
                                      " Sign Up",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 220, 33, 78),
                                          fontSize: 15,
                                          fontFamily: "Poppin",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FadeInRight(
                          duration: Duration(milliseconds: 1100),
                          child: PhysicalModel(
                            color: Colors.transparent,
                            elevation: 7,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*E-mail Required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none),
                                hintText: "E-mail",
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppin",
                                    fontSize: 17),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        FadeInRight(
                          duration: Duration(milliseconds: 1300),
                          child: PhysicalModel(
                            color: Colors.transparent,
                            elevation: 7,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(30),
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
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none),
                                hintText: "Password",
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppin",
                                    fontSize: 17),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        FadeInRight(
                          duration: Duration(milliseconds: 1500),
                          child: PhysicalModel(
                            color: Colors.transparent,
                            elevation: 7,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (mykey.currentState!.validate()) {
                                    setState(() {
                                      login(context, email.text.trim(),
                                          passwd.text.trim());
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        Color.fromARGB(255, 220, 33, 78))),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
