import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';

import 'package:user_app/models/sellers.dart';
import 'package:user_app/widgets/sellers_design.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [
    "assets/images/slider/0.jpg",
    "assets/images/slider/1.jpg",
    "assets/images/slider/2.jpg",
    "assets/images/slider/3.jpg",
    "assets/images/slider/4.jpg",
    "assets/images/slider/5.jpg",
    "assets/images/slider/6.jpg",
    "assets/images/slider/7.jpg",
    "assets/images/slider/8.jpg",
    "assets/images/slider/9.jpg",
    "assets/images/slider/10.jpg",
    "assets/images/slider/11.jpg",
    "assets/images/slider/12.jpg",
    "assets/images/slider/13.jpg",
    "assets/images/slider/14.jpg",
    "assets/images/slider/15.jpg",
    "assets/images/slider/16.jpg",
    "assets/images/slider/17.jpg",
    "assets/images/slider/18.jpg",
    "assets/images/slider/19.jpg",
    "assets/images/slider/20.jpg",
    "assets/images/slider/21.jpg",
    "assets/images/slider/22.jpg",
    "assets/images/slider/23.jpg",
    "assets/images/slider/24.jpg",
    "assets/images/slider/25.jpg",
    "assets/images/slider/26.jpg",
    "assets/images/slider/27.jpg",
  ];

  @override
  void initState() {
    super.initState();

    clearCartNow(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.amber],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "iFood",
          style: TextStyle(fontFamily: "Signatra", fontSize: 40),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  items: items.map((Index) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              Index,
                              fit: BoxFit.fill,
                            )),
                      );
                    });
                  }).toList(),
                  options: CarouselOptions(
                    height: 500,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    autoPlayCurve: Curves.decelerate,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("sellers").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (context) =>
                            const StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          Sellers sModel = Sellers.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);

                          return SellersDesignWidget(
                            model: sModel,
                            context: context,
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
              }),
        ],
      ),
    );
  }
}
