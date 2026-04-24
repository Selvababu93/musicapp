import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _songNameController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  void selectSong() async {
    print("Calling audio picker");
    final pickedSong = await pickAudio();
    if (pickedSong != null) {
      setState(() {
        selectedAudio = pickedSong;
      });
    }
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
    final isLoading = ref.watch(homeViewmodelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a Song"),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && selectedAudio != null && selectedPicture != null) {
                ref
                    .read(homeViewmodelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedPicture!,
                      songName: _songNameController.text,
                      artist: _artistController.text,
                      selectedColor: selectedColor,
                    );
              } else {
                showSnackbar(context, "Missing fields!");
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomField(
                              hintText: "Pick a Song",
                              controller: null,
                              readOnly: true,
                              onTap: () {
                                selectSong();
                              },
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
            ),
    );
  }
}
