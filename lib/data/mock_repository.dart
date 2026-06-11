import '../models/models.dart';

/// Returns a stable, topic-matched stock photo URL. Each opportunity is
/// hand-paired with one specific Unsplash photo so the image always fits its
/// theme (e.g. solar panels for a sustainability challenge, a server room for
/// a cloud internship). Unlike a keyword search, [id] pins one exact photo, so
/// it loads fast and never returns an off-topic result.
///
/// NOTE: these are curated stock photos, not pictures of real ALU events. When
/// the team has actual photos, drop them in `assets/` and replace these URLs
/// with asset paths (and use `Image.asset` in [AppImage]).
String _img(String id) =>
    'https://images.unsplash.com/photo-$id?auto=format&fit=crop&w=800&q=80';

/// In-memory data source for the Home Feed & Discovery feature.
///
/// This stands in for a real backend. The screens talk to this repository
/// through plain method calls; swapping in an HTTP client later means changing
/// only this file (and making the methods `async`).
class MockRepository {
  MockRepository._();
  static final MockRepository instance = MockRepository._();

  /// User's display name. Defaults to "User" until auth is implemented.
  /// When sign-in is added, this will be set to the authenticated user's name.
  String _greetingName = 'User';

  String get greetingName => _greetingName;

  set greetingName(String name) => _greetingName = name;

  // Reference "today" so relative copy like "Ends in 2 days" stays sensible
  // against the mock deadlines below. Replace with DateTime.now() when wired
  // to a real backend.
  static final DateTime _today = DateTime(2026, 6, 10);
  DateTime get today => _today;

