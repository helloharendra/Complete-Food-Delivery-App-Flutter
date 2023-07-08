import 'package:flutter/material.dart';

class Cake extends StatelessWidget {
  const Cake({super.key});

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
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/cake1.jpeg',
              ),
            ),
            title: Text('cake'),
            subtitle: Text('Rs. 40 Only'),
            trailing: IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.red,
                )),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/cake2.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake3.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake4.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake5.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake6.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake7.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake8.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake9.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake12.jpeg',
                ),
              ),
              title: Text('cake'),
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
                  'assets/images/cake11.jpeg',
                ),
              ),
              title: Text('cake'),
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
    ));
  }
}
