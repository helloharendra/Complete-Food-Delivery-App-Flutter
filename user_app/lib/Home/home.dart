import 'package:flutter/material.dart';

import '../cake/cakeItems.dart';
import '../restaurent/restaurent1.dart';
import '../restaurent/restaurent2.dart';
import '../restaurent/restaurent3.dart';
import '../restaurent/restaurent4.dart';
import '../restaurent/restaurent5.dart';
import 'HomeLargeItems.dart';

import 'HomePageItems3.dart';
import 'HomePageMediumItems.dart';
import 'HomepageItems4.dart';

void main(List<String> args) {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DiningPagePageState();
}

class _DiningPagePageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              // child: HomeMenuBarListItems(),
            ),
          ),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: HomeLargeItems(),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              'EXPLORE',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: HomeMediumItems(),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              'WHATS ON YOUR MIND?',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: HomePageItems3(),
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: HomePageItems4(),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              'IN THE SPOTLIGHT',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: CakeItems1(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'OUR RESTAURENTS',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'FEATURES',
              style: TextStyle(
                  fontSize: 15, color: Color.fromARGB(255, 126, 126, 126)),
            ),
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Restaurent1(),
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Restaurent2(),
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Restaurent3(),
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Restaurent4(),
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Restaurent5(),
          ),
        ],
      ),
    );
  }
}
