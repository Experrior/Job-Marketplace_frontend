import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../models/job.dart';

class JobTile extends StatelessWidget {
  const JobTile({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CupertinoListTile(
        onTap: () {},
        padding: const EdgeInsets.all(16),
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.jobTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(6),
            Row(
              children: [
                _JobTags(job: job),
                const Spacer(),
                _JobSalary(job: job),
              ],
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.jobDescription,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(6),
            _JobLocation(job: job),

          ],
        ),
      ),
    );
  }
}

class _JobSalary extends StatelessWidget {
  const _JobSalary({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Text(
      "\$ ${job.salary}",
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}


class _JobLocation extends StatelessWidget {
  const _JobLocation({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          CupertinoIcons.location,
          size: 16,
          color: Theme.of(context).textTheme.labelSmall!.color,
        ),
        const Gap(6),
        Text(
          job.location,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _JobTags extends StatelessWidget {
  const _JobTags({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: ThemeData(
          chipTheme: const ChipThemeData(
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: Wrap(
          spacing: 6,
          children: job.requiredSkills
              .map(
                (tag) => Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