  final List<Opportunity> _opportunities = [
    Opportunity(
      id: 'op1',
      title: 'ALU Innovators Hackathon',
      subtitle: 'Build for impact',
      description:
          'A 48-hour hackathon bringing together ALU\'s brightest builders '
          'to solve real challenges facing African communities. Form a team, '
          'ship a prototype, and pitch to a panel of industry judges.',
      type: OpportunityType.hackathon,
      imageUrl: _img('1504384308090-c894fdcc538d'), // hackathon hall
      deadline: DateTime(2026, 6, 12),
      trending: true,
      organizer: 'ALU Entrepreneurship Lab',
      location: 'Kigali Campus',
    ),
    Opportunity(
      id: 'op2',
      title: 'Google Internship',
      subtitle: 'Product Design',
      description:
          'A 12-week summer internship on Google\'s Product Design team. '
          'Work alongside senior designers on real products used by millions.',
      type: OpportunityType.internship,
      imageUrl: _img('1581291518857-4e27b48ff24e'), // UI/UX wireframe sketch
      deadline: DateTime(2026, 7, 1),
      trending: true,
      organizer: 'Google',
      location: 'Remote',
    ),
    Opportunity(
      id: 'op3',
      title: 'Sustainability Tech Challenge 2024',
      subtitle: 'Solve real environmental challenges',
      description:
          'Join global leaders to solve environmental challenges using AI and '
          'IoT technologies. Top teams receive funding and mentorship to take '
          'their solution to market.',
      type: OpportunityType.hackathon,
      imageUrl: _img('1509391366360-2e959784a276'), // solar panels
      deadline: DateTime(2026, 10, 24),
      score: 850,
      trending: true,
      organizer: 'Green Future Foundation',
      location: 'Online',
    ),
    Opportunity(
      id: 'op4',
      title: 'Software Eng. Fellowship',
      subtitle: 'Final Application Submission',
      description:
          'A six-month fellowship pairing fellows with experienced engineering '
          'mentors at top startups across the continent.',
      type: OpportunityType.fellowship,
      imageUrl: _img('1461749280684-dccba630e2f6'), // source code on screen
      deadline: DateTime(2026, 10, 30),
      organizer: 'Africa Code Network',
      location: 'Hybrid',
    ),
    Opportunity(
      id: 'op6',
      title: 'Microsoft Software Engineering Internship',
      subtitle: 'Backend & Cloud',
      description:
          'Spend the summer building scalable cloud services with Microsoft\'s '
          'Azure team. Open to penultimate-year students.',
      type: OpportunityType.internship,
      imageUrl: _img('1558494949-ef010cbdcc31'), // data center / servers
      deadline: DateTime(2026, 7, 15),
      organizer: 'Microsoft',
      location: 'Nairobi / Remote',
    ),
    Opportunity(
      id: 'op7',
      title: 'AfricaTech Builders Hackathon',
      subtitle: 'Fintech for the unbanked',
      description:
          'A weekend hackathon focused on financial inclusion. Build a working '
          'prototype and pitch to a panel of fintech founders.',
      type: OpportunityType.hackathon,
      imageUrl: _img('1522071820081-009f0129c71c'), // team coding together
      deadline: DateTime(2026, 8, 2),
      organizer: 'AfricaTech',
      location: 'Lagos',
    ),
    Opportunity(
      id: 'op8',
      title: 'Andela Engineering Internship',
      subtitle: 'Full-Stack Development',
      description:
          'A paid internship placing you on a distributed engineering team '
          'building products for global clients. Mentorship included.',
      type: OpportunityType.internship,
      imageUrl: _img('1573164713988-8665fc963095'), // African developers coding
      deadline: DateTime(2026, 7, 20),
      organizer: 'Andela',
      location: 'Remote',
    ),
    Opportunity(
      id: 'op9',
      title: 'Flutterwave Product Internship',
      subtitle: 'Payments & Growth',
      description:
          'Join Flutterwave\'s product team to help scale digital payments '
          'across Africa. Work on real features shipped to merchants.',
      type: OpportunityType.internship,
      imageUrl: _img('1556742502-ec7c0e9f34b1'), // mobile card payment
      deadline: DateTime(2026, 8, 10),
      organizer: 'Flutterwave',
      location: 'Lagos / Hybrid',
    ),
    Opportunity(
      id: 'op10',
      title: 'UNICEF Data Science Internship',
      subtitle: 'Data for Good',
      description:
          'Use data science to support UNICEF programmes improving outcomes '
          'for children. Open to students with Python experience.',
      type: OpportunityType.internship,
      imageUrl: _img('1551288049-bebda4e38f71'), // analytics dashboard
      deadline: DateTime(2026, 9, 1),
      organizer: 'UNICEF',
      location: 'Kigali',
    ),
    Opportunity(
      id: 'op11',
      title: 'Climate Hack Africa 2026',
      subtitle: 'Tech for the planet',
      description:
          'A continent-wide hackathon to prototype climate-resilience tools. '
          'Winning teams join an accelerator with seed funding.',
      type: OpportunityType.hackathon,
      imageUrl: _img('1441974231531-c6227db76b6e'), // forest / nature
      deadline: DateTime(2026, 8, 25),
      organizer: 'Climate Hack',
      location: 'Accra',
    ),
    Opportunity(
      id: 'op12',
      title: 'HealthTech Hackathon',
      subtitle: 'Build for better care',
      description:
          'A 36-hour sprint to design digital health solutions for rural '
          'clinics. Clinicians and engineers team up to ship prototypes.',
      type: OpportunityType.hackathon,
      imageUrl: _img('1576091160550-2173dba999ef'), // health / medical tech
      deadline: DateTime(2026, 9, 14),
      organizer: 'MedConnect',
      location: 'Kampala',
    ),
    Opportunity(
      id: 'op13',
      title: 'ALU x AWS Cloud Hackathon',
      subtitle: 'Serverless challenge',
      description:
          'Partner with AWS architects to build a serverless app over a '
          'weekend. Best solutions win AWS credits and certification vouchers.',
      type: OpportunityType.hackathon,
      imageUrl: _img('1544197150-b99a580bb7a8'), // network / cloud cabling
      deadline: DateTime(2026, 7, 28),
      organizer: 'ALU x AWS',
      location: 'Kigali Campus',
    ),
    Opportunity(
      id: 'op5',
      title: 'Kigali Tech Summit RSVP',
      subtitle: 'Networking Event • 10:00 AM',
      description:
          'The largest tech gathering in the region. Meet founders, investors '
          'and engineers shaping East Africa\'s tech scene.',
      type: OpportunityType.event,
      imageUrl: _img('1540575467063-178a50c2df87'), // conference audience
      deadline: DateTime(2026, 6, 14),
      organizer: 'Kigali Innovation City',
      location: 'Kigali Convention Centre',
    ),
  ];

  final List<Category> _categories = [
    Category(
      id: 'cat1',
      name: 'Tech',
      subtitle: '24 Active Communities',
      imageUrl: _img('1620712943543-bcc4688e7485'), // AI / robotics
    ),
    Category(
      id: 'cat2',
      name: 'Entrepreneurship',
      subtitle: '12 Active Programs',
      imageUrl: _img('1556761175-b413da4baf72'), // startup team meeting
    ),
    Category(
      id: 'cat3',
      name: 'Leadership',
      subtitle: '8 Leadership Tracks',
      imageUrl: _img('1454165804606-c3d57bc86b40'), // strategy / leadership session
    ),
  ];

  final List<Discussion> _discussions = const [
    Discussion(
      id: 'd1',
      title: 'Impact of AI in Mauritius Startups',
      participants: 45,
    ),
    Discussion(id: 'd2', title: 'Club Fair \'24', participants: 18),
    Discussion(id: 'd3', title: 'Bug Hunters', participants: 9),
    Discussion(id: 'd4', title: 'Green Tech Collaboration', participants: 34),
    Discussion(id: 'd5', title: 'Design Sprint Ideas', participants: 27),
  ];

