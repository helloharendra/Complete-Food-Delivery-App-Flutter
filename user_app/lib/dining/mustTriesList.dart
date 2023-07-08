import 'package:flutter/material.dart';
import 'package:user_app/dining/mustTriesModel.dart';

class MustTriesList extends StatefulWidget {
  const MustTriesList({super.key});

  @override
  State<MustTriesList> createState() => _MustTriesListState();
}

class _MustTriesListState extends State<MustTriesList> {
  List list = <MustTriesModel>[
    MustTriesModel(
        imageLink: 'assets/images/restaurent10.jpeg',
        text: '8 Best Insta-Worthly Places'),
    MustTriesModel(
        imageLink: 'assets/images/restaurent9.jpeg',
        text: '12 Must-Visit Legendary Places'),
    MustTriesModel(
        imageLink: 'assets/images/restaurent8.jpeg',
        text: '5 Places For Smoky Kebabs'),
    MustTriesModel(
        imageLink: 'assets/images/restaurent6.jpeg',
        text: '10 Best Bars & Pubs'),
    MustTriesModel(
        imageLink: 'assets/images/restaurent5.jpeg',
        text: '8 Serene Rooftop Places'),
    MustTriesModel(
        imageLink: 'assets/images/restaurent4.jpeg',
        text: '8 Place For BingeWorthy Desserts'),
    MustTriesModel(
        imageLink: 'assets/images/restaurent3.jpeg', text: '5 Flavourful Thali')
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        list[index].text.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
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
