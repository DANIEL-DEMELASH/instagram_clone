// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/post_provider.dart';

import '../widgets/my_button_widget.dart';

class PublishPostScreen extends StatefulWidget {
  const PublishPostScreen({super.key});

  @override
  State<PublishPostScreen> createState() => _PublishPostScreenState();
}

class _PublishPostScreenState extends State<PublishPostScreen> {
  File? imageFile;

  final _description = TextEditingController();

  final _postProvider = PostProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
    imageFile = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _showImageDialog(),
                  child: Container(
                    width: size.width * 0.8,
                    height: size.width * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blue),
                    ),
                    child: imageFile == null
                        ? const Icon(
                            Icons.camera_enhance_sharp,
                            color: Colors.blue,
                            size: 30,
                          )
                        : Image.file(
                            imageFile!,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _description,
                  maxLines: 5,
                  minLines: 1,
                  decoration: const InputDecoration(
                      hintText: 'post description', hintStyle: TextStyle()),
                ),
                const SizedBox(height: 15),
                MyButtonWidget(
                    bgColor: Colors.blueAccent,
                    text: 'post',
                    onPressed: () async {
                      _postProvider.uploadPost(
                          image: imageFile!, description: _description.text);
                      setState(() {
                        _description.clear();
                        imageFile = null;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
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
    pickedFile != null ? _cropImage(pickedFile.path) : null;
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    pickedFile != null ? _cropImage(pickedFile.path) : null;
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
