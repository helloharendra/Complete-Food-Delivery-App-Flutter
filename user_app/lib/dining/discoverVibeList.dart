import 'package:flutter/material.dart';

import 'package:user_app/dining/mustTriesModel.dart';

class DiscoverVibeList extends StatefulWidget {
  const DiscoverVibeList({super.key});

  @override
  State<DiscoverVibeList> createState() => _DiscoverVibeListState();
}

class _DiscoverVibeListState extends State<DiscoverVibeList> {
  List list = <MustTriesModel>[
    MustTriesModel(
        imageLink: 'assets/images/discovervibe1.gif',
        text: 'The Ultimate Dining Wishlist'),
    MustTriesModel(
        imageLink: 'assets/images/discovervibe4.gif',
        text: 'A guide to cafe hoping'),
    MustTriesModel(
        imageLink: 'assets/images/discovervibe3.gif', text: 'Legend Inn'),
    MustTriesModel(
        imageLink: 'assets/images/discovervibe2.gif',
        text: 'Roastery Cafe House'),
    MustTriesModel(
        imageLink: 'assets/images/discovervibe5.gif', text: 'Masup Cafe & Bar'),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 200,
                width: 150,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(list[index].imageLink.toString()),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        list[index].text.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
