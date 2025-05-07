// src/models/sample_item.dart
import 'dart:io'; // Required for File type

/// Model representing a post in the department's group feed.
class GroupPost {
  GroupPost(
    this.id, {
    required this.name, // title of the post
    required this.authorName, // given that it is not meant to be anonymous post.
    this.likes = 0,
    this.comments = const [], // start off as an empty list, as it will be filled as comments are added later on.
    this.imageFile,      // images picked by user from their gallery, currently not set up for actual iOS as I cannot test it.
    this.assetImagePath,
    this.contents,
  }) : assert(imageFile == null || assetImagePath == null,
            "Cannot provide both imageFile and assetImagePath. Use one or the other.");

  final int id;
  final String name;
  final String authorName;
  final File? imageFile;
  final String? assetImagePath;
  final String? contents; // Optional, given someone may only want to post an image and title? Definitely should talk to other people about this to see the opinions. 
  int likes;
  List<String> comments; // NOTE! this should hold "comments" objects which contains user who posted and the comment itself, with timestamp.
}