import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/features/service/page_service.dart';

import '../features/utilities/appcolors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 100,
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(top: BorderSide(color: AppColor.lightGray)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavBarItem(
            svgPath: 'assets/images/Vector (5).svg',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
            selectedColor: AppColor.primaryColor,
            unselectedColor: AppColor.unselectedColor,
            label: 'Wishlist',

          ),
          _BottomNavBarItem(
            svgPath: 'assets/images/arrow-swap.svg',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
            selectedColor: AppColor.primaryColor,
            unselectedColor: AppColor.unselectedColor,
            label: 'all tickets',
          ),
          _BottomNavBarItem(
            svgPath: 'assets/images/Vector (6).svg',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
            selectedColor: AppColor.primaryColor,
            unselectedColor: AppColor.unselectedColor,
            label: 'Account',
          ),

        ],
      ),
    );
  }
}

class _BottomNavBarItem extends StatelessWidget {
  final String svgPath;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final String label;

  const _BottomNavBarItem({
    required this.svgPath,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required  this.label
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(

          children: [
            PageService.textSpaceL,
            Center(
              child: SvgPicture.asset(
                svgPath,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            PageService.labelSpaceL,
            Text(label, style: PageService.bottomSheetLabel,)
          ],
        ),
      ),
    );
  }
}