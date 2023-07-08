import 'package:admin_web_portal/mainScreens/home_screen.dart';
import 'package:admin_web_portal/widgets/simple_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AllBlockedRidersScreen extends StatefulWidget {
  const AllBlockedRidersScreen({super.key});

  @override
  State<AllBlockedRidersScreen> createState() => _AllBlockedRidersScreenState();
}

class _AllBlockedRidersScreenState extends State<AllBlockedRidersScreen> {
  QuerySnapshot? allRiders;
  displayDilaugeBoxForUnBlocAccount(userDocumentID) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "UnBlock Account",
            style: TextStyle(
                fontSize: 25, letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Do you want to UnBlock this Account",
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Map<String, dynamic> userDataMap = {
                  "status": "Approved",
                };
                FirebaseFirestore.instance
                    .collection("riders")
                    .doc(userDocumentID)
                    .update(userDataMap)
                    .then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                  SnackBar snackBar = const SnackBar(
                    content: Text(
                      "UnBlocked Successfully",
                      style: TextStyle(fontSize: 36, color: Colors.black),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("riders")
        .where('status', isEqualTo: "Blocked")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allRiders = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayBlockedRidersDesign() {
      if (allRiders != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, i) {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                allRiders!.docs[i].get("riderAvtar"),
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                      title: Text(
                        allRiders!.docs[i].get("riderName"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            allRiders!.docs[i].get("riderEmail"),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "UnBlock this Account".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        displayDilaugeBoxForUnBlocAccount(
                            allRiders!.docs[i].id);
                      },
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: allRiders!.docs.length,
        );
      } else {
        return const Center(
          child: Text(
            "No Record Found",
            style: TextStyle(fontSize: 30),
          ),
        );
      }
    }

    return Scaffold(
      appBar: SimpleAppBar(title: "All Blocked Riders Account "),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 5,
          child: displayBlockedRidersDesign(),
        ),
      ),
    );
  }
}
