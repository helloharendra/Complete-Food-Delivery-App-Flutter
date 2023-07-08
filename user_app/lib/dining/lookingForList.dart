import 'package:flutter/material.dart';

import 'package:user_app/dining/lookingForModel.dart';

class LookingForList extends StatefulWidget {
  const LookingForList({super.key});

  @override
  State<LookingForList> createState() => _LookingForListState();
}

class _LookingForListState extends State<LookingForList> {
  List list1 = <LookingForModel>[
    LookingForModel(
        name: 'Nightlife & Drinks',
        imageLink: 'assets/images/restaurent1.jpeg'),
    LookingForModel(
        name: 'Family Dining', imageLink: 'assets/images/restaurent2.jpeg'),
    LookingForModel(
        name: 'Dinner', imageLink: 'assets/images/restaurent3.jpeg'),
  ];
  List list2 = <LookingForModel>[
    LookingForModel(
        name: 'Romantic Places', imageLink: 'assets/images/restaurent4.jpeg'),
    LookingForModel(
        name: 'Indoor Dining', imageLink: 'assets/images/restaurent5.jpeg'),
    LookingForModel(
        name: 'Outdoor Dining', imageLink: 'assets/images/restaurent6.jpeg'),
  ];
  List list3 = <LookingForModel>[
    LookingForModel(
        name: 'Newly Opened ', imageLink: 'assets/images/restaurent8.jpeg'),
    LookingForModel(name: 'Deserts', imageLink: 'assets/images/cake1.jpeg'),
    LookingForModel(
        name: 'Events', imageLink: 'assets/images/restaurent10.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list1.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            list1[index].imageLink.toString(),
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      list1[index].name.toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(227, 33, 32, 32),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            list2[index].imageLink.toString(),
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      list2[index].name.toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(227, 33, 32, 32),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            list3[index].imageLink.toString(),
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      list3[index].name.toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(227, 33, 32, 32),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
