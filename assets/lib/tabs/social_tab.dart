import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:fbla_connect/entities/widgets/models/post_model.dart';
import 'package:fbla_connect/services/YouTube/YouTube_services.dart';
import 'package:fbla_connect/services/user_storage/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SocialTab extends StatefulWidget {
  const SocialTab({super.key});

  @override
  State<SocialTab> createState() => _SocialTabState();
}

class _SocialTabState extends State<SocialTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final YouTubeService _youtubeService = YouTubeService();
  List<YouTubeVideo> _videos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final videos = await _youtubeService.searchFBLAVideos(maxResults: 15);
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomNormalText(text:'Social', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: uniqueTertiaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.video_library), text: 'FBLA Videos'),
            Tab(icon: Icon(Icons.share), text: 'Share'),
            Tab(icon: Icon(Icons.link), text: 'Connect'),
            //Tab(icon: Icon(Icons.people), text: 'Community'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildYouTubeTab(),
          _buildShareTab(),
          _buildLinksTab(),
          //_buildCommunityTab() 
        ],
      ),
    );
  }
  Widget _buildCommunityTab() {
    final communityService = CommunityService();
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: uniqueTertiaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<CommunityPost>>(
        stream: communityService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No posts yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showCreatePostDialog(context),
                    child: const Text('Create First Post'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _buildPostCard(context, post, communityService);
            },
          );
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, CommunityPost post, CommunityService service) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isLiked = post.likes.contains(currentUserId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: post.userPhotoUrl != null
                      ? NetworkImage(post.userPhotoUrl!)
                      : null,
                  child: post.userPhotoUrl == null
                      ? Text(
                          post.userName.isNotEmpty ? post.userName[0].toUpperCase() : '?',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _timeAgo(post.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
            const SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (isLiked) {
                      service.unlikePost(post.id);
                    } else {
                      service.likePost(post.id);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.likes.length.toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comments coming soon!')),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.comment_outlined, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        post.commentCount.toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreatePostDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Post'),
          backgroundColor: Colors.white,
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "What's on your mind?",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final content = controller.text.trim();
                if (content.isNotEmpty) {
                  Navigator.pop(dialogContext);
                  final service = CommunityService();
                  await service.createPost(content);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post created!')),
                  );
                }
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) {
      return '${date.month}/${date.day}/${date.year}';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildYouTubeTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error loading videos',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadVideos,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No videos found',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVideos,
      color: uniqueTertiaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _playVideo(video.id),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          video.thumbnailUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 40),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 12,
                        right: 12,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.play_arrow,
                            color: uniqueTertiaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          video.channelTitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              video.formattedViews,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.thumb_up_outlined,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              video.formattedLikes,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              video.timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  
Widget _buildShareTab() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomNormalText(
          text: 'Share Your FBLA Journey',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003366),
        ),
        const SizedBox(height: 8),
        const CustomNormalText(
          text: 'Share your achievements and events with your network',
          fontSize: 16,
          color: Colors.grey,
        ),
        const SizedBox(height: 24),

        _buildShareCard(
          icon: Icons.emoji_events,
          title: 'Share Achievement',
          subtitle: 'Let everyone know about your FBLA success',
          onTap: () async {
            final result = await SharePlus.instance.share(
              ShareParams(
                text: 'I just earned a new achievement on FBLA Connect! '
                    '#FBLA #FutureBusinessLeader #FBLAConnect',
                subject: 'My FBLA Achievement', 
              )
            );
            print('Share result: $result');
          },
        ),

        const SizedBox(height: 12),

        _buildShareCard(
          icon: Icons.event,
          title: 'Share Event',
          subtitle: 'Invite friends to FBLA events',
          onTap: () async {
            final result = await SharePlus.instance.share(
              ShareParams(
                text: 'Join me at the upcoming FBLA event! '
                    'Check it out on FBLA Connect. #FBLA',
                subject: 'FBLA Event Invitation',
              )
            );
            print('Share result: $result');
          },
        ),

        const SizedBox(height: 12),

        _buildShareCard(
          icon: Icons.menu_book,
          title: 'Share Resource',
          subtitle: 'Share helpful FBLA materials',
          onTap: () async {
            final result = await SharePlus.instance.share(
              ShareParams(
                text: 'Check out this great FBLA resource I found on FBLA Connect! '
                    '#FBLA #Study',
                subject: 'FBLA Resource',
              )
            );
            print('Share result: $result');
          },
        ),

        const SizedBox(height: 24),

          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                const Text(
                  'Share to:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialShareIcon(
                      icon: Icons.facebook,
                      color: const Color(0xFF1877F2),
                      onTap: () {},
                    ),
                    _buildSocialShareIcon(
                      icon: Icons.message,
                      color: const Color(0xFF1DA1F2),
                      onTap: () {},
                    ),
                    _buildSocialShareIcon(
                      icon: Icons.link,
                      color: Colors.green[700]!,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connect with FBLA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSocialLinkCard(
            icon: FontAwesomeIcons.instagram,
            color: const Color(0xFFE4405F),
            title: 'Instagram',
            subtitle: '@fbla_national',
            url: 'https://www.instagram.com/fbla_national/',
          ),
          
          _buildSocialLinkCard(
            icon: FontAwesomeIcons.facebook,
            color: const Color(0xFF1877F2),
            title: 'Facebook',
            subtitle: 'Future Business Leaders of America',
            url: 'https://www.facebook.com/FutureBusinessLeaders',
          ),
          
          _buildSocialLinkCard(
            icon: FontAwesomeIcons.twitter,
            color: const Color(0xFF1DA1F2),
            title: 'X (Twitter)',
            subtitle: '@FBLA_National',
            url: 'https://twitter.com/FBLA_National',
          ),
          
          _buildSocialLinkCard(
            icon: FontAwesomeIcons.youtube,
            color: const Color(0xFFFF0000),
            title: 'YouTube',
            subtitle: 'FBLA National',
            url: 'https://www.youtube.com/c/fblapblinc',
          ),
          
          _buildSocialLinkCard(
            icon: FontAwesomeIcons.linkedin,
            color: const Color(0xFF0A66C2),
            title: 'LinkedIn',
            subtitle: 'Future Business Leaders of America',
            url: 'https://www.linkedin.com/company/future-business-leaders-america/',
          ),
        ],
      ),
    );
  }

  Widget _buildShareCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: uniqueTertiaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: uniqueTertiaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.share),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSocialShareIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
    );
  }

  Widget _buildSocialLinkCard({
    required FaIconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => _launchURL(url),
      ),
    );
  }

  Future<void> _playVideo(String videoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}