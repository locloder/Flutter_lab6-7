import 'package:flutter/material.dart';
import 'package:my_personal_app/models/user_profile.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile userProfile;
  final String title;

  const ProfileCard({
    super.key,
    required this.userProfile,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              userProfile.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 5),
            Text(
              userProfile.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(userProfile.bio),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: userProfile.skills
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text("Email: ${userProfile.email}"),
            // Блок коду, що відноситься до GitHub, видалено
          ],
        ),
      ),
    );
  }
}