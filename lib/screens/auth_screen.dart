// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../services/auth_firebase.dart';
import '../widgets/my_button_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _emailText = TextEditingController();
  final _passwordText = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  late TabController _tabController;

  File? imageFile;

  final _signupEmailText = TextEditingController();
  final _signupPasswordText = TextEditingController();
  final _signupPhoneText = TextEditingController();
  final _signupUsernameText = TextEditingController();
  final _signupFullnameText = TextEditingController();
  final signupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _emailText.dispose();
    _passwordText.dispose();
    _tabController.dispose();

    _signupEmailText.dispose();
    _signupFullnameText.dispose();
    _signupPasswordText.dispose();
    _signupUsernameText.dispose();
    _signupPhoneText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Login',
                  ),
                  Tab(
                    text: 'Signup',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_loginWidget(), _signupWidget()],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _loginWidget() {
    return Form(
        key: formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Instagram',
            style: GoogleFonts.lobsterTwo(
              textStyle: const TextStyle(fontSize: 38),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextFormField(
              controller: _emailText,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!value!.contains('@')) {
                  return 'enter valid email address';
                }
                return null;
              },
              decoration:
                  textInputDecoration.copyWith(hintText: 'email address')),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            obscureText: _obscureText,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordText,
            validator: (value) {
              if (value!.length < 8) {
                return 'password length must be 7+ characters';
              }
              return null;
            },
            decoration: textInputDecoration.copyWith(
                hintText: 'your password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          MyButtonWidget(
              bgColor: Colors.blueAccent,
              text: 'Login',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Auth().signInWithEmailAndPassword(
                      email: _emailText.text.trim(),
                      password: _passwordText.text.trim(),
                      context: context);
                }
              }),
        ]));
  }

  Widget _signupWidget() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
          key: signupFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _showImageDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: size.width * 0.24,
                    height: size.width * 0.24,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.cyanAccent),
                        shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: imageFile == null
                          ? const Icon(
                              Icons.camera_enhance_sharp,
                              color: Colors.cyan,
                              size: 30,
                            )
                          : Image.file(
                              imageFile!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                  controller: _signupEmailText,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!value!.contains('@')) {
                      return 'enter valid email address';
                    }
                    return null;
                  },
                  decoration:
                      textInputDecoration.copyWith(hintText: 'email address')),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: _signupFullnameText,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'name must be 2+ characters';
                    }
                    return null;
                  },
                  decoration:
                      textInputDecoration.copyWith(hintText: 'full name')),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: _signupUsernameText,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'username must be 5+ characters';
                    }
                    return null;
                  },
                  decoration:
                      textInputDecoration.copyWith(hintText: 'username')),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: _signupPhoneText,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.length < 10) {
                      return 'phone number be 9+ characters';
                    }
                    return null;
                  },
                  decoration:
                      textInputDecoration.copyWith(hintText: 'phone number')),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                obscureText: _obscureText,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                controller: _signupPasswordText,
                validator: (value) {
                  if (value!.length < 8) {
                    return 'password length must be 7+ characters';
                  }
                  return null;
                },
                decoration: textInputDecoration.copyWith(
                    hintText: 'your password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              MyButtonWidget(
                  bgColor: Colors.blueAccent,
                  text: 'Signup',
                  onPressed: () {
                    if (signupFormKey.currentState!.validate() &&
                        imageFile != null) {
                      Auth().createUserWithEmailAndPassword(
                          email: _signupEmailText.text.trim(),
                          password: _signupPasswordText.text.trim(),
                          username: _signupUsernameText.text.trim(),
                          fullname: _signupFullnameText.text.trim(),
                          photo: imageFile!,
                          phoneNumber: _signupPhoneText.text.trim(),
                          context: context);
                    }
                  }),
            ],
          )),
    );
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(children: const [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ]),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(children: const [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.image,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ]),
                ),
              ],
            ),
          );
        }));
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }
}
