import 'package:flutter/material.dart';
import '../../../core/validators.dart';
import '../../../state/app_state.dart';
import '../domain/app_user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.seeker;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final nav = Navigator.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final err = await appState.register(
        _name.text.trim(), _email.text.trim(), _password.text, _role);
    if (err == null) {
      nav.pop();
    } else if (mounted) {
      setState(() {
        _busy = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmployer = _role == UserRole.employer;
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('I am a...'),
            const SizedBox(height: 8),
            SegmentedButton<UserRole>(
              segments: const [
                ButtonSegment(value: UserRole.seeker, label: Text('Job seeker'), icon: Icon(Icons.person_search)),
                ButtonSegment(value: UserRole.employer, label: Text('Employer'), icon: Icon(Icons.business)),
              ],
              selected: {_role},
              onSelectionChanged: (s) => setState(() => _role = s.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              validator: requiredField,
              decoration: InputDecoration(
                  labelText: isEmployer ? 'Company name' : 'Full name',
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: emailField,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              validator: passwordField,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Show password' : 'Hide password',
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(_busy ? 'Creating...' : 'Create account'),
            ),
          ]),
        ),
      ),
    );
  }
}