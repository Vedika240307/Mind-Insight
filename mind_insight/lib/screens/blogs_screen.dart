import 'package:flutter/material.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  final List<Map<String, String>> blogs = const [
    {
      'title': 'Understanding Depression',
      'content':
          'Depression is a common mental health condition that affects mood, thoughts, and behavior...',
    },
    {
      'title': 'Effective Coping Strategies',
      'content':
          'Here are some strategies to cope with stress and anxiety, including mindfulness and exercise...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blogs')),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          return ListTile(
            title: Text(blog['title']!),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: blog)),
              );
            },
          );
        },
      ),
    );
  }
}

class BlogDetailScreen extends StatelessWidget {
  final Map<String, String> blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(blog['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(blog['content']!),
      ),
    );
  }
}
