import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/build_context_x.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/auth/auth_boot_cleanup.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/repositories/i_user_repository.dart';
import '../viewmodels/signup_viewmodel.dart';

/// AUTH-008 step 4 — profile (username + gender).
///
/// Username ≤16 chars enforced via `maxLength`. Gender picker is a Material
/// `DropdownButtonFormField` (see PROGRESS.md AQ-5 — TS mentions
/// `CustomDropdown` but no such widget exists, so we use the Material
/// equivalent styled with FND-004 tokens).
class SignupProfileScreen extends StatefulWidget {
  const SignupProfileScreen({super.key});

  @override
  State<SignupProfileScreen> createState() => _SignupProfileScreenState();
}

class _SignupProfileScreenState extends State<SignupProfileScreen> {
  final SignupViewModel _vm = SignupViewModel();
  final TextEditingController _username = TextEditingController();
  String _gender = 'Male';
  bool _submitting = false;

  @override
  void dispose() {
    _vm.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_username.text.trim().isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      _vm.username$.add(_username.text.trim());
      _vm.gender$.add(_gender);
      final ok = await _vm.submit();
      if (!mounted) return;
      if (ok) {
        // AUTH-008 ownership: post-signup cleanup of legacy SP `APP/USER` key.
        // See `auth_boot_cleanup.dart` — the canonical user lives in Hive
        // from here on; the legacy datasource (still DI-registered for
        // un-rewritten screens) will fall back to defaults harmlessly.
        await getIt<AuthBootCleanup>().clearLegacyUserKey();
        // Mark the canonical user as authenticated so the splash → home
        // routing decision treats them as ready.
        await getIt<IUserRepository>().setAuthentication(true);
        if (!mounted) return;
        context.go(AppRoutes.habitsPath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save profile. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Your profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                'How should we call you?',
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _username,
                maxLength: 16,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  // Block leading/trailing whitespace via simple filter.
                  FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'e.g. Alex',
                  counterText: '',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (v) => setState(() => _gender = v ?? 'Male'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentDefault,
                  foregroundColor: AppColors.darkOnSurface,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lgBorder),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Finish'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
