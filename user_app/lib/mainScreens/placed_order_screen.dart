import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totolAmmount;
  String? sellerUID;

  PlacedOrderScreen(
      {super.key, this.addressID, this.totolAmmount, this.sellerUID});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().microsecondsSinceEpoch.toString();
  addOrderDetails() {
    writeOrderDetailsForUser({
      "addressId": widget.addressID,
      "totolAmmount": widget.totolAmmount,
      "orderedBy": sharedPreferences!.getString("uid"),
      "productIds": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });

    writeOrderDetailsForSeller({
      "addressId": widget.addressID,
      "totolAmmount": widget.totolAmmount,
      "orderedBy": sharedPreferences!.getString("uid"),
      "productIds": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId = "";

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        Fluttertoast.showToast(
            msg: "Congratulations, Order has been placed Successfully");
      });
    });
  }

  Future writeOrderDetailsForUser(
    Map<String, dynamic> data,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(
    Map<String, dynamic> data,
  ) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.amber],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/delivery.jpg"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              addOrderDetails();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Place order'),
          )
        ]),
      ),
    );
  }
}
