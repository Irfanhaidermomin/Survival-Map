class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uId;
  late String image;
  late bool isEmailVerified;

  UserModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    required this.image,
    required this.isEmailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'isEmailVerified': isEmailVerified,
    };
  }
}
