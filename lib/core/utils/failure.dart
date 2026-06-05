/// Sealed `Failure` taxonomy.
///
/// Hand-rolled sealed class (not Freezed) — keeps zero codegen deps for the
/// core utility layer so it can be imported by domain code without breaking
/// the dependency rule (domain has no `freezed_annotation` import).
sealed class Failure {
  const Failure(this.message);
  final String message;

  R when<R>({
    required R Function(StorageFailure f) storage,
    required R Function(NetworkFailure f) network,
    required R Function(TimeoutFailure f) timeout,
    required R Function(UnauthorizedFailure f) unauthorized,
    required R Function(RateLimitedFailure f) rateLimited,
    required R Function(ParseFailure f) parse,
    required R Function(ValidationFailure f) validation,
    required R Function(NotFoundFailure f) notFound,
    required R Function(PlatformFailure f) platform,
    required R Function(UnknownFailure f) unknown,
  }) {
    return switch (this) {
      final StorageFailure f => storage(f),
      final NetworkFailure f => network(f),
      final TimeoutFailure f => timeout(f),
      final UnauthorizedFailure f => unauthorized(f),
      final RateLimitedFailure f => rateLimited(f),
      final ParseFailure f => parse(f),
      final ValidationFailure f => validation(f),
      final NotFoundFailure f => notFound(f),
      final PlatformFailure f => platform(f),
      final UnknownFailure f => unknown(f),
    };
  }

  @override
  String toString() => '$runtimeType($message)';
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message, [this.stack]);
  final StackTrace? stack;
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('timeout');
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('unauthorized');
}

final class RateLimitedFailure extends Failure {
  const RateLimitedFailure(this.nextAttempt) : super('rate_limited');
  final DateTime nextAttempt;
}

final class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(this.field, super.message);
  final String field;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(this.entity, this.id) : super('not_found');
  final String entity;
  final String id;
}

final class PlatformFailure extends Failure {
  const PlatformFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
