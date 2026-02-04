import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/countries.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLoginTap;

  const RegisterScreen({super.key, this.onLoginTap});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool _acceptTerms = false;
  bool _isSubmitting = false;

  String? _selectedCountryResidence;
  String? _selectedInterestCountry;

  @override
  void dispose() {
    _pseudoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      SnackbarHelper.showWarning(context, 'Vous devez accepter les conditions d\'utilisation');
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await ref.read(authStateProvider.notifier).register(
          name: _pseudoController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmController.text,
          countryResidence: _selectedCountryResidence,
          interestCountry: _selectedInterestCountry,
          terms: _acceptTerms,
        );

    if (mounted) {
      setState(() => _isSubmitting = false);

      if (!success) {
        final authState = ref.read(authStateProvider);
        if (authState is AuthError) {
          SnackbarHelper.showError(context, authState.message);
        }
      } else {
        SnackbarHelper.showSuccess(context, SnackbarHelper.registerSuccess);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState is AuthLoading || _isSubmitting;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scheme.onSurface),
          onPressed: widget.onLoginTap,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outline),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'Créer un compte',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rejoignez la communauté Sekaijin',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Pseudo field
                    TextFormField(
                      key: const Key('pseudo_field'),
                      controller: _pseudoController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Pseudo',
                        hintText: 'Votre pseudo unique',
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      validator: Validators.pseudo,
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      key: const Key('email_field'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'votre@email.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      key: const Key('password_field'),
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: Validators.registerPassword,
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordHints(),
                    const SizedBox(height: 16),

                    // Confirm password field
                    TextFormField(
                      key: const Key('password_confirm_field'),
                      controller: _passwordConfirmController,
                      obscureText: _obscurePasswordConfirm,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePasswordConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() =>
                                _obscurePasswordConfirm = !_obscurePasswordConfirm);
                          },
                        ),
                      ),
                      validator: (value) => Validators.confirmRegisterPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Country of residence dropdown
                    _buildCountryDropdown(
                      key: const Key('country_residence_dropdown'),
                      label: 'Pays de résidence (optionnel)',
                      value: _selectedCountryResidence,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() => _selectedCountryResidence = value);
                            },
                    ),
                    const SizedBox(height: 16),

                    // Country of interest dropdown
                    _buildCountryDropdown(
                      key: const Key('interest_country_dropdown'),
                      label: 'Pays qui vous intéresse (optionnel)',
                      value: _selectedInterestCountry,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() => _selectedInterestCountry = value);
                            },
                    ),
                    const SizedBox(height: 16),

                    // Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          key: const Key('terms_checkbox'),
                          value: _acceptTerms,
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  setState(() => _acceptTerms = value ?? false);
                                },
                          activeColor: AppColors.primary,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    setState(() => _acceptTerms = !_acceptTerms);
                                  },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: RichText(
                                text: TextSpan(
                                  style: textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                  children: const [
                                    TextSpan(text: 'J\'accepte les '),
                                    TextSpan(
                                      text: 'conditions d\'utilisation',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: ' et la '),
                                    TextSpan(
                                      text: 'politique de confidentialité',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Register button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        key: const Key('register_button'),
                        onPressed: isLoading ? null : _handleRegister,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Créer mon compte',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Déjà un compte ? ',
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          key: const Key('login_link'),
                          onPressed: isLoading ? null : widget.onLoginTap,
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordHints() {
    final password = _passwordController.text;
    final hasMinLength = password.length >= 12;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHintRow('Au moins 12 caractères', hasMinLength),
        _buildHintRow('Au moins une majuscule', hasUppercase),
        _buildHintRow('Au moins une minuscule', hasLowercase),
        _buildHintRow('Au moins un chiffre', hasDigit),
      ],
    );
  }

  Widget _buildHintRow(String text, bool isValid) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isValid ? AppColors.success : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isValid ? AppColors.success : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryDropdown({
    required Key key,
    required String label,
    required String? value,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      key: key,
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.public),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Sélectionner un pays'),
        ),
        ...Countries.list.map((country) {
          return DropdownMenuItem<String>(
            value: country,
            child: Text(country),
          );
        }),
      ],
      onChanged: onChanged,
    );
  }
}
