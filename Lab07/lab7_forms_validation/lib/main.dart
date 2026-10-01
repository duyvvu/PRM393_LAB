import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

// =============================================================
// Lab 7.1 - 7.4: Signup Screen with Validation & Good UX
// =============================================================

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // --------------- Form Key ---------------
  final _formKey = GlobalKey<FormState>();

  // --------------- Controllers ---------------
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --------------- Focus Nodes (Lab 7.3) ---------------
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // --------------- State Variables ---------------
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false; // Bonus: Terms & Conditions
  bool _isCheckingEmail = false; // Lab 7.4: Async validation

  // --------------- Lifecycle ---------------
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // =============================================================
  // Lab 7.2: Separate Validator Functions
  // =============================================================

  /// Validates that the name field is not empty.
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates that the email is not empty and has a valid format.
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // Check for basic email pattern: must contain @ and .
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Validates password strength:
  /// - At least 8 characters
  /// - At least 1 digit
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    return null;
  }

  /// Validates that confirm password matches the password.
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // =============================================================
  // Bonus: Password Strength Indicator
  // =============================================================

  /// Returns a strength label for the current password.
  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return 'Weak';
    if (score <= 3) return 'Medium';
    return 'Strong';
  }

  /// Returns a color matching the password strength.
  Color _getStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // =============================================================
  // Lab 7.4: Submit with Async Email Check
  // =============================================================

  Future<void> _submit() async {
    // Step 1: Run local (synchronous) validation
    if (!_formKey.currentState!.validate()) return;

    // Check terms agreement (bonus)
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms & Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 2: Async email check (Lab 7.4)
    setState(() => _isCheckingEmail = true);

    // Simulate a server call
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim().toLowerCase();
    final isTaken = email.startsWith('taken');

    setState(() => _isCheckingEmail = false);

    if (!mounted) return;

    if (isTaken) {
      // Email is "already taken"
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already taken. Please use a different one.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 3: Save and show success
    _formKey.currentState!.save();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Account Created!'),
        content: Text(
          'Welcome, ${_nameController.text.trim()}!\n\n'
          'Your account has been created successfully with email: '
          '${_emailController.text.trim()}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // Build
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final passwordStrength = _getPasswordStrength(_passwordController.text);

    // Lab 7.3: GestureDetector to dismiss keyboard when tapping outside
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            // Lab 7.2: Auto-validate on user interaction
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // Lab 7.3: ListView to avoid overflow when keyboard opens
            child: ListView(
              children: [
                const SizedBox(height: 16),
                // Header
                const Icon(Icons.person_add, size: 64, color: Colors.indigo),
                const SizedBox(height: 8),
                Text(
                  'Create Your Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                // ---- Full Name ----
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g. John Doe',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // Lab 7.3: Move focus Name -> Email
                    FocusScope.of(context).requestFocus(_emailFocus);
                  },
                  validator: _validateName,
                ),
                const SizedBox(height: 16),

                // ---- Email ----
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'e.g. john@example.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // Lab 7.3: Move focus Email -> Password
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),

                // ---- Password ----
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 8 characters, 1 digit',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    // Bonus: Show/Hide password toggle
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    // Rebuild to update password strength indicator
                    setState(() {});
                  },
                  onFieldSubmitted: (_) {
                    // Lab 7.3: Move focus Password -> Confirm
                    FocusScope.of(context).requestFocus(_confirmFocus);
                  },
                  validator: _validatePassword,
                ),
                const SizedBox(height: 4),

                // ---- Bonus: Password Strength Indicator ----
                if (_passwordController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Strength: ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          passwordStrength,
                          style: TextStyle(
                            color: _getStrengthColor(passwordStrength),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: passwordStrength == 'Weak'
                                ? 0.33
                                : passwordStrength == 'Medium'
                                    ? 0.66
                                    : 1.0,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getStrengthColor(passwordStrength),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),

                // ---- Confirm Password ----
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmFocus,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    // Bonus: Show/Hide confirm password toggle
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    // Lab 7.3: From Confirm -> Submit
                    _submit();
                  },
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 16),

                // ---- Bonus: Terms & Conditions Checkbox ----
                CheckboxListTile(
                  value: _agreedToTerms,
                  onChanged: (val) {
                    setState(() => _agreedToTerms = val ?? false);
                  },
                  title: const Text('I agree to the Terms & Conditions'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                // ---- Submit Button ----
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // Disable button while checking email (Lab 7.4)
                    onPressed: _isCheckingEmail ? null : _submit,
                    child: _isCheckingEmail
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
