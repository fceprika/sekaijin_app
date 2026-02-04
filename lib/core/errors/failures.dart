import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  String get userMessage => message.isNotEmpty ? message : 'Une erreur est survenue';

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required super.message, this.statusCode});

  @override
  String get userMessage =>
      message.isNotEmpty ? message : 'Une erreur est survenue, réessayez plus tard';

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});

  @override
  String get userMessage => message.isNotEmpty ? message : 'Vérifiez votre connexion internet';
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});

  @override
  String get userMessage =>
      message.isNotEmpty ? message : 'Session expirée, veuillez vous reconnecter';
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({required super.message, this.errors});

  @override
  String get userMessage => message.isNotEmpty ? message : 'Données invalides';

  @override
  List<Object?> get props => [message, errors];
}
