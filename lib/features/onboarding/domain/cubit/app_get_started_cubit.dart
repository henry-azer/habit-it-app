import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../usecase/app_get_started_usecase.dart';
import 'app_get_started_state.dart';

class AppGetStartedCubit extends Cubit<AppGetStartedState> {
  final AppGetStartedUseCase appGetStartedUseCase;

  AppGetStartedCubit({required this.appGetStartedUseCase}) : super(AppGetStartedInitial());

  Future<void> setAppGetStarted() async {
    await appGetStartedUseCase.call(NoParams());
  }
}