import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_nav_bottom.dart';
import '../service/shared_service/bottom_shared_service.dart';

import 'bottom_sheet_pages/account/account.dart';
import 'bottom_sheet_pages/all_tickets/screens/all_tickets.dart';
import 'bottom_sheet_pages/home/home.dart';

class MainActivityPage extends StatefulWidget {
  final int initialIndex; // Add this parameter

  const MainActivityPage({
    super.key,
    this.initialIndex = 0, // Default to first tab
  });

  @override
  State<MainActivityPage> createState() => _MainActivityPageState();
}

class _MainActivityPageState extends State<MainActivityPage> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Set the initial index when the widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final counter = Provider.of<ModelProviders>(context, listen: false);
      counter.changeCounter(widget.initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelProviders>(
      builder: (context, counter, child) {
        List<Widget> bottomNavPages = [
          HomeScreen(),
          AllTicketHomeScreen(),
          AccountScreen(),
        ];

        return Scaffold(
          body: bottomNavPages[counter.bottomCounter],
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: counter.bottomCounter,
            onTap: (index) {
              counter.changeCounter(index);
            },
          ),
        );
      },
    );
  }
}
