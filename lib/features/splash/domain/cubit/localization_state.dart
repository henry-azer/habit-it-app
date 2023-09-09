part of 'localization_cubit.dart';

abstract class LocalizationState extends Equatable {
  final Locale locale;
  const LocalizationState(this.locale);

  @override
  List<Object> get props => [locale];
}

class ChangeLocaleState extends LocalizationState {
  const ChangeLocaleState(Locale selectedLocale) : super(selectedLocale);
}
