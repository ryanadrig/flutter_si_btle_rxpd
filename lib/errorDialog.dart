import 'package:flutter/material.dart';



showErrorDialog(BuildContext context, Size ss, String message){
  showDialog(context: context, builder: (context){
    return Dialog(backgroundColor: Colors.black45,
      child: Container(
        width: ss.width,
        height: ss.width,
        child: Center(child:Text(message,
          style: TextStyle(color: Colors.white),)),
      ),
    );
  });
}