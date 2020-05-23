//Widget class used to Define the Update form,
// that is used to update the Group once we clicked the Group in the List

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_google_auth/Api/FirestoreApi.dart';
import 'package:flutter_google_auth/Models/Group.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../GoogleSignIn.dart';

//Define UpdateGroup Stateful widget
class UpdateGroup extends StatefulWidget {

  //Group Instance that is instantiate using the constructor that is passed from GroupListPage
  final Group group;
  UpdateGroup({Key key,this.group}):super(key:key);

  //Define State of UpdateGroup using createState override method
  @override
  _UpdateGroupState createState() => _UpdateGroupState();
}

//Define State for the UpdateGroup Stateful widget
class _UpdateGroupState extends State<UpdateGroup> {

  //List of State that are maintained inorder to update the Group
  final group_types = ['Office', 'Friends', 'Family'];
  final _formKey = GlobalKey<FormState>();
  final groupNameController = TextEditingController();
  String _type;
  final messageController = TextEditingController();
  DateTime _dateTime;
  String isFavorite;
  int priority;

  //Override init lifecycle method to instantiate states
  @override
  void initState() {
    super.initState();

    groupNameController.text = widget.group.groupName;
    _type = widget.group.type;
    messageController.text = widget.group.message;
    _dateTime = widget.group.pingTime;
    isFavorite  = (widget.group.isFavourite)?"Yes":"No";
    priority = widget.group.priority;
  }

  //Override build method that returns the Update page with Update form populated with group data
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
            Icon(Icons.mode_edit, size: 30),
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
        //Define the Update form where the fields are populated with the Group data
        body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(75.0)),
                            color: Colors.orange.shade200),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 230,
                        child: IconButton(
                            icon: const Icon(
                              Icons.people,
                              color: Colors.black87,
                              size: 50,
                            ),
                            onPressed: () {}),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 45.0, left: 15.0),
                        child: Text(
                          'Update Group',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 30.0,
                              color: Colors.brown),
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
                            style: TextStyle(fontFamily: "Montserrat",),
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
                                child: Text(type,style: TextStyle(fontFamily: "Montserrat",),),
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
                            style: TextStyle(fontFamily: "Montserrat",),
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
                          leading: const Icon(Icons.favorite),
                          title: Row(
                            children: <Widget>[
                              Radio(
                                  value: "Yes",
                                  groupValue: isFavorite,
                                  onChanged: (String value) {
                                    setState(() {
                                      isFavorite = value;
                                    });
                                  },
                              ),
                              Text("Yes",style: TextStyle(fontFamily: "Montserrat",),),
                              SizedBox(width: 50,),
                              Radio(
                                value: "No",
                                groupValue: isFavorite,
                                onChanged: (String value) {
                                  setState(() {
                                    isFavorite = value;
                                  });
                                },
                              ),
                              Text("No",style: TextStyle(fontFamily: "Montserrat",),)
                            ],
                          ),
                        ),
                        const SizedBox(height:10.0),
                        new ListTile(
                          leading: const Icon(Icons.notifications_active),
                          title: Row(
                            children: <Widget>[
                              getRatedStar(priority, 1),
                              SizedBox(width: 5,),
                              getRatedStar(priority, 2),
                              SizedBox(width: 5,),
                              getRatedStar(priority, 3),
                              SizedBox(width: 5,),
                              getRatedStar(priority, 4),
                              SizedBox(width: 5,),
                              getRatedStar(priority, 5),
                              SizedBox(width: 7.0),
                              Text(priority.toString(),
                                style: TextStyle(
                                    color: Colors.yellow[800],
                                    fontSize: 17.0
                                ),
                              )
                            ],
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
                                  currentTime: this._dateTime, locale: LocaleType.en);
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

                        //create Group with updated fields
                        Group group = Group.setValue(
                            groupName:groupNameController.text,
                            type: _type,
                            message: messageController.text,
                            pingTime: _dateTime,
                            isFavourite: (isFavorite=="Yes")?true:false,
                            priority: priority
                        );

                        FirestoreApi api = new FirestoreApi();
                        bool status = api.updateGroup(widget.group,group.toJson());

                        Navigator.of(context).pop();

                        SweetAlert.show(context,
                            title: "Update Group",
                            subtitle: "Successful",
                            style: SweetAlertStyle.success);
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.blueGrey.shade200, Colors.yellow.shade100],
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
                                "Update Group",
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
                  SizedBox(height: 20,)
                ],
              ),
            )
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.arrow_forward_ios, color: Colors.black),
        backgroundColor: Colors.orange.shade200,
      ),
    );
  }

  //Method used to handle change in priority values that is displayed using stars
  //compare the priority value in the State and index in order ot color the stars
  getRatedStar(int rating, int index) {
    if (index <= rating) {
      return InkWell(
        child:Icon(Icons.star,color: Colors.yellow[600],size: 40,),
        onTap: (){
          setState(() {
            this.priority = index;
          });
        },
      );
    } else {
      return InkWell(
        child:Icon(Icons.star_border,color: Colors.grey,size: 40,),
        onTap: (){
          setState(() {
            this.priority = index;
          });
        },
      );
    }
  }
}
