import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/features/splash/domain/reposotories/splash_repo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  final DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;

  ConfigModel? _configModel;
  ConfigModel? get configModel=>_configModel;
  BaseUrls? _baseUrls;
  BaseUrls? get baseUrls => _baseUrls;



  Future<File> downloadAndSaveImage(String imageUrl) async {
    // Get the application's document directory
    final directory = await getApplicationDocumentsDirectory();

    // Define the file path where you want to save the image
    final filePath = '${directory.path}/downloaded_image.png';

    // Send HTTP request to download the image
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Write the downloaded image bytes to the file
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('Image saved at $filePath');
        return file;
      } else {
        throw Exception('Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading image: $e');
      throw Exception('Error saving image: $e');
    }
  }

  Future<void> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    if(response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);
      _baseUrls = ConfigModel.fromJson(response.body).baseUrls;

    }else {
      ApiChecker.checkApi(response);
    }
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }
}
