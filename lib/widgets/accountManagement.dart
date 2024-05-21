import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psx/models/psxUserInfo.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  var pageNavigationIndex = 0;
  final psxAccountNameController = TextEditingController();
  final psxNameController = TextEditingController();
  // Create a TextEditingController for passwords
  final psxController = TextEditingController();
  final psxValidationController = TextEditingController();
  List<PSXUserInfo> psxUserInfo = [];

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

  void saveAndClearControls() {
    //save into array
    var record = PSXUserInfo(
        accountName: psxAccountName, login: psxNameText, password: psxCodeText);
    psxUserInfo.add(record);

    // Clear Controls of Data
    psxAccountName = '';
    psxAccountNameController.text = '';
    psxCodeText = '';
    psxCodeValidationText = '';
    psxNameText = '';
    psxNameController.text = '';
    psxController.text = '';
    psxValidationController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (pageNavigationIndex) {
      case 0:
        page = Placeholder();
        break;
      case 1:
        //page = Placeholder(); // a flutter page for helping in development
        page = AccountManagementPage();
        break;
      default:
        throw UnimplementedError('no widget for $pageNavigationIndex');
    }

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
