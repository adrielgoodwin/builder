enum Keys { a, s, d, f, g, h, j, k, l, semicolon, n }

Map<String, Keys> stringKeys = {
  'a': Keys.a,
  's': Keys.s,
  'd': Keys.d,
  'f': Keys.f,
  'g': Keys.g,
  'h': Keys.h,
  'j': Keys.j,
  'k': Keys.k,
  'l': Keys.l,
  ';': Keys.semicolon,
  'n': Keys.n,
};

Map<Keys, String> keyStrings = {
  Keys.a: "A",
  Keys.s: "S",
  Keys.d: "D",
  Keys.f: "F",
  Keys.g: "G",
  Keys.h: "H",
  Keys.j: "J",
  Keys.k: "K",
  Keys.l: "L",
  Keys.semicolon: ";",
  Keys.n: "N",
};

class KeyExplanationFunction {
  final Keys key;
  final String explanation;
  final Function function;

  KeyExplanationFunction(this.key, this.explanation, this.function);
}

class ActionPlug {
  // This is pretty important!

  // This is how functions get called from user input
  void execute(Keys key) => funcMap[key]!();

  final Function backOut; // A
  final Function left; // S
  final Function right; // D
  final Function down; // F
  final Function up; // G
  final Function select; // H
  final Function actionj; // J
  final Function actionk; // K
  final Function actionl; // L
  final Function actionSemicolon; // ;
  final Function actionNew; // N

  final String backOutExpl;
  final String leftExpl;
  final String rightExpl;
  final String downExpl;
  final String upExpl;
  final String selectExpl;
  final String actionjExpl;
  final String actionkExpl;
  final String actionlExpl;
  final String actionSemicolonExpl;
  final String actionNewExpl;

  late Map<Keys, Function> funcMap = {
    Keys.a: backOut,
    Keys.s: left,
    Keys.d: right,
    Keys.f: select,
    Keys.g: down,
    Keys.h: up,
    Keys.j: actionj,
    Keys.k: actionk,
    Keys.l: actionl,
    Keys.semicolon: actionSemicolon,
    Keys.n: actionNew,
  };

  late Map<Keys, String> funcExplanations = {
    Keys.a: backOutExpl,
    Keys.s: leftExpl,
    Keys.d: rightExpl,
    Keys.f: selectExpl,
    Keys.g: downExpl,
    Keys.h: upExpl,
    Keys.j: actionjExpl,
    Keys.k: actionkExpl,
    Keys.l: actionlExpl,
    Keys.semicolon: actionSemicolonExpl,
    Keys.n: actionNewExpl,
  };

  late List<KeyExplanationFunction> keyExplanationFunctions = [
    KeyExplanationFunction(Keys.a, backOutExpl, backOut),
    KeyExplanationFunction(Keys.s, leftExpl, left),
    KeyExplanationFunction(Keys.d, rightExpl, right),
    KeyExplanationFunction(Keys.f, downExpl, down),
    KeyExplanationFunction(Keys.g, upExpl, up),
    KeyExplanationFunction(Keys.h, selectExpl, select),
    KeyExplanationFunction(Keys.j, actionjExpl, actionj),
    KeyExplanationFunction(Keys.k, actionkExpl, actionk),
    KeyExplanationFunction(Keys.l, actionlExpl, actionl),
    KeyExplanationFunction(Keys.n, actionNewExpl, actionNew),
  ];

  ActionPlug({
    required this.backOut,
    required this.backOutExpl,
    required this.left,
    required this.leftExpl,
    required this.right,
    required this.rightExpl,
    required this.select,
    required this.selectExpl,
    required this.down,
    required this.downExpl,
    required this.up,
    required this.upExpl,
    required this.actionj,
    required this.actionjExpl,
    required this.actionk,
    required this.actionkExpl,
    required this.actionl,
    required this.actionlExpl,
    required this.actionSemicolon,
    required this.actionSemicolonExpl,
    required this.actionNew,
    required this.actionNewExpl,
  });
}


var emptyPlug = ActionPlug(
    backOut: () {},
    backOutExpl: "",
    left: () {},
    leftExpl: "",
    right: () {},
    rightExpl: "",
    select: () {},
    selectExpl: "",
    down: () {},
    downExpl: "",
    up: () {},
    upExpl: "",
    actionj: () {},
    actionjExpl: "",
    actionk: () {},
    actionkExpl: "",
    actionl: () {},
    actionlExpl: "",
    actionSemicolon: () {},
    actionSemicolonExpl: "",
    actionNew: () {},
    actionNewExpl: "",
  );