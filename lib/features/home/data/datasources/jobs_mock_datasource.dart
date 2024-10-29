import 'package:job_search_app/features/home/data/datasources/jobs_datasource.dart';
import 'package:job_search_app/models/job.dart';

class JobsMockDatasource implements IJobsDatasource {
  @override
  Future<List<Job>> getJobs() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final List<Job> jobs = [
      Job(
        jobId: '1',
        companyId: '1',
        jobTitle: 'Senior Flutter Developer',
        jobDescription:
            'We are looking for a Senior Flutter Developer to join our team',
        requiredSkills: ['Flutter', 'Dart', 'Firebase'],
        requiredExperience: '3 years',
        location: 'Remote',
        salary: 5000,
        createdAt: DateTime.now(),
      ),
      Job(
        jobId: '2',
        companyId: '2',
        jobTitle: 'Senior React Developer',
        jobDescription:
            'We are looking for a Senior React Developer to join our team',
        requiredSkills: ['React', 'JavaScript', 'Redux'],
        requiredExperience: '3 years',
        location: 'Remote',
        salary: 5000,
        createdAt: DateTime.now(),
      ),
      Job(
        jobId: '3',
        companyId: '3',
        jobTitle: 'Senior Node.js Developer',
        jobDescription:
            'We are looking for a Senior Node.js Developer to join our team',
        requiredSkills: ['Node.js', 'Express', 'MongoDB'],
        requiredExperience: '3 years',
        location: 'Remote',
        salary: 5000,
        createdAt: DateTime.now(),
      ),
      Job(
        jobId: '4',
        companyId: '4',
        jobTitle: 'Senior Python Developer',
        jobDescription:
            'We are looking for a Senior Python Developer to join our team',
        requiredSkills: ['Python', 'Django', 'PostgreSQL'],
        requiredExperience: '3 years',
        location: 'Remote',
        salary: 5000,
        createdAt: DateTime.now(),
      ),
      Job(
        jobId: '5',
        companyId: '5',
        jobTitle: 'Senior Java Developer',
        jobDescription:
            'We are looking for a Senior Java Developer to join our team',
        requiredSkills: ['Java', 'Spring', 'MySQL'],
        requiredExperience: '3 years',
        location: 'Remote',
        salary: 5000,
        createdAt: DateTime.now(),
      ),
      Job(
        jobId: '6',
        companyId: '6',
        jobTitle: 'Senior Ruby Developer',
        jobDescription:
            'We are looking for a Senior Ruby Developer to join our team',
        requiredSkills: ['Ruby', 'Rails', 'PostgreSQL'],
        requiredExperience: '3 years',
        location: 'Remote',
        salary: 5000,
        createdAt: DateTime.now(),
      ),
      Job(
        jobId: '7',
        companyId: '7',
        jobTitle: 'Senior PHP Developer',
        jobDescription:
            'We are looking for a Senior PHP Developer to join our team',
        requiredSkills: ['PHP', 'Laravel', 'MySQL'],
        requiredExperience: '3 years',
        location: 'Remote',
        salary: 5000,
        createdAt: DateTime.now(),
      ),
    ];
    return jobs;
  }
}
