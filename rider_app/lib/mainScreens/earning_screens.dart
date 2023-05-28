import 'package:flutter/material.dart';
import 'package:rider_app/global/global.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/splashScreen/splash_screen.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("₹"+previousRidersEarnings,style: const TextStyle(
              fontSize: 50,color: Colors.white,fontFamily: "Signatra"
            ),),
             const Text("Total Earnings",style: TextStyle(
              fontSize: 20,color: Colors.grey,fontWeight: FontWeight.bold
              ,letterSpacing: 3,
            ),),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              thickness: 1.5,
              ),
            ),
    
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
              },
              child: const Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 40,horizontal: 120),
                child: ListTile(
                  leading: Icon(Icons.arrow_back,color: Colors.grey,),
                  title: Text("Back",textAlign: TextAlign.center, style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12,),),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}