abstract class Failure {
  final int statusCode;
  final String message;

  Failure(this.statusCode, this.message);

  factory Failure.failure(int statusCode, [String? customMessage]) {
    switch (statusCode) {
      case 400:
        return BadRequestFailure(
          customMessage ??
              'Unauthorized: Authentication is required and has failed.',
        );
      case 401:
        return UnauthorizedFailure(
          customMessage ??
              'Unauthorized: Authentication is required and has failed.',
        );
      case 403:
        return ForbiddenFailure(
          customMessage ??
              'Forbidden: You do not have permission to access this resource.',
        );
      case 404:
        return NotFoundFailure(
          customMessage ??
              'Not Found: The requested resource could not be found.',
        );
      case 405:
        return MethodNotAllowedFailure(
          customMessage ??
              'Method Not Allowed: The request method is not supported for this resource.',
        );
      case 408:
        return RequestTimeoutFailure(
          customMessage ??
              'Request Timeout: The server timed out waiting for the request.',
        );
      case 500:
        return InternalServerErrorFailure(
          customMessage ??
              'Internal Server Error: The server encountered an error and could not complete your request.',
        );
      case 502:
        return BadGatewayFailure(
          customMessage ??
              'Bad Gateway: The server received an invalid response from an upstream server.',
        );
      case 503:
        return ServiceUnavailableFailure(
          customMessage ??
              'Service Unavailable: The server is currently unable to handle the request.',
        );
      case 504:
        return GatewayTimeoutFailure(
          customMessage ??
              'Gateway Timeout: The server did not receive a timely response from an upstream server.',
        );
      default:
        return InternalServerErrorFailure(
          customMessage ??
              'Internal Server Error: The server encountered an error and could not complete your request.',
        );
    }
  }

  @override
  String toString() => 'Failure(statusCode: $statusCode, message: $message)';
}

class BadRequestFailure extends Failure {
  BadRequestFailure(String customMessage) : super(400, customMessage);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String customMessage) : super(401, customMessage);
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure(String customMessage) : super(403, customMessage);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(String customMessage) : super(404, customMessage);
}

class MethodNotAllowedFailure extends Failure {
  MethodNotAllowedFailure(String customMessage) : super(405, customMessage);
}

class RequestTimeoutFailure extends Failure {
  RequestTimeoutFailure(String customMessage) : super(408, customMessage);
}

class InternalServerErrorFailure extends Failure {
  InternalServerErrorFailure(String customMessage) : super(500, customMessage);
}

class BadGatewayFailure extends Failure {
  BadGatewayFailure(String customMessage) : super(502, customMessage);
}

class ServiceUnavailableFailure extends Failure {
  ServiceUnavailableFailure(String customMessage) : super(503, customMessage);
}

class GatewayTimeoutFailure extends Failure {
  GatewayTimeoutFailure(String customMessage) : super(504, customMessage);
}
