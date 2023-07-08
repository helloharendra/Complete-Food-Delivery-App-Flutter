import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    Material(
      child: PageView(
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 245, 107, 97),
                size: 40,
              ),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      title: Text(
                        'Sector B',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Bargawan,LDA Colony,Lucknow'),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0, top: 8),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 220, 218, 218)),
                  child: const Icon(Icons.g_translate),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView(
                    children: const [
                      ListTile(
                        trailing: 
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile.jpeg'),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
