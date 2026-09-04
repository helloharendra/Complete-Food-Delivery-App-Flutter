import 'package:flutter/material.dart';

import '../models/items.dart';

class CartItemDesign extends StatelessWidget {
  const CartItemDesign({
    super.key,
    this.model,
    this.quanNumber,
    BuildContext? context,
  }) : legacyContext = context;

  final Items? model;
  final int? quanNumber;
  final BuildContext? legacyContext;

  @override
  Widget build(BuildContext context) {
    final item = model;
    if (item == null) return const SizedBox.shrink();
    final image = item.thumbnailUrl ?? '';
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 92,
                height: 92,
                child: image.isEmpty
                    ? ColoredBox(
                        color: colors.surfaceContainerHighest,
                        child: Icon(Icons.inventory_2_outlined, color: colors.outline),
                      )
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: colors.surfaceContainerHighest,
                          child: Icon(Icons.broken_image_outlined, color: colors.outline),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? 'منتج',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الكمية: ${quanNumber ?? 1}',
                    style: TextStyle(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price ?? 0} ج.م',
                    style: TextStyle(color: colors.primary, fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
