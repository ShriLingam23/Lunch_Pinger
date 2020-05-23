//Main menu page of the Application
//Which displays the User logged in information with list of Groups

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sweetalert/sweetalert.dart';

import '../main.dart';
import '../GoogleSignIn.dart';
import 'Group/GroupListPage.dart';

//GroupMenu Statefulwidget definition
class GroupMenu extends StatefulWidget {

  //Firebase Auth user instance that is passed from Google Firebase Authentication
  final FirebaseUser user;
  GroupMenu({Key key, @required this.user}) : super(key: key);

  //Define State for the GroupMenu Stateful widget
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//Define State class for the roupMenu Stateful widget
class _MyHomePageState extends State<GroupMenu>
    with SingleTickerProviderStateMixin {

  //Tab controller instance used to swipe between all group list and favourite group list
  TabController tabController;

  final tween = MultiTrackTween([
    Track("color1").add(Duration(seconds: 3),
        ColorTween(begin: Colors.red.shade50, end: Colors.grey.shade50)),
    Track("color2").add(Duration(seconds: 2),
        ColorTween(begin: Colors.blue.shade100, end: Colors.yellow.shade100))
  ]);

  //define init lifecycle method to instantiate tab controller with particular length
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  //Override build method to return ListView
  //Where 1st part used to display Logged in users
  //2nd Part used to List the Groups with Tab controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 250.0,
                width: double.infinity,
                child: ControlledAnimation(
                  startPosition: 0.2,
                  playback: Playback.MIRROR,
                  tween: tween,
                  duration: tween.duration,
                  builder: (context, animation) {
                    return Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              colors: [animation["color1"], animation["color2"]])),
                    );
                  },
                ),
              ),
              Positioned(
                top: 140.0,
                right: 15.0,
                child: FloatingActionButton.extended(
                  heroTag: "btn2",
                  label: Text('Log out',style: TextStyle(fontFamily: "Montserrat",),),
                  backgroundColor: Colors.indigo.shade200,
                  icon: Icon(Icons.settings_power),
                  onPressed: () {
                    SweetAlert.show(context,
                        subtitle: "Do you want to logout",
                        style: SweetAlertStyle.confirm,
                        showCancelButton: true, onPress: (bool isConfirm) {
                          if(isConfirm){
                            SweetAlert.show(context,subtitle: "logging out...", style: SweetAlertStyle.loading);
                            new Future.delayed(new Duration(seconds: 2),(){
                              signOutGoogle();
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return HomePage();}), ModalRoute.withName('/'));
                              SweetAlert.show(context,subtitle: "Success!", style: SweetAlertStyle.success);
                            });
                          }else{
                            SweetAlert.show(context,subtitle: "Canceled!", style: SweetAlertStyle.error);
                          }
                          // return false to keep dialog
                          return false;
                        });

                  },
                ),
              ),
              Positioned(
                top: 25.0,
                left: 15.0,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 125.0,
                      width: 125.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(62.5),
                          image: DecorationImage(
                              image: NetworkImage(widget.user.photoUrl,),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        greetUser(),
                        SizedBox(height: 5.0),
                        Text(
                          widget.user.displayName.split(" ")[0],
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade300),
                        ),
                        SizedBox(height: 1.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.email, color: Colors.indigo.shade200),
                            Container(
                              width: MediaQuery.of(context).size.width - 175.0,
                              child: Text(
                                widget.user.email,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:200.0),
                child: TabBar(
                  controller: tabController,
                  indicatorColor: Colors.redAccent,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 4.0,
                  labelColor: Color(0xFFFE6E22),
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Ping Groups',
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 18.0,
                          //fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade300
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Favourite Groups',
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 18.0,
                            //fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade300
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height - 285.0,
            color: Colors.white24,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                new GroupListPage(isFavouriteList: false,),
                new GroupListPage(isFavouriteList: true,)
              ],
            ),
          )
        ],
      ),
    );
  }

  //Method used determine time of the Day inorder to greet the user
  Widget greetUser(){
    var hour = DateTime.now().hour;
    String greet = (hour<12)?'Morning':((hour < 17)?'Afternoon':'Evening');
    return Text(
      "Good $greet !",
      style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.0,
          fontStyle: FontStyle.normal,
          color: Colors.orangeAccent.shade400),
    );
  }
}