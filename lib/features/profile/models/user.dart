// This class holds all the data for a single user.
// We use it across the profile, edit, and settings screens.

class User{
  String name;
  String major;
  String campus;
  String classYear;
  int impactScore;       // e.g. 850
  int maxImpactScore;    // always 1000
  String rankLabel;      // e.g. "Top 6% Globally"
  String nextLevel;      // e.g. "Impact Titan"
  List<String> badges;   // e.g. ["Global Leader", "Hacker Extra"]
  List<String> joinedHubs;
  int eventsAttended;
  int communities;
  int connections;

  User({
    required this.name,
    required this.major,
    required this.campus,
    required this.classYear,
    required this.impactScore,
    this.maxImpactScore = 1000,
    required this.rankLabel,
    required this.nextLevel,
    required this.badges,
    required this.joinedHubs,
    required this.eventsAttended,
    required this.communities,
    required this.connections,
  });
}