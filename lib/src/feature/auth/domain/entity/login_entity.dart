import 'package:equatable/equatable.dart';

class LoginEnity extends Equatable {
  final String token;
  final UserEntity user;

  const LoginEnity({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class UserEntity extends Equatable {
  final String userId;
  final String email;
  final String username;
  final String image;

  const UserEntity({
    required this.userId,
    required this.email,
    required this.username,
    required this.image,
  });

  @override
  List<Object?> get props => [userId];
}
