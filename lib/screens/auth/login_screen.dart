import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/exceptions/app_exception.dart';
import '../../providers/auth_provider.dart';
import '../../providers/news_provider.dart';
import '../main_navigation_screen.dart';
import 'register_screen.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<AuthProvider>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await context.read<NewsProvider>().onUserChanged();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } on AppException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Đăng nhập thất bại');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6D5DF6),
              Color(0xFF8E7CFF),
              Color(0xFFF4F2FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE9FF),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.newspaper_rounded,
                                  size: 46,
                                  color: Color(0xFF6D5DF6),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Chào mừng trở lại',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F1F39),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Đăng nhập để đọc tin tức mới nhất và quản lý danh sách yêu thích của bạn',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 28),
                              CustomTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'Nhập email của bạn',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng nhập email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Email không hợp lệ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _passwordController,
                                label: 'Mật khẩu',
                                hint: 'Nhập mật khẩu',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  }
                                  if (value.length < 6) {
                                    return 'Mật khẩu tối thiểu 6 ký tự';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6D5DF6),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                      : const Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Chưa có tài khoản?',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Đăng ký ngay',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6D5DF6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'News App • Flutter Midterm',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}