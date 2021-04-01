class User {
  int id;
  String mail;
  String password;
  bool isInHome;

  User.fromInput(this.id, this.mail, this.password, this.isInHome);

  User.fromJson(Map json) {
    this.id = json['ID'] != null ? int.parse(json['id']) : json['id'];
    this.mail = json['mail'] == null ? '' : json['mail'];
    this.password = json['password'] == null ? '' : json['password'];
    this.isInHome = json['isInHome'] == null ? '' : json['isInHome'];
  }

  Map toJson() => {
        'id': id,
        'mail': mail,
        'password': password,
        'isInHome': isInHome,
      };
}
