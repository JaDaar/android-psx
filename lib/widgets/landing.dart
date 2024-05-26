import 'package:flutter/material.dart';
import 'package:psx/services/data_service.dart';
import 'package:psx/widgets/accountList.dart';
import 'package:psx/widgets/accountManagement.dart';
import 'package:psx/widgets/homescreen.dart';

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
        //page = Placeholder();
        page = HomeScreen();
        break;
      case 1:
        page = AccountListPage();
        break;
      case 2:
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
