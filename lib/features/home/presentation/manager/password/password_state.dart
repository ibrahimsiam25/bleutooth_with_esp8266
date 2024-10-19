part of 'password_cubit.dart';


abstract class PasswordState {}

class PasswordInitial extends PasswordState {}
class PasswordUpdated extends PasswordState {
  final String password;

  PasswordUpdated({required this.password});
}