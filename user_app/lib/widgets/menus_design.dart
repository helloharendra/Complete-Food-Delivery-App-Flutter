import 'package:flutter/material.dart';
import 'package:user_app/mainScreens/items_screen.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/models/sellers.dart';

class MenusDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  MenusDesignWidget({super.key, this.model, this.context});

  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ItemsScreen(model:widget.model)));
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
            Image.network(
              widget.model!.thumbnailUrl!,
              height: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.model!.menuTitle!,
              style: const TextStyle(
                  color: Colors.cyan, fontSize: 20, fontFamily: "Train"),
            ),
            Text(
              widget.model!.menuInfo!,
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
