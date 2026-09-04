import 'package:flutter/material.dart';

import 'home_page.dart';
import '../community/ask_dierb_page.dart';
import '../marketplace/categories_page.dart';
import '../orders/customer_orders_page.dart';
import '../account/account_page.dart';

class DierbAppShell extends StatefulWidget {
  const DierbAppShell({super.key});

  @override
  State<DierbAppShell> createState() => _DierbAppShellState();
}

class _DierbAppShellState extends State<DierbAppShell> {
  int currentIndex = 0;

  static const labels = ['الرئيسية', 'الأقسام', 'اسأل ديرب', 'طلباتي', 'حسابي'];
  static const icons = [
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.forum_rounded,
    Icons.receipt_long_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          const DierbHomePage(),
          const CategoriesPage(),
          const AskDierbPage(),
          const CustomerOrdersPage(),
          const AccountPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (value) => setState(() => currentIndex = value),
        destinations: List.generate(
          labels.length,
          (index) => NavigationDestination(
            icon: Icon(icons[index]),
            selectedIcon: Icon(icons[index], color: const Color(0xFF166534)),
            label: labels[index],
          ),
        ),
      ),
    );
  }
}
