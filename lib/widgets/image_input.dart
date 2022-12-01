import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput(this.onSelectImage, {Key key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    //доступ до спціальної папки на пристрої (getExternalStorageDirectory - для карти пам'яті на Android)
    final fileName = path.basename(imageFile.path);
    //шлях до місця(тимчасовий каталог), де зберігається imageFile. ТОчніше частина шляху, після останнього '/'
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    //збережене в спеціальну папку для файлів Flutter зображення
    widget.onSelectImage(savedImage);
    //передаєм фото з каммери файлу AddPlaceScreen
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.camera_enhance),
            label: Text('Take Picture',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background)),
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
