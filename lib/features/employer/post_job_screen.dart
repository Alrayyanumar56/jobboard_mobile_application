import 'package:flutter/material.dart';
import '../../core/validators.dart';
import '../../state/app_state.dart';
import '../jobs/domain/job.dart';
import '../jobs/presentation/home_screen.dart';
import '../jobs/presentation/job_badges.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _company = TextEditingController(text: appState.user?.name ?? '');
  final _location = TextEditingController();
  final _salary = TextEditingController();
  final _description = TextEditingController();
  final _requirements = TextEditingController();
  final _skills = TextEditingController();
  final _max = TextEditingController();
  DateTime? _deadline = DateTime.now().add(const Duration(days: 14));
  String _type = jobTypes.first;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_title, _company, _location, _salary, _description, _requirements, _skills, _max]) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> _split(String s, String sep) =>
      s.split(sep).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Widget _field(TextEditingController c, String label, {int lines = 1, String? hint}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: c,
          maxLines: lines,
          validator: requiredField,
          decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder()),
        ),
      );

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final p = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (p != null) setState(() => _deadline = DateTime(p.year, p.month, p.day, 23, 59));
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    await appState.postJob(Job(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      company: _company.text.trim(),
      location: _location.text.trim(),
      employmentType: _type,
      salary: _salary.text.trim(),
      description: _description.text.trim(),
      requirements: _split(_requirements.text, '\n'),
      skills: _split(_skills.text, ','),
      postedDate: DateTime.now(),
      employerEmail: appState.user?.email,
      deadline: _deadline,
      maxApplicants: int.tryParse(_max.text.trim()),
    ));
    nav.pop();
    messenger.showSnackBar(const SnackBar(content: Text('Job posted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a job')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _field(_title, 'Job title'),
            _field(_company, 'Company'),
            _field(_location, 'Location'),
            const Text('Employment type'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              for (final t in jobTypes)
                ChoiceChip(label: Text(t), selected: _type == t, onSelected: (_) => setState(() => _type = t)),
            ]),
            const SizedBox(height: 16),
            _field(_salary, 'Salary', hint: 'e.g. PKR 100k - 150k / month'),
            _field(_description, 'Description', lines: 4),
            _field(_requirements, 'Requirements', lines: 3, hint: 'One per line'),
            _field(_skills, 'Skills', hint: 'Comma separated'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('Application deadline'),
              subtitle: Text(_deadline == null ? 'No deadline' : formatDate(_deadline!)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (_deadline != null)
                  IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _deadline = null)),
                TextButton(onPressed: _pickDeadline, child: const Text('Change')),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                controller: _max,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = int.tryParse(v.trim());
                  return (n == null || n < 1) ? 'Enter a whole number' : null;
                },
                decoration: const InputDecoration(
                  labelText: 'Max applicants (optional)',
                  helperText: 'Applications close automatically when this is reached',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _busy ? null : _submit,
                child: Text(_busy ? 'Posting...' : 'Post job'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
