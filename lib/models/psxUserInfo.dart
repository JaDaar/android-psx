class PSXUserInfo {
  final int id;
  String accountName;
  String login;
  String password;

  PSXUserInfo(
      {required this.id,
      required this.accountName,
      required this.login,
      required this.password});

  @override
  String toString() {
    return 'PSXAccount{id: $id, accountName: $accountName, login: $login, password: $password}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'login': login,
      'password': password,
    };
  }

  factory PSXUserInfo.fromMap(Map<String, dynamic> map) {
    return PSXUserInfo(
      id: map['id'],
      accountName: map['accountName'],
      login: map['login'],
      password: map['password'],
    );
  }
}
