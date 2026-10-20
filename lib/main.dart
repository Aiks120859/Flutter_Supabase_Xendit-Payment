import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'supabase_config.dart';

const purple = Color(0xFF8975D5);
const pale = Color(0xFFF0EBFF);
const ink = Color(0xFF302947);
final db = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    ).timeout(const Duration(seconds: 20));
    runApp(const StudentShop());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SelectableText(
              'Student Shop startup error:\n$e',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
  }
}

class StudentShop extends StatelessWidget {
  const StudentShop({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Student Shop',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFBFAFF),
      colorScheme: ColorScheme.fromSeed(seedColor: purple),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFBFAFF),
        foregroundColor: ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: const AuthGate(),
  );
}

void toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<AuthState>(
    stream: db.auth.onAuthStateChange,
    builder: (context, snapshot) =>
        db.auth.currentUser == null ? const LoginPage() : const ShopPage(),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  bool register = false, busy = false, obscure = true;

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6) {
      toast(context, 'Enter email and password (at least 6 characters).');
      return;
    }
    setState(() => busy = true);
    try {
      if (register) {
        await db.auth.signUp(
          email: email.text.trim(),
          password: password.text,
          data: {'full_name': name.text.trim()},
        );
        if (mounted)
          toast(
            context,
            'Registration submitted. Check email if confirmation is required.',
          );
      } else {
        await db.auth.signInWithPassword(
          email: email.text.trim(),
          password: password.text,
        );
      }
    } catch (_) {
      if (mounted)
        toast(
          context,
          'Login failed. Check your email, password, and Supabase settings.',
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.shopping_bag_rounded, size: 76, color: purple),
              const SizedBox(height: 12),
              const Text(
                'STUDENT SHOP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                  color: ink,
                ),
              ),
              const Text(
                'Your style, your everyday essentials.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                register ? 'Create account' : 'Welcome back',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: ink,
                ),
              ),
              const SizedBox(height: 16),
              if (register) ...[
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: busy ? null : submit,
                child: Text(
                  busy
                      ? 'Please wait...'
                      : register
                      ? 'CREATE ACCOUNT'
                      : 'LOG IN',
                ),
              ),
              TextButton(
                onPressed: () => setState(() => register = !register),
                child: Text(
                  register ? 'Already registered? Log in' : 'Create an account',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int tab = 0;
  String query = '', category = 'All';
  final search = TextEditingController();
  final cart = <String, Map<String, dynamic>>{};
  final categories = const [
    'All',
    'Men',
    'Women',
    'Babies',
    'Accessories',
    'General',
  ];
  final methods = const [
    'Cash on Delivery',
    'GCash',
    'Maya',
    'Credit/Debit Card',
  ];
  String payment = 'Cash on Delivery';
  bool busy = false;

  double get total => cart.values.fold(
    0,
    (s, p) => s + (num.tryParse('${p['price']}') ?? 0) * (p['qty'] as int),
  );

  Future<List<Map<String, dynamic>>> products() async {
    final data = await db
        .from('products')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  void add(Map<String, dynamic> p) {
    final id = '${p['id']}';
    setState(() {
      if (cart.containsKey(id)) {
        cart[id]!['qty'] = (cart[id]!['qty'] as int) + 1;
      } else {
        cart[id] = {...p, 'qty': 1};
      }
    });
    toast(context, 'Added to cart');
  }

  Future<void> checkout() async {
    if (cart.isEmpty || busy) {
      toast(context, 'Your cart is empty.');
      return;
    }
    setState(() => busy = true);
    try {
      if (payment != 'Cash on Delivery') {
        final result = await db.functions.invoke(
          'create-xendit-payment',
          body: {
            'payment_method': payment,
            'items': cart.values
                .map(
                  (p) => {
                    'product_id': '${p['id']}',
                    'name': '${p['name']}',
                    'quantity': p['qty'],
                    'price': p['price'],
                  },
                )
                .toList(),
          },
        );
        final data = result.data;
        final url = data is Map ? data['checkout_url']?.toString() : null;
        if (url == null || !url.startsWith('https://')) {
          throw Exception('Missing checkout URL');
        }
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        if (mounted)
          toast(context, 'Complete payment on the secure checkout page.');
      } else {
        await db.from('orders').insert({
          'user_id': db.auth.currentUser!.id,
          'total': total,
          'status': 'pending',
          'payment_method': payment,
          'payment_status': 'pending',
        });
        if (!mounted) return;
        setState(() {
          cart.clear();
          tab = 2;
        });
        toast(context, 'COD order recorded as pending.');
      }
    } catch (_) {
      if (mounted)
        toast(
          context,
          payment == 'Cash on Delivery'
              ? 'Order failed. Check your orders table and RLS policies.'
              : 'Xendit backend is not deployed or checkout failed.',
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Student Shop',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      actions: [
        IconButton(
          onPressed: () => setState(() => tab = 1),
          icon: Badge(
            label: Text(
              '${cart.values.fold<int>(0, (s, p) => s + (p['qty'] as int))}',
            ),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        ),
      ],
    ),
    body: IndexedStack(
      index: tab,
      children: [shopTab(), cartTab(), const OrdersTab(), profileTab()],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: tab,
      onDestinationSelected: (i) => setState(() => tab = i),
      backgroundColor: Colors.white,
      indicatorColor: pale,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          label: 'Shop',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    ),
  );

  Widget shopTab() => FutureBuilder<List<Map<String, dynamic>>>(
    future: products(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return const Center(
          child: Text(
            'Could not load products. Check Supabase settings and policies.',
          ),
        );
      }
      final list = (snapshot.data ?? []).where((p) {
        final matches =
            category == 'All' ||
            '${p['category']}'.toLowerCase() == category.toLowerCase();
        final q = query.toLowerCase();
        return matches &&
            ('${p['name']}'.toLowerCase().contains(q) ||
                '${p['description'] ?? ''}'.toLowerCase().contains(q));
      }).toList();
      return RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: pale,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DISCOVER YOUR STYLE',
                    style: TextStyle(
                      color: purple,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fresh picks for you.',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: ink,
                    ),
                  ),
                  Text('Everyday essentials, all in one place.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: search,
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: category == c,
                          selectedColor: pale,
                          onSelected: (_) => setState(() => category = c),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No products found. Add products to your Supabase products table.',
                  textAlign: TextAlign.center,
                ),
              ),
            ...list.map(productCard),
          ],
        ),
      );
    },
  );

  void openDetails(Map<String, dynamic> p) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsPage(
          product: p,
          onAddToCart: () {
            add(p);
            Navigator.pop(context);
          },
          onBuyNow: () {
            final id = '${p['id']}';
            setState(() {
              cart
                ..clear()
                ..[id] = {...p, 'qty': 1};
              tab = 1;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget productCard(Map<String, dynamic> p) {
    final price = num.tryParse('${p['price']}') ?? 0;
    final url = '${p['image_url'] ?? ''}';

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFEAE4F8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openDetails(p),
        child: Row(
          children: [
            Container(
              width: 115,
              height: 145,
              color: pale,
              child: url.startsWith('http')
                  ? Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.checkroom, size: 42, color: purple),
                    )
                  : const Icon(Icons.checkroom, size: 42, color: purple),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${p['category'] ?? 'General'}'.toUpperCase(),
                      style: const TextStyle(
                        color: purple,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${p['name'] ?? 'Product'}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '₱${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => add(p),
                        child: const Text('ADD TO CART'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => openDetails(p),
                        child: const Text('VIEW DETAILS'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text(
        'Your Cart',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink),
      ),
      const SizedBox(height: 12),
      if (cart.isEmpty)
        const Padding(
          padding: EdgeInsets.all(28),
          child: Text('Your cart is empty.', textAlign: TextAlign.center),
        ),
      ...cart.entries.map((e) {
        final p = e.value;
        final price = num.tryParse('${p['price']}') ?? 0;
        return Card(
          color: Colors.white,
          elevation: 0,
          child: ListTile(
            title: Text(
              '${p['name']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('₱${price.toStringAsFixed(2)} × ${p['qty']}'),
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    if ((p['qty'] as int) > 1) {
                      p['qty'] = (p['qty'] as int) - 1;
                    } else {
                      cart.remove(e.key);
                    }
                  }),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                IconButton(
                  onPressed: () =>
                      setState(() => p['qty'] = (p['qty'] as int) + 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
        );
      }),
      const SizedBox(height: 12),
      Text(
        'Total: ₱${total.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w900,
          color: ink,
        ),
      ),
      const SizedBox(height: 18),
      const Text(
        'Choose payment method',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      ...methods.map(
        (m) => RadioListTile<String>(
          value: m,
          groupValue: payment,
          activeColor: purple,
          title: Text(m),
          onChanged: (v) => setState(() => payment = v!),
        ),
      ),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: cart.isEmpty || busy ? null : checkout,
        child: Text(
          busy
              ? 'PLEASE WAIT...'
              : payment == 'Cash on Delivery'
              ? 'PLACE ORDER (COD)'
              : 'CONTINUE TO XENDIT',
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'GCash, Maya, and card checkout need a deployed secure Xendit backend.',
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    ],
  );

  Widget profileTab() => ListView(
    padding: const EdgeInsets.all(22),
    children: [
      const CircleAvatar(
        radius: 42,
        backgroundColor: pale,
        child: Icon(Icons.person, color: purple, size: 48),
      ),
      const SizedBox(height: 16),
      const Text(
        'My Profile',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ink),
      ),
      const SizedBox(height: 8),
      Text(db.auth.currentUser?.email ?? '', textAlign: TextAlign.center),
      const SizedBox(height: 22),
      Card(
        color: Colors.white,
        elevation: 0,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: pale,
            child: Icon(Icons.support_agent, color: purple),
          ),
          title: const Text(
            'Customer Support',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Chat with us on Messenger'),
          trailing: const Icon(Icons.open_in_new, color: purple),
          onTap: () async {
            final uri = Uri.parse('https://m.me/Tppa23');
            try {
              final opened = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              if (!opened && context.mounted) {
                toast(context, 'Could not open Messenger. Please try again.');
              }
            } catch (e) {
              if (context.mounted) {
                toast(context, 'Could not open Messenger: $e');
              }
            }
          },
        ),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => db.auth.signOut(),
        icon: const Icon(Icons.logout),
        label: const Text('LOG OUT'),
      ),
    ],
  );
}

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final price = num.tryParse('${p['price']}') ?? 0;
    final stock = int.tryParse('${p['stock'] ?? 0}') ?? 0;
    final imageUrl = '${p['image_url'] ?? ''}';

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 300,
              color: pale,
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.checkroom, size: 90, color: purple),
                    )
                  : const Icon(Icons.checkroom, size: 90, color: purple),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${p['category'] ?? 'General'}'.toUpperCase(),
            style: const TextStyle(
              color: purple,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${p['name'] ?? 'Product'}',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '₱${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: purple,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${p['description'] ?? 'No description available.'}',
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 14),
          Text(
            stock > 0 ? 'Stock available: $stock' : 'Currently out of stock',
            style: TextStyle(
              color: stock > 0 ? Colors.green.shade700 : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                onPressed: quantity > 1
                    ? () => setState(() => quantity--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: quantity < stock
                    ? () => setState(() => quantity++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Text(
            'Subtotal: ₱${(price * quantity).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ink,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: stock > 0 ? widget.onAddToCart : null,
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('ADD TO CART'),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: stock > 0 ? widget.onBuyNow : null,
            child: const Text('BUY NOW'),
          ),
        ],
      ),
    );
  }
}

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});
  Future<List<Map<String, dynamic>>> load() async {
    final user = db.auth.currentUser;
    if (user == null) return [];
    final rows = await db
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(
    BuildContext context,
  ) => FutureBuilder<List<Map<String, dynamic>>>(
    future: load(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return const Center(
          child: Text('Could not load orders. Check table and policies.'),
        );
      }
      final rows = snapshot.data ?? [];
      if (rows.isEmpty)
        return const Center(child: Text('You have no orders yet.'));
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'My Orders',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: ink,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (o) => Card(
              color: Colors.white,
              elevation: 0,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: pale,
                  child: Icon(Icons.receipt_long, color: purple),
                ),
                title: Text('Order ${'${o['id']}'.substring(0, 8)}'),
                subtitle: Text(
                  '${o['payment_method']} • ${o['status']} • ${o['payment_status']}',
                ),
                trailing: Text(
                  '₱${(num.tryParse('${o['total']}') ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
