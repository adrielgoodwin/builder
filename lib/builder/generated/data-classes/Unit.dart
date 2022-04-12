import '../../models/nameValueType.dart';

// This code was generated on 2022-04-11 18:48
// class
class Unit {
  // fields
  final String name;
  final String symbol;
  // fields end
  Unit({required this.name, required this.symbol});
  factory Unit.fromJson(Map<String, dynamic> data) {
    return Unit(
      name: data['name'],
      symbol: data['symbol'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String', false, false), 

      NameValueType('symbol', symbol, 'String', false, false), 

  ];
  static Unit makeWithData(List<String> iterations) {
   return Unit(
     name: "Unit name",
     symbol: "Unit symbol",
  );
  }
  static List<Unit> makeMultipleWithData(List<String> iterations) {
    List<Unit> unitList = [];
      iterations.forEach((x) {
        unitList.add(Unit(
        name: "Unit name",
        symbol: "Unit symbol",
      ));
    });
   return unitList;
  }
}