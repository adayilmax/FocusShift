import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String id;
  final String time;
  final String title;

  Event({required this.id, required this.time, required this.title});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      time: data['time'] ?? '',
      title: data['title'] ?? '',
    );
  }
}

class EventProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userId;
  StreamSubscription? _subscription;

  List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  bool isLoading = false;

  EventProvider(this._userId) {
    if (_userId != null) {
      _listenToEvents();
    }
  }

  void updateUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      _events = [];
      _subscription?.cancel();
      if (_userId != null) {
        _listenToEvents();
      }
      notifyListeners();
    }
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    _subscription?.cancel();
    if (_userId != null) {
      _listenToEvents();
    }
    notifyListeners();
  }

  void _listenToEvents() {
    final day = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    isLoading = true;
    notifyListeners();

    _subscription = _firestore
        .collection('events')
        .where('userId', isEqualTo: _userId)
        .where('date', isEqualTo: Timestamp.fromDate(day))
        .orderBy('time')
        .snapshots()
        .listen((snapshot) {
      _events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addEvent(DateTime date, String time, String title) async {
    if (_userId == null) return;

    final day = DateTime(date.year, date.month, date.day);

    await _firestore.collection('events').add({
      'userId': _userId,
      'date': Timestamp.fromDate(day),
      'time': time,
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeEvent(String id) async {
    await _firestore.collection('events').doc(id).delete();
  }

  Future<void> updateEvent({
    required String id,
    required DateTime newDate,
    required String newTime,
    required String newTitle,
  }) async {
    await _firestore.collection('events').doc(id).update({
      'date': Timestamp.fromDate(DateTime(newDate.year, newDate.month, newDate.day)),
      'time': newTime,
      'title': newTitle,
    });
  }

  List<Event> getEventsForDay(DateTime date) {
    final formattedDate = DateTime(date.year, date.month, date.day);
    return _events;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
