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
    required super.createdAt,
    required super.updatedAt,
    required super.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['_id'],
      email: map['email'],
      username: map['username'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: DateTime.parse(map['updatedAt']).toLocal(),
      image: map['image'],
    );
  }
}
