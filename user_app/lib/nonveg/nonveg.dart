import 'package:flutter/material.dart';

class NonVeg extends StatelessWidget {
  const NonVeg({super.key});

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
                    'assets/images/nonveg1.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg2.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg3.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg4.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg5.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg6.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg7.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg8.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg10.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg11.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
                    'assets/images/nonveg8.jpeg',
                  ),
                ),
                title: Text('nonveg'),
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
    ;
  }
}
