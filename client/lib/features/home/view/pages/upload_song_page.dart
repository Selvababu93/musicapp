import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _songNameController = TextEditingController();
  final _artistNameController = TextEditingController();
  var _selectedColor = Pallete.cardColor;

  @override
  void dispose() {
    _songNameController.dispose();
    _artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(10),
                  strokeCap: StrokeCap.round,
                  color: Pallete.borderColor,
                  dashPattern: [14, 4],
                ),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Select the thumbnail for your song',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              CustomField(
                hintText: "Pick Song",
                controller: null,
                readOnly: true,
                onTap: () {},
              ),

              const SizedBox(
                height: 20,
              ),
              CustomField(hintText: 'Artist', controller: _artistNameController),
              const SizedBox(
                height: 20,
              ),
              CustomField(hintText: 'Song name', controller: _songNameController),

              const SizedBox(
                height: 20,
              ),

              ColorPicker(
                color: _selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    _selectedColor = color;
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
