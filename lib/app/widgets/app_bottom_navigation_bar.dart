import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/discovery/discovery_view.dart';
import 'package:salon_app/app/pages/profile/profile_view.dart';
import 'package:salon_app/app/pages/salons/salons_view.dart';

final navigationItems = [
  {
    'id': 0,
    'key': 'discovery',
    'label': 'Discovery',
    'icon': const Icon(Icons.home),
    'view': () => const DiscoveryView(),
  },
  {
    'id': 1,
    'key': 'salons',
    'label': 'Salons',
    'icon': const Icon(Icons.list),
    'view': () => const SalonsView(),
  },
  {
    'id': 2,
    'key': 'profile',
    'label': 'Profile',
    'icon': const Icon(Icons.person),
    'view': () => const ProfileView(),
  },
];

final navigationItemsIndexed = {
  for (final v in navigationItems) v['key']: v['id']
};

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  void handleTap(context, index) {
    final view = navigationItems[index]['view'] as dynamic;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => view()));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => handleTap(context, index),
        items: navigationItems.map((e) {
          return BottomNavigationBarItem(
            icon: e['icon'] as Widget,
            label: e['label'] as String,
          );
        }).toList());
  }
}
