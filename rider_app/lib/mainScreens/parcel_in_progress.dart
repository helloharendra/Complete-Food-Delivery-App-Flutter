import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rider_app/widgets/progress_bar.dart';
import 'package:rider_app/widgets/simple_Appbar.dart';

import '../assistant_methods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';

class ParcelInProgress extends StatefulWidget {
  const ParcelInProgress({super.key});

  @override
  State<ParcelInProgress> createState() => _ParcelInProgressState();
}

class _ParcelInProgressState extends State<ParcelInProgress> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "Parcel In Progress",
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
              .where("status", isEqualTo: "picking")
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("itemId",
                                whereIn: separateOrderItemIds(
                                    (snapshot.data?.docs[index].data()
                                        as Map<String, dynamic>)["productIds"]))
                            
                            .orderBy("publishedDate", descending: true)
                            .get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? OrderCard(
                                  itemCount: snap.data?.docs.length,
                                  data: snap.data?.docs,
                                  orderId: snapshot.data?.docs[index].id,
                                  seperateQuantitiesList:
                                      separateOrderItemQuantities(
                                          (snapshot.data?.docs[index].data()
                                                  as Map<String, dynamic>)[
                                              "productIds"]),
                                )
                              : Center(
                                  child: circularProgress(),
                                );
                        },
                      );
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
