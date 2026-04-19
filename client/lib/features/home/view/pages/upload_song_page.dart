import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UploadSongPageState();
  }
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _songNameController = TextEditingController();
  final _artistController = TextEditingController();
  var selectedColor = Pallete.cardColor;
  File? selectedPicture;
  File? selectedAudio;

  @override
  void dispose() {
    _songNameController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  void selectSong() async {
    final pickedSong = pickAudio();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedPicture = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a Song"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.check))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: selectedPicture != null
                    ? SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Image.file(
                            selectedPicture!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: Radius.circular(10),
                          color: Pallete.borderColor,
                          dashPattern: [10, 5],
                          strokeCap: StrokeCap.round,
                        ),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 40,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Upload a Thumbnail",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 30,
              ),

              CustomField(
                hintText: "Pick a Song",
                controller: null,
                readOnly: true,
                onTap: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              CustomField(hintText: "Artist", controller: _artistController),
              const SizedBox(
                height: 20,
              ),
              CustomField(hintText: "Song", controller: _songNameController),
              const SizedBox(
                height: 20,
              ),
              ColorPicker(
                pickersEnabled: const {ColorPickerType.wheel: true},
                color: selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
