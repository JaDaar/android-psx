import 'dart:async';

import 'package:flutter/material.dart';
import 'package:psx/models/psxUserInfo.dart';
import 'package:psx/services/data_service.dart';
import 'package:psx/services/database_service.dart';
import 'package:psx/widgets/accountManagement.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  late DataBase handler;
  List<Map<String, dynamic>> dataList = [];
  DataService ds = DataService();
  @override
  void initState() {
    super.initState();
    //_items = _dataService.getItems();
    handler = DataBase();
  }

  Future<void> refreshData() async {
    // Fetch the updated data from your database or data source
    // For example, if you have a `DatabaseHelper` class:
    List<Map<String, dynamic>> updatedData =
        await handler.retrieveUserAccount();

    // Update your widget's state with the new data
    setState(() {
      // Assign the updated data to your widget's state variables
      // When the user updates the data, edit or delete
      dataList = updatedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account Information'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: handler.retrieveUserAccount(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> dataList = snapshot.data!;
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> row = dataList[index];
                  int id = row['id'];
                  String accountName = row['accountName'];
                  String login = row['login'];
                  String password = row['password'];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(accountName),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(login),
                            SizedBox(height: 4.0),
                            Text(password),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () => edit(PSXUserInfo(
                                          id: id,
                                          accountName: accountName,
                                          login: login,
                                          password: password)),
                                      child: Icon(Icons.edit)),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () => delete(id),
                                      child: Icon(Icons.delete)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
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

  delete(int id) {
    print('Delete Card $id');
    handler.deleteUserAccount(id);
    refreshData();
  }

  edit(PSXUserInfo psxUserInfo) {
    print('edit card $psxUserInfo.id');
    // String newAccountName = psxUserInfo.accountName;
    // String newLogin = psxUserInfo.login;
    // String newPassword = psxUserInfo.password;
    // ds.sendToUI(PSXUserInfo(
    //     id: psxUserInfo.id,
    //     accountName: newAccountName,
    //     login: newLogin,
    //     password: newPassword));

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AccountManagementPage(
                id: psxUserInfo.id,
                accountName: psxUserInfo.accountName,
                login: psxUserInfo.login,
                password: psxUserInfo.password,
              )),
    );
    refreshData();
  }
}
