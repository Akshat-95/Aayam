class UserRanking {
  final int rank;
  final String userId;
  final String name;
  final String avatarUrl;
  final int xp;
  final bool isCurrentUser;

  const UserRanking({
    required this.rank,
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.xp,
    this.isCurrentUser = false,
  });

  // Sample data generator for testing
  static List<UserRanking> generateSampleRankings(
    String scope, {
    String currentUserId = '1',
  }) {
    final List<UserRanking> rankings = [];
    final scopePrefix = scope[0].toUpperCase();

    for (int i = 1; i <= 20; i++) {
      rankings.add(
        UserRanking(
          rank: i,
          userId: i.toString(),
          name: '$scopePrefix-User$i',
          avatarUrl: 'assets/avatars/user$i.png',
          xp: 25000 - (i * 1000),
          isCurrentUser: i.toString() == currentUserId,
        ),
      );
    }
    return rankings;
  }
}
