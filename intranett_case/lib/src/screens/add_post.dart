import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intranett_case/src/models/department_group_post.dart';

/// Screen for allowing user to add a new group post to the department.
/// Allows user to add a title, optional contents and an image.
class AddGroupPostScreen extends StatefulWidget {
  const AddGroupPostScreen({super.key});

  static const routeName = '/add_item';

  @override
  State<AddGroupPostScreen> createState() => _AddGroupPostScreenState();
}

class _AddGroupPostScreenState extends State<AddGroupPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentsController = TextEditingController(); // Controller for contents
  File? _pickedImageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentsController.dispose();
    super.dispose();
  }

// I would set some of these as widgets to be reusable, but opting not to due to time constraints at the moment.

  /// NOTE: In order for this to work on iOS you need to alter Info.plist. I have added it but I can't test if it actually works, I don't have an iOS device on hand.
  Future<void> _pickImage() async {
    try {
      final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        if (mounted) {
          setState(() {
            _pickedImageFile = File(selectedImage.path);
          });
        }
      }
    } catch (exception) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $exception')),
        );
      }
      debugPrint('Error picking image: $exception');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newItemId = DateTime.now().millisecondsSinceEpoch;
      final newPost = GroupPost(
        newItemId,
        name: _titleController.text,
        authorName: 'Emma', // Hardcoded author name
        contents: _contentsController.text.isNotEmpty ? _contentsController.text : null, // Add contents
        likes: 0,
        comments: [],
        imageFile: _pickedImageFile,
        assetImagePath: null,
      );
      Navigator.of(context).pop(newPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // for potentially longer content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Post Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title for the post.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Formfield section for the "contents" piece of the post.
                TextFormField( 
                  controller: _contentsController,
                  decoration: const InputDecoration(
                    labelText: 'Post Contents (Optional)', // since they could post only title and picture for example.
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5, // this should be changed
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                _pickedImageFile == null
                    ? TextButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text('Add Image'),
                        onPressed: _pickImage,
                      )
                    : Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              _pickedImageFile!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          TextButton(
                            onPressed: _pickImage,
                            child: const Text('Change Image'),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Add Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}