import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/exceptions/app_exception.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<AuthProvider>().register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Đăng ký thành công, hãy đăng nhập'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
      Navigator.pop(context);
    } on AppException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Đăng ký thất bại');
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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.15),
                          ),
                        ),
                      ),
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
                                  Icons.person_add_alt_1_rounded,
                                  size: 46,
                                  color: Color(0xFF6D5DF6),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Tạo tài khoản mới',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F1F39),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Đăng ký để sử dụng ứng dụng đọc tin tức và lưu bài viết yêu thích',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 28),
                              CustomTextField(
                                controller: _fullNameController,
                                label: 'Họ và tên',
                                hint: 'Nhập họ tên của bạn',
                                prefixIcon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng nhập họ tên';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                label: 'Xác nhận mật khẩu',
                                hint: 'Nhập lại mật khẩu',
                                prefixIcon: Icons.lock_reset_outlined,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng xác nhận mật khẩu';
                                  }
                                  if (value.trim() != _passwordController.text.trim()) {
                                    return 'Mật khẩu xác nhận không khớp';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading ? null : _register,
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
                                    'Đăng ký',
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
                                    'Đã có tài khoản?',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Đăng nhập',
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