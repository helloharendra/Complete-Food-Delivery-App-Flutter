import 'package:flutter/material.dart';

import '../mainScreens/search_screen.dart';
import 'cakeItemsModel.dart';

class CakeItems1 extends StatefulWidget {
  const CakeItems1({super.key});

  @override
  State<CakeItems1> createState() => _CakeItems1State();
}

class _CakeItems1State extends State<CakeItems1> {
  List list1 = <CakeItemsModel>[
    CakeItemsModel(
        cakeImageLink: 'assets/images/cake1.jpeg',
        name: 'Cake Brown Factory',
        cakeRating: '4.0',
        cakeDiscount: '10% OFF up to 150'),
    CakeItemsModel(
        cakeImageLink: 'assets/images/cake2.jpeg',
        name: 'Binze Cake',
        cakeRating: '3.9',
        cakeDiscount: '20% OFF up to 100'),
    CakeItemsModel(
        cakeImageLink: 'assets/images/cake3.jpeg',
        name: 'Cake Brand  ',
        cakeRating: '4.0',
        cakeDiscount: '30% OFF up to 250'),
  ];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: list1.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 150,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(list1[index].cakeImageLink.toString()),
                  fit: BoxFit.cover),
            ),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(125, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list1[index].cakeDiscount.toString(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  list1[index].name.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                // margin: const EdgeInsets.only(left: 80),
                                height: 23,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 14, 159, 19),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        list1[index].cakeRating.toString(),
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
                        ],
                      ),
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
