import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/controller/task_list_cubit.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/view/auth/auth.dart';
import 'package:todoapp/view/home/home.dart';
import 'package:todoapp/view/intro/introduction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get initial auth state
  final auth = FirebaseAuth.instance;
  final initialLocation = auth.currentUser != null ? "/home" : "/auth";

  // Create router with dynamic redirects
  final _router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: "/intro",
        name: "intro",
        builder: (context, state) {
          return const IntroScreen();
        },
      ),
      GoRoute(
        path: "/auth",
        name: "auth",
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: "/home",
        name: "home",
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final currentUser = FirebaseAuth.instance.currentUser;
      final isAuthRoute = state.path == "/auth";

      // Redirect to auth if not logged in
      if (currentUser == null && !isAuthRoute) return "/auth";

      // Redirect to home if logged in and trying to access auth
      if (currentUser != null && isAuthRoute) return "/home";

      // No redirect needed
      return null;
    },
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskListCubit(),
        )
      ],
      child: MyApp(router: _router),
    ),
  );
}

class MyApp extends StatefulWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen for auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        widget.router.go('/auth');
      } else {
        widget.router.go('/home');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: widget.router,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
