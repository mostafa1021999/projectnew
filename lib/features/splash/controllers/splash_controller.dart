import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/features/splash/domain/reposotories/splash_repo.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  final DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;

  ConfigModel? _configModel;
  ConfigModel? get configModel=>_configModel;
  BaseUrls? _baseUrls;
  BaseUrls? get baseUrls => _baseUrls;




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
