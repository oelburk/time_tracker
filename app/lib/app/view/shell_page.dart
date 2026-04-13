import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router.dart';

const _kTitleBarHeight = 28.0;

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
      body: Column(
        children: [
          const SizedBox(height: _kTitleBarHeight),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: theme.dividerColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.md),
                        _NavItem(
                          icon: Icons.timer_outlined,
                          activeIcon: Icons.timer,
                          isSelected: selectedIndex == 0,
                          onTap: () => context.go(AppRoutePath.timer),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _NavItem(
                          icon: Icons.bar_chart_outlined,
                          activeIcon: Icons.bar_chart,
                          isSelected: selectedIndex == 1,
                          onTap: () => context.go(AppRoutePath.analytics),
                        ),
                        const Spacer(),
                        _NavItem(
                          icon: Icons.settings_outlined,
                          activeIcon: Icons.settings,
                          isSelected: selectedIndex == 2,
                          onTap: () => context.go(AppRoutePath.settings),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
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
  });

  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const activeColor = AppColors.codingPrimary;
    final inactiveColor = theme.textTheme.bodySmall?.color ?? AppColors.idle;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 36,
        child: Center(
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              end: isSelected ? activeColor : inactiveColor,
            ),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            builder: (context, color, _) => Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
