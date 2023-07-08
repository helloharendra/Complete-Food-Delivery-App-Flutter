import 'package:flutter/material.dart';

class SoftDrink extends StatelessWidget {
  const SoftDrink({super.key});

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
                    'assets/images/siftdrink1.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger2.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger6.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger4.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger11.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger12.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger3.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger7.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger9.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger7.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
                    'assets/images/burger4.jpeg',
                  ),
                ),
                title: Text('Soft Drink'),
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
