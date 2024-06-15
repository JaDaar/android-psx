import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psx/main.dart';
import 'package:psx/models/psxUserInfo.dart';
import 'package:psx/services/data_service.dart';
import 'package:psx/services/database_service.dart';
import 'package:psx/widgets/accountList.dart';
import 'package:psx/widgets/homescreen.dart';
import 'package:psx/widgets/landing.dart';

class AccountManagementPage extends StatefulWidget {
  final int id;
  final String accountName;
  final String login;
  final String password;
  const AccountManagementPage({
    super.key,
    this.id = -1,
    this.accountName = '',
    this.login = '',
    this.password = '',
  });

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  late DataBase handler;
  final DataService _dataService = DataService();
  var pageNavigationIndex = 0;
  late TextEditingController psxAccountNameController;
  late TextEditingController psxNameController;
  late TextEditingController psxController = TextEditingController();
  late TextEditingController psxValidationController = TextEditingController();

  bool _obscureText = true;
  bool _obscureTextValidation = true;

  String psxAccountName = '';
  String psxCodeText = '';
  String psxCodeValidationText = '';
  String psxNameText = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    psxAccountNameController.dispose();
    psxController.dispose();
    psxNameController.dispose();
    psxValidationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    psxAccountNameController = TextEditingController(text: widget.accountName);
    psxNameController = TextEditingController(text: widget.login);
    psxController = TextEditingController(text: widget.password);
    psxValidationController = TextEditingController(text: widget.password);
    handler = DataBase();
  }

  bool validatePasswords() {
    var result = false;
    if (psxCodeText.toLowerCase().trim() ==
        psxCodeValidationText.toLowerCase().trim()) {
      result = true;
    }
    return result;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  IconData _getIconData() {
    return _obscureText ? Icons.visibility : Icons.visibility_off;
  }

  void _toggleObscureTextValidation() {
    setState(() {
      _obscureTextValidation = !_obscureTextValidation;
    });
  }

  IconData _getIconDataValidation() {
    return _obscureTextValidation ? Icons.visibility : Icons.visibility_off;
  }

  Future<void> saveAndClearControls() async {
    if (widget.id != null && widget.id > 0) {
      // Retrieve the existing record from the database
      PSXUserInfo? existingRecord =
          await handler.getUserAccountById(widget.id!);

      if (existingRecord != null) {
        // Update the fields with the modified values
        existingRecord.accountName = psxAccountName.isNotEmpty
            ? psxAccountName
            : existingRecord.accountName;
        existingRecord.login =
            psxNameText.isNotEmpty ? psxNameText : existingRecord.login;
        existingRecord.password =
            psxCodeText.isNotEmpty ? psxCodeText : existingRecord.password;

        // Update the existing record in the database
        await handler.updateUserAccount(existingRecord);
      }
    } else {
      // Add new record
      var newRecord = PSXUserInfo(
        id: 0, // Set the id to null for new records
        accountName: psxAccountName,
        login: psxNameText,
        password: psxCodeText,
      );
      await handler.addUserAccount(newRecord);
    }

    // Clear the text controllers and navigate back
    psxAccountNameController.clear();
    psxNameController.clear();
    psxController.clear();
    psxValidationController.clear();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PSX Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: psxAccountNameController,
              onChanged: (value) => setState(() {
                psxAccountName = value;
              }),
              decoration: const InputDecoration(hintText: 'Enter Account Name'),
            ),
            TextField(
              controller: psxNameController,
              onChanged: (value) => setState(() {
                psxNameText = value;
              }),
              decoration: const InputDecoration(hintText: 'Enter login name'),
            ),
            TextField(
              controller: psxController,
              obscureText: _obscureText,
              onChanged: (value) => setState(() {
                psxCodeText = value;
              }),
              decoration: InputDecoration(
                hintText: 'Enter password...',
                suffixIcon: IconButton(
                  icon: Icon(_getIconData()),
                  onPressed: _toggleObscureText,
                ),
              ),
            ),
            TextField(
              controller: psxValidationController,
              obscureText: _obscureTextValidation,
              onChanged: (value) => setState(() {
                psxCodeValidationText = value;
              }),
              decoration: InputDecoration(
                hintText: 'Re-Enter password for validation...',
                suffixIcon: IconButton(
                  icon: Icon(_getIconDataValidation()),
                  onPressed: _toggleObscureTextValidation,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                  onPressed: psxController.text.isNotEmpty &&
                          psxNameController.text.isNotEmpty &&
                          psxAccountNameController.text.isNotEmpty &&
                          validatePasswords()
                      ? () {
                          Fluttertoast.showToast(
                            msg: "Login and Password Information Saved",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          saveAndClearControls();
                        }
                      : null,
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
