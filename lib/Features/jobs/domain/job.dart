class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String employmentType;
  final String salary;
  final String description;
  final List<String> requirements;
  final List<String> skills;
  final DateTime postedDate;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.skills,
    required this.postedDate,
  });
}
