import 'package:flutter/material.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _majorController;
  late TextEditingController _campusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _majorController = TextEditingController(text: widget.user.major);
    _campusController = TextEditingController(text: widget.user.campus);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _campusController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        name: _nameController.text.trim(),
        major: _majorController.text.trim(),
        campus: _campusController.text.trim(),
        classYear: widget.user.classYear,
        impactScore: widget.user.impactScore,
        rankLabel: widget.user.rankLabel,
        nextLevel: widget.user.nextLevel,
        badges: widget.user.badges,
        joinedHubs: widget.user.joinedHubs,
        eventsAttended: widget.user.eventsAttended,
        communities: widget.user.communities,
        connections: widget.user.connections,
      );
      Navigator.pop(context, updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final fieldColor =
        isDark ? const Color(0xFF1B2B4B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
        elevation: 0,
        title: Text('Edit Profile', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(
                controller: _nameController,
                label: 'Full Name',
                textColor: textColor,
                fieldColor: fieldColor,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _majorController,
                label: 'Major',
                textColor: textColor,
                fieldColor: fieldColor,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Major cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _campusController,
                label: 'Campus',
                textColor: textColor,
                fieldColor: fieldColor,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Campus cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5B800),
                    foregroundColor: const Color(0xFF0D1B2A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required Color textColor,
    required Color fieldColor,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.5)),
        filled: true,
        fillColor: fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF6B6B)),
      ),
    );
  }
}