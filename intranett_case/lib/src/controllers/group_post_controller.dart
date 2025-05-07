import 'package:flutter/material.dart';
import 'package:intranett_case/src/models/department_group_post.dart';
import 'package:intranett_case/src/screens/group_post_screen.dart';

/// Controller for managing group posts in a department.
/// Controls the logic for adding, updating, and navigating to posts.
class GroupPostController {

  final List<GroupPost> items;
  final VoidCallback onUpdate;

  GroupPostController({required this.items, required this.onUpdate});

  /// Increments the likes for a specific post.
  /// Just a workaround to show the number going up, it doesn't actually do anything beyond that.
  void incrementLikes(int itemIndex) {
    if (itemIndex >= 0 && itemIndex < items.length) {
      items[itemIndex].likes++;
      onUpdate(); // Notify the view to rebuild
    }
  }

  /// Adds a comment to a specific post.
  ///
  /// Needs to have poster identity added in a way, probably through authentication or similar.
  void addCommentToItem(GroupPost item, String commentText) {
    // Updated type
    item.comments.add(commentText);
    onUpdate(); // Notify the view to rebuild
  }

  /// Navigate to the post details.
  void navigateToItemDetails(BuildContext context, GroupPost post) {
    Navigator.restorablePushNamed(
      context,
      GroupPostScreen
          .routeName, // Consider if this routeName or view needs renaming
      arguments: post.id,
    );
  }

  /// Adds a new GroupPost to front of the list.
  void addItem(GroupPost post) {
    items.insert(0,
        post); // Add the new post to the top of the list. Ideally we'd sort it by datetime, or popularity.
    onUpdate();
  }

  /// Shows a dialog to display and add comments for a specific item.
  /// Just a generic one, haven't really styled it or anything.
  void showCommentsDialog(BuildContext context, GroupPost post) {

    TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Comments for ${post.name}'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: post.comments.length,
                    itemBuilder: (context, commentIndex) {
                      return ListTile(
                        title: Text(post.comments[commentIndex]),
                      );
                    },
                  ),
                ),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(hintText: "Add a comment"),
                  autofocus: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add Comment'),
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  addCommentToItem(post, commentController.text);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              }, // I see them put close to the right all the time, but it confuses me
            ),
          ],
        );
      },
    );
  }
}
