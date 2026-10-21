import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const orange = Color(0xFF168C83);
const bg = Color(0xFFF5F7F7);
const card = Color(0xFFFFFFFF);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://apjyfgqgosjmjioatper.supabase.co',
    anonKey: 'sb_publishable_haukXK78_eKzm44xI9rqPw_rUsouyNn',
  );

  runApp(const AppliancesApp());
}

class Product {
  final String name, category, brand, description, imageUrl;
  final double price;
  final int stock;
  final IconData icon;
  final List<String> specs;

  const Product({
    required this.name,
    required this.category,
    required this.brand,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.stock,
    required this.icon,
    required this.specs,
  });
}

const products = [
  Product(
    name: 'Smart Refrigerator',
    category: 'Kitchen',
    brand: 'HomeTech',
    price: 18999,
    stock: 12,
    icon: Icons.kitchen,
    description:
        'Modern refrigerator designed for everyday family use, '
        'with spacious storage and an energy-saving design.',
    specs: [
      'Capacity: 10 cu. ft.',
      'Type: Double Door',
      'Energy: Energy-saving',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Front Load Washer',
    category: 'Laundry',
    brand: 'WashPro',
    price: 14999,
    stock: 8,
    icon: Icons.local_laundry_service,
    description:
        'A convenient washing machine for everyday laundry '
        'with multiple wash programs.',
    specs: [
      'Capacity: 8 kg',
      'Type: Front Load',
      'Programs: Multiple Wash Modes',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Smart LED Television',
    category: 'Entertainment',
    brand: 'VisionMax',
    price: 12999,
    stock: 15,
    icon: Icons.tv,
    description:
        'Enjoy movies and shows on a modern LED television '
        'with smart entertainment features.',
    specs: [
      'Screen: 43 inches',
      'Resolution: Full HD',
      'Connectivity: HDMI / USB',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Split Type Air Conditioner',
    category: 'Cooling',
    brand: 'CoolBreeze',
    price: 21999,
    stock: 6,
    icon: Icons.ac_unit,
    description:
        'Keep your room comfortable with a modern split-type '
        'air conditioner.',
    specs: [
      'Type: Split Type',
      'Cooling: 1 HP class',
      'Control: Remote',
      'Warranty: Check product warranty',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1631545806609-6e3e3e7c2a1b?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Digital Microwave Oven',
    category: 'Kitchen',
    brand: 'HeatWave',
    price: 3499,
    stock: 20,
    icon: Icons.microwave,
    description:
        'Heat meals quickly and conveniently with digital '
        'controls and preset cooking functions.',
    specs: [
      'Capacity: 20 L',
      'Power: 700 W class',
      'Control: Digital',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Electric Stand Fan',
    category: 'Cooling',
    brand: 'AirFlow',
    price: 1599,
    stock: 25,
    icon: Icons.air,
    description:
        'A practical stand fan with adjustable airflow '
        'for everyday home comfort.',
    specs: [
      'Type: Stand Fan',
      'Speed: Multiple Settings',
      'Height: Adjustable',
      'Warranty: Check product warranty',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1581270260425-7f4b5a3c6b3a?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Rice Cooker',
    category: 'Kitchen',
    brand: 'KitchenPro',
    price: 1299,
    stock: 30,
    icon: Icons.soup_kitchen,
    description: 'A simple rice cooker for preparing rice at home.',
    specs: [
      'Capacity: 1.8 L class',
      'Function: Cook / Keep Warm',
      'Inner Pot: Non-stick type',
      'Warranty: Check product warranty',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1585515320310-259814833e62?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Water Dispenser',
    category: 'Kitchen',
    brand: 'AquaHome',
    price: 2799,
    stock: 10,
    icon: Icons.water_drop,
    description: 'A convenient water dispenser for home or office use.',
    specs: [
      'Type: Floor Standing',
      'Function: Hot / Cold',
      'Use: Home and Office',
      'Warranty: Check product warranty',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Digital Air Fryer',
    category: 'Kitchen',
    brand: 'CrispHome',
    price: 2499,
    stock: 14,
    icon: Icons.kitchen,
    description: 'A digital air fryer for convenient everyday cooking.',
    specs: [
      'Type: Digital Air Fryer',
      'Control: Digital',
      'Use: Home cooking',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Cordless Vacuum Cleaner',
    category: 'Cleaning',
    brand: 'DustAway',
    price: 2999,
    stock: 11,
    icon: Icons.cleaning_services,
    description: 'A convenient vacuum cleaner for routine home cleaning.',
    specs: [
      'Type: Cordless style',
      'Use: Indoor cleaning',
      'Design: Portable',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Countertop Blender',
    category: 'Kitchen',
    brand: 'BlendMate',
    price: 1799,
    stock: 18,
    icon: Icons.blender,
    description: 'A countertop blender for smoothies and food preparation.',
    specs: [
      'Type: Countertop',
      'Use: Blending',
      'Container: Included',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Electric Kettle',
    category: 'Kitchen',
    brand: 'BoilQuick',
    price: 899,
    stock: 24,
    icon: Icons.kitchen,
    description: 'An electric kettle for quickly boiling water.',
    specs: [
      'Type: Electric kettle',
      'Function: Boil water',
      'Use: Kitchen',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Espresso Coffee Machine',
    category: 'Kitchen',
    brand: 'BrewCraft',
    price: 4599,
    stock: 7,
    icon: Icons.coffee,
    description: 'A home coffee machine for preparing espresso-style drinks.',
    specs: [
      'Type: Coffee machine',
      'Use: Home brewing',
      'Design: Countertop',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Electric Clothes Iron',
    category: 'Laundry',
    brand: 'SmoothPress',
    price: 799,
    stock: 16,
    icon: Icons.iron,
    description: 'An electric iron for everyday clothing care.',
    specs: [
      'Type: Electric iron',
      'Use: Clothes pressing',
      'Control: Temperature settings',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1489274495757-95c7c837b101?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Electric Toaster',
    category: 'Kitchen',
    brand: 'ToastPlus',
    price: 1199,
    stock: 13,
    icon: Icons.breakfast_dining,
    description: 'A compact toaster for quick breakfast preparation.',
    specs: [
      'Type: Electric toaster',
      'Use: Toasting bread',
      'Design: Countertop',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1585238342024-78d387f4a707?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Electric Pressure Cooker',
    category: 'Kitchen',
    brand: 'QuickPot',
    price: 2899,
    stock: 9,
    icon: Icons.soup_kitchen,
    description: 'A multi-purpose electric cooker for everyday meals.',
    specs: [
      'Type: Electric pressure cooker',
      'Use: Meal preparation',
      'Controls: Preset modes',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1585515320310-259814833e62?w=700&h=700&fit=crop&auto=compress',
  ),
  Product(
    name: 'Portable Room Heater',
    category: 'Cooling',
    brand: 'WarmNest',
    price: 1899,
    stock: 8,
    icon: Icons.electric_bolt,
    description: 'A portable electric heater for suitable indoor spaces.',
    specs: [
      'Type: Portable heater',
      'Use: Indoor heating',
      'Controls: Adjustable',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1614631446501-abcf76949eca?w=700&h=700&fit=crop',
  ),
  Product(
    name: 'Portable Dehumidifier',
    category: 'Home Comfort',
    brand: 'DryAir',
    price: 3299,
    stock: 6,
    icon: Icons.air,
    description: 'A compact appliance designed to help reduce indoor humidity.',
    specs: [
      'Type: Portable dehumidifier',
      'Use: Indoor spaces',
      'Design: Compact',
      'Warranty: 1 year',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1631545806609-6e3e3e7c2a1b?w=700&h=700&fit=crop&auto=compress',
  ),
];

Widget _paymentOption({
  required BuildContext context,
  required String label,
  required String value,
  required Color color,
  String? logo,
  IconData? icon,
  String? subtitle,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: color.withValues(alpha: 0.18)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.pop(context, value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 82,
              height: 42,
              child: logo != null
                  ? Image.network(
                      logo,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.account_balance_wallet_outlined,
                        color: color,
                        size: 34,
                      ),
                    )
                  : Icon(icon, color: color, size: 34),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.radio_button_unchecked, color: color, size: 24),
          ],
        ),
      ),
    ),
  );
}

class AppliancesApp extends StatelessWidget {
  const AppliancesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ApplianceHub',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: orange,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF203333),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) return const StoreScreen();
        return const AuthScreen();
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isRegister = false;
  bool loading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty ||
        password.length < 6 ||
        (isRegister && nameController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter the required details. Password must be at least 6 characters.',
          ),
        ),
      );
      return;
    }

    setState(() => loading = true);
    try {
      final auth = Supabase.instance.client.auth;
      if (isRegister) {
        final result = await auth.signUp(
          email: email,
          password: password,
          data: {'full_name': nameController.text.trim()},
        );
        if (!mounted) return;
        if (result.session == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Account created. Check your email to confirm, then log in.',
              ),
            ),
          );
          setState(() => isRegister = false);
        }
      } else {
        await auth.signInWithPassword(email: email, password: password);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e, stackTrace) {
      debugPrint('REGISTER/LOGIN ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF168C83);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDDF5EF), Color(0xFFEAF1FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.home_work_rounded,
                            size: 42,
                            color: teal,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'ApplianceHub',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF183C3A),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Smart appliances for better living',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF526A68)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    isRegister ? 'Create your account' : 'Welcome back',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF203333),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isRegister
                        ? 'Join us and discover your home essentials.'
                        : 'Sign in to continue shopping.',
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 22),
                  if (isRegister) ...[
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password (at least 6 characters)',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => obscurePassword = !obscurePassword),
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      onPressed: loading ? null : submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isRegister ? 'CREATE ACCOUNT' : 'SIGN IN',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => setState(() => isRegister = !isRegister),
                    child: Text(
                      isRegister
                          ? 'Already have an account? Sign in'
                          : "Don't have an account? Register",
                      style: const TextStyle(
                        color: teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String category = 'All';
  String query = '';
  int tab = 0;
  final Map<Product, int> cartItems = {};

  final categories = const [
    'All',
    'Kitchen',
    'Laundry',
    'Entertainment',
    'Cooling',
  ];

  void add(Product product) {
    if ((cartItems[product] ?? 0) >= product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum available stock reached')),
      );
      return;
    }
    setState(() {
      cartItems[product] = (cartItems[product] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) {
      final matchesCategory = category == 'All' || p.category == category;
      final matchesQuery = '${p.name} ${p.brand} ${p.category}'
          .toLowerCase()
          .contains(query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ApplianceHub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => tab = 1),
            icon: Badge(
              isLabelVisible: cartItems.isNotEmpty,
              label: Text('${cartItems.values.fold<int>(0, (a, b) => a + b)}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: tab == 0
          ? _home(filtered)
          : tab == 1
          ? _cart()
          : _profile(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: card,
        selectedIndex: tab,
        indicatorColor: orange.withValues(alpha: 0.2),
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: orange),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: orange),
            label: 'My Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: orange),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _profile() {
    final user = Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata;
    final name = metadata?['full_name']?.toString() ?? 'Customer';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),
        CircleAvatar(
          radius: 42,
          backgroundColor: orange.withValues(alpha: 0.15),
          child: const Icon(Icons.person, size: 48, color: orange),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            name,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Center(child: Text(user?.email ?? 'No email available')),
        const SizedBox(height: 28),
        Card(
          color: card,
          child: ListTile(
            leading: const Icon(Icons.support_agent, color: orange),
            title: const Text('Customer Service'),
            subtitle: const Text('Send a question or report a problem'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomerServiceScreen()),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: card,
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Sign Out'),
            subtitle: const Text('Log out of your account'),
            onTap: () async {
              try {
                await Supabase.instance.client.auth.signOut();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign out failed: $e')),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _home(List<Product> filtered) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF472600), Color(0xFF242424)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UPGRADE YOUR HOME',
                style: TextStyle(color: orange, letterSpacing: 2),
              ),
              SizedBox(height: 10),
              Text(
                'Appliances for\neveryday living.',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Explore appliances for your home.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search appliances, brands...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Categories',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final c = categories[index];
              return ChoiceChip(
                label: Text(c),
                selected: category == c,
                selectedColor: orange,
                onSelected: (_) => setState(() => category = c),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Popular Appliances (${filtered.length})',
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No appliances found.')),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 260,
          ),
          itemBuilder: (context, index) {
            final p = filtered[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetails(product: p, onAdd: () => add(p)),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.network(
                          p.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              Icon(p.icon, size: 68, color: orange),
                        ),
                      ),
                    ),
                    Text(
                      p.brand,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '₱${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Stock: ${p.stock}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _cart() {
    final entries = cartItems.entries.toList();
    final total = entries.fold<double>(
      0,
      (sum, e) => sum + e.key.price * e.value,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'My Shopping Cart',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: Text('Your cart is empty.')),
          ),
        ...entries.map(
          (e) => Card(
            color: card,
            child: ListTile(
              leading: Icon(e.key.icon, color: orange, size: 34),
              title: Text(e.key.name),
              subtitle: Text('₱${e.key.price.toStringAsFixed(2)} × ${e.value}'),
              trailing: Wrap(
                spacing: 0,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      if (e.value <= 1) {
                        cartItems.remove(e.key);
                      } else {
                        cartItems[e.key] = e.value - 1;
                      }
                    }),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  IconButton(
                    onPressed: () => add(e.key),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Total: ₱${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: orange,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: orange,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: entries.isEmpty
              ? null
              : () async {
                  final method = await showDialog<String>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text(
                        'Select Payment Method',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: SizedBox(
                        width: 420,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _paymentOption(
                                context: dialogContext,
                                label: 'Cash on Delivery (COD)',
                                value: 'COD',
                                icon: Icons.local_shipping_outlined,
                                color: const Color(0xFF168C83),
                              ),
                              _paymentOption(
                                context: dialogContext,
                                label: 'GCash',
                                value: 'GCASH',
                                logo: 'https://logo.clearbit.com/gcash.com',
                                color: const Color(0xFF007DFE),
                              ),
                              _paymentOption(
                                context: dialogContext,
                                label: 'Maya',
                                value: 'MAYA',
                                logo: 'https://logo.clearbit.com/maya.ph',
                                color: const Color(0xFF00A86B),
                              ),
                              _paymentOption(
                                context: dialogContext,
                                label: 'Credit / Debit Card',
                                value: 'CARD',
                                icon: Icons.credit_card,
                                color: const Color(0xFF183A75),
                                subtitle: 'Visa • Mastercard',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                  if (!mounted || method == null) return;

                  if (method == 'COD') {
                    try {
                      final user = Supabase.instance.client.auth.currentUser;
                      if (user == null) {
                        throw Exception('Please sign in first.');
                      }

                      await Supabase.instance.client.from('orders').insert({
                        'user_id': user.id,
                        'total': total,
                        'status': 'pending',
                        'payment_method': 'COD',
                        'payment_status': 'pending',
                      });

                      if (!mounted) return;
                      setState(() {
                        cartItems.clear();
                        tab = 0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('COD order saved! Status: pending.'),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not save COD order: $e')),
                      );
                    }
                    return;
                  }

                  try {
                    final response = await Supabase.instance.client.functions
                        .invoke(
                          'create-payment',
                          body: {
                            'amount': total,
                            'order_id':
                                'order_${DateTime.now().millisecondsSinceEpoch}',
                            'method': method,
                          },
                        );

                    final data = response.data;
                    if (data is! Map ||
                        data['invoice_url'] is! String ||
                        (data['invoice_url'] as String).isEmpty) {
                      final message = data is Map
                          ? data['error']?.toString() ??
                                'No checkout URL returned.'
                          : 'Invalid payment response.';
                      throw Exception(message);
                    }

                    final uri = Uri.tryParse(data['invoice_url'] as String);
                    if (uri == null ||
                        (uri.scheme != 'https' && uri.scheme != 'http')) {
                      throw Exception('Invalid checkout URL.');
                    }

                    final opened = await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                    if (!opened) {
                      throw Exception('Unable to open checkout page.');
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Payment error: $e'),
                        duration: const Duration(seconds: 6),
                      ),
                    );
                  }
                },
          child: const Text('PROCEED TO CHECKOUT'),
        ),
      ],
    );
  }
}

class CustomerServiceScreen extends StatefulWidget {
  const CustomerServiceScreen({super.key});

  @override
  State<CustomerServiceScreen> createState() => _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends State<CustomerServiceScreen> {
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  bool sending = false;

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please log in first.')));
      return;
    }

    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a subject and message.')),
      );
      return;
    }

    setState(() => sending = true);
    try {
      await Supabase.instance.client.from('support_messages').insert({
        'user_id': user.id,
        'email': user.email,
        'subject': subject,
        'message': message,
      });

      if (!mounted) return;
      subjectController.clear();
      messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your message was sent to customer service.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not send. Check the support_messages table in Supabase. Details: $e',
          ),
          duration: const Duration(seconds: 7),
        ),
      );
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Service')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.support_agent, size: 64, color: orange),
          const SizedBox(height: 12),
          const Text(
            'How can we help?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Send your question or concern to our support team.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: subjectController,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: messageController,
            minLines: 4,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: 'Your message',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: sending ? null : sendMessage,
            icon: const Icon(Icons.send),
            label: Text(sending ? 'SENDING...' : 'SEND MESSAGE'),
            style: FilledButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductDetails({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(product.icon, size: 120, color: orange),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product.brand.toUpperCase(),
            style: const TextStyle(color: orange, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '₱${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 25,
              color: orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text('Available stock: ${product.stock}'),
          const SizedBox(height: 22),
          const Text(
            'Product Description',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(color: Colors.white70, height: 1.6),
          ),
          const SizedBox(height: 22),
          const Text(
            'Specifications',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...product.specs.map(
            (spec) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: orange, size: 19),
                  const SizedBox(width: 10),
                  Expanded(child: Text(spec)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: product.stock > 0 ? onAdd : null,
            icon: const Icon(Icons.shopping_cart),
            label: const Text('ADD TO CART'),
          ),
        ],
      ),
    );
  }
}
