import 'package:flutter/material.dart';
import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesTab extends StatelessWidget {
  const ResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomNormalText(text: "Resources", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: uniqueTertiaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: secondaryColor.withAlpha(200)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '2025-2026 Official FBLA Documents',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('COMPETITIVE EVENT GUIDELINES'),
            _buildEventGuidelines(context),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('FBLA BYLAWS & GOVERNANCE'),
            _buildBylawsSection(context),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('EXAM PREPARATION'),
            _buildExamPrepSection(context),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('NATIONAL LEADERSHIP CONFERENCE'),
            _buildNLCInfo(context),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('CHAPTER MANAGEMENT'),
            _buildChapterManagement(context),
            
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: secondaryColor!),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, size: 16, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All documents sourced from official FBLA national website (fbla.org)',
                      style: TextStyle(
                        fontSize: 11,
                        color: secondaryColor.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: uniqueTertiaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEventGuidelines(BuildContext context) {
    final events = [
      {
        'title': '2025-2026 Competitive Events Guidelines',
        'description': 'Complete official guidelines for all FBLA competitive events including Accounting, Advertising, Business Law, Coding & Programming, and more',
        'url': 'https://www.fbla.org/high-school/competitive-events/',
        'category': 'Official Guidelines',
        'icon': Icons.gavel,
      },
      {
        'title': 'Event Rating Sheets',
        'description': 'Official scoring rubrics used by judges at competitions',
        'url': 'https://www.fbla.org/high-school/competitive-events/',
        'category': 'Judging Materials',
        'icon': Icons.star_rate,
      },
      {
        'title': 'Mobile Application Development Guidelines',
        'description': 'Specific rules and requirements for our event category',
        'url': 'https://greektrack-fbla-public.s3.amazonaws.com/files/1/High%20School%20Competitive%20Events%20Resources/Individual%20Guidelines/Presentation%20Events/Mobile-Application-Development.pdf?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAWVAJYMX2IFDGHQE3%2F20260311%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260311T011340Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Signature=40505edf603c5697bb93537088dc8f5c5997f96f3f26d6ad89e710cbf8102ec2',
        'category': 'Our Event',
        'icon': Icons.phone_android,
      },
      {
        'title': 'Objective Tests Overview',
        'description': 'Format: 60 minutes, 80 multiple-choice questions, 5 points each (400 total)',
        'url': 'https://fbla.org.cn/',
        'category': 'Test Format',
        'icon': Icons.quiz,
      },
    ];

    return Column(
      children: events.map((event) => _buildResourceCard(
        context,
        title: event['title'] as String, 
        description: event['description'] as String,
        url: event['url'] as String,
        category: event['category'] as String,
        icon: event['icon'] as IconData,
      )).toList(),
    );
  }

  Widget _buildBylawsSection(BuildContext context) {
    return Column(
      children: [
        _buildResourceCard(
          context,
          title: 'FBLA Bylaws (2025-2026 Edition)',
          description: 'Official governing document: Article I (Name), Article II (Purpose & Goals), Article III (Membership classes: Active, Professional, Honorary Life)',
          url: 'https://www.fbla.org/media/2024/10/FBLA-High-School-Division-Bylaws-June-2023.pdf',
          category: 'Governance',
          icon: Icons.description,
        ),
        _buildResourceCard(
          context,
          title: 'FBLA Purpose & Goals',
          description: 'Develop competent business leadership, strengthen confidence, create interest in American business enterprise, develop character and citizenship [citation:3]',
          url: 'https://www.fbla.org/',
          category: 'Mission',
          icon: Icons.flag,
        ),
        _buildResourceCard(
          context,
          title: 'Membership Requirements', 
          description: 'Active members: secondary students in business/business-related fields. Professional members: educators/advisers. Honorary Life: significant contributions [citation:3]',
          url: 'https://www.fbla.org/high-school/membership/',
          category: 'Membership',
          icon: Icons.people,
        ),
      ],
    );
  }

  Widget _buildExamPrepSection(BuildContext context) {
    return Column(
      children: [
        _buildResourceCard(
          context,
          title: 'Sample Objective Test Questions',
          description: 'Practice with actual FBLA-style questions covering: Financial ratios, market segmentation, business ethics, and data analysis [citation:6]',
          url: 'https://fbla.org.cn/',
          category: 'Practice',
          icon: Icons.assignment,
        ),
        _buildResourceCard(
          context,
          title: 'FBLA Knowledge Map',
          description: 'Complete topic breakdown: Microeconomics, Financial Ratios, Marketing Principles, Business Law, Ethics, and Management',
          url: 'https://fbla.org.cn/',
          category: 'Study Guide',
          icon: Icons.map,
        ),
        _buildResourceCard(
          context,
          title: 'Virtual Business Challenge (VBC)',
          description: 'Practice business simulation using Knowledge Matters platform - manage manufacturing, retail, or service businesses [citation:6]',
          url: 'https://www.fbla.org/',
          category: 'Simulation',
          icon: Icons.analytics,
        ),
        _buildResourceCard(
          context,
          title: 'Data Science & AI Resources',
          description: '2026 new topic focus: AI business applications, blockchain finance, and data visualization tools [citation:6]',
          url: 'https://www.fbla.org/',
          category: 'Emerging Topics',
          icon: Icons.smart_toy,
        ),
      ],
    );
  }

  Widget _buildNLCInfo(BuildContext context) {
    return Column(
      children: [
        _buildResourceCard(
          context,
          title: 'National Leadership Conference 2026',
          description: 'June 29 - July 2, 2026 • San Antonio, Texas. Middle School & High School divisions [citation:5][citation:9]',
          url: 'https://www.fbla.org/events/',
          category: 'Event Info',
          icon: Icons.event,
        ),
        _buildResourceCard(
          context,
          title: '2025 NLC Top Ten Results',
          description: 'View national top ten competitors from Anaheim, California [citation:2]',
          url: 'https://www.fbla.org/high-school/competitive-events/',
          category: 'Results',
          icon: Icons.leaderboard,
        ),
        _buildResourceCard(
          context,
          title: 'Press Release Template',
          description: 'Share your chapter\'s competition results with local media [citation:2]',
          url: 'https://www.fbla.org/high-school/competitive-events/',
          category: 'Media',
          icon: Icons.newspaper,
        ),
      ],
    );
  }

  Widget _buildChapterManagement(BuildContext context) {
    return Column(
      children: [
        _buildResourceCard(
          context,
          title: 'Chapter Management Handbook (CMH)',
          description: 'Complete guide for chapter operation, leadership training, and national programs [citation:8]',
          url: 'https://www.fbla.org/',
          category: 'Handbook',
          icon: Icons.menu_book,
        ),
        _buildResourceCard(
          context,
          title: 'Who\'s Who in FBLA Award',
          description: 'Outstanding member recognition program - requires portfolio submission [citation:4]',
          url: 'https://www.flfbla.org/',
          category: 'Awards',
          icon: Icons.emoji_events,
        ),
        _buildResourceCard(
          context,
          title: 'Champion Chapter Program',
          description: 'Track chapter achievements in community service, fundraising, and member development',
          url: 'https://www.fbla.org/',
          category: 'Chapter Growth',
          icon: Icons.stars,
        ),
      ],
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String description,
    required String url,
    required String category,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: secondaryColor.withAlpha(200)),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _launchURL(context, url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _getCategoryColor(category), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: uniqueTertiaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: proffessionalBlack.withAlpha(180),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category).withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _getCategoryColor(category),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: secondaryColor.withAlpha(200)),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Official Guidelines':
      case 'Our Event':
        return uniqueTertiaryColor; 
      case 'Judging Materials':
        return tertiaryColor; 
      case 'Test Format':
      case 'Practice':
      case 'Study Guide':
        return Colors.green[700]!;
      case 'Simulation':
      case 'Emerging Topics':
        return Colors.purple[600]!;
      case 'Governance':
      case 'Mission':
      case 'Membership':
      case 'Handbook':
        return Colors.blue[700]!;
      case 'Event Info':
      case 'Results':
        return Colors.orange[700]!;
      case 'Awards':
      case 'Chapter Growth':
        return Colors.teal[700]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open $url'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}