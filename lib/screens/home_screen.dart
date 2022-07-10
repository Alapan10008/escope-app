import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escope/screens/UserdataCard.dart';
import 'package:escope/screens/audiotypeslector.dart';
import 'package:escope/screens/setfilename.dart';
import 'package:escope/services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _filenameTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  String filename = "";
  String name = "";
  String age = "";
  List<Object> _userdata=[];

  Future getUserdataList() async{
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print(uid);
    var data = await FirebaseFirestore.instance.collection('Userdata').doc(uid).collection('testdata').orderBy('DateTime',descending: true).get();
    setState((){
      _userdata=List.from(data.docs.map((doc) => Userdata.fromSnapshot(doc)));
    });

  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    getUserdataList();
    print(_userdata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 245, 197, 190),
        title: Center(
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover,
              height: 70,
              width: 70,
              color: Colors.black,)),
      ),
      body :
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: SafeArea(
              child: ListView.builder(
                itemCount: _userdata.length,
                  itemBuilder: (context,index){
                  return Userdatacard(_userdata[index] as Userdata);
                  }),

            ),
          ),


      floatingActionButton:
      Container(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: FloatingActionButton.extended(
          backgroundColor:  Color.fromARGB(255, 245, 197, 190),
          foregroundColor: Colors.white,
          icon: Icon(Icons.add),
          label: Text('NEW ',
          style: GoogleFonts.montserrat(),),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: BackdropFilter(
                          filter:ImageFilter.blur(
                            sigmaX: 6.0,
                            sigmaY: 6.0,
                          ),

                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(width: 2,color: Colors.pinkAccent.withOpacity(0.1))
                          ),
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text("Patient Detail",
                              style: GoogleFonts.montserrat(fontSize: 24),),
                            content: Container(
                              width: 400,
                              height: 280,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Filename",
                                      style: GoogleFonts.montserrat(fontSize: 20),),),
                                  TextField(
                                    controller: _filenameTextController,
                                    cursorColor: Color.fromARGB(
                                        255, 255, 255, 255),
                                    style: TextStyle(fontSize: 20, height: 1.5),
                                    decoration:
                                    textfielddecoration(),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Name",
                                      style: GoogleFonts.montserrat(fontSize: 20),),),
                                  TextField(
                                    controller: _nameTextController,
                                    cursorColor: Color.fromARGB(255, 245, 197, 190),
                                    style: TextStyle(fontSize: 20, height: 1.5),
                                    decoration:
                                    textfielddecoration(),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    alignment: Alignment.bottomLeft, child: Text(
                                    "Age",
                                    style: GoogleFonts.montserrat(fontSize: 20),),),
                                  TextField(
                                    controller: _ageTextController,
                                    cursorColor: Color.fromARGB(255, 245, 197, 190),
                                    style: TextStyle(fontSize: 20, height: 1.5,),
                                    keyboardType: TextInputType.number,
                                    decoration: textfielddecoration(),

                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    setState(() {

                                      filename = _filenameTextController.text;
                                      name = _nameTextController.text;
                                      age = _ageTextController.text;
                                      DateTime now =DateTime.now();
                                      global_Datetime='$now';
                                      global_Year='${now.year}';
                                      global_Month ='${now.month}';
                                      global_Day='${now.day}';
                                      global_filename=filename;
                                      global_name=name;
                                      global_age=age;

                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            AudioTypeselector()));
                                  },
                                  child: Text("ADD", style: GoogleFonts.montserrat(
                                    fontSize: 20, color: Color.fromARGB(
                                      255, 245, 197, 190),),))
                            ],
                          ),
                        ),
                      ),
                    );
                }
            );
          },

        ),
      ),


    );
  }
}



