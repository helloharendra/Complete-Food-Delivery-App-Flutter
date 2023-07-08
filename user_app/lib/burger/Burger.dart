import 'package:flutter/material.dart';

class Burger extends StatefulWidget {
  const Burger({super.key});

  @override
  State<Burger> createState() => BurgerState();
}

class BurgerState extends State<Burger> {
  String error = '';
  int item = 0;
  void increment() {
    if (item < 9) {
      item++;
    }
    setState(() {});
  }

  void decrement() {
    if (item > 0) {
      item--;
    }
    setState(() {});
  }

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
          actions: [
            InkWell(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const CartItem()));
              },
              child: const Icon(Icons.shopping_cart),
            )
          ],
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger1.jpeg',
                ),
              ),
              title: const Text('Chicken Burger'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger2.jpeg',
                ),
              ),
              title: const Text('Veg Burger'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger6.jpeg',
                ),
              ),
              title: const Text('Cheese Burger'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger4.jpeg',
                ),
              ),
              title: const Text('Lentil and Mushroom Burger.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger11.jpeg',
                ),
              ),
              title: const Text('Stuffed Bean Burger.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger12.jpeg',
                ),
              ),
              title: const Text('Lamb Burger with Radish Slaw.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger3.jpeg',
                ),
              ),
              title: const Text('Potato Corn Burger.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger7.jpeg',
                ),
              ),
              title: const Text('Supreme Veggie Burger.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger9.jpeg',
                ),
              ),
              title: const Text('Butter Chicken Twin Burgers.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger7.jpeg',
                ),
              ),
              title: const Text('Rajma Patty Burger.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/burger4.jpeg',
                ),
              ),
              title: const Text('Pizza Burger.'),
              subtitle: const Text('Rs. 40 Only'),
              trailing: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: decrement,
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
