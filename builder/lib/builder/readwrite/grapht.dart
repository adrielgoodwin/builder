import 'dart:io';enum Widgets { text }

Map<Widgets, String> widgies = {
  Widgets.text: "@text",
};

class Grapht {

late List<String> widgetsFile = [];

Grapht._create(List<String> widgieFile) {
  widgetsFile = widgieFile;
}

static Future<Grapht> create() async {
  var file = File('widgets.dart');
  var widgetsLines = await file.readAsLines();
  return Grapht._create(widgetsLines);
}

String text(String varName) {
  List<String> pieceIWant = [];
  var record = false;
  for(var i = 0; i < widgetsFile.length; i++) {
    if(widgetsFile[i].contains('@end')) break;
    if(record) pieceIWant.add(widgetsFile[i]);
    if(widgetsFile[i].contains(widgies[Widgets.text]!)) record = true;
  }
  return pieceIWant.join('\n').replaceFirst('tv1', varName);
}
}

void main() async {
  var grapht = await Grapht.create();
  print(grapht.text('bigTits'));
  
}
