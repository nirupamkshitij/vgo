class UserModel {
  final String name;
  final String mail;
  final String phone;
  final String dpURl;
  final String uid;
  final String userId;
  UserModel(
    this.name,
    this.mail,
    this.phone,
    this.dpURl,
    this.uid,
    this.userId,
  );

  UserModel.fromJson(
    Map<String, dynamic> json,
  )   : name = json['name'] ?? '',
        mail = json['mail'] ?? '',
        phone = json['phone'] ?? '',
        dpURl = json['dpURl'] ?? '',
        uid = json['uid'],
        userId = json['userId'] ?? '';

  Map<String, dynamic> toJson() => {
        'name': name,
        'mail': mail,
        'phoneNumber': phone,
        'photoUrl': dpURl,
        'uid': uid,
        'userId': userId
      };
}
