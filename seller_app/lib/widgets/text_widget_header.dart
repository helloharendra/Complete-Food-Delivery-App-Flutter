import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  const TextWidgetHeader({required this.title});
  final String title;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900, color: colors.onSurface),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 58;
  @override
  double get minExtent => 58;

  @override
  bool shouldRebuild(covariant TextWidgetHeader oldDelegate) =>
      title != oldDelegate.title;
}
