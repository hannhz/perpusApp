import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final int hoveredIndex;
  final Function(int) onItemTapped;
  final Function(int, bool) onItemHovered;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.hoveredIndex,
    required this.onItemTapped,
    required this.onItemHovered,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home},
      {'icon': Icons.add},
      {'icon': Icons.person},
    ];

    return BottomAppBar(
      color: Colors.grey[100], // Changed to solid white background
      elevation: 8,
      shape: const CircularNotchedRectangle(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey[300]!, // Light grey top border
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = selectedIndex == index;
            final isHovered = hoveredIndex == index && !isSelected;

            return Expanded(
              child: MouseRegion(
                onEnter: (_) => onItemHovered(index, true),
                onExit: (_) => onItemHovered(index, false),
                child: GestureDetector(
                  onTap: () => onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.grey[50] // Very light grey for selected
                              : isHovered
                              ? Colors.grey[100] // Lighter grey for hover
                              : Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color:
                              isSelected
                                  ? const Color.fromARGB(255, 59, 59, 59)
                                  : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color:
                              isSelected
                                  ? const Color.fromARGB(255, 59, 59, 59)
                                  : Colors
                                      .grey[600], // Darker grey for unselected
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
