import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_ups/services/auth_service.dart';
import 'package:push_ups/services/navigation.dart';

class _ViewModel {
  final BuildContext context;
  final _authService = AuthService();
  _ViewModel(this.context) {
    init();
  }

  void init() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final isAuth = await _authService.isAuth();
    if (isAuth) {
      Navigation.showMainScreen(context);
    } else {
      Navigation.showAuthScreen(context);
    }
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static Widget withProvider() {
    return Provider(
      lazy: false,
      create: (context) => _ViewModel(context),
      child: const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
