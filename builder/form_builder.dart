import 'FormFieldData.dart';
import 'FormData.dart';

class FormBuilder {

  final FormData formData;

  FormBuilder(this.formData);


  List<List<String>> inputs = [];

  // List<String> buildInput(FormFieldData data) {
  //
  // }

  Map<String, Function> inputBuilders = {
    "regular": (FormData formData) {
      return """
            TextFormField(
              decoration: InputDecoration(
                hintText: 'placeholder',
                label: Text('label'),
              ),
            ),
      """;
    },
  };

}