import 'package:fbla_connect/entities/widgets/models/event_details_sheet.dart';
import 'package:fbla_connect/entities/widgets/models/event_model.dart';
import 'package:fbla_connect/services/events/events.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entities/color_pallete.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<FBLAEvent>> _eventsByDay = {};
  String _selectedFilter = 'All';
  bool _showOnlyUpcoming = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 48),
          _buildFilterChips(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _showOnlyUpcoming ? 'Showing upcoming' : 'Showing all events',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: !_showOnlyUpcoming,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyUpcoming = !value;
                    });
                  },
                  activeColor: uniqueTertiaryColor,
                  activeTrackColor: uniqueTertiaryColor.withAlpha(50),
                ),
              ],
            ),
          ), 

          Expanded(
            child: Consumer<EventService>(
              builder: (context, eventService, child) {
                return StreamBuilder<List<FBLAEvent>>(
                  stream: _getFilteredStream(eventService),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final events = snapshot.data ?? [];
                    _groupEventsByDay(events);

                    return Column(
                      children: [
                        _buildCalendar(),
                        
                        const SizedBox(height: 8),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDay == null
                                    ? 'Upcoming Events'
                                    : 'Events on ${_formatDate(_selectedDay!)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                ),
                              ),
                              Text(
                                '${_getEventsForSelectedDay(events).length} events',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Expanded(
                          child: _buildEventList(events),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: _buildAddEventButton(),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', Icons.all_inclusive),
          const SizedBox(width: 8),
          _buildFilterChip('competition', Icons.emoji_events),
          const SizedBox(width: 8),
          _buildFilterChip('meeting', Icons.groups),
          const SizedBox(width: 8),
          _buildFilterChip('workshop', Icons.handyman),
          const SizedBox(width: 8),
          _buildFilterChip('social', Icons.celebration),
          const SizedBox(width: 8),
          _buildFilterChip('service', Icons.volunteer_activism),
          const SizedBox(width: 8),
          _buildFilterChip('fundraiser', Icons.attach_money),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(EventService.formatEventType(label)),
      avatar: Icon(icon, size: 16),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? label : 'All';
        });
      },
      selectedColor: tertiaryColor,
      backgroundColor: const Color.fromARGB(183, 244, 244, 244),
      iconTheme: IconThemeData(
        color: isSelected ? Colors.white : secondaryColor,
      ),
      checkmarkColor: uniqueTertiaryColor,
    );
  }

  Stream<List<FBLAEvent>> _getFilteredStream(EventService service) {
    if (_selectedFilter == 'All') { 
      return _showOnlyUpcoming 
          ? service.getUpcomingEvents() 
          : service.getAllEvents();
    } else {
      return service.getEventsByType(_selectedFilter);
    }
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2026, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: (day) => _eventsByDay[day] ?? [],
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: CalendarStyle(
        markerDecoration: const BoxDecoration(
          color: tertiaryColor, 
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: uniqueTertiaryColor.withAlpha(100),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: uniqueTertiaryColor, 
          shape: BoxShape.circle,
        ),
        weekendTextStyle: const TextStyle(color: Colors.red),
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003366),
        ),
        formatButtonDecoration: BoxDecoration(
          color: tertiaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        formatButtonTextStyle: const TextStyle(
          color: uniqueSecondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<FBLAEvent> _getEventsForSelectedDay(List<FBLAEvent> allEvents) {
    if (_selectedDay == null) {
      return allEvents;
    }
    return _eventsByDay[_selectedDay] ?? [];
  }

  Widget _buildEventList(List<FBLAEvent> allEvents) {
    final events = _getEventsForSelectedDay(allEvents);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: secondaryColor.withAlpha(200),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedDay == null
                  ? 'No upcoming events'
                  : 'No events on this day',
              style: TextStyle(
                fontSize: 16,
                color: secondaryColor.withAlpha(200),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(FBLAEvent event) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isRegistered = event.isUserRegistered(userId ?? '');
    final statusColor = event.getStatusColor();
    final statusText = event.registrationStatus;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: secondaryColor.withAlpha(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRegistered ? Colors.green : Colors.grey.shade300,
          width: isRegistered ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showEventDetails(event),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: uniqueTertiaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: uniqueTertiaryColor.withAlpha(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${event.date.month}/${event.date.day}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: uniqueTertiaryColor,
                          ),
                        ),
                        Text(
                          _getDayOfWeek(event.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: secondaryColor.withAlpha(200),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(event.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryColor.withAlpha(200),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: secondaryColor.withAlpha(200),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryColor.withAlpha(200),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.group,
                              size: 14,
                              color: secondaryColor.withAlpha(200),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${event.registeredUsers.length}/${event.maxParticipants} registered',
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryColor.withAlpha(200),
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (isRegistered)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withAlpha(20),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 12,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Registered',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetails(FBLAEvent event) {
    final eventService = Provider.of<EventService>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailsSheet(
        event: event,
        eventService: eventService,
      ),
    );
  }

  Widget? _buildAddEventButton() {
    return null;
  }

  void _groupEventsByDay(List<FBLAEvent> events) {
    _eventsByDay = {};
    for (var event in events) {
      final day = DateTime.utc(
        event.date.year,
        event.date.month,
        event.date.day,
      );
      if (_eventsByDay[day] == null) {
        _eventsByDay[day] = [];
      }
      _eventsByDay[day]!.add(event);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  String _getDayOfWeek(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}