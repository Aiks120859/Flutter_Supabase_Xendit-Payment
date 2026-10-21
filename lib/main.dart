import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const supabaseUrl = 'https://apjyfgqgosjmjioatper.supabase.co';
const supabaseKey = 'sb_publishable_haukXK78_eKzm44xI9rqPw_rUsouyNn';

class Product {
  final String name, desc, specs;
  final int price;
  final IconData icon;
  Product(this.name, this.price, this.desc, this.specs, this.icon);
}

final products = [
  Product('Air Conditioner 1.0HP', 18990, 'Inverter split-type aircon', 'Cooling: 9000 BTU | Warranty: 2 years', Icons.ac_unit),
  Product('Electric Fan 16in', 1250, 'Stand fan, 3 speeds', 'Power: 55W | Warranty: 1 year', Icons.air),
  Product('Rice Cooker 1.8L', 1890, 'Non-stick pot, keep-warm', 'Power: 700W | Warranty: 1 year', Icons.rice_bowl),
  Product('Refrigerator 2-Door', 15990, 'No-frost, 7 cu.ft', 'Power: 120W | Warranty: 3 years', Icons.kitchen),
  Product('Washing Machine 7kg', 11490, 'Top-load twin tub', 'Power: 400W | Warranty: 2 years', Icons.local_laundry_service),
  Product('Microwave Oven 20L', 4290, 'Digital control', 'Power: 800W | Warranty: 1 year', Icons.microwave),
];
final cart = <Product>[];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  } catch (_) {}
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Shop()));
}

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appliances Shop'), actions: [
        IconButton(
          icon: Badge(label: Text('${cart.length}'), child: const Icon(Icons.shopping_cart)),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
            setState(() {});
          },
        ),
      ]),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return Card(
            child: ListTile(
              leading: Icon(p.icon, size: 40),
              title: Text(p.name),
              subtitle: Text('PHP ${p.price}'),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => Details(p)));
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}

class Details extends StatelessWidget {
  final Product p;
  const Details(this.p, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Icon(p.icon, size: 120)),
          Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('PHP ${p.price}', style: const TextStyle(fontSize: 20, color: Colors.green)),
          const SizedBox(height: 8),
          Text(p.desc),
          Text(p.specs),
          const Spacer(),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  cart.add(p);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                },
                child: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Payment([p]))),
                child: const Text('Buy Now'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartState();
}

class _CartState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final total = cart.fold<int>(0, (s, p) => s + p.price);
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(cart[i].name),
                subtitle: Text('PHP ${cart[i].price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => cart.removeAt(i)),
                ),
              ),
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Payment(List.of(cart)))),
                child: Text('Checkout PHP $total'),
              ),
            ),
    );
  }
}

class Payment extends StatefulWidget {
  final List<Product> items;
  const Payment(this.items, {super.key});
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool loading = false;

  Future<void> pay(int total) async {
    setState(() => loading = true);
    try {
      final res = await Supabase.instance.client.functions
          .invoke('create-invoice', body: {'amount': total, 'description': 'Appliances order'});
      final url = (res.data as Map)['invoice_url'] as String;
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment error: $e')));
      }
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.items.fold<int>(0, (s, p) => s + p.price);
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          for (final p in widget.items) Text('${p.name} - PHP ${p.price}'),
          const Divider(height: 32),
          Text('Total: PHP $total', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : () => pay(total),
              child: Text(loading ? 'Please wait...' : 'Pay with Xendit'),
            ),
          ),
        ]),
      ),
    );
  }
}
