import 'package:flutter_bloc/flutter_bloc.dart';

import '../usecase/user_pin_registration_usecase.dart';
import 'user_pin_registration_state.dart';

class UserPINRegistrationCubit extends Cubit<UserPINRegistrationState> {
  final UserPINRegistrationUseCase userPINRegistrationUseCase;

  UserPINRegistrationCubit({required this.userPINRegistrationUseCase})
      : super(UserPINRegistrationInitial());

  Future<void> registerUserPIN(String pin) async {
    await userPINRegistrationUseCase.call(pin);
  }
}
