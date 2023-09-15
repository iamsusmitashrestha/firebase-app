import 'dart:io';

import 'package:firebase_app/common/constants/ui_helpers.dart';
import 'package:firebase_app/common/widgets/button_loading_indicator.dart';
import 'package:firebase_app/common/widgets/common_button.dart';
import 'package:firebase_app/common/widgets/common_text_form_field.dart';
import 'package:firebase_app/data/provider/auth_provider.dart';
import 'package:firebase_app/themes/app_themes.dart';
import 'package:firebase_app/utils/snackbar_util.dart';
import 'package:firebase_app/utils/validation_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullName = "";
  String _email = "";
  bool _isLoading = false;
  File? _imageFile;

  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> updateUserData() async {
    if (_formKey.currentState?.validate() == false) {
      return;
    }
    _formKey.currentState!.save();
    try {
      _setLoading(true);

      await Provider.of<AuthProvider>(context, listen: false)
          .updateUserData(_fullName, _email, _imageFile!);

      SnackbarUtil.showSnackbar(context, "User details updated");
    } catch (e) {
      print("Error on updating user details $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  // Select image from gallery
  Future<void> selectImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    var file = File(pickedImage!.path);
    setState(() {
      _imageFile = file;
    });
  }

  // User logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await Provider.of<AuthProvider>(context, listen: false).logout();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(builder: (context, data, child) {
          final currentUser = data.currentUser!;
          return ListView(
            padding: lPadding,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.purple,
                            ),
                          ),
                          onTap: () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .logout();
                            if (mounted) {
                              Navigator.of(context)
                                  .pushReplacementNamed("/login");
                            }
                          }),
                    ],
                  ),
                  lHeightSpan,
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: (_imageFile != null)
                            ? FileImage(File(_imageFile!.path))
                                as ImageProvider<Object>?
                            : (currentUser.imageUrl.isNotEmpty)
                                ? NetworkImage(currentUser.imageUrl)
                                : null,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: PRIMARY_COLOR,
                        ),
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                          ),
                          color: Colors.white,
                          autofocus: true,
                        ),
                      ),
                    ],
                  ),
                  sHeightSpan,
                  Text(
                    currentUser.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              lHeightSpan,
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CommonTextFormField(
                      label: "Full name",
                      initialValue: currentUser.fullName,
                      validator: ValidationUtils.validateFullName,
                      onSaved: (value) {
                        setState(() {
                          _fullName = value ?? '';
                        });
                      },
                    ),
                    mHeightSpan,
                    CommonTextFormField(
                      label: "Email",
                      initialValue: currentUser.email,
                      validator: ValidationUtils.validateEmail,
                      onSaved: (value) {
                        setState(() {
                          _email = value ?? '';
                        });
                      },
                    ),
                    mHeightSpan,
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            onPressed: updateUserData,
                            child: _isLoading
                                ? const ButtonLoadingIndicator()
                                : const Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
