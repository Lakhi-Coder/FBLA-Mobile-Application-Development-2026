import 'package:fbla_connect/entities/color_pallete.dart';
import 'package:fbla_connect/entities/widgets/custom_text.dart';
import 'package:fbla_connect/tabs/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: CustomNormalText(text: "FBLA Connect", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: uniqueTertiaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white), 
            onPressed: () => Navigator.pushNamed(context, '/profile'), 
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            SizedBox(height: 24),
            _buildCalendarSection(context),
            SizedBox(height: 24),
            _buildResourcesSection(context),
            SizedBox(height: 24),
            _buildSocialSection(context),
            SizedBox(height: 24),
            _buildQuickNavGrid(context), 
            SizedBox(height: 80), 
            ],
          ),
        )
      );
    }
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNormalText(
          text: 'Welcome back, Lakhitesh Varma!',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: proffessionalBlack,
        ),
        SizedBox(height: 4),
        CustomNormalText(
          text: 'Wake Young Men\'s Leadership Academy FBLA',
          fontSize: 14,
          color: proffessionalBlack.withOpacity(0.6),
        ),
        SizedBox(height: 8),
        Chip(
          label: CustomNormalText(
            text: 'Sources: Official FBLA Resources',
            fontSize: 12,
            color: Colors.green[800],
          ),
          backgroundColor: Colors.green[50],
          side: BorderSide.none,
        ),
      ],
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            CustomNormalText(
              text: 'Upcoming FBLA Events',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: proffessionalBlack,
            ),
            TextButton(
              onPressed: () => _launchURL(context, 'https://ncfbla.org/calendar/'), 
              child: CustomNormalText(
                text: 'Full Calendar →',
                fontSize: 14,
                color: uniqueTertiaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildEventCard(
          title: 'State Leadership Conference',
          date: 'March 15, 2026',
          location: 'Raleigh, NC',
          source: 'NC FBLA Calendar',
        ),
        SizedBox(height: 8),
        _buildEventCard(
          title: 'District Competition Deadline', 
          date: 'February 10, 2026',
          location: 'Virtual Submission',
          source: 'NC FBLA Calendar',
        ),
        SizedBox(height: 8),
        _buildEventCard(
          title: 'Mobile App Workshop',
          date: 'January 28, 2026',
          location: 'School Library',
          source: 'Chapter Event',
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
    required String source,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50], 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomNormalText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: proffessionalBlack,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: uniqueTertiaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomNormalText(
                    text: source,
                    fontSize: 10,
                    color: uniqueTertiaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 16, color: Colors.grey[600]),
                SizedBox(width: 6),
                CustomNormalText(
                  text: date,
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 6),
                Expanded(
                  child: CustomNormalText(
                    text: location,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard('3', 'Upcoming Events'),
        _buildStatCard('5', 'Resources'),
        _buildStatCard('142', 'Points'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor),
      ),
      child: Column(
        children: [
          CustomNormalText(
            text: value,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: uniqueTertiaryColor,
          ),
          SizedBox(height: 4),
          CustomNormalText(
            text: label,
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNormalText(
          text: 'Key FBLA Documents',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: proffessionalBlack,
        ),
        SizedBox(height: 12),
        _buildDocumentCard(
          context,
          icon: Icons.gavel,
          title: 'FBLA High School Bylaws',
          subtitle: 'Official National Document',
          url: 'https://www.fbla.org/media/2024/10/FBLA-High-School-Division-Bylaws-June-2023.pdf',
        ),
        SizedBox(height: 8),
        _buildDocumentCard(
          context,
          icon: Icons.rule,
          title: 'NC FBLA Documents Hub',
          subtitle: 'State Guidelines & Resources',
          url: 'https://ncfbla.org/fbla-documents/',
        ),
        SizedBox(height: 8),
        _buildDocumentCard(
          context,
          icon: Icons.emoji_events,
          title: 'Competition Guidelines',
          subtitle: 'Mobile App Development Rules',
          url: 'https://www.fbla.org/competitive-events/',
        ),
      ],
    );
  }

  Widget _buildDocumentCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.white),
        onTap: () => _launchURL(context, url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: uniqueTertiaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: uniqueTertiaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomNormalText(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: proffessionalBlack,
                    ),
                    SizedBox(height: 2),
                    CustomNormalText(
                      text: subtitle,
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNormalText(
          text: 'Connect with FBLA',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: proffessionalBlack,
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSocialIconButton(
                context,
                icon: FontAwesomeIcons.instagram,
                color: Color(0xFFE4405F),
                url: 'https://www.instagram.com/fbla_national/',
                label: 'Instagram',
              ),
              SizedBox(width: 12),
              _buildSocialIconButton(
                context,
                icon: FontAwesomeIcons.facebook,
                color: Color(0xFF1877F2),
                url: 'https://www.facebook.com/FutureBusinessLeaders',
                label: 'Facebook',
              ),
              SizedBox(width: 12),
              _buildSocialIconButton(
                context,
                icon: FontAwesomeIcons.twitter,
                color: Color(0xFF1DA1F2),
                url: 'https://twitter.com/FBLA_National',
                label: 'X (Twitter)',
              ),
              SizedBox(width: 12),
              _buildSocialIconButton(
                context,
                icon: FontAwesomeIcons.youtube,
                color: Color(0xFFFF0000),
                url: 'https://www.youtube.com/c/fblapblinc',
                label: 'YouTube',
              ),
              SizedBox(width: 12),
              _buildSocialIconButton(
                context,
                icon: FontAwesomeIcons.linkedin,
                color: Color(0xFF0A66C2),
                url: 'https://www.linkedin.com/company/future-business-leaders-america/',
                label: 'LinkedIn',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIconButton(
    BuildContext context, {
    required FaIconData icon,
    required Color color,
    required String url,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: FaIcon(icon, color: color, size: 24),
            onPressed: () => _launchURL(context, url),
          ),
        ),
        SizedBox(height: 6),
        CustomNormalText(
          text: label,
          fontSize: 11,
          color: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildQuickNavGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 1.0,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _buildNavItem(
          context,
          Icons.calendar_month,
          'Calendar',
          '/calendar',
          uniqueTertiaryColor,
        ),
        _buildNavItem(
          context,
          Icons.announcement,
          'News',
          '/news',
          Colors.blue[600]!,
        ),
        _buildNavItem(
          context,
          Icons.library_books,
          'Resources',
          '/resources',
          Colors.green[600]!,
        ),
        _buildNavItem(
          context,
          Icons.people,
          'Connect',
          '/social',
          Colors.purple[600]!,
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, String route, Color color) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(height: 8),
            CustomNormalText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: proffessionalBlack,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
