import 'package:flutter/material.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  // Sample data for UI demonstration
  final List<Map<String, dynamic>> categories = [
    {
      "id": "food",
      "name": "Food",
      "icon": Icons.restaurant,
      "color": Colors.orange,
      "isDefault": true,
    },
    {
      "id": "transport",
      "name": "Transport",
      "icon": Icons.directions_car,
      "color": Colors.blue,
      "isDefault": true,
    },
    {
      "id": "shopping",
      "name": "Shopping",
      "icon": Icons.shopping_bag,
      "color": Colors.purple,
      "isDefault": false,
    },
    {
      "id": "entertainment",
      "name": "Entertainment",
      "icon": Icons.movie,
      "color": Colors.pink,
      "isDefault": false,
    },
  ];

  final List<IconData> availableIcons = [
    Icons.restaurant,
    Icons.directions_car,
    Icons.shopping_bag,
    Icons.movie,
    Icons.power,
    Icons.sports_esports,
    Icons.medical_services,
    Icons.home,
    Icons.school,
    Icons.fitness_center,
  ];

  final List<Color> availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.brown,
  ];

  void _showCategoryDialog({Map<String, dynamic>? category}) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?['name']);
    var selectedIcon = category?['icon'] ?? availableIcons[0];
    var selectedColor = category?['color'] ?? availableColors[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name Input
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon Selection
                const Text('Select Icon'),
                Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: availableIcons.length,
                    itemBuilder: (context, index) {
                      final icon = availableIcons[index];
                      return IconButton(
                        icon: Icon(icon),
                        color: selectedIcon == icon ? selectedColor : Colors.grey,
                        onPressed: () => setState(() => selectedIcon = icon),
                      );
                    },
                  ),
                ),

                // Color Selection
                const Text('Select Color'),
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    itemCount: availableColors.length,
                    itemBuilder: (context, index) {
                      final color = availableColors[index];
                      return GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color 
                                  ? Colors.black 
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    if (isEditing) {
                      final index = categories.indexWhere((c) => c['id'] == category['id']);
                      categories[index] = {
                        ...category,
                        'name': nameController.text,
                        'icon': selectedIcon,
                        'color': selectedColor,
                      };
                    } else {
                      categories.add({
                        'id': nameController.text.toLowerCase().replaceAll(' ', '_'),
                        'name': nameController.text,
                        'icon': selectedIcon,
                        'color': selectedColor,
                        'isDefault': false,
                      });
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Categories'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Default categories cannot be modified'),
                      Text('• Custom categories can be edited or deleted'),
                      Text('• Categories help organize your expenses'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: category['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  category['icon'],
                  color: category['color'],
                ),
              ),
              title: Text(category['name']),
              trailing: category['isDefault']
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Default',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showCategoryDialog(category: category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Category'),
                                content: Text(
                                  'Are you sure you want to delete "${category['name']}"?'
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        categories.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
      ),
    );
  }
}