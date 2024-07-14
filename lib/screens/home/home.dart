import 'package:flutter/material.dart';

// screens
import 'books.dart';
import 'Bookshelves.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showAppbar = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setShowAppbar(bool state) {
    setState(() {
      showAppbar = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppbar
          ? AppBar(
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                        ),
                      ),
                      child: TabBar(
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        indicatorPadding: const EdgeInsets.only(bottom: 15),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Theme.of(context).colorScheme.onBackground,
                        indicatorWeight: 2,
                        automaticIndicatorColorAdjustment: false,
                        controller: _tabController,
                        tabs: [
                          Tab(
                              child: Text(
                            "책",
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                          Tab(
                              child: Text(
                            "책장",
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : null,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          BookScreen(setShowAppbar: _setShowAppbar),
          const BookshelfScreen(),
        ],
      ),
    );
  }
}
