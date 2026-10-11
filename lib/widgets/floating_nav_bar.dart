import 'package:flutter/material.dart';

class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final int pendingReviewCount;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.pendingReviewCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              height: 68,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha:0.7),
              surfaceTintColor: Colors.transparent,
              indicatorColor: Theme.of(context).colorScheme.primaryContainer,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Items',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: pendingReviewCount > 0,
                    label: Text('$pendingReviewCount'),
                    child: const Icon(Icons.rate_review_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: pendingReviewCount > 0,
                    label: Text('$pendingReviewCount'),
                    child: const Icon(Icons.rate_review),
                  ),
                  label: 'Review',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: 'Statistics',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
