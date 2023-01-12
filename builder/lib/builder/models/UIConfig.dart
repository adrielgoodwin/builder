
class UIConfig {

  String configuration;

  UIConfig({required this.configuration});

  factory UIConfig.fromJson(Map<String, dynamic> data) {
    return UIConfig(configuration: data['configuration']);
  }

  Map<String, dynamic> toMap() {
    return {
      "configuration": configuration,
    };
  }

}