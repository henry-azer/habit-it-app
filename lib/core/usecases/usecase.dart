import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/exceptions.dart';

abstract class UseCase<Type, Params> {
  Future<Either<GenericException, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
