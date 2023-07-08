import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/models/sellers.dart';

import '../widgets/sellers_design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? restaurentsDocumentsList;
  String sellerNameText = "";
  initSearchingRestaurents(String textEntered) {
    restaurentsDocumentsList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.red],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              sellerNameText = textEntered;
            });
            initSearchingRestaurents(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search Restaurent here...",
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffix: IconButton(
              onPressed: () {
                initSearchingRestaurents(sellerNameText);
              },
              icon: const Icon(Icons.search),
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: restaurentsDocumentsList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Sellers model = Sellers.fromJson(snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>);
                    return SellersDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                )
              : const Center(
                  child: Text("No Recoord Found"),
                );
        },
      ),
    );
  }
}
