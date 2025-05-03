import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';

class LoginModel extends LoginEnity {
  const LoginModel({required super.token, required super.user});

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      token: map['token'],
      user: UserModel.fromMap(map['user']),
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.email,
    required super.username,
    required super.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['_id'],
      email: map['email'],
      username: map['username'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
  return {
    '_id': userId,
    'email': email,
    'username': username,
    'image': image,
  };
}

}
