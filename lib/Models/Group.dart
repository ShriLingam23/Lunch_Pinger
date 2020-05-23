//This is the Core Model class that is used as Data Transfer object.
//In Order to manipulate and carry data along the Pages and Widgets

import 'package:cloud_firestore/cloud_firestore.dart';

class Group{

  String groupName;
  String type;
  String message;
  DateTime pingTime;
  bool isFavourite;
  int priority;
  DocumentReference reference;

  //Constructor used to instantiate object when creating
  Group.setValue({this.groupName,this.type,this.message,this.pingTime,this.isFavourite,this.priority});

  //Constructor that used to validate fields and assign to instance properties
  //Inorder to instantiate Group instance
  Group.fromMap(Map<String,dynamic>map,{this.reference}){
    assert(map['groupName']!=null);
    assert(map['type']!=null);
    this.groupName = map['groupName'];
    this.type = map['type'];
    this.message = map['message'];
    this.pingTime = (map['pingTime'] as Timestamp).toDate();
    this.isFavourite = (map['isFavourite']==null)?false:map['isFavourite'];
    this.priority = (map['priority']==null)?0: map['priority'];
  }

  //Constructor called from GroupListItem by passing document snapshot to create an instance of Group
  Group.fromSnapshot(DocumentSnapshot snapshot):this.fromMap(snapshot.data,reference:snapshot.reference);

  //Method used to get the Map<String,dynamic> type from the object properties
  toJson(){
    return{
      "groupName":groupName,
      "type":type,
      "message":message,
      "pingTime":pingTime,
      "isFavourite":isFavourite,
      "priority":priority
    };
  }

}