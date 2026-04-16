import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/news_provider.dart';
import 'repositories/article_repository.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..loadUser(),
        ),
        ChangeNotifierProvider<NewsProvider>(
          create: (_) => NewsProvider(
            repository: ArticleRepository(
              apiService: ApiService(),
            ),
          )..initialize(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff7f8fc),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoggedIn) {
              return const MainNavigationScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}