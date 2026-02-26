import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_commerce/core/constants/app_colors.dart';
import 'package:little_commerce/core/constants/app_constants.dart';
import 'package:little_commerce/features/auth/presentation/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // FakeStoreAPI test credentials
  // username: johnd  password: m38rmF$

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await ref.read(authProvider.notifier).login(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen for state changes and react
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Navigate to home and remove login from stack
        Navigator.pushReplacementNamed(context, '/home');
      }
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Login failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 48),
              _buildUsernameField(),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildPasswordField(),
              const SizedBox(height: 32),
              _buildLoginButton(isLoading),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildTestCredentials(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.secondary,
            size: 32,
          ),
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        const Text(
          'Welcome back!',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        const Text(
          'Sign in to your account',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppConstants.fontSizeNormal,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Username',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        TextField(
          controller: _usernameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Enter your username',
            hintStyle: const TextStyle(color: AppColors.hintText),
            prefixIcon: const Icon(Icons.person_outline_rounded,
                color: AppColors.grey),
            filled: true,
            fillColor: AppColors.cardBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingMedium,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: const TextStyle(color: AppColors.hintText),
            prefixIcon:
                const Icon(Icons.lock_outline_rounded, color: AppColors.grey),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey,
              ),
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingMedium,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isLoading ? null : _handleLogin,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.paddingMedium,
          ),
          decoration: BoxDecoration(
            color: isLoading
                ? AppColors.primary.withOpacity(0.7)
                : AppColors.primary,
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: AppConstants.fontSizeNormal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Shows test credentials so you don't forget them
  Widget _buildTestCredentials() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🧪 Test Credentials',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeMedium,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Username: johnd\nPassword: m38rmF\$',
            style: TextStyle(
              color: Colors.blue,
              fontSize: AppConstants.fontSizeMedium,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}