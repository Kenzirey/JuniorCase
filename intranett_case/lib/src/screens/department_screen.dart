import 'package:flutter/material.dart';
import 'package:intranett_case/src/controllers/group_post_controller.dart';
import 'package:intranett_case/src/models/department_group_post.dart';
import 'package:intranett_case/src/screens/add_post.dart';
import 'package:intranett_case/src/screens/profile_screen.dart';

/// Screen that displays the group posts in a department.
///
/// Allows users to view, add and and interact with other users' posts.
class DepartmentScreen extends StatefulWidget {

  const DepartmentScreen({
    super.key,
    this.initialItems = const [],
  });

  // In the real app, at the start users would log in and be redirected to choose a group. Right now, none of this is set up.
  static const routeName = '/';

  final List<GroupPost> initialItems;

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  late List<GroupPost> _items;
  late GroupPostController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.initialItems.isEmpty) {
      _items = [
        // Note: should have set up a group post + comment model, to allow the comments to have actual poster name attached.
        // Yes, I know it's Gjøvik.
        GroupPost(1, name: 'Gjo in Vik Here I come', authorName: 'Emma', contents: 'Gardemoen is confusing', assetImagePath: 'assets/images/gardemoen.jpg', likes: 15, comments: ['Great shot, Emma!!', 'I agree, the airport is too big']),
        GroupPost(2, name: 'Aalesund > Molde', authorName: 'Sunnmoering', contents: 'Even though Molde has great soda', assetImagePath: 'assets/images/oskar.jpg', likes: 27, comments: ['Pear one is my favorite.']),
        GroupPost(3, name: 'Hire me, would love to work with iOS', authorName: 'Emma', assetImagePath: 'assets/images/emma.jpg', likes: 99, comments: []),  // need to set up a guard for having at least an image or content, or some sort of ruleset. No guards now.
      ];
    } else {
      _items = widget.initialItems.map((post) => GroupPost(
        post.id,
        name: post.name,
        authorName: post.authorName,
        contents: post.contents,
        likes: post.likes,
        comments: List<String>.from(post.comments), // ideally, like mentioned in model, this does not currently support name of the poster.
        assetImagePath: post.assetImagePath,
        imageFile: post.imageFile,
      )).toList();
    }

    _controller = GroupPostController(
      items: _items,
      onUpdate: () => setState(() {}),
    );
  }

  // I am more familiar with GoRouter, but this was how the "best practice" new project was set up, so I gave it a go.
  Future<void> _navigateAndAddPost(BuildContext context) async {
    final GroupPost? newPost = await Navigator.push<GroupPost>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddGroupPostScreen(),
      ),
    );

    if (newPost != null) {
      setState(() {
        _items.insert(0, newPost); //so that new posts appear at the top, ideally there would be filtering here with filter by popularity, time etc.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avdeling'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create Post',
            onPressed: () {
              _navigateAndAddPost(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.restorablePushNamed(context, ProfileScreen.routeName);
            },
          ),
        ],
      ),
      // I set up ListView.builder for future optimization, as it implements lazy loading. Which would be very useful for larger sets of data, such as social media.
      body: ListView.builder(
        restorationId: 'groupPostListView',
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          final post = _items[index];
          ImageProvider? itemImageProvider;

          if (post.imageFile != null) {
            itemImageProvider = FileImage(post.imageFile!);
          } else if (post.assetImagePath != null && post.assetImagePath!.isNotEmpty) {
            itemImageProvider = AssetImage(post.assetImagePath!);
          }

          // Chose card option for posts for its simplicity and how it looks. Though could have used a ListTile or something else
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: InkWell(
              onTap: () => _controller.navigateToItemDetails(context, post),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.name, // Post Title
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text( // Author's name header
                      'Posted by: ${post.authorName}',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                    // Display Contents if available
                    if (post.contents != null && post.contents!.isNotEmpty) ...[
                      const SizedBox(height: 8.0),
                      Text(
                        post.contents!,
                        style: const TextStyle(fontSize: 14.0, color: Colors.white),  // just setting darkmode atm
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8.0),
                    // Display Image
                    if (itemImageProvider != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image(
                            image: itemImageProvider,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else if (post.contents == null || post.contents!.isEmpty)
                      // placeholder if no content at all
                      Center(
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[200],
                          ),
                          child: Icon(Icons.article_outlined, color: Colors.grey[400], size: 50), // not bothering with setting theme colors on everything
                        ),
                      ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.thumb_up_alt_outlined),
                              color: Theme.of(context).colorScheme.primary,
                              tooltip: 'Like',
                              onPressed: () {
                                _controller.incrementLikes(index);
                              },
                            ),
                            Text('${post.likes}'),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment_outlined),
                              color: Theme.of(context).colorScheme.primary,
                              tooltip: 'Comments',
                              onPressed: () {
                                _controller.showCommentsDialog(context, post);
                              },
                            ),
                            Text('${post.comments.length}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}