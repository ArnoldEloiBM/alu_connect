import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_repository.dart';
import '../models/models.dart';
import 'event_image_storage.dart';
import 'user_session.dart';

/// Central state for RSVP, saved events, and organizer-created events.
class EventService extends ChangeNotifier {
  EventService._();
  static final EventService instance = EventService._();

  static const _rsvpKey = 'rsvp_event_ids';
  static const _savedKey = 'saved_event_ids';
  static const _createdKey = 'created_events';

  final Set<String> _rsvpedIds = {};
  final Set<String> _savedIds = {};
  final List<Opportunity> _createdEvents = [];

  bool _ready = false;
  bool get isReady => _ready;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _rsvpedIds
      ..clear()
      ..addAll(prefs.getStringList(_rsvpKey) ?? const []);
    _savedIds
      ..clear()
      ..addAll(prefs.getStringList(_savedKey) ?? const []);

    final raw = prefs.getStringList(_createdKey) ?? const [];
    _createdEvents
      ..clear()
      ..addAll(
        raw.map((s) => Opportunity.fromJson(jsonDecode(s) as Map<String, dynamic>)),
      );

    _ready = true;
    notifyListeners();
  }

  bool isRsvped(String id) => _rsvpedIds.contains(id);
  bool isSaved(String id) => _savedIds.contains(id);
  bool isUserCreated(String id) => _createdEvents.any((e) => e.id == id);

  bool isOrganizer(Opportunity event) {
    if (!isUserCreated(event.id)) return false;
    final current = UserSession.instance.displayName.toLowerCase();
    return event.organizer.toLowerCase() == current;
  }

  bool isRegistrationOpen(Opportunity o) {
    if (o.status == EventStatus.cancelled) return false;
    final now = MockRepository.instance.today;
    return !o.deadline.isBefore(now);
  }

  Opportunity? opportunityById(String id) {
    for (final o in _createdEvents) {
      if (o.id == id) return o;
    }
    return MockRepository.instance.getById(id);
  }

  List<Opportunity> get attendingEvents {
    return _rsvpedIds
        .map(opportunityById)
        .whereType<Opportunity>()
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  List<Opportunity> get savedEvents {
    return _savedIds
        .map(opportunityById)
        .whereType<Opportunity>()
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  List<Opportunity> get organizingEvents =>
      List.unmodifiable(_createdEvents);

  int attendeeCount(String eventId) {
    if (_rsvpedIds.contains(eventId)) {
      return 12 + eventId.hashCode.abs() % 40;
    }
    return 5 + eventId.hashCode.abs() % 20;
  }

  Future<bool> rsvp(String eventId) async {
    final event = opportunityById(eventId);
    if (event == null || !isRegistrationOpen(event)) return false;
    if (_rsvpedIds.contains(eventId)) return true;

    _rsvpedIds.add(eventId);
    await _persistRsvps();
    notifyListeners();
    return true;
  }

  Future<void> cancelRsvp(String eventId) async {
    _rsvpedIds.remove(eventId);
    await _persistRsvps();
    notifyListeners();
  }

  Future<void> toggleSave(String eventId) async {
    if (_savedIds.contains(eventId)) {
      _savedIds.remove(eventId);
    } else {
      _savedIds.add(eventId);
    }
    await _persistSaved();
    notifyListeners();
  }

  Future<Opportunity?> createEvent(CreateEventInput input) async {
    if (!UserSession.instance.hasProfileName) return null;

    final id = 'user_${DateTime.now().millisecondsSinceEpoch}';
    var imageUrl = _defaultImageForType(input.type);

    if (input.localImagePath != null) {
      final stored = await EventImageStorage.persistPickedImage(
        input.localImagePath!,
        id,
      );
      if (stored != null) imageUrl = stored;
    }

    final event = Opportunity(
      id: id,
      title: input.title.trim(),
      subtitle: input.subtitle.trim(),
      description: input.description.trim(),
      type: input.type,
      imageUrl: imageUrl,
      deadline: input.deadline,
      organizer: UserSession.instance.displayName,
      location: input.location.trim(),
      trending: false,
      status: EventStatus.active,
    );

    _createdEvents.insert(0, event);
    await _persistCreated();
    notifyListeners();
    return event;
  }

  Future<bool> postponeEvent(String eventId, DateTime newDeadline) async {
    final index = _createdEvents.indexWhere((e) => e.id == eventId);
    if (index < 0) return false;

    _createdEvents[index] = _createdEvents[index].copyWith(
      deadline: newDeadline,
      status: EventStatus.postponed,
    );
    await _persistCreated();
    notifyListeners();
    return true;
  }

  Future<bool> cancelEvent(String eventId) async {
    final index = _createdEvents.indexWhere((e) => e.id == eventId);
    if (index < 0) return false;

    _createdEvents[index] = _createdEvents[index].copyWith(
      status: EventStatus.cancelled,
    );
    await _persistCreated();
    notifyListeners();
    return true;
  }

  Future<void> _persistRsvps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_rsvpKey, _rsvpedIds.toList());
  }

  Future<void> _persistSaved() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_savedKey, _savedIds.toList());
  }

  Future<void> _persistCreated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _createdKey,
      _createdEvents.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  String _defaultImageForType(OpportunityType type) {
    const base = 'https://images.unsplash.com/photo-';
    switch (type) {
      case OpportunityType.hackathon:
        return '${base}1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80';
      case OpportunityType.internship:
        return '${base}1556761175-597462dc967e?auto=format&fit=crop&w=800&q=80';
      case OpportunityType.fellowship:
        return '${base}1522202176988-66273c96fd55?auto=format&fit=crop&w=800&q=80';
      case OpportunityType.event:
        return '${base}1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80';
      case OpportunityType.program:
        return '${base}1517245386807-bb43f82c33c4?auto=format&fit=crop&w=800&q=80';
    }
  }
}
