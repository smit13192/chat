abstract class UserCase<Params, Response> {
  Future<Response> call(Params params);
}
