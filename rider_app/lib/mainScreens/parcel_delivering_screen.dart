import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/assistant_methods/get_current_location.dart';
import 'package:rider_app/maps/map_utils.dart';
import 'package:rider_app/splashScreen/splash_screen.dart';

import '../global/global.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  String? purchaserLat;
  String? purchaserLng;

  String? sellerId;
  String? getOrderId;

  ParcelDeliveringScreen({
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId,
  });

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = "";

  confirmParcelHasBeenDelivered(getOrederId, sellerId, purchaserId,
      purchaserAddress, purchaserLat, purchaserLng) {
    String riderNewTotolEarningAmount =
        (double.tryParse(previousRidersEarnings + perParcelDeliveryAmount))
            .toString();
    // ((double.parse(previousRidersEarnings))+(double.parse(perParcelDeliveryAmount))).toString();
    FirebaseFirestore.instance.collection("orders").doc(getOrederId).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earnings": perParcelDeliveryAmount,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("riders")
          .doc(sharedPreferences?.getString("uid"))
          .update({
        "earnings": riderNewTotolEarningAmount,
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(widget.sellerId)
          .update({
        "earnings":
            (double.parse(orderTotalAmount) + (double.parse(previousEarnings)))
                .toString(), //new totla earning for sellers
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(purchaserId)
          .collection("orders")
          .doc(getOrederId)
          .update({
        "status": "ended",
        "riderUID": sharedPreferences!.getString("uid"),
      });
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  getOrderTotalAmount() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderId)
        .get()
        .then((snap) {
      orderTotalAmount = snap.data()!["totolAmmount"].toString();
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((snap) {
      previousEarnings = snap.data()!["earnings"].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    UserLocation userLocation = UserLocation();
    userLocation.getCurrentLocation();
    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/confirm2.png",
            // width: 350,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              MapUtils.launchMapFromSourceToDestination(
                  position?.latitude,
                  position?.longitude,
                  widget.purchaserLat,
                  widget.purchaserLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/restaurant.png",
                  width: 50,
                ),
                const SizedBox(
                  width: 7,
                ),
                Column(
                  children: const [
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      "Show Delivery Drop-off Location",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          letterSpacing: 2,
                          fontFamily: "Signatra"),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  //rider location
                  UserLocation userLocation = UserLocation();
                  userLocation.getCurrentLocation();

                  confirmParcelHasBeenDelivered(
                      widget.getOrderId,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng);

                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>MySplashScreen()));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Colors.pinkAccent, Colors.red],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been Delivered-Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
