// Repository class that act as the connection point to the Firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_auth/Models/Group.dart';

class FirestoreApi{

  //Create method that is used when a Group need to be created.
   createGroup(Group group){

    try{
      Firestore.instance.runTransaction((Transaction transaction) async {
        await Firestore.instance.collection("groups").document()
            .setData(group.toJson());
      });
    }
    catch(e){
      print(e.toString());
    }
  }

  //Read Stream that takes boolean parameter to determine,
   // whether to return All the groups or favourite groups
  Stream<QuerySnapshot> getStream(bool isFavouriteList){
     
     if(isFavouriteList) 
       return Firestore.instance.collection("groups").where('isFavourite',isEqualTo: true).orderBy('priority',descending: true).snapshots();
     else
       return Firestore.instance.collection("groups").orderBy('priority',descending: true).snapshots();
  }

  //Method used update particular method with the new Map data
  updateGroup(Group group, Map<String,dynamic> newData){

     try{
       Firestore.instance.runTransaction((Transaction transaction) async{
         await transaction.update(group.reference, newData);
       });
     }
     catch(e){
       print(e.toString());
     }
  }

  //Method used to delete the Group pointed by the reference number
  deleteGroup(Group group){
     Firestore.instance.runTransaction(
       (Transaction transaction) async{
         await transaction.delete(group.reference);
       }
     );
  }
}