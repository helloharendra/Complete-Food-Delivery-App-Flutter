import 'package:flutter/material.dart';

import 'package:user_app/dining/popularRestaurentModel.dart';

class PopularRestaurent extends StatefulWidget {
  const PopularRestaurent({super.key});

  @override
  State<PopularRestaurent> createState() => PopularRestaurentState();
}

class PopularRestaurentState extends State<PopularRestaurent> {
  List<PopularRestaurentModel> list1 = [
    PopularRestaurentModel(
        restaurentImage: 'assets/images/restaurent1.jpeg',
        restaurentName: 'Beers N Cheers',
        restaurentRating: '4.1',
        restaurentItemCategory: 'Beer,Bar',
        restaurentItemPrice: '300 for one',
        restaurentAdderess: 'Alambag Lucknow',
        restaurentDistance: '2 km'),
    PopularRestaurentModel(
        restaurentImage: 'assets/images/restaurent2.jpeg',
        restaurentName: 'JB Celebrations',
        restaurentRating: '3.5',
        restaurentItemCategory: 'Mithai,Street Food',
        restaurentItemPrice: '300 for one',
        restaurentAdderess: 'Alambag Lucknow',
        restaurentDistance: '110 m'),
    PopularRestaurentModel(
        restaurentImage: 'assets/images/restaurent3.jpeg',
        restaurentName: 'Royal Bar & Cafe',
        restaurentRating: '3.9',
        restaurentItemCategory: 'Mithai,Street Food',
        restaurentItemPrice: '300 for one',
        restaurentAdderess: 'Alambag Lucknow',
        restaurentDistance: '1 km'),
    PopularRestaurentModel(
        restaurentImage: 'assets/images/restaurent4.jpeg',
        restaurentName: 'Awadh Restaurent',
        restaurentRating: '4.0',
        restaurentItemCategory: 'Non-Veg',
        restaurentItemPrice: '300 for one',
        restaurentAdderess: 'Alambag Lucknow',
        restaurentDistance: '3 km'),
    PopularRestaurentModel(
        restaurentImage: 'assets/images/restaurent5.jpeg',
        restaurentName: 'Skyhilton',
        restaurentRating: '4.5',
        restaurentItemCategory: 'Restaurent & Bar',
        restaurentItemPrice: '300 for one',
        restaurentAdderess: 'Alambag Lucknow',
        restaurentDistance: '110 m')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list1.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const Burger(),
                //   ),
                // );
              },
              child: Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color: const Color.fromARGB(255, 226, 226, 226)),
                    color: const Color.fromARGB(255, 255, 253, 253),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  list1[index].restaurentImage.toString()),
                              fit: BoxFit.cover),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                list1[index].restaurentName.toString(),
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 14, 159, 19),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        list1[index]
                                            .restaurentRating
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(list1[index]
                                      .restaurentItemCategory
                                      .toString())),
                              Text(
                                list1[index].restaurentItemPrice.toString(),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(list1[index]
                                      .restaurentAdderess
                                      .toString())),
                              Text(list1[index].restaurentDistance.toString())
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
