import 'package:flutter/material.dart';
import '../../../models/nameValueType.dart';

Widget isNotAListDisplay(NameValueType e) {
  return Column(
    children: [
      Text(
        "${e.name}:",
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 18),
      ),
      Text(
        "${e.value}:",
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 18),
      ),
      const SizedBox(
        height: 5,
      ),
    ],
  );
}

Widget isAListDisplay(NameValueType e) {
  List<String> listOfValues = e.value as List<String>;
  return Column(
    children: [
      Text(
        "${e.name}:",
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 18),
      ),
      ...listOfValues.map((y) => Text(y, style: const TextStyle(fontSize: 18)),).toList(),
      const SizedBox(
        height: 5,
      ),
    ],
  );
}