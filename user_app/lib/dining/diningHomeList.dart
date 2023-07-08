import 'package:flutter/material.dart';

import 'package:user_app/dining/diningHomeModel.dart';

class DiningHomeList extends StatefulWidget {
  const DiningHomeList({super.key});

  @override
  State<DiningHomeList> createState() => _DiningHomeListState();
}

class _DiningHomeListState extends State<DiningHomeList> {
  List<DiningHomeModel> list1 = [
    DiningHomeModel(
        imageLInk: 'assets/images/restaurent3.jpeg',
        restaurentName: 'Skyhilton',
        restaurentDiscount: '15% off',
        distance: '10 m away',
        rating: '4.1'),
    DiningHomeModel(
        imageLInk: 'assets/images/restaurent2.jpeg',
        restaurentName: 'Best Choice Of Awadh',
        restaurentDiscount: '25% off',
        distance: '15 m away',
        rating: '4.3'),
    DiningHomeModel(
        imageLInk: 'assets/images/restaurent4.jpeg',
        restaurentName: 'Theka-The Piccadily',
        restaurentDiscount: '20% off',
        distance: '50 m away',
        rating: '4.5'),
    DiningHomeModel(
        imageLInk: 'assets/images/restaurent5.jpeg',
        restaurentName: 'Punjab-The Piccadily',
        restaurentDiscount: '30% off',
        distance: '100 m away',
        rating: '4.2'),
    DiningHomeModel(
        imageLInk: 'assets/images/restaurent1.jpeg',
        restaurentName: 'Cheers N Beers',
        restaurentDiscount: '10% off',
        distance: '500 m away',
        rating: '4.6'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list1.length,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 200,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 224, 224, 224),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(children: [
                    Container(
                      height: 200,
                      width: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 223, 223, 223)),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: const Color.fromARGB(255, 254, 254, 255)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list1[index].restaurentName.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                list1[index].distance.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
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
                                      list1[index].rating.toString(),
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
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromARGB(255, 223, 223, 223)),
                              color: const Color.fromARGB(255, 240, 240, 246),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                TextButton(
                                  onPressed: null,
                                  child: Text(
                                    'Pay bill',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.red,
                                )
                              ],
                            ))
                      ],
                    )
                  ]),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              height: 200,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: const Color.fromARGB(255, 223, 223, 223)),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage(list1[index].imageLInk.toString()),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FLAT ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      list1[index].restaurentDiscount.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
