class User {
  int id;
  String email;
  String password;
  String is_in_home;

  User.fromInput(this.id, this.email, this.password, this.is_in_home);

  User.fromJson(Map json) {
    this.id = json['id'] != null ? int.parse(json['id']) : json['id'];
    this.email = json['mail'] == null ? '' : json['mail'];
    this.password = json['password'] == null ? '' : json['password'];
    this.is_in_home = json['is_in_home'] == null ? '' : json['is_in_home'];
  }

  Map toJson() => {
        'id': id,
        'mail': email,
        'password': password,
        'is_in_home': is_in_home,
      };
}

class Neighbours {
  String email;
  String is_in_home;

  Neighbours.fromInput(this.email, this.is_in_home);
}
