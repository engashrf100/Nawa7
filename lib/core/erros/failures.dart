import 'package:nawah/features/auth/data/model/shared/validation_model.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache Failure"]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Server Failure"]);
}

class NoInternetFailure extends Failure {
  NoInternetFailure([super.message = 'No internet connection']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = "Timeout Failure"]);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = "Unexpected Failure"]);
}

class ValidationFailure extends Failure {
  final ValidationErrors errors;
  const ValidationFailure(this.errors) : super("Validation failed");
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure(super.message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
