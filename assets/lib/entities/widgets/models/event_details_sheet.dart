import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:fbla_connect/services/events/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event_model.dart';

class EventDetailsSheet extends StatefulWidget {
  final FBLAEvent event;
  final EventService eventService; 

  const EventDetailsSheet({
    super.key, 
    required this.event,
    required this.eventService, 
  });

  @override
  State<EventDetailsSheet> createState() => _EventDetailsSheetState();
}

class _EventDetailsSheetState extends State<EventDetailsSheet> {
  bool _isLoading = false;
  

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isRegistered = event.isUserRegistered(userId ?? '');
    final statusColor = event.getStatusColor();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header with image
          if (event.imageUrl != null)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and type
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: uniqueTertiaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          event.registrationStatus,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCC00).withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      EventService.formatEventType(event.eventType),
                      style: const TextStyle(
                        color: Color(0xFF003366),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Date',
                    _formatFullDate(event.date),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildDetailRow(
                    Icons.access_time,
                    'Time',
                    _formatTimeRange(event),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildDetailRow(
                    Icons.location_on,
                    'Location',
                    event.location,
                    isLink: event.isVirtual && event.meetingLink != null,
                    link: event.meetingLink,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildDetailRow(
                    Icons.group,
                    'Capacity',
                    '${event.registeredUsers.length} / ${event.maxParticipants} registered',
                    child: event.availableSpots > 0
                        ? Text(
                            '${event.availableSpots} spots left',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          )
                        : null,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildDetailRow(
                    Icons.event_busy,
                    'Registration Deadline',
                    _formatFullDate(event.registrationDeadline),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildDetailRow(
                    Icons.person,
                    'Organizer',
                    event.organizer,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Registration button
                  if (!isRegistered)
                    _buildRegisterButton(event)
                  else
                    _buildUnregisterButton(event),
                  
                  const SizedBox(height: 16),
                  
                  // Share button
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share feature coming soon!'), 
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, color: uniqueTertiaryColor,),
                    label: const CustomNormalText(
                      text: 'Share Event',
                      color: uniqueTertiaryColor,
                      fontSize: 16,
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: Color(0xFF003366)),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {bool isLink = false, String? link, Widget? child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFFFFCC00),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              if (isLink && link != null)
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(link);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              if (child != null) child,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(FBLAEvent event) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: event.isRegistrationOpen && !_isLoading
            ? () => _registerForEvent(event)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                !event.isRegistrationOpen
                    ? 'Registration Closed'
                    : 'Register for Event',
              ),
      ),
    );
  }

  Widget _buildUnregisterButton(FBLAEvent event) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isLoading ? null : () => _unregisterFromEvent(event),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 2,
                ),
              )
            : const Text('Cancel Registration'),
      ),
    );
  }

  Future<void> _registerForEvent(FBLAEvent event) async {
    setState(() => _isLoading = true);
    
    try {
      await widget.eventService.registerForEvent(event.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully registered for ${event.title}!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _unregisterFromEvent(FBLAEvent event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryColor,
        title: const Text('Cancel Registration'),
        content: Text('Are you sure you want to cancel your registration for ${event.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(color: Colors.grey),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    
    try {
      final eventService = Provider.of<EventService>(context, listen: false);
      await eventService.unregisterFromEvent(event.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTimeRange(FBLAEvent event) {
    final start = _formatTime(event.date);
    if (event.endDate == null) return start;
    
    final end = _formatTime(event.endDate!);
    return '$start - $end';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }
}