import 'package:flutter/material.dart';

import 'package:user_app/restaurent/restaurent1Model.dart';

import '../mainScreens/search_screen.dart';

class Restaurent5 extends StatefulWidget {
  const Restaurent5({super.key});

  @override
  State<Restaurent5> createState() => _Restaurent5State();
}

class _Restaurent5State extends State<Restaurent5> {
  List list1 = <Restaurent1Model>[
    Restaurent1Model(
        imageLink: 'assets/images/burger1.jpeg',
        restaurentItemNameAndPrice: 'Chilli Paneer Rs.295',
        icon1: (Icons.favorite_border_outlined),
        restaurentName: 'MC Donald',
        restaurentItemCategory: 'Pure Veg. North Indian .Chinese',
        restaurentItemCategoryIcon: Icons.energy_savings_leaf,
        restaurentRating: '4.0',
        restaurentDiscount: '40 % off up to Rs.100',
        deliveryTiming: '40-50 min.',
        restaurentDistance: '10 km',
        restaurentPrice: 'Rs 250 for one'),
    Restaurent1Model(
        imageLink: 'assets/images/burger2.jpeg',
        restaurentItemNameAndPrice: 'Chilli Paneer Rs.295',
        icon1: (Icons.favorite_border_outlined),
        restaurentName: 'MC Donald',
        restaurentItemCategory: 'Pure Veg',
        restaurentItemCategoryIcon: Icons.energy_savings_leaf,
        restaurentRating: '4.0',
        restaurentDiscount: '40 % off up to Rs.100',
        deliveryTiming: '40-50 min.',
        restaurentDistance: '10 km',
        restaurentPrice: 'Rs 250 for one'),
    Restaurent1Model(
        imageLink: 'assets/images/burger3.jpeg',
        restaurentItemNameAndPrice: 'Chilli Paneer Rs.295',
        icon1: (Icons.favorite_border_outlined),
        restaurentName: 'MC Donald',
        restaurentItemCategory: 'Pure Veg',
        restaurentItemCategoryIcon: Icons.energy_savings_leaf,
        restaurentRating: '4.0',
        restaurentDiscount: '40 % off up to Rs.100',
        deliveryTiming: '40-50 min.',
        restaurentDistance: '10 km',
        restaurentPrice: 'Rs 250 for one'),
    Restaurent1Model(
        imageLink: 'assets/images/burger4.jpeg',
        restaurentItemNameAndPrice: 'Chilli Paneer Rs.295',
        icon1: (Icons.favorite_border_outlined),
        restaurentName: 'MC Donald',
        restaurentItemCategory: 'Pure Veg',
        restaurentItemCategoryIcon: Icons.energy_savings_leaf,
        restaurentRating: '4.0',
        restaurentDiscount: '40 % off up to Rs.100',
        deliveryTiming: '40-50 min.',
        restaurentDistance: '10 km',
        restaurentPrice: 'Rs 250 for one'),
    Restaurent1Model(
        imageLink: 'assets/images/burger6.jpeg',
        restaurentItemNameAndPrice: 'Chilli Paneer Rs.295',
        icon1: (Icons.favorite_border_outlined),
        restaurentName: 'MC Donald',
        restaurentItemCategory: 'Pure Veg',
        restaurentItemCategoryIcon: Icons.energy_savings_leaf,
        restaurentRating: '4.0',
        restaurentDiscount: '40 % off up to Rs.100',
        deliveryTiming: '40-50 min.',
        restaurentDistance: '10 km',
        restaurentPrice: 'Rs 250 for one'),
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
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
                                    list1[index].imageLink.toString()),
                                fit: BoxFit.cover),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(110, 7, 7, 7),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              139, 9, 9, 9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          list1[index]
                                              .restaurentItemNameAndPrice
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        alignment: Alignment.topRight,
                                        onPressed: null,
                                        icon: Icon(
                                          list1[index].icon1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          list1[index]
                                              .restaurentName
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      list1[index].restaurentItemCategoryIcon,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    Expanded(
                                      child: Text(
                                        list1[index]
                                            .restaurentItemCategory
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 23,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 14, 159, 19),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                list1[index]
                                                    .restaurentRating
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Icon(
                                                Icons.star,
                                                color: Colors.white,
                                                size: 15,
                                              )
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const Icon(Icons.access_alarm_rounded),
                              const Expanded(
                                child: Text(
                                  '45-50 min . 9km',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                list1[index].restaurentPrice,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //stack item two start from here
              Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 183, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 140, 255),
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.percent_sharp,
                          color: Colors.white,
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "40% off up to Rs.100",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 5, 111, 199),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(items: const [
                              DropdownMenuItem(
                                child: Text(
                                  '+1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ], onChanged: null),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
