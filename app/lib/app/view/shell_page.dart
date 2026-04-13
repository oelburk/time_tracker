import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_ui/app_ui.dart';
import '../../router.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child});
  final Widget child;

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutePath.analytics)) return 1;
    if (location.startsWith(AppRoutePath.settings)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 64,
            decoration: BoxDecoration(
              color: theme.cardTheme.color ?? theme.scaffoldBackgroundColor,
              border: Border(
                right: BorderSide(color: theme.dividerColor, width: 0.5),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                _NavItem(
                  icon: Icons.timer_outlined,
                  activeIcon: Icons.timer,
                  isSelected: selectedIndex == 0,
                  onTap: () => context.go(AppRoutePath.timer),
                  color: AppColors.codingPrimary,
                ),
                _NavItem(
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart,
                  isSelected: selectedIndex == 1,
                  onTap: () => context.go(AppRoutePath.analytics),
                  color: AppColors.codingPrimary,
                ),
                const Spacer(),
                _NavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  isSelected: selectedIndex == 2,
                  onTap: () => context.go(AppRoutePath.settings),
                  color: AppColors.codingPrimary,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          child: Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? color : Theme.of(context).iconTheme.color,
            size: 22,
          ),
        ),
      ),
    );
  }
}
