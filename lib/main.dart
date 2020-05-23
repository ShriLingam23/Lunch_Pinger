//This is the entry point of the the Lunch ping application
//So Here I have designed a Landing page using simple_animations library

import 'package:flutter/material.dart';

import './Animations/FadeAnimation.dart';
import './Pages/LoginPage.dart';

// Here we are calling HomePage stateful widget using runApp(), which is the entry point
void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage()
    )
);

//HomePage statefulwidget that overrides createState
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//State of the HomePage Stateful widget
class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  //List of state we maintain
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  bool hideIcon = false;

  //This method is called when State is initiated
  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    );

    _scaleAnimation = Tween<double>(
        begin: 1.0, end: 0.8
    ).animate(_scaleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _widthController.forward();
      }
    });

    _widthController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600)
    );

    _widthAnimation = Tween<double>(
        begin: 80.0,
        end: 300.0
    ).animate(_widthController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _positionController.forward();
      }
    });

    _positionController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );

    _positionAnimation = Tween<double>(
        begin: 0.0,
        end: 215.0
    ).animate(_positionController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          hideIcon = true;
        });
        _scale2Controller.forward();
      }
    });

    _scale2Controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    );

    _scale2Animation = Tween<double>(
        begin: 1.0,
        end: 32.0
    ).animate(_scale2Controller)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginPage()));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context){
              return LoginPage();
            }
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.orange, Colors.blue.shade100])),
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -50,
              left: 0,
              child: FadeAnimation(1, Container(
                width: width,
                height: 730,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/one.png'),
                        fit: BoxFit.cover
                    )
                ),
              )),
            ),
            Positioned(
              top: -150,
              left: 0,
              child: FadeAnimation(1.3, Container(
                width: width,
                height: 600,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/one.png'),
                        fit: BoxFit.cover
                    )
                ),
              )),
            ),
            Positioned(
              top: -200,
              left: 0,
              child: FadeAnimation(1.6, Container(
                width: width,
                height: 600,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/one.png'),
                        fit: BoxFit.cover
                    )
                ),
              )),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height-5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Welcome to",
                    style: TextStyle(fontFamily: "Montserrat",color: Colors.white, fontSize: 30),)),
                  SizedBox(height: 10,),
                  FadeAnimation(1.5, Text("Lunch Pinger",
                    style: TextStyle(fontFamily: "Montserrat",color: Colors.deepOrange.shade50, fontSize: 45),)),
                  SizedBox(height: 160,),
                  FadeAnimation(1.3, Text("We make sure you enjoy \nfuss-free time with your liked.",
                    style: TextStyle(color: Colors.white.withOpacity(.7), height: 1.4, fontSize: 20),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.6, AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) => Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _widthController,
                            builder: (context, child) => Container(
                              width: _widthAnimation.value,
                              height: 80,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue.shade50.withOpacity(.4)
                              ),
                              child: InkWell(
                                onTap: () {
                                  _scaleController.forward();
                                },
                                child: Stack(
                                    children: <Widget> [
                                      AnimatedBuilder(
                                        animation: _positionController,
                                        builder: (context, child) => Positioned(
                                          left: _positionAnimation.value,
                                          child: AnimatedBuilder(
                                            animation: _scale2Controller,
                                            builder: (context, child) => Transform.scale(
                                                scale: _scale2Animation.value,
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.orangeAccent.shade200
                                                  ),
                                                  child: hideIcon == false ? Icon(Icons.arrow_forward, color: Colors.white,) : Container(),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        )),
                  )),
                  SizedBox(height: 60,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
