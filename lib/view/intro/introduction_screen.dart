import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/view/auth/auth.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introViewed', true);
    if (mounted) {
      context.pushReplacementNamed("home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            title: 'Organize Your Tasks',
            body: 'Easily manage your daily tasks and stay productive',
            image: _buildImage(Icons.task_rounded),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: 'Track Progress',
            body: 'Visualize your completion rate with progress indicators',
            image: _buildImage(Icons.timeline_rounded),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: 'Secure & Private',
            body: 'Your data stays locally stored and protected',
            image: _buildImage(Icons.lock_clock_rounded),
            decoration: _getPageDecoration(),
          ),
        ],
        showSkipButton: false,
        showDoneButton: true,
        done: const Text('Get Started',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
          size: const Size(10, 10),
          color: Colors.white54,
          activeSize: const Size(22, 10),
          activeColor: Colors.white,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        next: const Icon(Icons.arrow_forward, color: Colors.white),
        onDone: _onIntroEnd,
        globalBackgroundColor: const Color(0xFF6A11CB),
      ),
    );
  }

  Widget _buildImage(IconData icon) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 80, color: Colors.white),
    );
  }

  PageDecoration _getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyTextStyle: TextStyle(fontSize: 18, color: Colors.white70),
      imagePadding: EdgeInsets.all(24),
    );
  }
}
