import 'dart:ui';

import 'package:escope/screens/setfilename.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Userdatacard extends StatelessWidget{
  final Userdata _data;
  Userdatacard(this._data);


  @override
  Widget build(BuildContext context){
    return 
      ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child:
        BackdropFilter(
          filter:ImageFilter.blur(
            sigmaX: 16.0,
            sigmaY: 16.0,
          ),
          child: Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(8, 25, 8, 12),
          decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2,color: Colors.pinkAccent.withOpacity(0.3))
          ),
          child:
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 5, 5),
            child:  Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("${_data.filename}",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color.fromARGB(225, 255, 23, 0),
                          letterSpacing:1.5,

                        ),
                      )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Name: ${_data.filename}  Age:${_data.age}" ,style:TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(237, 255, 78, 51)
                    ),),
                    Spacer(),
                    Text("Date: ${_data.day}/${_data.month}/${_data.year}",
                        style:TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(237, 255, 78, 51)
                        )),
                  ],
                ),
              ],
            ),
          ),
    ),
        ),
      );
  }

}
