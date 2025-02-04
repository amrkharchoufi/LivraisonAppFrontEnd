import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:foodie2/backend.dart';
import 'package:geolocator/geolocator.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    _verifyLocationAccess();
  }

  Future<void> _verifyLocationAccess() async {
    try {
      // Location access granted, you can use position if needed
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Required'),
          content:
              const Text('This app needs location access to function properly'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Geolocator.openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 220, 33, 78),
        body: Stack(
          children: [
            Positioned(
                right: 0,
                top: 0,
                child: FadeInRight(
                  duration: Duration(seconds: 1),
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset("asset/images/circle.png")),
                )),
            Positioned(
                left: 0,
                bottom: 0,
                child: FadeInLeft(
                  duration: Duration(milliseconds: 1200),
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset("asset/images/circleone.png")),
                )),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FadeInUp(
                    duration: Duration(milliseconds: 1600),
                    child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Image.asset("asset/images/flg.png")),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1900),
                    child: Text(
                      "ARE YOU\nHUNGRY ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Monsterrat"),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: GestureDetector(
                      onTap: () {
                        checklogin(context);
                      },
                      child: PhysicalModel(
                        color: Colors.transparent,
                        elevation: 10,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 220, 33, 78),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    "GET STARTED",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
