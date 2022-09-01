import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  get getScreenSize => MediaQuery.of(context).size;
  get getScreenWidth => MediaQuery.of(context).size.width;
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(
    source: source,
    imageQuality: 30,
  );
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
