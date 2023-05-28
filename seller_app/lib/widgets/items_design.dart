import 'package:flutter/material.dart';
import 'package:seller_app/mainScreens/item_detail_screen.dart';
import 'package:seller_app/mainScreens/itemsScreen.dart';
import 'package:seller_app/model/items.dart';
import 'package:seller_app/model/menus.dart';

class ItemDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemDesignWidget({super.key, this.model, this.context});

  @override
  State<ItemDesignWidget> createState() => _ItemDesignWidgetState();
}

class _ItemDesignWidgetState extends State<ItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>ItemDetailsScreen (model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              widget.model!.title!,
              style: const TextStyle(
                  color: Colors.cyan, fontSize: 18, fontFamily: "Train"),
            ),
            const SizedBox(
              height: 2,
            ),
            Image.network(
              widget.model!.thumbnailUrl!,
              height: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              widget.model!.shortInfo!,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 20, fontFamily: "Train"),
            ),
            Divider(
              height: 4,
              thickness: 2,
              color: Colors.grey[300],
            )
          ]),
        ),
      ),
    );
  }
}
