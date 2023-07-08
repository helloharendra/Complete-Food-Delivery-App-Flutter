import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/global/global.dart';
import 'package:rider_app/mainScreens/earning_screens.dart';
import 'package:rider_app/mainScreens/history_screen.dart';
import 'package:rider_app/mainScreens/new_orders_screen.dart';
import 'package:rider_app/mainScreens/not_yetDelivered_screen.dart';
import 'package:rider_app/mainScreens/parcel_in_progress.dart';

import '../../authentication/auth_screen.dart';
import '../assistant_methods/get_current_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItems(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.pinkAccent],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.amber],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              // new order
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const NewOrdersScreen()));
            }
            //Parcel in progress
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const ParcelInProgress()));
            }
            if (index == 2) {
              // not yet delivered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const NotYetDeliveredScreen()));
            }
            if (index == 3) {
              // history
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HistoryScreen()));
            }
            if (index == 4) {
              // total earning
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const EarningScreen()));
            }
            if (index == 5) {
              // logout
              firebaseAuth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      previousRidersEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("alizeb438")
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.pink],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Welcome ${sharedPreferences!.getString("name")!}",
          style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              letterSpacing: 2,
              fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItems("New Available Orders", Icons.assignment, 0),
            makeDashboardItems("Parcel in Progress", Icons.airport_shuttle, 1),
            makeDashboardItems("Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItems("History", Icons.done, 3),
            makeDashboardItems("Totol Earning", Icons.monetization_on, 4),
            makeDashboardItems("Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
