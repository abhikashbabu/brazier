import 'dart:math';
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../theme/app_theme.dart';

const Color fireOrange = AppColors.fireOrange; // Single unified Fire Orange Accent from AppTheme

class ItemsDetailScreen extends StatelessWidget {
  final String title;
  final List<Item> items;
  final Category? category;

  const ItemsDetailScreen({
    super.key,
    required this.title,
    required this.items,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Baseline scaling: max total price and max monthly cost across items in this subpage
    final maxPrice = items.fold(0.0, (maxVal, item) => item.price > maxVal ? item.price : maxVal);
    final maxMonthlyCost = items.fold(0.0, (maxVal, item) {
      final usedCost = item.usedDurationMonths > 0 ? item.usedPricePerMonth : item.goalPricePerMonth;
      final itemMax = max(item.goalPricePerMonth, usedCost);
      return itemMax > maxVal ? itemMax : maxVal;
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (category != null) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: category!.color.withValues(alpha: isDarkMode ? 0.25 : 0.15),
                child: Icon(category!.icon, size: 16, color: category!.color),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No items found in this section.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            )
          : ListView.separated(
              itemCount: items.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final cat = item.category;

                // Total Price ratio (scaled to maxPrice)
                final priceRatio = maxPrice > 0 ? (item.price / maxPrice).clamp(0.05, 1.0) : 0.0;

                // Monthly Progress ratios (scaled relative to maxMonthlyCost)
                final usedPrice = item.usedDurationMonths > 0 ? item.usedPricePerMonth : item.goalPricePerMonth;
                final goalRatio = maxMonthlyCost > 0 ? (item.goalPricePerMonth / maxMonthlyCost).clamp(0.02, 1.0) : 0.0;
                final usedRatio = maxMonthlyCost > 0 ? (usedPrice / maxMonthlyCost).clamp(0.02, 1.0) : 0.0;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1C222D) : theme.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFF2B3342) : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Category Icon + Item Name + Goal Badge
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: cat.color.withValues(alpha: isDarkMode ? 0.25 : 0.15),
                            child: Icon(cat.icon, size: 16, color: cat.color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (item.isGoalReached)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: fireOrange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Goal Reached',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Bar 1: Total Price Bar (scaled to maxPrice)
                      Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              'Total Price:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: priceRatio,
                                minHeight: 8,
                                backgroundColor: isDarkMode ? const Color(0xFF28303F) : theme.colorScheme.surfaceContainerHighest,
                                valueColor: const AlwaysStoppedAnimation<Color>(fireOrange),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '${item.price.toStringAsFixed(2)} €',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Bar 2: Monthly Cost Bar with 8px Target Notch ALWAYS ON TOP
                      Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              'Monthly Cost:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final totalWidth = constraints.maxWidth;
                                final goalLeft = totalWidth > 0 ? (totalWidth * goalRatio).clamp(0.0, totalWidth) : 0.0;
                                final maxMarkerLeft = max(0.0, totalWidth - 8);
                                final markerLeft = maxMarkerLeft > 0 ? (goalLeft - 4).clamp(0.0, maxMarkerLeft) : 0.0;

                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // 1. Gray Background Track (100% width)
                                    Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isDarkMode ? const Color(0xFF28303F) : theme.colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),

                                    // 2. Current Used Monthly Cost Fill Bar
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: usedRatio,
                                        minHeight: 8,
                                        backgroundColor: Colors.transparent,
                                        valueColor: const AlwaysStoppedAnimation<Color>(fireOrange),
                                      ),
                                    ),

                                    // 3. Target Goal Indicator Segment (8px Notch ALWAYS ON TOP)
                                    Positioned(
                                      left: markerLeft,
                                      child: Tooltip(
                                        message: 'Target Goal (${item.goalDurationMonths} mo): ${item.goalPricePerMonth.toStringAsFixed(2)} €/mo',
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: fireOrange,
                                              width: 1.5,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black38,
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: Text(
                              item.usedDurationMonths > 0
                                  ? '${item.usedPricePerMonth.toStringAsFixed(2)} €/mo'
                                  : '${item.goalPricePerMonth.toStringAsFixed(2)} €/mo',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: fireOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
