/// Data models for the Home Feed & Discovery feature.
///
/// These are plain Dart classes with simple `fromJson` constructors so the
/// mock data layer can later be swapped for a real backend without touching
/// the UI.
library;

enum OpportunityType { hackathon, internship, fellowship, event, program }

extension OpportunityTypeLabel on OpportunityType {
  String get label {
    switch (this) {
      case OpportunityType.hackathon:
        return 'Hackathon';
      case OpportunityType.internship:
        return 'Internship';
      case OpportunityType.fellowship:
        return 'Fellowship';
      case OpportunityType.event:
        return 'Event';
      case OpportunityType.program:
        return 'Program';
    }
  }
}

class Opportunity {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final OpportunityType type;
  final String imageUrl;
  final DateTime deadline;
  final int? score;
  final bool trending;
  final String organizer;
  final String location;

  const Opportunity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.deadline,
    this.score,
    this.trending = false,
    this.organizer = '',
    this.location = '',
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: OpportunityType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => OpportunityType.event,
      ),
      imageUrl: json['imageUrl'] as String? ?? '',
      deadline: DateTime.parse(json['deadline'] as String),
      score: json['score'] as int?,
      trending: json['trending'] as bool? ?? false,
      organizer: json['organizer'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}

class Category {
  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
  });
}

class Deadline {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final bool urgent;

  const Deadline({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    this.urgent = false,
  });
}

class Discussion {
  final String id;
  final String title;
  final int participants;

  const Discussion({
    required this.id,
    required this.title,
    required this.participants,
  });
}
