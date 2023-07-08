import 'package:flutter/material.dart';
import 'package:user_app/dining/MostLovedRestaurentsModel.dart';


class MostLovedRestaurentsList extends StatefulWidget {
  const MostLovedRestaurentsList({super.key});

  @override
  State<MostLovedRestaurentsList> createState() =>
      _MostLovedRestaurentsListState();
}

class _MostLovedRestaurentsListState extends State<MostLovedRestaurentsList> {
  List list = <MostLovedRestaurents>[
    MostLovedRestaurents(
        imageLink: 'assets/images/restaurent10.jpeg',
        rating: '4.1',
        restaurentName: 'Best Choice Of Awadh',
        discounts: '20% FLAT OFF'),
    MostLovedRestaurents(
        imageLink: 'assets/images/restaurent2.jpeg',
        rating: '4.3',
        restaurentName: 'Tunde Kababi',
        discounts: '15% FLAT OFF'),
    MostLovedRestaurents(
        imageLink: 'assets/images/restaurent3.jpeg',
        rating: '4.5',
        restaurentName: 'Skyhilton',
        discounts: '10% FLAT OFF'),
    MostLovedRestaurents(
        imageLink: 'assets/images/restaurent4.jpeg',
        rating: '4.2',
        restaurentName: 'Tunde Kababi',
        discounts: '20% FLAT OFF'),
    MostLovedRestaurents(
        imageLink: 'assets/images/restaurent5.jpeg',
        rating: '4.0',
        restaurentName: 'Theka-The Piccadily',
        discounts: '30% FLAT OFF'),
    MostLovedRestaurents(
        imageLink: 'assets/images/restaurent6.jpeg',
        rating: '4.4',
        restaurentName: 'Punjabi-The Piccadily',
        discounts: '15% FLAT OFF'),
    MostLovedRestaurents(
        imageLink: 'assets/images/restaurent1.jpeg',
        rating: '4.3',
        restaurentName: 'Cheer N Beers',
        discounts: '20% FLAT OFF'),
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
                height: 120,
                width: 200,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(list[index].imageLink.toString()),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 9, 133, 13),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                list[index].rating.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                list[index].restaurentName.toString(),
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                list[index].discounts.toString(),
                style: const TextStyle(color: Color.fromARGB(255, 5, 108, 242)),
              ),
            ],
          ),
        );
      },
    );
  }
}
