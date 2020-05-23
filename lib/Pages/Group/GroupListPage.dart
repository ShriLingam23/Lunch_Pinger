// Class used for listing of Groups
// Here we pass true/false to constructor of the Widget in order to determine whether to list all the groups or favourite groups

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_auth/Api/FirestoreApi.dart';

import 'CreateGroup.dart';
import 'GroupListItemPage.dart';

//GuessYouLikePage StatefulWidget instantiation
class GroupListPage extends StatefulWidget {

  //Property passed from parent inorder to determine whether favourite group listing or not
  final bool isFavouriteList;
  GroupListPage({Key key,this.isFavouriteList}):super(key:key);

  //Override createstate to define the state for the GroupListPage
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

//State class definition for GroupListPage
class _GroupListPageState extends State<GroupListPage> {

  //Instantiate the instance of FirestoreApi which act as the Repository class to connect with Firebase
  FirestoreApi api = new FirestoreApi();

  //Override build which returns StreamBuilder
  @override
  Widget build(BuildContext context) {

    //Set the Stream to Stream<QuerySnapshot> to retrive the list of groups
    return StreamBuilder(
      stream: api.getStream(widget.isFavouriteList),
      builder: (context,snapshot){

        //Check whether there is any error in the Snapshot
        if(snapshot.hasError)
          return Text('Error ${snapshot.error}');

        //Check if snapshot has data, if not return Circular progress indicator
        if(!snapshot.hasData)
          return SizedBox(
              height: 150.0,
              width: 150.0,
              child:
              Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                    strokeWidth: 5.0),
              )
          );
        //Return a List if data exist
        else
          return buildList(context,snapshot.data.documents);

      },
    );
  }
}

// Define a Widget that returns Stack that includes a ListView and Floating button.
Widget buildList(BuildContext context,List<DocumentSnapshot> data){

  //Return a Stack view
  return Stack(
    children: <Widget>[
      //List view that return List of Groups
      ListView(
        children: data.map((doc){
          return Column(
            children: <Widget>[
              new Container(
                  height: 2,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide( color: Colors.grey.shade300)
                    ),
                  )
              ),
              GroupListItemPage(key: Key(doc.documentID) ,documentSnapshot: doc,),
              new Container(
                  height: 2,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide( color: Colors.grey.shade300)
                    ),
                  )
              )
            ],
          );
        }).toList(),
      ),
      //Return a Floating button to add a new group
      Container(
        child: Positioned(
          bottom: 10.0,
          left: 15.0,
          child: FloatingActionButton.extended(
            heroTag: "btn1",
            label: Text('Group',style: TextStyle(fontFamily: "Montserrat",),),
            backgroundColor: Colors.green.shade300,
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context){
                    return CreateGroup();
                  }
              ));
            },
          ),
        ),
      )
    ],
  );
}
