import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:psx/services/data_service.dart';
import 'package:psx/widgets/accountList.dart';

import 'package:psx/widgets/accountManagement.dart';

void main() {
  runApp(const MyApp()); // Replace 'MyApp' with your app's class name
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan.shade900),
        ),
        home: LandingPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var navigationLandingIndex = 0;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _dataService.setPsxUserInfo([]);
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (navigationLandingIndex) {
      case 0:
        page = Placeholder();
        break;
      case 1:
        page = AccountList();
        break;
      case 2:
        //page = Placeholder(); // a flutter page for helping in development
        page = AccountManagementPage();
        break;
      default:
        throw UnimplementedError('no widget for $navigationLandingIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('List'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  label: Text('List'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.lock),
                  label: Text('Add'),
                ),
              ],
              selectedIndex: navigationLandingIndex,
              onDestinationSelected: (value) {
                setState(() {
                  navigationLandingIndex = value;
                });
                print(
                    'the navigationrail index has been updated to $navigationLandingIndex');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
