import 'package:json_annotation/json_annotation.dart';

part 'job.g.dart';

@JsonSerializable()
class Job {
  @JsonKey(name: 'job_id')
  final String jobId;
  @JsonKey(name: 'company_id')
  final String companyId;
  @JsonKey(name: 'job_title')
  final String jobTitle;
  @JsonKey(name: 'job_description')
  final String jobDescription;
  @JsonKey(name: 'required_skills')
  final List<String> requiredSkills;
  @JsonKey(name: 'required_experience')
  final String requiredExperience;
  final String location;
  final double salary;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Job({
    required this.jobId,
    required this.companyId,
    required this.jobTitle,
    required this.jobDescription,
    required this.requiredSkills,
    required this.requiredExperience,
    required this.location,
    required this.salary,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);
}
