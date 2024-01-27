import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Blog',
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlogHomePage(),
    );
  }
}

class BlogHomePage extends StatefulWidget {
  @override
  _BlogHomePageState createState() => _BlogHomePageState();
}

class _BlogHomePageState extends State<BlogHomePage> {
  List<BlogPost> blogPosts = [];

  @override
  void initState() {
    super.initState();
    blogPosts = [
      BlogPost(
        title: 'The Art of Growing a Forest: A Beginner\'s Guide',
        content:
            'Creating a forest is a rewarding journey. Learn the basics of selecting the right seeds, nurturing saplings, and fostering a diverse ecosystem.',
        imageUrl:
            'https://agrilifetoday.tamu.edu/wp-content/uploads/2020/09/fetilizer-1366x598.jpg',
        date: DateTime.now(),
        likes: 42,
        comments: [
          BlogComment(author: 'NatureLover', text: 'Great tips!'),
          BlogComment(
              author: 'GreenThumb', text: 'I tried this and it works wonders.'),
        ],
      ),
      BlogPost(
        title: 'Unlocking the Potential of Fertilizers for Healthy Plants',
        content:
            'Discover the secrets of choosing the right fertilizer for your plants. From organic to synthetic, explore the benefits and find the perfect match for your garden.',
        imageUrl:
            'https://st.depositphotos.com/1315854/2159/i/950/depositphotos_21596341-stock-photo-pine-tree-forrest-in-the.jpg',
        date: DateTime.now().subtract(const Duration(days: 2)),
        likes: 30,
        comments: [
          BlogComment(author: 'GardeningGuru', text: 'Informative post!'),
          BlogComment(author: 'PlantParent', text: 'I learned a lot. Thanks!'),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog-Post'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          return BlogPostTile(blogPost: blogPosts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          BlogPost? newPost = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogPostEditor(),
            ),
          );

          if (newPost != null) {
            setState(() {
              blogPosts.add(newPost);
            });
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BlogPostTile extends StatefulWidget {
  final BlogPost blogPost;

  BlogPostTile({required this.blogPost});

  @override
  _BlogPostTileState createState() => _BlogPostTileState();
}

class _BlogPostTileState extends State<BlogPostTile> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogPostDetails(blogPost: widget.blogPost),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.blogPost.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.blogPost.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Published on ${widget.blogPost.formattedDate}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: _isLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked = !_isLiked;
                            if (_isLiked) {
                              widget.blogPost.likes++;
                            } else {
                              widget.blogPost.likes--;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.blogPost.likes} Likes',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comments (${widget.blogPost.comments.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.blogPost.comments.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.blogPost.comments
                          .map((comment) => BlogCommentWidget(comment: comment))
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogPost {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;
  int likes;
  final List<BlogComment> comments;

  BlogPost({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.likes,
    this.comments = const [],
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class BlogComment {
  final String author;
  final String text;

  BlogComment({required this.author, required this.text, String? imageUrl});
}

class BlogPostDetails extends StatefulWidget {
  final BlogPost blogPost;

  BlogPostDetails({required this.blogPost});

  @override
  _BlogPostDetailsState createState() => _BlogPostDetailsState();
}

class _BlogPostDetailsState extends State<BlogPostDetails> {
  final TextEditingController _commentController = TextEditingController();
  File? _commentImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Existing post details UI

            // Comment section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Comments (${widget.blogPost.comments.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Divider(),
            // Display existing comments
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.blogPost.comments
                  .map((comment) => BlogCommentWidget(comment: comment))
                  .toList(),
            ),
            // Add a new comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        setState(() {
                          _commentImage = File(pickedFile.path);
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the comment submission logic here
                      String commentText = _commentController.text;
                      if (commentText.isNotEmpty || _commentImage != null) {
                        BlogComment newComment = BlogComment(
                          text: commentText,
                          imageUrl: _commentImage != null
                              ? _commentImage!.path
                              : null,
                          author: '',
                          // You may need to adjust other properties based on your BlogComment class
                        );
                        // Add the new comment to the post
                        setState(() {
                          widget.blogPost.comments.add(newComment);
                          // Clear the comment text and image
                          _commentController.clear();
                          _commentImage = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text('Post'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogPostEditor extends StatefulWidget {
  @override
  _BlogPostEditorState createState() => _BlogPostEditorState();
}

class _BlogPostEditorState extends State<BlogPostEditor> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Blog Post'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.green),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: Colors.green),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                labelStyle: TextStyle(color: Colors.green),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Create a new blog post
                BlogPost newPost = BlogPost(
                  title: _titleController.text,
                  content: _contentController.text,
                  imageUrl: _imageUrlController.text.isEmpty
                      ? 'https://via.placeholder.com/600x300'
                      : _imageUrlController.text,
                  date: DateTime.now(),
                  likes: 0,
                  comments: [],
                );

                Navigator.pop(context, newPost);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogCommentWidget extends StatelessWidget {
  final BlogComment comment;

  BlogCommentWidget({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.author,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comment.text,
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
