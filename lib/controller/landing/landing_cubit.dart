import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageCubit extends Cubit<String> {
  LandingPageCubit() : super(_initialLandingPage);

  static const String _initialLandingPage = 'home';

  Future<void> changeLandingPage(String page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('landingPage', page);
    emit(page);
  }
}
