abstract class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure([String? message]) : super(message ?? 'Server error. Please try again later.');
}

class NetworkFailure extends Failure {
  NetworkFailure([String? message])
    : super(message ?? 'No internet connection. Please check your network.');
}

class AuthFailure extends Failure {
  AuthFailure([String? message]) : super(message ?? 'Authentication Failed');
}

class ValidationFailure extends Failure {
  ValidationFailure([String? message]) : super(message ?? 'Validation Error');
}

class NotFoundFailure extends Failure {
  NotFoundFailure([String? message]) : super(message ?? 'Resource Not Found');
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure([String? message]) : super(message ?? 'Access Forbidden');
}

class ConflictFailure extends Failure {
  ConflictFailure([String? message]) : super(message ?? 'Conflict Error');
}

class TimeoutFailure extends Failure {
  TimeoutFailure([String? message]) : super(message ?? 'Connection timed out. Please check your internet.');
}

class CancelledFailure extends Failure {
  CancelledFailure([String? message]) : super(message ?? 'Request Cancelled');
}

class UnknownFailure extends Failure {
  UnknownFailure([String? message]) : super(message ?? 'Something went wrong. Please try again.');
}
