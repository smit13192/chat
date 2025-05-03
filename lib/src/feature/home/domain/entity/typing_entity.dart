import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:equatable/equatable.dart';

class TypingEntity extends Equatable {
  final String chatId;
  final UserEntity user;

  const TypingEntity({required this.chatId, required this.user});

  @override
  List<Object?> get props => [chatId, user];
}
