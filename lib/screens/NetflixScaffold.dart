import 'package:flutter/material.dart';
import 'package:movie_app/api/globals.dart';

import '../widgets/netflix_bottom_navigation.dart';

class NetflixScaffold extends StatelessWidget {
  const NetflixScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: Globals.scaffoldMessengerKey,
            body: child,
            bottomNavigationBar: const NextflixBottomNavigation()));
  }
}
