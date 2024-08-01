class Endpoints {
  static const String baseUrl = 'http://192.168.1.8:8001';
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String profile = '$baseUrl/profile';
  static const String getAllUser = '$baseUrl/get-all-user';
  static const String chat = '$baseUrl/chat';
  static const String getAllChatMessage = '$baseUrl/chat/get-all-chat-message';
  static const String sendMessage = '$baseUrl/chat/send-message';
}