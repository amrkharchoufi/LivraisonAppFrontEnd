import 'package:flutter/material.dart';

class Loginn extends StatefulWidget {
  const Loginn({super.key});

  @override
  State<Loginn> createState() => _LoginnState();
}

class _LoginnState extends State<Loginn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset("asset/images/circlered.png"))),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: 250,
                        height: 250,
                        child: Image.asset("asset/images/foodiebig.png")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Already Account | Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    PhysicalModel(
                      color: Colors.transparent,
                      elevation: 7,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
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
                    SizedBox(
                      height: 45,
                    ),
                    PhysicalModel(
                      color: Colors.transparent,
                      elevation: 7,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
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
                    SizedBox(
                      height: 45,
                    ),
                    PhysicalModel(
                      color: Colors.transparent,
                      elevation: 7,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Color.fromARGB(255, 220, 33, 78))),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
