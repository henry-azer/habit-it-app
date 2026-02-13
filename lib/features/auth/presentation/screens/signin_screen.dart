import 'package:flutter/material.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/config/routes/app_routes.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/core/utils/form_validators.dart';
import 'package:habit_it/core/providers/i_auth_provider.dart';
import 'package:habit_it/core/providers/biometric_provider.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFormValid = false;
  bool _isLogging = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    final hasEmailError = FormValidators.validateEmail(email) != null;
    final hasPasswordError = FormValidators.validatePassword(password) != null;
    
    final isValid = !hasEmailError && !hasPasswordError;
    
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            AppStrings.signIn.tr.toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    AppImageAssets.signup,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  _buildEmailField(isDark),
                  const SizedBox(height: 12),
                  _buildPasswordField(isDark),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
                  const SizedBox(height: 14),
                  _buildRegisterPrompt(),
                  _buildBiometricSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: isDark ? 0.1 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.buttonGradientStart, AppColors.buttonGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: AppColors.lightOnPrimary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.email.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: _emailKey,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.enterYourEmail.tr,
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: FormValidators.validateEmail,
            onChanged: (value) {
              _emailKey.currentState?.validate();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(bool isDark) {
    return Consumer<IAuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBackground : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: isDark ? 0.1 : 0.03),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.buttonGradientStart, AppColors.buttonGradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: AppColors.lightOnPrimary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.password.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: authProvider.obscurePassword,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.enterPasswordHint.tr,
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      authProvider.obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    onPressed: () {
                      authProvider.togglePasswordVisibility();
                    },
                  ),
                ),
                validator: FormValidators.validatePassword,
                onChanged: (value) {
                  final formState = Form.of(context);
                  formState.validate();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return Consumer<IAuthProvider>(
      builder: (context, authProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bool isEnabled = _isFormValid && !_isLogging;
        return Container(
          width: double.infinity,
          decoration: isEnabled
              ? BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.buttonGradientStart, AppColors.buttonGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.buttonGradientStart.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                )
              : null,
          child: ElevatedButton(
            onPressed: isEnabled ? _login : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled
                  ? Colors.transparent
                  : (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground),
              foregroundColor: isEnabled
                  ? AppColors.lightOnPrimary
                  : (isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled),
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isLogging
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightOnPrimary),
                    ),
                  )
                : Text(
                    AppStrings.signIn.tr,
                    style: const TextStyle(
                      color: AppColors.lightOnPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildBiometricSection() {
    return Consumer<BiometricProvider>(
      builder: (context, biometricProvider, child) {
        if (!biometricProvider.isBiometricAvailable || !biometricProvider.isBiometricEnabled) {
          return const SizedBox.shrink();
        }

        return Consumer<IAuthProvider>(
          builder: (context, authProvider, child) {
            return FutureBuilder<bool>(
              future: authProvider.isBiometricEnabled(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!) {
                  return const SizedBox.shrink();
                }

                final isDark = Theme.of(context).brightness == Brightness.dark;

                return Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                                : AppColors.lightTextSecondary.withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppStrings.or.tr,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                                : AppColors.lightTextSecondary.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _attemptBiometricLogin,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.fingerprint,
                                  color: AppColors.lightOnPrimary,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  AppStrings.useBiometric.tr.replaceAll(
                                    '{type}',
                                    biometricProvider.biometricTypeLabel,
                                  ),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.lightOnPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.register);
          },
          child: Text(
            AppStrings.signUp.tr,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLogging = true;
    });

    final authProvider = Provider.of<IAuthProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 500));
    
    final success = await authProvider.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );  

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, Routes.app);
    } else {
      String errorMessage = AppStrings.invalidCredentials.tr;
      if (authProvider.errorMessage != null) {
        final error = authProvider.errorMessage!.toLowerCase();
        if (error.contains('invalid login credentials') || error.contains('invalid email or password')) {
          errorMessage = AppStrings.invalidCredentials.tr;
        } else if (error.contains('email is already exists') || error.contains('already registered')) {
          errorMessage = AppStrings.emailAlreadyExists.tr;
        } else {
          errorMessage = authProvider.errorMessage!;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }

    setState(() {
      _isLogging = false;
    });
  }

  Future<void> _attemptBiometricLogin() async {
    final biometricProvider = Provider.of<BiometricProvider>(context, listen: false);
    final authProvider = Provider.of<IAuthProvider>(context, listen: false);
    
    if (!biometricProvider.isBiometricEnabled) return;
    
    final isBiometricEnabled = await authProvider.isBiometricEnabled();
    if (!isBiometricEnabled) return;

    final success = await authProvider.signInWithBiometric(
      reason: AppStrings.authenticateToUnlock.tr,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, Routes.app);
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage!)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
