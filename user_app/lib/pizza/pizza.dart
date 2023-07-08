import 'package:flutter/material.dart';

class Pizza extends StatelessWidget {
  const Pizza({super.key});

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
                    'assets/images/pizza1.jpeg',
                  ),
                ),
                title: Text('Chicken pizza'),
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
                    'assets/images/pizza2.jpeg',
                  ),
                ),
                title: Text('Veg pizza'),
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
                    'assets/images/pizza3.jpeg',
                  ),
                ),
                title: Text('Cheese pizza'),
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
                    'assets/images/pizza8.jpeg',
                  ),
                ),
                title: Text('Lentil and Mushroom pizza.'),
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
                    'assets/images/pizza5.jpeg',
                  ),
                ),
                title: Text('Stuffed Bean pizza.'),
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
                    'assets/images/pizza6.jpeg',
                  ),
                ),
                title: Text('Lamb pizza with Radish Slaw.'),
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
                    'assets/images/pizza7.jpeg',
                  ),
                ),
                title: Text('Potato Corn pizza.'),
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
                    'assets/images/pizza8.jpeg',
                  ),
                ),
                title: Text('Supreme Veggie pizza.'),
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
                    'assets/images/pizza9.jpeg',
                  ),
                ),
                title: Text('Butter Chicken Twin pizza.'),
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
                    'assets/images/pizza10.jpeg',
                  ),
                ),
                title: Text('Rajma Patty pizza.'),
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
                    'assets/images/pizza1.jpeg',
                  ),
                ),
                title: Text('Pizza pizza.'),
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
