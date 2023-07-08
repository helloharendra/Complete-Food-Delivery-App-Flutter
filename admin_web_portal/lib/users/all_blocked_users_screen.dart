import 'package:admin_web_portal/mainScreens/home_screen.dart';
import 'package:admin_web_portal/widgets/simple_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AllBlockedUsersScreen extends StatefulWidget {
  const AllBlockedUsersScreen({super.key});

  @override
  State<AllBlockedUsersScreen> createState() => _AllBlockedUsersScreenState();
}

class _AllBlockedUsersScreenState extends State<AllBlockedUsersScreen> {
  QuerySnapshot? allUsers;
  displayDilaugeBoxForUnBlockingAccount(userDocumentID) {
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
            "Do you want to Unblock this Account",
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
                    .collection("users")
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
        .collection("users")
        .where('status', isEqualTo: "Blocked")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allUsers = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayBlockedUsersDesign() {
      if (allUsers != null) {
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
                                allUsers!.docs[i].get("photo"),
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                      title: Text(
                        allUsers!.docs[i].get("name"),
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
                            allUsers!.docs[i].get("email"),
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
                        "Unblock this Account".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        displayDilaugeBoxForUnBlockingAccount(
                            allUsers!.docs[i].id);
                      },
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: allUsers!.docs.length,
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
      appBar: SimpleAppBar(title: "All Blocked Users Account "),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 5,
          child: displayBlockedUsersDesign(),
        ),
      ),
    );
  }
}
