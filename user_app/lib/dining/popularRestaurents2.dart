import 'package:flutter/material.dart';

import 'package:user_app/dining/PopularRestaurentItemsModel.dart';

import '../burger/Burger.dart';

class PopularRestaurent2 extends StatefulWidget {
  const PopularRestaurent2({super.key});

  @override
  State<PopularRestaurent2> createState() => _PopularRestaurent2State();
}

class _PopularRestaurent2State extends State<PopularRestaurent2> {
  List list1 = <PopularRestaurentItemsModel>[
    PopularRestaurentItemsModel(
        restaurentImage: 'assets/images/restaurent3.jpeg',
        restaurentName: 'Royal Bar & Cafe',
        restaurentItemPrice: '500 for one',
        restaurentAddress: 'Alambag Lucknow',
        restaurentDistance: '10 km',
        restaurentRating: '4.3',
        restaurentItemCategory: 'Wines'),
    PopularRestaurentItemsModel(
        restaurentImage: 'assets/images/restaurent6.jpeg',
        restaurentName: 'Awadh Restaurent',
        restaurentItemPrice: '250 for one',
        restaurentAddress: 'Alambag Lucknow',
        restaurentDistance: '2 km',
        restaurentRating: '4.5',
        restaurentItemCategory: 'Pure Veg'),
    PopularRestaurentItemsModel(
        restaurentImage: 'assets/images/restaurent9.jpeg',
        restaurentName: 'JB Celebrations',
        restaurentItemPrice: '300 for one',
        restaurentAddress: 'Alambag Lucknow',
        restaurentDistance: '100 m',
        restaurentRating: '4.5',
        restaurentItemCategory: 'Mithai & StreetFood'),
    PopularRestaurentItemsModel(
        restaurentImage: 'assets/images/restaurent1.jpeg',
        restaurentName: 'Beer N Cheer ',
        restaurentItemPrice: '250 for one',
        restaurentAddress: 'Alambag Lucknow',
        restaurentDistance: '1 km',
        restaurentRating: '4.0',
        restaurentItemCategory: 'Beers & Drinks'),
    PopularRestaurentItemsModel(
        restaurentImage: 'assets/images/restaurent8.jpeg',
        restaurentName: 'Skyhilton',
        restaurentItemPrice: '300 for one',
        restaurentAddress: 'Alambag Lucknow',
        restaurentDistance: '5 km',
        restaurentRating: '4.5',
        restaurentItemCategory: 'Family Restaurents'),
  ];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: list1.length,
      scrollBehavior: null,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Burger(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
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
                                  color: const Color.fromARGB(255, 14, 159, 19),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      list1[index].restaurentRating.toString(),
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
                                child: Text(
                                    list1[index].restaurentAddress.toString())),
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
        );
      },
    );
  }
}
