import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String _apiKey = 'AIzaSyAECW_vUPuQX6QrzvuTHqT56HwSSNTWIdE///'; 
  final String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  Future<List<YouTubeVideo>> searchFBLAVideos({int maxResults = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search?part=snippet&q=FBLA&type=video&maxResults=$maxResults&key=$_apiKey'
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoIds = data['items'].map((item) => item['id']['videoId']).join(',');

        return await _getVideoDetails(videoIds);
      }
      return [];
    } catch (e) {
      print('YouTube API error: $e');
      return [];
    }
  }

  Future<List<YouTubeVideo>> _getVideoDetails(String videoIds) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/videos?part=snippet,statistics&id=$videoIds&key=$_apiKey'
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'].map<YouTubeVideo>((item) {
        return YouTubeVideo(
          id: item['id'],
          title: item['snippet']['title'],
          description: item['snippet']['description'],
          thumbnailUrl: item['snippet']['thumbnails']['high']['url'],
          channelTitle: item['snippet']['channelTitle'],
          publishedAt: DateTime.parse(item['snippet']['publishedAt']),
          viewCount: int.parse(item['statistics']['viewCount'] ?? '0'),
          likeCount: int.parse(item['statistics']['likeCount'] ?? '0'),
        );
      }).toList();
    }
    return [];
  }

  Future<List<YouTubeVideo>> getFBLAChannelVideos() async {
    const channelId = 'UCfbla_national'; 
    
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/search?part=snippet&channelId=$channelId&type=video&maxResults=10&key=$_apiKey'
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videoIds = data['items'].map((item) => item['id']['videoId']).join(',');
      return await _getVideoDetails(videoIds);
    }
    return [];
  }
}

class YouTubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final DateTime publishedAt;
  final int viewCount;
  final int likeCount;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
    required this.viewCount,
    required this.likeCount,
  });

  String get formattedViews {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  String get formattedLikes {
    if (likeCount >= 1000) {
      return '${(likeCount / 1000).toStringAsFixed(1)}K';
    }
    return likeCount.toString();
  }

  String get timeAgo {
    final difference = DateTime.now().difference(publishedAt);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Now';
  }
}