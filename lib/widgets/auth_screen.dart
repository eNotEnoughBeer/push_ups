import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:push_ups/providers/session_data_provider.dart';
import 'package:push_ups/services/auth_service.dart';
import 'package:push_ups/services/navigation.dart';

class _ViewModel {
  final _authService = AuthService();

  Future<void> onButtonPressed(
      BuildContext context, PhysicalLevel level) async {
    await _authService.login(level);
    Navigation.showMainScreen(context);
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static Widget withProvider() {
    return Provider(
      create: (_) => _ViewModel(),
      child: const AuthScreen(),
    );
  }

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;
  late final AnimationController _controller4;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(vsync: this);
    _controller2 = AnimationController(vsync: this);
    _controller3 = AnimationController(vsync: this);
    _controller4 = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black38,
                  Colors.black12,
                  Colors.black12,
                  Colors.black38,
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: OrientationBuilder(builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? _portraitWidget(context)
                  : _horizontalWidget(context);
            }),
          ),
        ),
      ),
    );
  }

  Widget _portraitWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          levelButton(
            _controller1,
            PhysicalLevel.low,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              levelButton(
                _controller2,
                PhysicalLevel.medium,
              ),
              levelButton(
                _controller3,
                PhysicalLevel.high,
              ),
            ],
          ),
          levelButton(
            _controller4,
            PhysicalLevel.extreme,
          ),
        ],
      ),
    );
  }

  Widget _horizontalWidget(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          levelButton(
            _controller1,
            PhysicalLevel.low,
          ),
          levelButton(
            _controller2,
            PhysicalLevel.medium,
          ),
          levelButton(
            _controller3,
            PhysicalLevel.high,
          ),
          levelButton(
            _controller4,
            PhysicalLevel.extreme,
          ),
        ],
      ),
    );
  }

  Widget levelButton(AnimationController controller, PhysicalLevel level) {
    final size =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width / 4;
    late final String imagePath;
    switch (level) {
      case PhysicalLevel.low:
        imagePath = 'assets/weak.png';
        break;
      case PhysicalLevel.medium:
        imagePath = 'assets/normal.png';
        break;
      case PhysicalLevel.high:
        imagePath = 'assets/strong.png';
        break;
      case PhysicalLevel.extreme:
        imagePath = 'assets/extreme.png';
        break;
      case PhysicalLevel.none:
        imagePath = 'assets/weak.png';
        break;
    }

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: size * 0.33,
            ),
          ),
          GestureDetector(
            onTap: () async {
              await controller.forward();
              await context.read<_ViewModel>().onButtonPressed(context, level);
            },
            child: Center(
              child: Lottie.asset(
                'assets/round_button.json',
                repeat: false,
                controller: controller,
                onLoaded: (composition) {
                  controller.duration = composition.duration;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
