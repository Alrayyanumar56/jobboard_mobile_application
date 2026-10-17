import '../domain/job.dart';

DateTime _ago(int days) => DateTime.now().subtract(Duration(days: days));

final List<Job> mockJobs = [
  Job(
    id: '1', title: 'Flutter Developer', company: 'Techlogix', location: 'Islamabad',
    employmentType: 'Full-time', salary: 'PKR 180k - 250k / month',
    description: 'Build and maintain cross-platform mobile apps used by thousands of customers. You will work closely with designers and backend engineers.',
    requirements: ['2+ years with Flutter and Dart', 'Experience with REST APIs', 'Git and code review habits'],
    skills: ['Flutter', 'Dart', 'REST', 'Git'], postedDate: _ago(0), deadline: _ago(-9), employerEmail: 'employer@demo.com',
  ),
  Job(
    id: '2', title: 'ASP.NET Core Backend Engineer', company: 'Systems Ltd', location: 'Lahore',
    employmentType: 'Full-time', salary: 'PKR 220k - 320k / month',
    description: 'Design and build secure APIs with ASP.NET Core and SQL Server for enterprise clients.',
    requirements: ['Strong C# fundamentals', 'Entity Framework Core', 'Clean architecture knowledge'],
    skills: ['C#', 'ASP.NET Core', 'SQL Server', 'EF Core'], postedDate: _ago(1), deadline: _ago(-6), maxApplicants: 3,
  ),
  Job(
    id: '3', title: 'UI/UX Design Intern', company: 'Pixel Studio', location: 'Remote',
    employmentType: 'Internship', salary: 'PKR 40k / month',
    description: 'Support our design team with wireframes, prototypes and user research for mobile products.',
    requirements: ['Portfolio of 2+ projects', 'Figma basics', 'Eye for detail'],
    skills: ['Figma', 'Wireframing', 'Research'], postedDate: _ago(2), deadline: _ago(-2),
  ),
  Job(
    id: '4', title: 'QA Engineer', company: 'Arbisoft', location: 'Lahore',
    employmentType: 'Full-time', salary: 'PKR 120k - 170k / month',
    description: 'Own the quality of our releases through manual and automated testing.',
    requirements: ['1+ year testing experience', 'Test case writing', 'Basic automation'],
    skills: ['Testing', 'Selenium', 'Postman'], postedDate: _ago(3), closed: true,
  ),
  Job(
    id: '5', title: 'WordPress Developer', company: 'WebCraft', location: 'Remote',
    employmentType: 'Part-time', salary: 'PKR 70k - 100k / month',
    description: 'Build and customise WordPress themes and plugins for small business clients.',
    requirements: ['PHP and WordPress experience', 'HTML, CSS, JavaScript', 'Good communication'],
    skills: ['WordPress', 'PHP', 'CSS'], postedDate: _ago(4), deadline: _ago(1),
  ),
  Job(
    id: '6', title: 'Data Analyst', company: 'Jazz', location: 'Islamabad',
    employmentType: 'Full-time', salary: 'PKR 150k - 210k / month',
    description: 'Turn raw data into dashboards and insights that guide product decisions.',
    requirements: ['SQL proficiency', 'Excel or Power BI', 'Analytical mindset'],
    skills: ['SQL', 'Power BI', 'Excel'], postedDate: _ago(5), deadline: _ago(-1), maxApplicants: 10,
  ),
  Job(
    id: '7', title: 'Software Engineering Intern', company: 'Folio3', location: 'Karachi',
    employmentType: 'Internship', salary: 'PKR 50k / month',
    description: 'Join a mentor-led team and contribute to real client projects from week one.',
    requirements: ['CS or SE student', 'Any programming language', 'Eagerness to learn'],
    skills: ['Programming', 'Git', 'Teamwork'], postedDate: _ago(6), deadline: _ago(-20),
  ),
  Job(
    id: '8', title: 'DevOps Engineer', company: 'Netsol', location: 'Lahore',
    employmentType: 'Full-time', salary: 'PKR 250k - 350k / month',
    description: 'Automate deployments and keep our cloud infrastructure reliable and secure.',
    requirements: ['Docker and CI/CD', 'Linux administration', 'Cloud experience'],
    skills: ['Docker', 'CI/CD', 'Linux', 'Azure'], postedDate: _ago(8), deadline: _ago(-30), maxApplicants: 25,
  ),
];
