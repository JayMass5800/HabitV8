import 'package:flutter/material.dart';
import '../../services/category_suggestion_service.dart';

/// Standardized category filter widget for consistent UI across screens
class CategoryFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final bool includeAll;
  final IconData? icon;

  const CategoryFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.includeAll = true,
    this.icon,
  });

  List<String> get _categories {
    final categories = <String>[];
    if (includeAll) {
      categories.add('All');
    }
    categories.addAll(CategorySuggestionService.getAllCategories());
    return categories;
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return Icons.all_inclusive;
      case 'health':
        return Icons.health_and_safety;
      case 'fitness':
        return Icons.fitness_center;
      case 'mental health':
        return Icons.psychology;
      case 'productivity':
        return Icons.work;
      case 'work':
        return Icons.business;
      case 'learning':
        return Icons.school;
      case 'education':
        return Icons.menu_book;
      case 'personal':
        return Icons.person;
      case 'hobbies':
        return Icons.palette;
      case 'social':
        return Icons.people;
      case 'finance':
        return Icons.account_balance_wallet;
      case 'lifestyle':
        return Icons.home;
      case 'travel':
        return Icons.flight;
      case 'mindfulness':
        return Icons.self_improvement;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onCategoryChanged,
      itemBuilder: (BuildContext context) {
        return _categories.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              children: [
                Icon(_getCategoryIcon(choice), size: 20),
                const SizedBox(width: 8),
                Text(choice),
                if (choice == selectedCategory) ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 16, color: Colors.green),
                ],
              ],
            ),
          );
        }).toList();
      },
      icon: Icon(icon ?? Icons.filter_list),
      tooltip: 'Filter by category',
    );
  }
}