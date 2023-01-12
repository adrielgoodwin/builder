import 'registry.dart';
import 'UIConfig.dart';

class BuilderData {

  List<Registry> appRegistries;
  UIConfig uiConfig;

  BuilderData({required this.appRegistries, required this.uiConfig});

  factory BuilderData.fromJson(Map<String, dynamic> data) {
    var appRegistries = data['appRegistries'];
    var uiConfigMap = data['uiConfig'];
    var uiConfig = UIConfig.fromJson(uiConfigMap);
    List<Registry> registries = [];
    for(var i = 0; i < appRegistries.length; i++ ){
      registries.add(Registry.fromJson(appRegistries[i]));
    }
    return BuilderData(appRegistries: appRegistries, uiConfig: uiConfig);
  }

}