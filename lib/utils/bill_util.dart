import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  var h = hex.replaceFirst('#', '');
  if (h.length == 6) h = 'FF$h';
  final val = int.tryParse(h, radix: 16) ?? 0xFFFFFFFF;
  return Color(val);
}

List<Color> ensureTwoColors(
  List<String>? hexes, {
  Color fallback = Colors.white,
}) {
  final list = (hexes ?? []).map(hexToColor).toList();
  if (list.isEmpty) return [fallback, fallback];
  if (list.length == 1) return [list.first, list.first];
  return list;
}

String formatMoney(String raw) {
  if (raw.trim().startsWith('₹')) return raw.trim();
  return '₹$raw';
}
