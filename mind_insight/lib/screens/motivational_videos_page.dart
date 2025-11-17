import 'package:flutter/material.dart';

class MotivationalVideosPage extends StatelessWidget {
  const MotivationalVideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> latestVideos = [
      {
        "title": "Start Your Day with Positivity 🌞",
        "thumbnail": "https://img.youtube.com/vi/MWz1G_yU7ak/0.jpg",
        "channel": "Mind Uplift",
      },
      {
        "title": "How to Stay Motivated Every Day 💪",
        "thumbnail": "https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg",
        "channel": "Daily Boost",
      },
      {
        "title": "Overcoming Failure with Confidence ✨",
        "thumbnail": "https://img.youtube.com/vi/L_jWHffIx5E/0.jpg",
        "channel": "Healing Mindset",
      },
    ];

    final List<Map<String, String>> trendingVideos = [
      {
        "title": "Believe in Yourself 🔥",
        "thumbnail": "https://img.youtube.com/vi/ZXsQAXx_ao0/0.jpg",
        "channel": "Inspire Now",
      },
      {
        "title": "Reset Your Mind for Success 💡",
        "thumbnail": "https://img.youtube.com/vi/V-_O7nl0Ii0/0.jpg",
        "channel": "Growth Spirit",
      },
      {
        "title": "How to Build Self-Discipline 🧠",
        "thumbnail": "https://img.youtube.com/vi/KxGRhd_iWuE/0.jpg",
        "channel": "Dr. Mind Coach",
      },
    ];

    final List<Map<String, String>> doctorsPlaylist = [
      {
        "title": "Dr. Anjali Sharma's Mind Healing Series",
        "thumbnail": "https://img.youtube.com/vi/Hp5uJ8Q_Jm8/0.jpg",
        "channel": "Dr. Anjali Sharma",
      },
      {
        "title": "Dr. Rohan Mehta: Overcoming Stress",
        "thumbnail": "https://img.youtube.com/vi/FVsfhA5Y3yY/0.jpg",
        "channel": "Dr. Rohan Mehta",
      },
      {
        "title": "Dr. Neha Patil: Building Emotional Strength",
        "thumbnail": "https://img.youtube.com/vi/3jWRrafhO7M/0.jpg",
        "channel": "Dr. Neha Patil",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text(
          "Motivational Videos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "🔥 Trending Videos",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trendingVideos.length,
              itemBuilder: (context, index) {
                final video = trendingVideos[index];
                return _videoCard(video, context);
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "🆕 Latest Uploads",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: latestVideos
                .map((video) => _videoTile(video, context))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "👩‍⚕️ Doctors' Playlists",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: doctorsPlaylist
                .map((video) => _videoTile(video, context))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Reusable small video tile (vertical list)
  Widget _videoTile(Map<String, String> video, BuildContext context) {
    final thumbnail = video["thumbnail"];
    final title = video["title"] ?? "Untitled";
    final channel = video["channel"] ?? "";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: thumbnail != null && thumbnail.isNotEmpty
              ? Image.network(
                  thumbnail,
                  width: 100,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _placeholderImage(),
                )
              : _placeholderImage(),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(channel, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(
          Icons.play_circle_fill,
          color: Color(0xFFE91E63),
          size: 32,
        ),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Playing: $title")));
        },
      ),
    );
  }

  // Reusable wide video card (horizontal scrolling)
  Widget _videoCard(Map<String, String> video, BuildContext context) {
    final thumbnail = video["thumbnail"];
    final title = video["title"] ?? "Untitled";
    final channel = video["channel"] ?? "";

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: thumbnail != null && thumbnail.isNotEmpty
                ? Image.network(
                    thumbnail,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _placeholderImage(height: 140, width: double.infinity),
                  )
                : _placeholderImage(height: 140, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              channel,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // A simple placeholder widget used when an image fails to load
  Widget _placeholderImage({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      color: Colors.black12,
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.white70),
      ),
    );
  }
}
