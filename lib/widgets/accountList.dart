import 'dart:async';

import 'package:flutter/material.dart';
import 'package:psx/models/psxUserInfo.dart';
import 'package:psx/services/data_service.dart';
import 'package:psx/widgets/accountManagement.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final DataService _dataService = DataService();

  List<PSXUserInfo> _items = [];

  @override
  void initState() {
    super.initState();
    _items = _dataService.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account Information'),
        ),
        body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _items[index].accountName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_items[index].login),
                    SizedBox(height: 4.0),
                    Text(_items[index].password),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountManagementPage()),
              );
            },
            child: Icon(Icons.add)));
  }
}
