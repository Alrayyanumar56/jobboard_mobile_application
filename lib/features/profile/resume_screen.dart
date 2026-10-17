import 'package:flutter/material.dart';
import '../../core/validators.dart';
import '../../state/app_state.dart';
import 'domain/resume.dart';

/// Read-only resume display, used by applications and employer views.
class ResumeView extends StatelessWidget {
  const ResumeView({super.key, required this.resume});
  final Resume resume;

  Widget _block(BuildContext context, String title, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 2),
        Text(text),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contact = [resume.phone, resume.location].where((e) => e.isNotEmpty).join(' • ');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(resume.headline,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      if (contact.isNotEmpty) Text(contact),
      _block(context, 'Summary', resume.summary),
      if (resume.skills.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(spacing: 6, runSpacing: 4, children: [
            for (final s in resume.skills) Chip(label: Text(s), visualDensity: VisualDensity.compact),
          ]),
        ),
      _block(context, 'Education', resume.education),
      _block(context, 'Experience', resume.experience),
    ]);
  }
}

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final _form = GlobalKey<FormState>();
  late final _headline = TextEditingController(text: appState.myResume?.headline);
  late final _phone = TextEditingController(text: appState.myResume?.phone);
  late final _location = TextEditingController(text: appState.myResume?.location);
  late final _summary = TextEditingController(text: appState.myResume?.summary);
  late final _skills = TextEditingController(text: appState.myResume?.skills.join(', '));
  late final _education = TextEditingController(text: appState.myResume?.education);
  late final _experience = TextEditingController(text: appState.myResume?.experience);

  @override
  void dispose() {
    for (final c in [_headline, _phone, _location, _summary, _skills, _education, _experience]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _field(TextEditingController c, String label,
          {int lines = 1, bool required = false, String? hint}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: c,
          maxLines: lines,
          validator: required ? requiredField : null,
          decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder()),
        ),
      );

  void _save() {
    if (!_form.currentState!.validate()) return;
    appState.saveResume(Resume(
      headline: _headline.text.trim(),
      phone: _phone.text.trim(),
      location: _location.text.trim(),
      summary: _summary.text.trim(),
      education: _education.text.trim(),
      experience: _experience.text.trim(),
      skills: _skills.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resume saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My resume')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _field(_headline, 'Headline', required: true, hint: 'e.g. Flutter Developer'),
            _field(_phone, 'Phone'),
            _field(_location, 'Location'),
            _field(_summary, 'Summary', lines: 4, required: true),
            _field(_skills, 'Skills', required: true, hint: 'Comma separated, e.g. Flutter, Dart, SQL'),
            _field(_education, 'Education', lines: 2),
            _field(_experience, 'Experience', lines: 4),
            FilledButton(onPressed: _save, child: const Text('Save resume')),
          ]),
        ),
      ),
    );
  }
}
