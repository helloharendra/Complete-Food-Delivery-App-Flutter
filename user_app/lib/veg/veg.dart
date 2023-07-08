import 'package:flutter/material.dart';

class Veg extends StatefulWidget {
  const Veg({super.key});

  @override
  State<Veg> createState() => _VegState();
}

class _VegState extends State<Veg> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          toolbarHeight: 30,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg1.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    selectedIcon: Icon(
                      Icons.shopping_cart,
                      color: Colors.red,
                    ),
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg2.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg3.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg4.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg5.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg6.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg7.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg8.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg9.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg10.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/veg1.jpeg',
                  ),
                ),
                title: Text('veg'),
                subtitle: Text('Rs. 40 Only'),
                trailing: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