  final List<Community> _communities = [
    Community(
      id: 'c1',
      name: 'AI & ML Society',
      category: 'Tech',
      description:
          'A community for learners and builders exploring machine learning, data science, and AI-driven products.',
      imageUrl: _img('1500534623284-43e6a8d38cad'),
      members: 82,
      discussions: const [
        Discussion(id: 'd1', title: 'Impact of AI in Mauritius Startups', participants: 45),
        Discussion(id: 'd5', title: 'Design Sprint Ideas', participants: 27),
      ],
    ),
    Community(
      id: 'c2',
      name: 'Entrepreneurship Hub',
      category: 'Entrepreneurship',
      description:
          'Founders and operators share funding tips, pitch feedback, and partner opportunities.',
      imageUrl: _img('1507679799987-c73779587ccf'),
      members: 119,
      discussions: const [
        Discussion(id: 'd2', title: 'Club Fair \'24', participants: 18),
        Discussion(id: 'd4', title: 'Green Tech Collaboration', participants: 34),
      ],
    ),
    Community(
      id: 'c3',
      name: 'Leadership Forum',
      category: 'Leadership',
      description:
          'Peer-led conversations on leading teams, running student projects, and building lifecycle skills.',
      imageUrl: _img('1494790108377-be9c29b29330'),
      members: 64,
      discussions: const [
        Discussion(id: 'd3', title: 'Bug Hunters', participants: 9),
      ],
    ),
  ];

  final List<ChatThread> _chatThreads = [
    ChatThread(
      id: 'thread-c1',
      title: 'AI & ML Society',
      subtitle: 'Community chat',
      lastMessage: 'Can we meet after the workshop?',
      timestamp: DateTime(2026, 6, 10, 16, 30),
      unreadCount: 3,
      isGroup: true,
      communityId: 'c1',
    ),
    ChatThread(
      id: 'thread-c2',
      title: 'Entrepreneurship Hub',
      subtitle: 'Community chat',
      lastMessage: 'Pitch deck review tomorrow.',
      timestamp: DateTime(2026, 6, 9, 18, 12),
      unreadCount: 1,
      isGroup: true,
      communityId: 'c2',
    ),
    ChatThread(
      id: 'thread-c3',
      title: 'Leadership Forum',
      subtitle: 'Community chat',
      lastMessage: 'Who wants to co-host the next session?',
      timestamp: DateTime(2026, 6, 8, 14, 55),
      unreadCount: 0,
      isGroup: true,
      communityId: 'c3',
    ),
  ];

  final List<Message> _messages = [
    Message(
      id: 'm1',
      threadId: 'thread-c1',
      sender: 'Amina',
      text: 'Anyone wants to join the AI lab session tomorrow?',
      time: DateTime(2026, 6, 10, 15, 20),
      isMine: false,
    ),
    Message(
      id: 'm2',
      threadId: 'thread-c1',
      sender: 'You',
      text: 'I can attend after 4pm.',
      time: DateTime(2026, 6, 10, 15, 22),
      isMine: true,
    ),
    Message(
      id: 'm3',
      threadId: 'thread-c1',
      sender: 'Musa',
      text: 'Let’s meet at the innovation hub.',
      time: DateTime(2026, 6, 10, 15, 24),
      isMine: false,
    ),
    Message(
      id: 'm4',
      threadId: 'thread-c1',
      sender: 'You',
      text: 'Sounds good! See you there.',
      time: DateTime(2026, 6, 10, 15, 25),
      isMine: true,
    ),
  ];

  // ---- Query methods -------------------------------------------------------

  List<Opportunity> get allOpportunities => List.unmodifiable(_opportunities);

  Opportunity? getById(String id) {
    for (final o in _opportunities) {
      if (o.id == id) return o;
    }
    return null;
  }

  List<Opportunity> get trending =>
      _opportunities.where((o) => o.trending).toList();

  List<Category> get categories => List.unmodifiable(_categories);

  List<Discussion> get discussions => List.unmodifiable(_discussions);

  int get upcomingDeadlineCount => deadlines.length;

  List<Community> get communities => List.unmodifiable(_communities);

  List<ChatThread> get chatThreads => List.unmodifiable(_chatThreads);

  List<Message> messagesForThread(String threadId) =>
      _messages.where((message) => message.threadId == threadId).toList();

  /// Upcoming deadlines, soonest first.
  List<Deadline> get deadlines {
    final items = _opportunities
        .map((o) => Deadline(
              id: o.id,
              title: o.title,
              subtitle: o.subtitle,
              date: o.deadline,
              urgent: o.deadline.difference(_today).inDays <= 7,
            ))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return items;
  }

  /// Filter the feed by opportunity type. Pass `null` for "All".
  List<Opportunity> filterByType(OpportunityType? type) {
    if (type == null) return allOpportunities;
    return _opportunities.where((o) => o.type == type).toList();
  }

  /// Full-text-ish search across title, subtitle and organizer.
  List<Opportunity> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return _opportunities.where((o) {
      return o.title.toLowerCase().contains(q) ||
          o.subtitle.toLowerCase().contains(q) ||
          o.organizer.toLowerCase().contains(q) ||
          o.type.label.toLowerCase().contains(q);
    }).toList();
  }
}
