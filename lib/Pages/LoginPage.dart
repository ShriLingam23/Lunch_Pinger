//Login Page that allow user to log into application using Googke Auth

import 'package:flutter_google_auth/Pages/GroupMenu.dart';

import '../Animations/FadeAnimation.dart';
import 'package:flutter/material.dart';
import '../GoogleSignIn.dart';

//Define LoginPage Stateful widget definition
class LoginPage extends StatelessWidget {

  //Override build method which includes Login page design
  // Includes one button that is used as the main interaction point to login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(1, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.5, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(bottom: 50),
                          child: Center(
                            child: Text("Login", style: TextStyle(fontFamily: "Montserrat",color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),
                      ),
                      Positioned.fill(
                        top: 180,
                        left: -100,
                        child: FadeAnimation(1.5, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/office_2.png')
                              )
                          ),
                        )),
                      ),

                    ],
                    overflow: Overflow.visible,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      FadeAnimation(2, Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.blue,
                                ]
                            )
                        ),
                        child: Center(
                          child: _signInButton(context),
                        ),
                      )),
                      SizedBox(height: 25,),
                      FadeAnimation(1.5, Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Product of CTSE 2020, SLIIT", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1))),
                          Icon(Icons.copyright,color: Colors.red,)
                        ],
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  //definition for Login button that calls the Firebase auth and Google auth to retrieve user details
  // Finally redirect to the Menu page
  Widget _signInButton(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(
          style: BorderStyle.none
      ),
      onPressed: () {
        signInWithGoogle().then((res) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return GroupMenu(user:res);
              },
            ),
          );
        });
      },
      highlightElevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 40.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}