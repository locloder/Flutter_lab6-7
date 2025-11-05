
class GitHubProfile {
  final String login;
  final String name;
  final String avatarUrl;
  final String htmlUrl;
  final String bio;
  final int publicRepos;
  final int followers;
  final int following;
  
  GitHubProfile({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.bio,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GitHubProfile.fromJson(Map<String, dynamic> json) {
    return GitHubProfile(
      login: json['login'] ?? 'N/A',
      name: json['name'] ?? json['login'] ?? 'N/A',
      avatarUrl: json['avatar_url'] ?? '',
      htmlUrl: json['html_url'] ?? '',
      bio: json['bio'] ?? 'No bio provided.',
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }
}