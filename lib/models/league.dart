class League {
  final String name;
  final int requiredXP;
  final String iconPath;
  final String reward;
  final String rewardDescription;

  const League({
    required this.name,
    required this.requiredXP,
    required this.iconPath,
    required this.reward,
    required this.rewardDescription,
  });

  static List<League> allLeagues = [
    League(
      name: 'Neighborhood Watcher',
      requiredXP: 0,
      iconPath: 'assets/icons/neighborhood_watcher.png',
      reward: 'Digital "Welcome" Certificate',
      rewardDescription: 'Welcome to the community of active citizens!',
    ),
    League(
      name: 'Community Helper',
      requiredXP: 250,
      iconPath: 'assets/icons/community_helper.png',
      reward: '"Clean Sidewalk" profile badge',
      rewardDescription: 'Recognition for your local impact',
    ),
    League(
      name: 'Street Captain',
      requiredXP: 1000,
      iconPath: 'assets/icons/street_captain.png',
      reward: 'App theme customization options',
      rewardDescription: 'Personalize your app experience',
    ),
    League(
      name: 'Ward Warrior',
      requiredXP: 2500,
      iconPath: 'assets/icons/ward_warrior.png',
      reward: '"Verified Reporter" checkmark',
      rewardDescription: 'Distinguished status on your profile',
    ),
    League(
      name: 'City Sentinel',
      requiredXP: 5000,
      iconPath: 'assets/icons/city_sentinel.png',
      reward: 'Community Spotlight Feature',
      rewardDescription: 'Featured in monthly community highlights',
    ),
    League(
      name: 'State Champion',
      requiredXP: 10000,
      iconPath: 'assets/icons/state_champion.png',
      reward: 'Premium "Civic Leader" frame',
      rewardDescription: 'Exclusive profile enhancement',
    ),
    League(
      name: 'National Hero',
      requiredXP: 25000,
      iconPath: 'assets/icons/national_hero.png',
      reward: 'Tree Planting Initiative',
      rewardDescription: 'A tree planted in your name',
    ),
  ];

  static League getCurrentLeague(int currentXP) {
    for (int i = allLeagues.length - 1; i >= 0; i--) {
      if (currentXP >= allLeagues[i].requiredXP) {
        return allLeagues[i];
      }
    }
    return allLeagues.first;
  }

  static League getNextLeague(int currentXP) {
    for (var league in allLeagues) {
      if (currentXP < league.requiredXP) {
        return league;
      }
    }
    return allLeagues.last;
  }
}
