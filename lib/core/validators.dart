String? requiredField(String? v) =>
    (v == null || v.trim().isEmpty) ? 'This field is required' : null;

String? emailField(String? v) {
  if (v == null || v.trim().isEmpty) return 'Enter your email';
  return (v.contains('@') && v.contains('.')) ? null : 'Enter a valid email';
}

String? passwordField(String? v) =>
    (v == null || v.length < 6) ? 'Use at least 6 characters' : null;
