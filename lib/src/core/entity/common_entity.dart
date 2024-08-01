class CommonEntity<T> {
  int statusCode;
  bool success;
  String? message;
  T? data;

  CommonEntity({
    required this.statusCode,
    required this.success,
    this.message,
    this.data,
  });
}
