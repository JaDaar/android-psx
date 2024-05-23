import 'dart:async';

import 'package:flutter/material.dart';
import 'package:psx/models/psxUserInfo.dart';
import 'package:psx/services/data_service.dart';

class AccountList extends StatefulWidget {
  const AccountList({super.key});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final DataService _dataService = DataService();

  List<PSXUserInfo> _items = [];

  @override
  void initState() {
    super.initState();
    _items = _dataService.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(_items[index].accountName),
            subtitle: Column(children: [
              Text(_items[index].login),
              Text(_items[index].password),
            ]));
      },
    );
  }
}
