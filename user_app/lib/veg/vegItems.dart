import 'package:flutter/material.dart';

class VegItems1 extends StatelessWidget {
  const VegItems1({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        InkWell(
          // onTap: () {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => const Veg()));
          // },
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/veg1.jpeg'),
                      fit: BoxFit.cover),
                ),
                child: Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(98, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10)),
                  child: Expanded(
                    child: Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, top: 50),
                                  child: Expanded(
                                    child: Text(
                                      '20% off up to Rs.50',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Binze Cakes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 32, 123, 35),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
                                      child: Row(
                                        children: const [
                                          Text(
                                            '3.9',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
        ),
        InkWell(
          // onTap: () {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => const Veg()));
          // },
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/veg2.jpeg'),
                      fit: BoxFit.cover),
                ),
                child: Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(98, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10)),
                  child: Expanded(
                    child: Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, top: 50),
                                  child: Expanded(
                                    child: Text(
                                      '50% off',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Cake Brown Factory',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 32, 123, 35),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
                                      child: Row(
                                        children: const [
                                          Text(
                                            '4.1',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
        ),
        InkWell(
          // onTap: () {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => const Veg()));
          // },
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/veg3.jpeg'),
                      fit: BoxFit.cover),
                ),
                child: Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(98, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10)),
                  child: Expanded(
                    child: Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, top: 50),
                                  child: Expanded(
                                    child: Text(
                                      '20% off up to Rs.50',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Cakes Brand',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 32, 123, 35),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
                                      child: Row(
                                        children: const [
                                          Text(
                                            '4.4',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
        ),
        InkWell(
          // onTap: () {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => const Veg()));
          // },
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/veg4.jpeg'),
                      fit: BoxFit.cover),
                ),
                child: Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(98, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10)),
                  child: Expanded(
                    child: Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, top: 50),
                                  child: Expanded(
                                    child: Text(
                                      '50% ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Cakes Devine',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 32, 123, 35),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
                                      child: Row(
                                        children: const [
                                          Text(
                                            '4.0',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
