import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/event_service.dart';
import '../../services/user_session.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/events/pick_date_time.dart';
import '../../widgets/events/set_name_dialog.dart';
import 'organizer_dashboard_screen.dart';

/// Event creation form with image upload, date + time, and logged-in organizer.
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  OpportunityType _type = OpportunityType.event;
  DateTime? _deadline;
  String? _imagePath;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    if (kIsWeb && file.bytes != null) {
      // Web fallback: keep bytes path note — mobile/desktop use file path.
      setState(() => _imagePath = file.name);
      return;
    }

    if (file.path != null) {
      setState(() => _imagePath = file.path);
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await pickEventDateTime(
      context,
      initial: _deadline,
      dateHelpText: 'Event date',
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final hasName = await ensureUserName(context);
    if (!hasName || !mounted) return;

    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select event date and time'),
          backgroundColor: AppColors.surfaceAlt,
        ),
      );
      return;
    }

    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an event image'),
          backgroundColor: AppColors.surfaceAlt,
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    final event = await EventService.instance.createEvent(
      CreateEventInput(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        description: _descriptionController.text,
        type: _type,
        location: _locationController.text,
        deadline: _deadline!,
        localImagePath: _imagePath,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (event != null) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Event published!',
              style: TextStyle(color: AppColors.textPrimary)),
          content: Text(
            '"${event.title}" is live. Organizer: ${UserSession.instance.displayName}.',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const OrganizerDashboardScreen(),
                  ),
                );
              },
              child: const Text('View dashboard'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            ListenableBuilder(
              listenable: UserSession.instance,
              builder: (context, _) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, color: AppColors.gold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Publishing as ${UserSession.instance.displayName}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    TextButton(
                      onPressed: () => showEditNameDialog(context),
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Post an opportunity for the ALU community — upload a cover image, set date & time, and publish under your name.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            _imagePicker(),
            const SizedBox(height: 16),
            _field(
              controller: _titleController,
              label: 'Event title',
              hint: 'e.g. ALU Sustainability Hackathon',
              validator: (v) =>
                  (v == null || v.trim().length < 4) ? 'Min 4 characters' : null,
            ),
            const SizedBox(height: 16),
            _field(
              controller: _subtitleController,
              label: 'Short tagline',
              hint: 'e.g. Build for impact in 48 hours',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _field(
              controller: _descriptionController,
              label: 'Description',
              hint: 'What will participants do? Who should join?',
              maxLines: 4,
              validator: (v) =>
                  (v == null || v.trim().length < 20) ? 'Min 20 characters' : null,
            ),
            const SizedBox(height: 16),
            _field(
              controller: _locationController,
              label: 'Location',
              hint: 'Kigali Campus / Online / Hybrid',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<OpportunityType>(
              key: ValueKey(_type),
              initialValue: _type,
              dropdownColor: AppColors.surfaceAlt,
              decoration: _inputDecoration('Event type'),
              items: OpportunityType.values
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.label),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _type = v);
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDeadline,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: _inputDecoration('Event date & time'),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.gold, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _deadline == null
                            ? 'Select date and time'
                            : prettyDateTime(_deadline!),
                        style: TextStyle(
                          color: _deadline == null
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.access_time, color: AppColors.gold, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.surfaceAlt,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Publish Event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event image',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _imagePath == null ? AppColors.border : AppColors.gold,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: _imagePath != null && !kIsWeb
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload_file, color: AppColors.gold, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        _imagePath != null ? _imagePath! : 'Tap to upload from device',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _inputDecoration(label, hint: hint),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
    );
  }
}
