import 'package:flutter/material.dart';

import '../models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({
    super.key,
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Container(
          height: 165,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                width: 100,
                height: 120,
              ),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "kiwi",
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    children: [
                      const Text(
                        "x",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Acme",
                        ),
                      ),
                      Text(
                        widget.quanNumber.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Acme",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Price",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      const Text(
                        "₹",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.blue),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
