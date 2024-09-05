abstract class UseCase<Params, Response> {
  Future<Response> call(Params params);
}
