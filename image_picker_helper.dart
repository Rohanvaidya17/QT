// lib/utils/image_picker_helper.dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qt_qt/providers/user_provider.dart';
import 'package:qt_qt/utils/image_picker_helper.dart';


class ImagePickerHelper {
  static Future<File?> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}

// lib/screens/profile/profile_picture_screen.dart

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({Key? key}) : super(key: key);

  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  bool _isLoading = false;

  Future<void> _handleImageSelection(ImageSource source) async {
    try {
      final file = await ImagePickerHelper.pickImage(source);
      if (file == null) return;

      setState(() => _isLoading = true);
      await Provider.of<UserProvider>(context, listen: false)
          .updateProfilePicture(file);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile picture: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'profile_picture',
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user?.profilePicture != null
                          ? NetworkImage(user!.profilePicture!)
                          : null,
                      child: user?.profilePicture == null
                          ? Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey[400],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => _handleImageSelection(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose from Gallery'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _handleImageSelection(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take a Photo'),
                  ),
                  if (user?.profilePicture != null) ...[
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement remove profile picture
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Remove Picture',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}