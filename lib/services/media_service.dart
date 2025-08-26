

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaService {
  ImagePicker _picker = ImagePicker();
  MediaService() {}

  Future<File?> getImageFromGalery() async{
      final XFile? _file = await _picker.pickImage(source: ImageSource.gallery);
      if(_file!= null)
        return  File(_file!.path);
      return null;
  }
  // Future<PlatformFile?> pickImageFromLibrary() async {
  //   FilePickerResult? _result =
  //   await FilePicker.platform.pickFiles(type: FileType.image);
  //   if (_result != null) {
  //     return _result.files[0];
  //   }
  //   return null;
  // }

}
