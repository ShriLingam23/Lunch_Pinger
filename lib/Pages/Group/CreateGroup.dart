//Widget class used to Define the Create Group form,
// that is used to create the Group once we clicked the Group add button in the Menu
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_google_auth/Api/FirestoreApi.dart';
import 'package:flutter_google_auth/Models/Group.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../GoogleSignIn.dart';

//Define CreateGroup Stateful widget
class CreateGroup extends StatefulWidget {
  //Define State of CreateGroup using createState override method
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

//Define State for the CreateGroup Stateful widget
class _CreateGroupState extends State<CreateGroup> {

  //List of State that are used to create the Group
  final group_types = ['Office', 'Friends', 'Family'];
  final _formKey = GlobalKey<FormState>();
  final groupNameController = TextEditingController();
  String _type = 'Office';
  final messageController = TextEditingController();
  DateTime _dateTime = new DateTime.now();

  //Override build method that returns the Create page with Bottom Navigation bar and Header decorations
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //Define bottom nav bar in order to provide users with basic actions, such as return to Home, Logout
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          height: 50,
          color: Colors.orangeAccent.shade100,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.save, size: 30),
            Icon(Icons.power_settings_new, size: 30),
          ],
          onTap: (index) {
            if(index==0){
              Navigator.of(context).pop();
            }
            else if(index==2){
              SweetAlert.show(context,subtitle: "logging out...", style: SweetAlertStyle.loading);
              new Future.delayed(new Duration(seconds: 2),(){
                signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return HomePage();}), ModalRoute.withName('/'));
                SweetAlert.show(context,subtitle: "Success!", style: SweetAlertStyle.success);
              });
            }
          },
        ),
        //Define the Create form where the fields are controlled by state properties
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: new Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 140.0,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(75.0)),
                          color: Colors.orange.shade100),
                    ),
                    Container(
                      height: 85.0,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(65.0)),
                          color: Colors.orange.shade200),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 200,
                      child: IconButton(
                          icon: const Icon(
                            Icons.people,
                            color: Colors.blueGrey,
                            size: 40,
                          ),
                          onPressed: () {}),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35.0, left: 15.0),
                      child: Text(
                        'Create your Lunch Group!',
                        style: TextStyle(
                            //decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 25.0,
                            color: Colors.blueGrey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 95.0, left: 15.0),
                      child: Text(
                        'New Group',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 30.0,
                            color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
                new Card(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                  elevation: 2,
                  child: Column(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.stars),
                        title: new TextFormField(
                          style: TextStyle(fontFamily: "Montserrat"),
                          decoration: new InputDecoration(
                            hintText: "Group Name",
                          ),
                          controller: groupNameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Group Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      new ListTile(
                        leading: const Icon(Icons.loyalty),
                        title: new DropdownButton<String>(
                          items: group_types.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type,style: TextStyle(fontFamily: "Montserrat"),),
                            );
                          }).toList(),
                          value: _type,
                          onChanged: (String value) {
                            setState(() {
                              this._type = value;
                            });
                          },
                          icon: Icon(Icons.arrow_downward),
                          isExpanded: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      new ListTile(
                        leading: const Icon(Icons.email),
                        title: new TextFormField(
                          style: TextStyle(fontFamily: "Montserrat"),
                          decoration: new InputDecoration(
                            hintText: "Message",
                          ),
                          controller: messageController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the ping message';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      new ListTile(
                        leading: const Icon(Icons.access_time),
                        title: new RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showTimePicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true,
                                onConfirm: (time) {
                                  setState(() {
                                    this._dateTime = time;
                                  });
                                },
                                currentTime: _dateTime, locale: LocaleType.en);
                            //setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: 250.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[

                                          Text(
                                            " ${DateFormat.jms().format(_dateTime)}",
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "  Change",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0,)
                    ],
                  ),
                ),
                new SizedBox(height : 20.0),
                new RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
//                      if(_time!="Not set"){
//                        Scaffold
//                            .of(context)
//                            .showSnackBar(SnackBar(content: Text('Processing Data')));

                        //create Group
                        Group group = Group.setValue(
                          groupName:groupNameController.text,
                          type: _type,
                          message: messageController.text,
                          pingTime: _dateTime,
                          isFavourite: false,
                          priority: 0
                        );

                        FirestoreApi api = new FirestoreApi();
                        bool status = api.createGroup(group);

                        Navigator.of(context).pop();

                        SweetAlert.show(context,
                            title: "New Group",
                            subtitle: "created sucessfully",
                            style: SweetAlertStyle.success);
                        }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.orange.shade200],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.save),
                            SizedBox(width: 10,),
                            Text(
                              "Create Group",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  color: Colors.black87
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
          )
    ));
  }
}
