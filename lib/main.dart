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
        scaffoldBackgroundColor: const Color(0xfff8faf8),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
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

  String studentName = 'Student';
  String studentEmail = 'student@college.edu';

  final List<Map<String, dynamic>> cartItems = [];
  final List<Map<String, dynamic>> orders = [];

  final List<Map<String, dynamic>> categories = [
    {'name': 'Snacks', 'icon': Icons.fastfood},
    {'name': 'Meals', 'icon': Icons.rice_bowl},
    {'name': 'Drinks', 'icon': Icons.local_drink},
    {'name': 'Desserts', 'icon': Icons.icecream},
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

  int get cartCount {
    int count = 0;

    for (final item in cartItems) {
      count += item['quantity'] as int;
    }

    return count;
  }

  int get cartTotal {
    int total = 0;

    for (final item in cartItems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }

    return total;
  }

  void addToCart(Map<String, dynamic> item) {
    final existingIndex = cartItems.indexWhere(
      (cartItem) => cartItem['name'] == item['name'],
    );

    setState(() {
      if (existingIndex != -1) {
        cartItems[existingIndex]['quantity']++;
      } else {
        cartItems.add({
          'name': item['name'],
          'price': item['price'],
          'icon': item['icon'],
          'quantity': 1,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void placeOrder() {
    if (cartItems.isEmpty) {
      return;
    }

    final orderItems = cartItems.map((item) {
      return {
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
        'icon': item['icon'],
      };
    }).toList();

    final newOrder = {
      'id': 'ORD-${1000 + orders.length + 1}',
      'items': orderItems,
      'total': cartTotal,
      'status': 'Preparing',
    };

    setState(() {
      orders.insert(0, newOrder);
      cartItems.clear();
      selectedIndex = 2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
      ),
    );
  }

  void editProfile() {
    final nameController = TextEditingController(text: studentName);
    final emailController = TextEditingController(text: studentEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  studentName = nameController.text.trim().isEmpty
                      ? 'Student'
                      : nameController.text.trim();

                  studentEmail = emailController.text.trim().isEmpty
                      ? 'student@college.edu'
                      : emailController.text.trim();
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showAboutDialogBox() {
    showAboutDialog(
      context: context,
      applicationName: 'CampusCafe',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.restaurant),
      children: const [
        Text(
          'A simple digital cafeteria ordering app built as a college project.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'CampusCafe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedIndex = 4;
              });
            },
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex > 3 ? 0 : selectedIndex,
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

    if (selectedIndex == 2) {
      return _buildOrdersPage();
    }

    if (selectedIndex == 4) {
      return _buildCartPage();
    }

    if (selectedIndex == 3) {
      return _buildProfilePage();
    }

    return _buildHomePage();
  }

  Widget _pageContent(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1100,
        ),
        child: child,
      ),
    );
  }

  Widget _buildHomePage() {
    final featuredItems = menuItems.take(3).toList();

    return _pageContent(
      SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(),
            const SizedBox(height: 28),
            _buildSectionTitle('Categories'),
            const SizedBox(height: 14),
            SizedBox(
              height: 105,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return SizedBox(
                    width: 115,
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          setState(() {
                            selectedCategory = category['name'];
                            selectedIndex = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category['icon'],
                              size: 32,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
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
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('Popular Today'),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                if (isWide) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: featuredItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.05,
                    ),
                    itemBuilder: (context, index) {
                      return FoodCard(
                        item: featuredItems[index],
                        onAdd: () =>
                            addToCart(featuredItems[index]),
                      );
                    },
                  );
                }

                return SizedBox(
                  height: 245,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredItems.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 230,
                        child: FoodCard(
                          item: featuredItems[index],
                          onAdd: () =>
                              addToCart(featuredItems[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 550;

          final text = Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $studentName! 👋',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fresh food, right from your campus cafeteria.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: compact ? double.infinity : 220,
                child: FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text('Explore Menu'),
                ),
              ),
            ],
          );

          if (compact) {
            return text;
          }

          return Row(
            children: [
              Expanded(child: text),
              const SizedBox(width: 30),
              Icon(
                Icons.restaurant,
                size: 110,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMenuPage() {
    const categoryFilters = [
      'All',
      'Snacks',
      'Meals',
      'Drinks',
      'Desserts',
    ];

    return _pageContent(
      SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Menu',
              style: TextStyle(
                fontSize: 30,
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
            const SizedBox(height: 22),
            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryFilters.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categoryFilters[index];

                  return FilterChip(
                    label: Text(category),
                    selected:
                        selectedCategory == category,
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
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    return FoodCard(
                      item: filteredItems[index],
                      showAddButton: true,
                      onAdd: () =>
                          addToCart(filteredItems[index]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartPage() {
    if (cartItems.isEmpty) {
      return _emptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Your cart is empty',
        message: 'Add something delicious from the menu.',
        buttonText: 'Browse Menu',
        onPressed: () {
          setState(() {
            selectedIndex = 1;
          });
        },
      );
    }

    return _pageContent(
      SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Cart',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$cartCount item${cartCount == 1 ? '' : 's'} in your cart',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 750) {
                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildCartItems(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _buildCartSummary(),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _buildCartItems(),
                    const SizedBox(height: 20),
                    _buildCartSummary(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems() {
    return Column(
      children: List.generate(
        cartItems.length,
        (index) {
          final item = cartItems[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item['icon'],
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${item['price']} each',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${item['price'] * item['quantity']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            decreaseQuantity(index),
                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                      ),
                      Text(
                        '${item['quantity']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            increaseQuantity(index),
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () =>
                        removeFromCart(index),
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _priceRow('Subtotal', '₹$cartTotal'),
            const SizedBox(height: 10),
            _priceRow('Service Fee', '₹0'),
            const Divider(height: 28),
            _priceRow(
              'Total',
              '₹$cartTotal',
              isTotal: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: placeOrder,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Text('Place Order'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersPage() {
    if (orders.isEmpty) {
      return _emptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No orders yet',
        message: 'Your placed orders will appear here.',
        buttonText: 'Order Food',
        onPressed: () {
          setState(() {
            selectedIndex = 1;
          });
        },
      );
    }

    return _pageContent(
      ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final items =
              order['items'] as List<Map<String, dynamic>>;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['id'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        avatar: const Icon(
                          Icons.access_time,
                          size: 16,
                        ),
                        label: Text(order['status']),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  ...items.map(
                    (item) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: 9),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item['name']} × ${item['quantity']}',
                          ),
                          Text(
                            '₹${item['price'] * item['quantity']}',
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  _priceRow(
                    'Total',
                    '₹${order['total']}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePage() {
    return _pageContent(
      SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 58,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              child: Icon(
                Icons.person,
                size: 68,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              studentName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              studentEmail,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: 240,
              child: FilledButton.icon(
                onPressed: editProfile,
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('My Orders'),
                    subtitle: Text(
                      '${orders.length} order${orders.length == 1 ? '' : 's'} placed',
                    ),
                    trailing:
                        const Icon(Icons.chevron_right),
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        const Icon(Icons.shopping_cart),
                    title: const Text('Cart'),
                    subtitle: Text(
                      '$cartCount item${cartCount == 1 ? '' : 's'}',
                    ),
                    trailing:
                        const Icon(Icons.chevron_right),
                    onTap: () {
                      setState(() {
                        selectedIndex = 4;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        const Icon(Icons.info_outline),
                    title:
                        const Text('About CampusCafe'),
                    trailing:
                        const Icon(Icons.chevron_right),
                    onTap: showAboutDialogBox,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'CampusCafe v1.0.0',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.restaurant_menu),
              label: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 19 : 16,
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool showAddButton;
  final VoidCallback? onAdd;

  const FoodCard({
    super.key,
    required this.item,
    this.showAddButton = false,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius:
                      BorderRadius.circular(14),
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
                color: Theme.of(context)
                    .colorScheme
                    .primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showAddButton) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onAdd,
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