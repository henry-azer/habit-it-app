import 'package:equatable/equatable.dart';

class ResponseModel<T> extends Equatable {
  final T body;
  final bool success;
  final String message;

  const ResponseModel({required this.success, required this.message, required this.body});

  @override
  List<Object?> get props => [body];
}
