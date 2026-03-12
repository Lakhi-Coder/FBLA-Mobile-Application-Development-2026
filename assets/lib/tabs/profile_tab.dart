import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:fbla_connect/services/user_storage/FBLA_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isEditing = false;
  bool _isLoading = false;
  
  late TextEditingController _nameController;
  late TextEditingController _chapterNumberController;
  late TextEditingController _chapterNameController;
  late TextEditingController _gradeLevelController;
  
  String? _selectedRole;
  final List<String> _roles = ['member', 'officer', 'advisor'];
  
  bool _eventReminders = true;
  bool _announcementAlerts = true;
  bool _resourceUpdates = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _chapterNumberController = TextEditingController();
    _chapterNameController = TextEditingController();
    _gradeLevelController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _chapterNumberController.dispose();
    _chapterNameController.dispose();
    _gradeLevelController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
      });
    }
  }

  Widget _buildAdminPanel(FBLAUser currentUser) {
  if (currentUser.role != 'advisor') return const SizedBox.shrink();

  return Container(
    margin: const EdgeInsets.only(top: 24),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue[200]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Colors.blue[800]),
            const SizedBox(width: 8),
            const Text(
              'Admin Panel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        TextField(
          decoration: InputDecoration(
            hintText: 'Search users by name or email...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
            // Implement user search
          },
        ),

        const SizedBox(height: 16),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return Column(
              children: snapshot.data!.docs.map((doc) {
                final userData = doc.data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(userData['fullName'] ?? 'No name'),
                    subtitle: Text('Role: ${userData['role'] ?? 'member'}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'make_officer') {
                          await doc.reference.update({'role': 'officer'});
                        } else if (value == 'make_member') {
                          await doc.reference.update({'role': 'member'});
                        } else if (value == 'make_advisor') {
                          await doc.reference.update({'role': 'advisor'});
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'make_member',
                          child: Text('Set as Member'),
                        ),
                        const PopupMenuItem(
                          value: 'make_officer',
                          child: Text('Set as Officer'),
                        ),
                        const PopupMenuItem(
                          value: 'make_advisor',
                          child: Text('Set as Advisor'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    ),
  );
}

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await _firestore.collection('users').doc(user.uid).update({
        'fullName': _nameController.text.trim(),
        'chapterNumber': _chapterNumberController.text.trim(),
        'chapterName': _chapterNameController.text.trim(),
        'gradeLevel': _gradeLevelController.text.trim(),
        'role': _selectedRole,
        'notificationPreferences': {
          'eventReminders': _eventReminders,
          'announcementAlerts': _announcementAlerts,
          'resourceUpdates': _resourceUpdates,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _isEditing = false);
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

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const CustomNormalText(text: 'Cancel', color: Colors.grey, fontSize: 16,),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const CustomNormalText(text: 'Logout', color: Colors.red, fontSize: 16,),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/getstarted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: uniqueTertiaryColor,
        ),
        body: const Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomNormalText(text: 'My Profile', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: uniqueTertiaryColor,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit, color: Colors.white,),
            onPressed: () {
              setState(() => _isEditing = !_isEditing);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('User data not found'),
            );
          }

          final userData = FBLAUser.fromMap(
            user.uid,
            snapshot.data!.data() as Map<String, dynamic>,
          );

          if (!_isEditing) {
            _nameController.text = userData.fullName;
            _chapterNumberController.text = userData.chapterNumber;
            _chapterNameController.text = userData.chapterName ?? '';
            _gradeLevelController.text = userData.gradeLevel;
            _selectedRole = userData.role; 
            
            final prefs = userData.notificationPreferences;
            _eventReminders = prefs['eventReminders'] ?? true;
            _announcementAlerts = prefs['announcementAlerts'] ?? true;
            _resourceUpdates = prefs['resourceUpdates'] ?? true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header with Photo
                _buildProfileHeader(userData),
                
                const SizedBox(height: 24),
                
                // Stats Cards
                _buildStatsGrid(userData),
                
                const SizedBox(height: 24),
                
                // Personal Information
                _buildPersonalInfo(userData),
                
                const SizedBox(height: 24),
                
                // Achievements
                _buildAchievementsSection(userData),
                
                const SizedBox(height: 24),
                
                // Events & Resources
                _buildActivitySection(userData),
                
                const SizedBox(height: 24),
                
                // Notification Preferences (only visible in edit mode)
                if (_isEditing) _buildNotificationPreferences(),
                
                const SizedBox(height: 24),
                
                // Save Button (only in edit mode)
                if (_isEditing) _buildSaveButton(),
                
                const SizedBox(height: 32),
                
                // Account Info
                _buildAccountInfo(userData),
                
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(FBLAUser user) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                uniqueTertiaryColor,
                uniqueTertiaryColor.withBlue(200),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Profile Image
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: user.profilePhotoUrl != null
                        ? NetworkImage(user.profilePhotoUrl!)
                        : null,
                    child: user.profilePhotoUrl == null
                        ? Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: uniqueTertiaryColor,
                            ),
                          )
                        : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: uniqueTertiaryColor, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20),
                          color: uniqueTertiaryColor,
                          onPressed: _pickImage,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Name
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (user.isVerified)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsGrid(FBLAUser user) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Service Hours',
            user.serviceHours.toString(),
            Icons.volunteer_activism,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Events',
            user.eventsAttended.length.toString(),
            Icons.event,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Achievements',
            user.achievements.length.toString(),
            Icons.emoji_events,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(FBLAUser user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            'Full Name',
            user.fullName,
            Icons.person,
            controller: _nameController,
            enabled: _isEditing,
          ),
          
          _buildInfoRow(
            'Email',
            user.email,
            Icons.email,
            isEditable: false,
          ),
          
          _buildInfoRow(
            'Chapter Number',
            user.chapterNumber,
            Icons.numbers,
            controller: _chapterNumberController,
            enabled: _isEditing,
          ),
          
          if (user.chapterName != null)
            _buildInfoRow(
              'Chapter Name',
              user.chapterName!,
              Icons.business,
              controller: _chapterNameController,
              enabled: _isEditing,
            ),
          
          _buildInfoRow(
              'Role',
              user.role,
              Icons.work,
              isEditable: false,
            ),
          
          _buildInfoRow(
            'Grade Level',
            user.gradeLevel,
            Icons.school,
            controller: _gradeLevelController,
            enabled: _isEditing,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    TextEditingController? controller,
    bool enabled = true,
    bool isEditable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: uniqueTertiaryColor),
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
                if (isEditable && enabled && controller != null)
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: uniqueTertiaryColor),
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(
    String label,
    String? value,
    List<String> items,
    IconData icon,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: uniqueTertiaryColor),
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
                DropdownButtonFormField<String>(
                  value: value,
                  items: items.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item[0].toUpperCase() + item.substring(1)),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(FBLAUser user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              if (user.achievements.isNotEmpty)
                Text(
                  '${user.achievements.length} earned',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (user.achievements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No achievements yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Attend events to earn badges!',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.achievements.map((achievement) {
                return Chip(
                  label: Text(achievement),
                  avatar: const Icon(
                    Icons.emoji_events,
                    size: 16,
                    color: Color(0xFFFFCC00),
                  ),
                  backgroundColor: uniqueTertiaryColor.withOpacity(0.1),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(FBLAUser user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildActivityCount(
                  'Events Attended',
                  user.eventsAttended.length.toString(),
                  Icons.event,
                ),
              ),
              Expanded(
                child: _buildActivityCount(
                  'Saved Resources',
                  user.favoriteResources.length.toString(),
                  Icons.bookmark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCount(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: uniqueTertiaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationPreferences() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          
          CheckboxListTile(
            title: const Text('Event Reminders'),
            subtitle: const Text('Get notified about upcoming events'),
            value: _eventReminders,
            onChanged: (value) {
              setState(() => _eventReminders = value ?? false);
            },
            activeColor: uniqueTertiaryColor,
            contentPadding: EdgeInsets.zero,
          ),
          
          CheckboxListTile(
            title: const Text('Announcement Alerts'),
            subtitle: const Text('Receive chapter and national announcements'),
            value: _announcementAlerts,
            onChanged: (value) {
              setState(() => _announcementAlerts = value ?? false);
            },
            activeColor: uniqueTertiaryColor,
            contentPadding: EdgeInsets.zero,
          ),
          
          CheckboxListTile(
            title: const Text('Resource Updates'),
            subtitle: const Text('Get notified when new resources are added'),
            value: _resourceUpdates,
            onChanged: (value) {
              setState(() => _resourceUpdates = value ?? false);
            },
            activeColor: uniqueTertiaryColor,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
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
            : const Text('Save Changes'),
      ),
    );
  }

  Widget _buildAccountInfo(FBLAUser user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Member since:',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDate(user.createdAt),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Account status:',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: user.isVerified ? Colors.green : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.isVerified ? 'Verified' : 'Pending',
                    style: TextStyle(
                      color: user.isVerified ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}