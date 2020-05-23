//Class that is used to Define individual Group item, based on the Group object passed from the parent

import 'package:flutter/material.dart';
import 'package:flutter_google_auth/Api/FirestoreApi.dart';
import 'package:flutter_google_auth/Models/Group.dart';
import 'package:intl/intl.dart';
import 'package:sweetalert/sweetalert.dart';
import 'UpdateGroup.dart';

//Class definition of GroupListItemPage stateful widget
class GroupListItemPage extends StatefulWidget{

  Group group;
  //Constructor that is used to instatiate using the Group object passed from the parent
  GroupListItemPage({Key key,documentSnapshot}):super(key:key){
    group = Group.fromSnapshot(documentSnapshot);
  }

  //override createState method that is used to define the State of the widget
  @override
  State<StatefulWidget> createState() => new _GroupListItemPageState();
}

//Define state class of the GroupListItemPage widget
class _GroupListItemPageState extends State<GroupListItemPage>{

  String imgPath;

  //Widget lifecycle method that is used to define the path of the image based on the Type of the group
  @mustCallSuper
  void initState() {
    imgPath = (widget.group.type=='Office') ?
    'assets/images/officeIcon.png' : ((widget.group.type=='Friends')? 'assets/images/friendsIcon.png' : 'assets/images/familyIcon.png');

  }

  //override build method that returns the list item structure, with the Group object properties
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: widget.key,
      padding: EdgeInsets.symmetric(vertical:8,horizontal: 5),
        child: InkWell(
          onTap: (){

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context){
                  return UpdateGroup(group: widget.group,);
                }
            ));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: AssetImage(imgPath),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width - 125.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.group.groupName,
                            style: TextStyle(
                                fontFamily: "Montserrat",fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.black54),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5.0),
                            height: 40.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0)),
                              color: (widget.group.isFavourite)?Color(0xFFF76765):Colors.black26,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )),
                  Row(
                    children: <Widget>[
                      getRatedStar(widget.group.priority, 1),
                      getRatedStar(widget.group.priority, 2),
                      getRatedStar(widget.group.priority, 3),
                      getRatedStar(widget.group.priority, 4),
                      getRatedStar(widget.group.priority, 5),
                      SizedBox(width: 7.0),
                      Text(widget.group.priority.toString(),
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.yellow[800],
                            fontSize: 17.0
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text('Ping Message',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12.0,
                        color: Color(0xFFC6CC40)
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width - 130.0,
                    child: Text(widget.group.message,
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14.0,
                          color: Colors.grey
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Icon(Icons.local_activity, color: Colors.red),
                      Text(
                        widget.group.type,
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Icon(Icons.timer, color: Colors.green.shade500),
                      Text(DateFormat.jms().format(widget.group.pingTime),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      InkWell(
                        child: Icon(Icons.delete_outline, color: Colors.deepOrange.shade900,size: 40,),
                        onTap: (){
                          SweetAlert.show(context,
                              subtitle: "Do you want to Delete",
                              style: SweetAlertStyle.confirm,
                              showCancelButton: true, onPress: (bool isConfirm) {
                                if(isConfirm){
                                  SweetAlert.show(context,subtitle: "Deleting group...", style: SweetAlertStyle.loading);
                                  new Future.delayed(new Duration(seconds: 2),(){
                                    FirestoreApi api = new FirestoreApi();
                                    api.deleteGroup(widget.group);
                                    SweetAlert.show(context,subtitle: "Success!", style: SweetAlertStyle.success);
                                  });
                                }else{
                                  SweetAlert.show(context,subtitle: "Canceled!", style: SweetAlertStyle.error);
                                }
                                // return false to keep dialog
                                return false;
                              });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }

  //Method used to fill the each indivitual stars by comparing the priority value of the group and the index of particular star
  getRatedStar(int rating, int index) {
    if (index <= rating) {
      return Icon(Icons.star, color: Colors.yellow[600]);
    } else {
      return Icon(Icons.star_border, color: Colors.grey);
    }
  }

}
