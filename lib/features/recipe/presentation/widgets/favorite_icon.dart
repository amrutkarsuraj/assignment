import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  final bool isFav;
  final VoidCallback onTap;

  const FavoriteIcon({
    super.key,
    required this.isFav,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFav),
          color: Colors.red,
          size: 28,
        ),
      ),
    );
  }
}