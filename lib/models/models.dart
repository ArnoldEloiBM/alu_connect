/// Data models for the Home Feed & Discovery feature.
///
/// These are plain Dart classes with simple `fromJson` constructors so the
/// mock data layer can later be swapped for a real backend without touching
/// the UI.
library;

enum OpportunityType { hackathon, internship, fellowship, event, program }

enum EventStatus { active, postponed, cancelled }

extension EventStatusLabel on EventStatus {
  String get label {
    switch (this) {
      case EventStatus.active:
        return 'Active';
      case EventStatus.postponed:
        return 'Postponed';
      case EventStatus.cancelled:
        return 'Cancelled';
    }
  }
}

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
  final EventStatus status;

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
    this.status = EventStatus.active,
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
      status: EventStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => EventStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'type': type.name,
        'imageUrl': imageUrl,
        'deadline': deadline.toIso8601String(),
        'score': score,
        'trending': trending,
        'organizer': organizer,
        'location': location,
        'status': status.name,
      };

  Opportunity copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    OpportunityType? type,
    String? imageUrl,
    DateTime? deadline,
    int? score,
    bool? trending,
    String? organizer,
    String? location,
    EventStatus? status,
  }) {
    return Opportunity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      deadline: deadline ?? this.deadline,
      score: score ?? this.score,
      trending: trending ?? this.trending,
      organizer: organizer ?? this.organizer,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }
}

/// Input payload for the event creation form (Member 4).
class CreateEventInput {
  final String title;
  final String subtitle;
  final String description;
  final OpportunityType type;
  final String location;
  final DateTime deadline;
  final String? localImagePath;
  final int? capacity;

  const CreateEventInput({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.location,
    required this.deadline,
    this.localImagePath,
    this.capacity,
  });
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

class Community {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final int members;
  final List<Discussion> discussions;

  const Community({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.members,
    required this.discussions,
  });
}

class ChatThread {
  final String id;
  final String title;
  final String subtitle;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isGroup;
  final String communityId;

  const ChatThread({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isGroup,
    required this.communityId,
  });
}

class Message {
  final String id;
  final String threadId;
  final String sender;
  final String text;
  final DateTime time;
  final bool isMine;

  const Message({
    required this.id,
    required this.threadId,
    required this.sender,
    required this.text,
    required this.time,
    required this.isMine,
  });
}
