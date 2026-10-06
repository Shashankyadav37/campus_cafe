import 'package:flutter/material.dart';

void main() {
  runApp(const CampusCafeApp());
}

class CampusCafeApp extends StatelessWidget {
  const CampusCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusCafe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedCategory = 'All';

  final List<String> pages = [
    'Home',
    'Menu',
    'Orders',
    'Profile',
  ];

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Snacks',
      'icon': Icons.fastfood,
    },
    {
      'name': 'Meals',
      'icon': Icons.rice_bowl,
    },
    {
      'name': 'Drinks',
      'icon': Icons.local_drink,
    },
    {
      'name': 'Desserts',
      'icon': Icons.icecream,
    },
  ];

  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Veg Burger',
      'price': 60,
      'category': 'Snacks',
      'icon': Icons.lunch_dining,
    },
    {
      'name': 'Samosa',
      'price': 20,
      'category': 'Snacks',
      'icon': Icons.fastfood,
    },
    {
      'name': 'Masala Dosa',
      'price': 50,
      'category': 'Meals',
      'icon': Icons.restaurant,
    },
    {
      'name': 'Veg Fried Rice',
      'price': 80,
      'category': 'Meals',
      'icon': Icons.rice_bowl,
    },
    {
      'name': 'Cold Coffee',
      'price': 40,
      'category': 'Drinks',
      'icon': Icons.local_cafe,
    },
    {
      'name': 'Fresh Lime Soda',
      'price': 30,
      'category': 'Drinks',
      'icon': Icons.local_drink,
    },
    {
      'name': 'Ice Cream',
      'price': 35,
      'category': 'Desserts',
      'icon': Icons.icecream,
    },
    {
      'name': 'Gulab Jamun',
      'price': 30,
      'category': 'Desserts',
      'icon': Icons.cake,
    },
  ];

  List<Map<String, dynamic>> get filteredItems {
    if (selectedCategory == 'All') {
      return menuItems;
    }

    return menuItems
        .where((item) => item['category'] == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CampusCafe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (selectedIndex == 1) {
      return _buildMenuPage();
    }

    if (selectedIndex != 0) {
      return Center(
        child: Text(
          pages[selectedIndex],
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return _buildHomePage();
  }

  Widget _buildHomePage() {
    final featuredItems = menuItems.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello, Student! 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'What would you like to eat today?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            decoration: InputDecoration(
              hintText: 'Search food...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = categories[index];

                return Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Popular Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth > 700
                  ? (constraints.maxWidth - 24) / 3
                  : 220.0;

              return SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredItems.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: itemWidth,
                      child: FoodCard(
                        item: featuredItems[index],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuPage() {
    final categories = [
      'All',
      'Snacks',
      'Meals',
      'Drinks',
      'Desserts',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Menu',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose something delicious.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected =
                    selectedCategory == category;

                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  constraints.maxWidth >= 900
                      ? 4
                      : constraints.maxWidth >= 600
                          ? 3
                          : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: filteredItems.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  return FoodCard(
                    item: filteredItems[index],
                    showAddButton: true,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool showAddButton;

  const FoodCard({
    super.key,
    required this.item,
    this.showAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'],
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item['name'],
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${item['price']}',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showAddButton) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}