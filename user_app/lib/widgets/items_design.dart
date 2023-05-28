import 'package:flutter/material.dart';
import 'package:user_app/mainScreens/item_detail_screen.dart';
import 'package:user_app/models/items.dart';

class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({ this.model, this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailsScreen(
                      model: widget.model,
                    )));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.grey[300],
            ),
            Image.network(
              widget.model!.thumbnailUrl!,
              height: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.model!.title!,
              style: const TextStyle(
                  color: Colors.cyan, fontSize: 20, fontFamily: "Train"),
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
