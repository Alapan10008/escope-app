import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escope/screens/APIcall.dart';
import 'package:escope/screens/setfilename.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:http/http.dart' as http;

class Storage{

  final firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance;


    Future<void> uploadFile(String filePath,String fileName,)async{
    File file =File(filePath);
    try{
       firebase_storage.Reference ref =storage.ref('files/$fileName');
       await storage.ref('files/$fileName').putFile(file);
       print("uploaded");
       String downurl = await ref.getDownloadURL();
       creatUserdata(downurl: downurl);
       print(downurl);
       uploadaudio(filePath, fileName);

    }on firebase_core.FirebaseException catch(e){
      print("Not Uploaded");
      print(e);
    }


  }
  
  Future creatUserdata ({ required String downurl}) async{
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final json ={
      'filename': global_filename,
      'name':global_name,
      'age':global_age,
      'downurl': downurl,
      'day':global_Day,
      'month':global_Month,
      'year':global_Year,
      'DateTime':global_Datetime,

    };

    final docuser =await FirebaseFirestore.instance.collection('Userdata').doc(uid).collection("testdata").add(json);

  }
}