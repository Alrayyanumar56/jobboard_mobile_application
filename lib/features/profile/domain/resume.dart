import '../../jobs/domain/job.dart';

class Resume {
  final String headline;
  final String phone;
  final String location;
  final String summary;
  final String education;
  final String experience;
  final List<String> skills;

  const Resume({
    this.headline = '',
    this.phone = '',
    this.location = '',
    this.summary = '',
    this.education = '',
    this.experience = '',
    this.skills = const [],
  });

  bool get isComplete => headline.isNotEmpty && summary.isNotEmpty && skills.isNotEmpty;

  double get completeness {
    final filled = [headline, phone, location, summary, education, experience]
            .where((s) => s.isNotEmpty)
            .length +
        (skills.isEmpty ? 0 : 1);
    return filled / 7;
  }
}

/// Percentage of the job's required skills that the resume covers.
int matchScore(Resume? r, Job j) {
  if (r == null || r.skills.isEmpty || j.skills.isEmpty) return 0;
  final mine = r.skills.map((s) => s.toLowerCase()).toSet();
  final hit = j.skills.where((s) => mine.contains(s.toLowerCase())).length;
  return (hit * 100 / j.skills.length).round();
}
