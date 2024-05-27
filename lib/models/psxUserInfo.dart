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
}
