import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.title,
    this.color = Colors.white,
  });
  final String title;
  final String id;
  final Color color;
}