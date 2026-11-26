enum JobAvailability { open, closed, expired, full }

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
  final String? employerEmail;
  final DateTime? deadline;
  final int? maxApplicants;
  final bool closed;

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
    this.employerEmail,
    this.deadline,
    this.maxApplicants,
    this.closed = false,
  });

  Job copyWith({DateTime? deadline, bool? closed}) => Job(
        id: id,
        title: title,
        company: company,
        location: location,
        employmentType: employmentType,
        salary: salary,
        description: description,
        requirements: requirements,
        skills: skills,
        postedDate: postedDate,
        employerEmail: employerEmail,
        deadline: deadline ?? this.deadline,
        maxApplicants: maxApplicants,
        closed: closed ?? this.closed,
      );
}
