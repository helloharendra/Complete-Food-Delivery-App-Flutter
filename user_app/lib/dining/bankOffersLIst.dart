import 'package:flutter/material.dart';

import 'bankOffersModel.dart';

class BankOffersList extends StatefulWidget {
  const BankOffersList({super.key});

  @override
  State<BankOffersList> createState() => _BankOffersListState();
}

class _BankOffersListState extends State<BankOffersList> {
  List list = <BankOffersModel>[
    BankOffersModel(
      imageLink: 'assets/images/simple.png',
      bankOffers: 'Get 10% OFF upto Rs.150',
      color: const Color.fromARGB(57, 214, 250, 245),
      borderColor: const Color.fromARGB(255, 2, 206, 179),
    ),
    BankOffersModel(
      imageLink: 'assets/images/paytmwallet.png',
      bankOffers: '5% cashback upto Rs.125',
      color: const Color.fromARGB(90, 204, 236, 255),
      borderColor: const Color.fromARGB(255, 0, 142, 250),
    ),
    BankOffersModel(
      imageLink: 'assets/images/paytmpostpaid.jpeg',
      bankOffers: '10% cashback upto Rs.300',
      color: const Color.fromARGB(90, 204, 236, 255),
      borderColor: const Color.fromARGB(255, 0, 142, 250),
    ),
    BankOffersModel(
      imageLink: 'assets/images/hsbc.png',
      bankOffers: 'Get 20% OFF upto Rs.750',
      color: const Color.fromARGB(90, 252, 208, 202),
      borderColor: const Color.fromARGB(255, 255, 78, 78),
    ),
    BankOffersModel(
      imageLink: 'assets/images/mobikwik.png',
      bankOffers: 'Get Flat Rs. 100 OFF',
      color: const Color.fromARGB(90, 200, 197, 253),
      borderColor: const Color.fromARGB(255, 56, 82, 255),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 200,
              width: 130,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: list[index].color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    list[index].imageLink.toString(),
                  ),
                  Text(
                    list[index].bankOffers.toString(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              height: 200,
              width: 130,
              decoration: BoxDecoration(
                color: list[index].color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: list[index].borderColor),
              ),
            ),
            // Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         margin: const EdgeInsets.all(0),
            //         width: 20,
            //         decoration: BoxDecoration(
            //             border: Border.all(
            //                 width: 1, color: list[index].borderColor),
            //             color: const Color.fromARGB(255, 250, 248, 248),
            //             shape: BoxShape.circle),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 110),
            //         width: 20,
            //         decoration: BoxDecoration(
            //             border: Border.all(
            //                 width: 1, color: list[index].borderColor),
            //             color: const Color.fromARGB(255, 250, 248, 248),
            //             shape: BoxShape.circle),
            //       )
            //     ],
            //   ),
            // )
          ],
        );
      },
    );
  }
}
