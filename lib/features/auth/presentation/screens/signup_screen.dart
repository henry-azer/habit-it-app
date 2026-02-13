import 'package:habit_it/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_assets_manager.dart';
import 'package:habit_it/core/utils/app_strings.dart';
import 'package:habit_it/core/utils/form_validators.dart';
import 'package:habit_it/core/providers/i_auth_provider.dart';
import 'package:habit_it/config/routes/app_routes.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _displayNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _phoneKey = GlobalKey<FormFieldState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _selectedBirthday;
  String? _selectedGender;
  bool _obscurePassword = true;
  bool _isRegistering = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _displayNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final displayName = _displayNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    
    final hasDisplayNameError = FormValidators.validateFullName(displayName) != null;
    final hasEmailError = FormValidators.validateEmail(email) != null;
    final hasPhoneError = FormValidators.validatePhoneNumber(phone) != null;
    final hasPasswordError = FormValidators.validatePassword(password) != null;
    
    final isValid = !hasDisplayNameError &&
                    !hasEmailError &&
                    !hasPhoneError &&
                    !hasPasswordError &&
                    _selectedGender != null &&
                    _selectedBirthday != null;
    
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            AppStrings.signUp.tr.toUpperCase(),
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
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    AppImageAssets.signup,
                    height: MediaQuery.of(context).size.height * 0.18,
                  ),
                  const SizedBox(height: 16),
                  _buildDisplayNameField(isDark),
                  const SizedBox(height: 12),
                  _buildEmailField(isDark),
                  const SizedBox(height: 12),
                  _buildPasswordField(isDark),
                  const SizedBox(height: 12),
                  _buildPhoneField(isDark),
                  const SizedBox(height: 12),
                  _buildBirthdayField(isDark),
                  const SizedBox(height: 12),
                  _buildGenderField(isDark),
                  const SizedBox(height: 28),
                  _buildRegisterButton(),
                  const SizedBox(height: 12),
                  _buildLoginPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayNameField(bool isDark) {
    return _buildFieldContainer(
      isDark: isDark,
      icon: Icons.person_outline,
      label: AppStrings.fullName.tr,
      child: TextFormField(
        key: _displayNameKey,
        controller: _displayNameController,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: _buildInputDecoration(isDark, AppStrings.enterFullName.tr),
        validator: FormValidators.validateFullName,
        onChanged: (value) {
          _displayNameKey.currentState?.validate();
        },
      ),
    );
  }

  Widget _buildEmailField(bool isDark) {
    return _buildFieldContainer(
      isDark: isDark,
      icon: Icons.email_outlined,
      label: AppStrings.email.tr,
      child: TextFormField(
        key: _emailKey,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: _buildInputDecoration(isDark, AppStrings.enterYourEmail.tr),
        validator: FormValidators.validateEmail,
        onChanged: (value) {
          _emailKey.currentState?.validate();
        },
      ),
    );
  }

  Widget _buildPasswordField(bool isDark) {
    return _buildFieldContainer(
      isDark: isDark,
      icon: Icons.lock_outline,
      label: AppStrings.password.tr,
      child: TextFormField(
        maxLength: 22,
        key: _passwordKey,
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: _buildInputDecoration(isDark, AppStrings.enterPasswordHint.tr).copyWith(
          counterText: '',
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: FormValidators.validatePassword,
        onChanged: (value) {
          _passwordKey.currentState?.validate();
        },
      ),
    );
  }

  Widget _buildPhoneField(bool isDark) {
    return _buildFieldContainer(
      isDark: isDark,
      icon: Icons.phone_outlined,
      label: AppStrings.phoneNumber.tr,
      child: TextFormField(
        key: _phoneKey,
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: _buildInputDecoration(isDark, AppStrings.enterPhoneNumber.tr),
        validator: FormValidators.validatePhoneNumber,
        onChanged: (value) {
          _phoneKey.currentState?.validate();
        },
      ),
    );
  }

  Widget _buildBirthdayField(bool isDark) {
    return _buildFieldContainer(
      isDark: isDark,
      icon: Icons.cake_outlined,
      label: AppStrings.birthday.tr,
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              _selectedBirthday = picked;
              _validateForm();
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedBirthday != null
                    ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                    : AppStrings.selectBirthday.tr,
                style: TextStyle(
                  color: _selectedBirthday != null
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.calendar_today,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField(bool isDark) {
    return _buildFieldContainer(
      isDark: isDark,
      icon: Icons.wc_outlined,
      label: AppStrings.gender.tr,
      child: Row(
        children: [
          Expanded(
            child: _buildGenderOption('Male', AppStrings.male.tr, isDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildGenderOption('Female', AppStrings.female.tr, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, bool isDark) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
          _validateForm();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.buttonGradientStart, AppColors.buttonGradientEnd],
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.lightOnPrimary
                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldContainer({
    required bool isDark,
    required IconData icon,
    required String label,
    required Widget child,
  }) {
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
                child: Icon(
                  icon,
                  color: AppColors.lightOnPrimary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(bool isDark, String hintText) {
    return InputDecoration(
      hintText: hintText,
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
    );
  }

  Widget _buildRegisterButton() {
    return Consumer<IAuthProvider>(
      builder: (context, authProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bool isEnabled = _isFormValid && !_isRegistering;
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
            onPressed: isEnabled ? _register : null,
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
            child: _isRegistering
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightOnPrimary),
                    ),
                  )
                : Text(
                    AppStrings.signUp.tr,
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

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppStrings.signIn.tr,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isRegistering = true;
    });

    final authProvider = Provider.of<IAuthProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 500));
    
    final success = await authProvider.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullname: _displayNameController.text.trim(),
      gender: _selectedGender,
      birthday: _selectedBirthday,
      phoneNumber: _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.accountCreationSuccess.tr)),
      );
      Navigator.pop(context);
    } else {
      String errorMessage = AppStrings.accountCreationError.tr;
      if (authProvider.errorMessage != null) {
        final error = authProvider.errorMessage!.toLowerCase();
        if (error.contains('email is already exists') || error.contains('already registered')) {
          errorMessage = AppStrings.emailAlreadyExists.tr;
        } else if (error.contains('invalid credentials')) {
          errorMessage = AppStrings.invalidCredentials.tr;
        } else {
          errorMessage = authProvider.errorMessage!;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }

    setState(() {
      _isRegistering = false;
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
