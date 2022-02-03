// import 'dart:convert';
// import 'ClassRegister.dart';
// import 'ClassData.dart';
// import 'FieldData.dart';
// import 'ClassFileComponents.dart';
// import '../lib/APIs/placeInformation/Geometry.dart';
// import '../lib/APIs/placeInformation/Result.dart';
// import 'builder.dart';
// import '../lib/APIs/placeAutoComplete/Predictions.dart';
//
// // extension StringExtension on String {
// //   // from underscores to proper camelcase
// //   String classify() {
// //     var string = "${this[0].toUpperCase()}${this.substring(1)}";
// //     for(;;) {
// //       int index = string.indexOf('_');
// //       if(index != -1) {
// //         var firstPart = string.substring(0, index);
// //         string = string.replaceFirst("_", "");
// //         var secondPart = string.substring(index);
// //         secondPart = "${secondPart[0].toUpperCase()}${secondPart.substring(1)}";
// //         string = "$firstPart$secondPart";
// //       } else {
// //         break;
// //       }
// //     }
// //     return string;
// //   }
// // }
//
// const StripeChargeResponse = '''
// {"stripeCharge" :
// {
//   "id": "ch_3JX9bG2eZvKYlo2C1eKZHvkp",
//   "object": "charge",
//   "amount": 2000,
//   "amount_captured": 0,
//   "amount_refunded": 0,
//   "application": null,
//   "application_fee": null,
//   "application_fee_amount": null,
//   "balance_transaction": "txn_1032HU2eZvKYlo2CEPtcnUvl",
//   "billing_details": {
//     "address": {
//       "city": null,
//       "country": null,
//       "line1": null,
//       "line2": null,
//       "postal_code": null,
//       "state": null
//     },
//     "email": null,
//     "name": null,
//     "phone": null
//   },
//   "calculated_statement_descriptor": null,
//   "captured": false,
//   "created": 1631041494,
//   "currency": "usd",
//   "customer": null,
//   "description": "My First Test Charge (created for API docs)",
//   "disputed": false,
//   "failure_code": null,
//   "failure_message": null,
//   "fraud_details": {},
//   "invoice": null,
//   "livemode": false,
//   "metadata": {},
//   "on_behalf_of": null,
//   "order": null,
//   "outcome": null,
//   "paid": true,
//   "payment_intent": null,
//   "payment_method": "card_1JX9bD2eZvKYlo2COxnvcn78",
//   "payment_method_details": {
//     "card": {
//       "brand": "visa",
//       "checks": {
//         "address_line1_check": null,
//         "address_postal_code_check": null,
//         "cvc_check": "pass"
//       },
//       "country": "US",
//       "exp_month": 8,
//       "exp_year": 2022,
//       "fingerprint": "Xt5EWLLDS7FJjR1c",
//       "funding": "credit",
//       "installments": null,
//       "last4": "4242",
//       "network": "visa",
//       "three_d_secure": null,
//       "wallet": null
//     },
//     "type": "card"
//   },
//   "receipt_email": null,
//   "receipt_number": null,
//   "receipt_url": "https://pay.stripe.com/receipts/acct_1032D82eZvKYlo2C/ch_3JX9bG2eZvKYlo2C1eKZHvkp/rcpt_KBWevEJ3Hh7GgimN1vTgvjVjVURIy6g",
//   "refunded": false,
//   "refunds": {
//     "object": "list",
//     "data": [],
//     "has_more": false,
//     "url": "/v1/charges/ch_3JX9bG2eZvKYlo2C1eKZHvkp/refunds"
//   },
//   "review": null,
//   "shipping": null,
//   "source_transfer": null,
//   "statement_descriptor": null,
//   "statement_descriptor_suffix": null,
//   "status": "succeeded",
//   "transfer_data": null,
//   "transfer_group": null,
//   "source": "tok_visa"
// }}
// ''';
//
// const geometryResponse = '''
// {
//    "result" : {
//       "geometry" : {
//          "location" : {
//             "lat" : 55.7326651,
//             "lng" : 24.3582559
//          },
//          "viewport" : {
//             "northeast" : {
//                "lat" : 55.7340140802915,
//                "lng" : 24.3596048802915
//             },
//             "southwest" : {
//                "lat" : 55.7313161197085,
//                "lng" : 24.3569069197085
//             }
//          }
//       }
//    },
//    "status" : "OK"
// }
// ''';
//
// const JsonString = '''{
//   "predictions":
//   [
//     {
//       "description": "Paris, France",
//       "matched_substrings": [{ "length": 5, "offset": 0 }],
//       "place_id": "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
//       "reference": "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
//       "structured_formatting":
//       {
//         "main_text": "Paris",
//         "main_text_matched_substrings": [{ "length": 5, "offset": 0 }],
//         "secondary_text": "France"
//       },
//       "terms":
//       [
//         { "offset": 0, "value": "Paris" },
//         { "offset": 7, "value": "France" }
//       ],
//       "types": ["locality", "political", "geocode"]
//     },
//     {
//       "description": "Paris, TX, USA",
//       "matched_substrings": [{ "length": 5, "offset": 0 }],
//       "place_id": "ChIJmysnFgZYSoYRSfPTL2YJuck",
//       "reference": "ChIJmysnFgZYSoYRSfPTL2YJuck",
//       "structured_formatting":
//       {
//         "main_text": "Paris",
//         "main_text_matched_substrings": [{ "length": 5, "offset": 0 }],
//         "secondary_text": "TX, USA"
//       },
//       "terms":
//       [
//         { "offset": 0, "value": "Paris" },
//         { "offset": 7, "value": "TX" },
//         { "offset": 11, "value": "USA" }
//       ],
//       "types": ["locality", "political", "geocode"]
//     },
//     {
//       "description": "Paris, Brant, ON, Canada",
//       "matched_substrings": [{ "length": 5, "offset": 0 }],
//       "place_id": "ChIJsamfQbVtLIgR-X18G75Hyi0",
//       "reference": "ChIJsamfQbVtLIgR-X18G75Hyi0",
//       "structured_formatting":
//       {
//         "main_text": "Paris",
//         "main_text_matched_substrings": [{ "length": 5, "offset": 0 }],
//         "secondary_text": "Brant, ON, Canada"
//       },
//       "terms":
//       [
//         { "offset": 0, "value": "Paris" },
//         { "offset": 7, "value": "Brant" },
//         { "offset": 14, "value": "ON" },
//         { "offset": 18, "value": "Canada" }
//       ],
//       "types": ["neighborhood", "political", "geocode"]
//     },
//     {
//       "description": "Paris, TN, USA",
//       "matched_substrings": [{ "length": 5, "offset": 0 }],
//       "place_id": "ChIJ4zHP-Sije4gRBDEsVxunOWg",
//       "reference": "ChIJ4zHP-Sije4gRBDEsVxunOWg",
//       "structured_formatting":
//       {
//         "main_text": "Paris",
//         "main_text_matched_substrings": [{ "length": 5, "offset": 0 }],
//         "secondary_text": "TN, USA"
//       },
//       "terms":
//       [
//         { "offset": 0, "value": "Paris" },
//         { "offset": 7, "value": "TN" },
//         { "offset": 11, "value": "USA" }
//       ],
//       "types": ["locality", "political", "geocode"]
//     },
//     {
//       "description": "Paris, AR, USA",
//       "matched_substrings": [{ "length": 5, "offset": 0 }],
//       "place_id": "ChIJFRt9mkF5zIcRdsZ3XM8ZyHE",
//       "reference": "ChIJFRt9mkF5zIcRdsZ3XM8ZyHE",
//       "structured_formatting":
//       {
//         "main_text": "Paris",
//         "main_text_matched_substrings": [{ "length": 5, "offset": 0 }],
//         "secondary_text": "AR, USA"
//       },
//       "terms":
//       [
//         { "offset": 0, "value": "Paris" },
//         { "offset": 7, "value": "AR" },
//         { "offset": 11, "value": "USA" }
//       ],
//       "types": ["locality", "political", "geocode"]
//     }
//   ],
//   "status": "OK"
// }
// ''';
//
// class JsonToDart {
//   final String jsonString;
//   final String name;
//
//   JsonToDart(this.jsonString, this.name);
//
//   List<ClassData> classDatas = [];
//
//   void makeClassFromMap(Map<String, dynamic> jsonMap, String className) {
//     List<FieldData> fieldDatas = [];
//     List<String> neededImports = [];
//
//     // Loop over jason map
//     jsonMap.forEach((key, value) {
//       String type = value.runtimeType.toString();
//       bool isAClass = false;
//       bool isAList = false;
//
//       // check if value is a list
//       if (type == 'List<dynamic>') {
//         isAList = true;
//
//         // check if list items are maps
//         if (value[0].runtimeType.toString() ==
//             '_InternalLinkedHashMap<String, dynamic>') {
//           // if so, that map is what we will make a new class from
//           isAClass = true;
//           // take the 's' off of the end to the key to make it singular. eg 'terms' -> 'term'
//           // this will be the name of the class
//           String nextClassName = key.substring(0, key.length - 1);
//           var map = Map<String, dynamic>.from(value[0]);
//           makeClassFromMap(map, nextClassName.classify());
//           type = nextClassName.classify();
//           neededImports.add(nextClassName.classify());
//
//         } else {
//
//           isAClass = false;
//           type = value[0].runtimeType.toString();
//         }
//
//       } else if (jsonMap[key].runtimeType.toString() ==
//           '_InternalLinkedHashMap<String, dynamic>') {
//         isAClass = true;
//         // this will be the name of the class
//         String className = key;
//         neededImports.add(className.classify());
//         // print(className);
//         var map = Map<String, dynamic>.from(jsonMap[key]);
//         makeClassFromMap(map, className.classify());
//         type = className.classify();
//       }
//
//       fieldDatas.add(FieldData(
//         type: type,
//         name: key,
//         isAList: isAList,
//         isAClass: isAClass,
//       ));
//
//     });
//
//     classDatas.add(ClassData(
//       name: className.classify(),
//       fieldData: fieldDatas,
//       neededImports: neededImports,
//     ));
//
//   }
//
//   void go() {
//     Map<String, dynamic> jsonMap = json.decode(jsonString);
//     makeClassFromMap(jsonMap, 'predictions');
//   }
//
// }
//
// void main() {
//
//   // JsonToDart placeAutocomplete = JsonToDart(JsonString, 'PlacesClasses');
//   // placeAutocomplete.go();
//   //
//   // placeAutocomplete.classDatas.forEach((classData) {
//   //   print(classData.name);
//   //   generateClassFilesFromClassData(classData, "../lib/APIs/placeAutoComplete/");
//   // });
//
//   // JsonToDart placeInformation = JsonToDart(geometryResponse, 'GeometryResponse');
//   // placeInformation.go();
//   //
//   // placeInformation.classDatas.forEach((classData) {
//   //   generateClassFilesFromClassData(classData, "../lib/APIs/placeInformation/");
//   // });
//
//   Result result = Result.fromJson(json.decode(geometryResponse)['result']);
//   print(result.geometry.location.lat);
//
//   // Predictions response = Predictions.fromJson(jsonDecode(JsonString));
//
// }
