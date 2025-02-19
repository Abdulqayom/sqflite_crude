import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_crud/usermodel.dart'; // Adjust the import according to your project structure
import 'package:sqflite_crud/provider.dart'; // Adjust the import accordingly

class UserDetailPage extends StatefulWidget {
  final User? user;
  const UserDetailPage({Key? key, this.user}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _imageController;
  bool isMale = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.user?.lastName ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _imageController = TextEditingController(text: widget.user?.image ?? '');
    isMale = widget.user?.isMale ?? true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Pick image from gallery; you can also use ImageSource.camera if desired.
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageController.text = pickedFile.path;
      });
    }
  }

  void _saveUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newUser = User(
        id: widget.user?.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        isMale: isMale,
        image: _imageController.text,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (widget.user == null) {
        await userProvider.addUser(newUser);
      } else {
        await userProvider.updateUser(newUser);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPadding = media.size.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // First Name Field
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter first name' : null,
              ),
              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter last name' : null,
              ),
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter email' : null,
              ),
              // Gender Switch
              SwitchListTile(
                title: const Text('Is Male?'),
                value: isMale,
                onChanged: (value) {
                  setState(() {
                    isMale = value;
                  });
                },
              ),
              // Image Field with Picker Button and Preview
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image Path'),
                readOnly: true,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pick Image'),
                  ),
                  const SizedBox(width: 16),
                  // Display image preview if an image path is available.
                  if (_imageController.text.isNotEmpty)
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        File(_imageController.text),
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
