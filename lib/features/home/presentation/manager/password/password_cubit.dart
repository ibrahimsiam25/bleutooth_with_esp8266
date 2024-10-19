import 'package:flutter_bloc/flutter_bloc.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(PasswordInitial());

  void updatePassword(String newPassword) {
    emit(PasswordUpdated(password: newPassword));
  }

  void resetPassword() {
    emit(PasswordInitial());
  }
}
