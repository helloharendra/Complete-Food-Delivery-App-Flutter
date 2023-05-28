import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/itemsScreen.dart';
import 'package:seller_app/model/menus.dart';

class InfoDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  InfoDesignWidget({super.key, this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
   deleteMenu( String menuId){
FirebaseFirestore.instance.collection("sellers")
.doc(sharedPreferences!.getString("uid"))
.collection("menus").doc(menuId).delete();

Fluttertoast.showToast(msg: "menu Deleted Successfully");
 }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.grey[300],
            ),
            Image.network(
              widget.model!.thumbnailUrl!,
              height: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.model!.menuTitle!,
                  style: const TextStyle(
                      color: Colors.cyan, fontSize: 20, fontFamily: "Train"),
                ),  IconButton(onPressed:() =>{
                  deleteMenu(widget.model!.menuId!)
                },
                 icon: const Icon(Icons.delete_sweep,
                  color: Colors.pinkAccent,))
              ],
            ),
            // Text(
            //   widget.model!.menuInfo!,
            //   style: const TextStyle(
            //       color: Colors.grey, fontSize: 20, fontFamily: "Train"),
            // ),
            Divider(
              height: 4,
              thickness: 2,
              color: Colors.grey[300],
            )
          ]),
        ),
      ),
    );
  }
}
