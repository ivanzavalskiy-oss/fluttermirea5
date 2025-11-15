import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IconGalleryScreen extends StatelessWidget {
  final bool embedMode;
  const IconGalleryScreen({super.key, this.embedMode = false});

  static const _icons = [
    'https://cdn-icons-png.flaticon.com/512/4150/4150897.png',
    'https://cdn-icons-png.flaticon.com/512/4150/4150922.png',
    'https://cdn-icons-png.flaticon.com/512/1694/1694611.png',
    'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
    'https://cdn-icons-png.flaticon.com/512/3448/3448724.png',
    'https://cdn-icons-png.flaticon.com/512/709/709496.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: embedMode ? null : AppBar(title: const Text('Галерея иконок')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: _icons.map((url) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Выбрана иконка: $url')));
              },
              child: Card(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    width: 64,
                    height: 64,
                    placeholder: (_, __) => const CircularProgressIndicator(),
                    errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
