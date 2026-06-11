import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final email = await AuthService.getCurrentUserEmail();
    if (email == null) {
      setState(() => _error = 'No signed-in account found.');
      return;
    }

    setState(() => _loading = true);
    final ok = await AuthService.changePassword(
      email: email,
      currentPassword: _currentCtrl.text,
      newPassword: _newCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (!ok) {
      setState(() => _error = 'Current password is incorrect.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1B2B4B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);
    final subColor =
        isDark ? Colors.white54 : Colors.black.withValues(alpha: 0.55);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
        elevation: 0,
        title: Text('Change Password', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_error != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFF6B6B)),
              ),
              child: Text(
                _error!,
                style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _passwordField(
            label: 'Current password',
            controller: _currentCtrl,
            visible: _showCurrent,
            onToggle: () => setState(() => _showCurrent = !_showCurrent),
            validator: AuthService.validateStrongPassword,
            textColor: textColor,
            subColor: subColor,
            cardColor: cardColor,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _passwordField(
            label: 'New password',
            controller: _newCtrl,
            visible: _showNew,
            onToggle: () => setState(() => _showNew = !_showNew),
            validator: AuthService.validateStrongPassword,
            textColor: textColor,
            subColor: subColor,
            cardColor: cardColor,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _passwordField(
            label: 'Confirm new password',
            controller: _confirmCtrl,
            visible: _showConfirm,
            onToggle: () => setState(() => _showConfirm = !_showConfirm),
            validator: (v) {
              if (v != _newCtrl.text) return 'Passwords do not match';
              return null;
            },
            textColor: textColor,
            subColor: subColor,
            cardColor: cardColor,
            isDark: isDark,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5B800),
                foregroundColor: const Color(0xFF0D1B2A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Text(
                      'Save Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
    required Color textColor,
    required Color subColor,
    required Color cardColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: subColor, fontSize: 13)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: !visible,
            validator: validator,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: subColor),
              filled: true,
              fillColor: isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF0F2F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: subColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
