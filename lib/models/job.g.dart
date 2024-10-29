// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      jobId: json['job_id'] as String,
      companyId: json['company_id'] as String,
      jobTitle: json['job_title'] as String,
      jobDescription: json['job_description'] as String,
      requiredSkills: (json['required_skills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      requiredExperience: json['required_experience'] as String,
      location: json['location'] as String,
      salary: (json['salary'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'job_id': instance.jobId,
      'company_id': instance.companyId,
      'job_title': instance.jobTitle,
      'job_description': instance.jobDescription,
      'required_skills': instance.requiredSkills,
      'required_experience': instance.requiredExperience,
      'location': instance.location,
      'salary': instance.salary,
      'created_at': instance.createdAt.toIso8601String(),
    };
