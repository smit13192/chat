import 'package:chat/src/api/failure/failure.dart';

class ApiException implements Exception {
  Failure failure;

  ApiException(this.failure);
}
