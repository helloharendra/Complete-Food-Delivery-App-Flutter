import 'package:admin_web_portal/mainScreens/home_screen.dart';
import 'package:admin_web_portal/widgets/simple_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AllVerifiedRidersScreen extends StatefulWidget {
  const AllVerifiedRidersScreen({super.key});

  @override
  State<AllVerifiedRidersScreen> createState() =>
      _AllVerifiedRidersScreenState();
}

class _AllVerifiedRidersScreenState extends State<AllVerifiedRidersScreen> {
  QuerySnapshot? allRiders;
  displayDilaugeBoxForBlocAccount(userDocumentID) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Block Account",
            style: TextStyle(
                fontSize: 25, letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Do you want to Block this Account",
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
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Map<String, dynamic> userDataMap = {
                  "status": "Blocked",
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
                      "Blocked Successfully",
                      style: TextStyle(fontSize: 36, color: Colors.black),
                    ),
                    backgroundColor: Colors.pinkAccent,
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.red),
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
        .where('status', isEqualTo: "Approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allRiders = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayVerifiedRidersDesign() {
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
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Block this Account".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        displayDilaugeBoxForBlocAccount(allRiders!.docs[i].id);
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
      appBar: SimpleAppBar(title: "All Verified Riders Account "),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 5,
          child: displayVerifiedRidersDesign(),
        ),
      ),
    );
  }
}
