import 'package:flutter/material.dart';

void main() => runApp(const ShopSmartApp());

const Color kOrange = Color(0xFFEE4D2D);
const double kMaxPrice = 5000000;
const List<String> kCategories = [
  'Semua',
  'Elektronik',
  'Fashion',
  'Olahraga',
  'Rumah Tangga',
];

// ================= MODEL =================

class Product {
  final int id;
  final String name;
  final int price;
  final String category;
  final int sold;
  final double rating;
  final IconData icon;
  final Color color;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.sold,
    required this.rating,
    required this.icon,
    required this.color,
    required this.description,
  });
}

const List<Product> kProducts = [
  Product(
    id: 1,
    name: 'Headphone Bluetooth Wireless',
    price: 350000,
    category: 'Elektronik',
    sold: 1200,
    rating: 4.8,
    icon: Icons.headphones,
    color: Colors.blue,
    description:
        'Headphone bluetooth dengan noise cancelling dan baterai tahan hingga 30 jam.',
  ),
  Product(
    id: 2,
    name: 'Smartwatch Sport Waterproof',
    price: 890000,
    category: 'Elektronik',
    sold: 540,
    rating: 4.6,
    icon: Icons.watch,
    color: Colors.teal,
    description:
        'Smartwatch dengan monitor detak jantung, GPS, dan tahan air IP68.',
  ),
  Product(
    id: 3,
    name: 'Kaos Polos Katun Premium',
    price: 75000,
    category: 'Fashion',
    sold: 3400,
    rating: 4.7,
    icon: Icons.checkroom,
    color: Colors.purple,
    description: 'Kaos polos 30s combed cotton, adem dan nyaman dipakai harian.',
  ),
  Product(
    id: 4,
    name: 'Sepatu Lari Ringan',
    price: 499000,
    category: 'Olahraga',
    sold: 870,
    rating: 4.5,
    icon: Icons.directions_run,
    color: Colors.green,
    description: 'Sepatu lari ringan dengan sol empuk dan grip kuat.',
  ),
  Product(
    id: 5,
    name: 'Laptop Ringan 14 Inch',
    price: 4850000,
    category: 'Elektronik',
    sold: 120,
    rating: 4.4,
    icon: Icons.laptop,
    color: Colors.indigo,
    description: 'Laptop 14 inch, RAM 8GB, SSD 512GB, cocok untuk kuliah.',
  ),
  Product(
    id: 6,
    name: 'Matras Yoga Anti Slip',
    price: 185000,
    category: 'Olahraga',
    sold: 260,
    rating: 4.9,
    icon: Icons.self_improvement,
    color: Colors.pink,
    description: 'Matras yoga tebal 6mm dengan permukaan anti slip.',
  ),
  Product(
    id: 7,
    name: 'Blender Portable USB',
    price: 215000,
    category: 'Rumah Tangga',
    sold: 410,
    rating: 4.3,
    icon: Icons.kitchen,
    color: Colors.brown,
    description: 'Blender portable isi ulang USB, praktis dibawa ke mana saja.',
  ),
  Product(
    id: 8,
    name: 'Lampu Meja LED Dimmer',
    price: 95000,
    category: 'Rumah Tangga',
    sold: 980,
    rating: 4.6,
    icon: Icons.lightbulb,
    color: Colors.amber,
    description: 'Lampu meja LED dengan 3 mode warna dan tingkat kecerahan.',
  ),
];

String formatRupiah(int n) =>
    n.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]}.',
        );

// ================= APP =================

class ShopSmartApp extends StatelessWidget {
  const ShopSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kOrange),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}

// ================= HOME =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();

  int _selectedIndex = 0;
  String _query = '';
  RangeValues _priceRange = const RangeValues(0, kMaxPrice);
  String _category = 'Semua';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    return kProducts.where((p) {
      final matchQuery =
          p.name.toLowerCase().contains(_query.toLowerCase());
      final matchPrice =
          p.price >= _priceRange.start && p.price <= _priceRange.end;
      final matchCategory = _category == 'Semua' || p.category == _category;
      return matchQuery && matchPrice && matchCategory;
    }).toList();
  }

  void _applyFilter(RangeValues range, String category) {
    setState(() {
      _priceRange = range;
      _category = category;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kOrange,
      foregroundColor: Colors.white,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Cari produk di ShopSmart',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune),
          tooltip: 'Filter',
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildBeranda();
      case 1:
        return _buildLive();
      case 2:
        return _buildNotifikasi();
      default:
        return const SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: ProfileCard()),
        );
    }
  }

  Widget _buildBeranda() {
    final items = _filteredProducts;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text(
                '${items.length} produk ditemukan',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const Spacer(),
              if (_category != 'Semua') Chip(label: Text(_category)),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('Produk tidak ditemukan'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) =>
                      ProductCard(product: items[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildLive() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.live_tv, size: 72, color: kOrange),
          SizedBox(height: 12),
          Text('Live Shopping', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Segera hadir', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNotifikasi() {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: kOrange,
            child: Icon(Icons.local_shipping, color: Colors.white),
          ),
          title: Text('Pesanan dikirim'),
          subtitle: Text('Pesananmu sedang dalam perjalanan'),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: kOrange,
            child: Icon(Icons.local_offer, color: Colors.white),
          ),
          title: Text('Promo gratis ongkir'),
          subtitle: Text('Berlaku hingga akhir bulan ini'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      endDrawer: FilterDrawer(
        initialRange: _priceRange,
        initialCategory: _category,
        onApply: _applyFilter,
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.live_tv_outlined),
            selectedIcon: Icon(Icons.live_tv),
            label: 'Live',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil Saya',
          ),
        ],
      ),
    );
  }
}

// ================= END DRAWER (FILTER) =================

class FilterDrawer extends StatefulWidget {
  final RangeValues initialRange;
  final String initialCategory;
  final void Function(RangeValues, String) onApply;

  const FilterDrawer({
    super.key,
    required this.initialRange,
    required this.initialCategory,
    required this.onApply,
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late RangeValues _range;
  late String _category;

  @override
  void initState() {
    super.initState();
    _range = widget.initialRange;
    _category = widget.initialCategory;
  }

  String _rp(double v) => 'Rp ${formatRupiah(v.round())}';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Produk',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32),
              const Text('Rentang Harga',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('${_rp(_range.start)} - ${_rp(_range.end)}'),
              RangeSlider(
                values: _range,
                min: 0,
                max: kMaxPrice,
                divisions: 50,
                activeColor: kOrange,
                onChanged: (v) => setState(() => _range = v),
              ),
              const SizedBox(height: 16),
              const Text('Kategori',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kCategories
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        selectedColor: kOrange.withOpacity(0.2),
                        onSelected: (_) => setState(() => _category = c),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _range = const RangeValues(0, kMaxPrice);
                        _category = 'Semua';
                      }),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        widget.onApply(_range, _category);
                        Navigator.pop(context);
                      },
                      child: const Text('Terapkan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= PRODUCT CARD =================

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: double.infinity,
              color: product.color.withOpacity(0.15),
              child: Icon(product.icon, size: 56, color: product.color),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${formatRupiah(product.price)}',
                    style: const TextStyle(
                      color: kOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '★ ${product.rating} | Terjual ${product.sold}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DETAIL PRODUK (STACK) =================

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: kOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              color: product.color.withOpacity(0.15),
              child: Icon(product.icon, size: 120, color: product.color),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp ${formatRupiah(product.price)}',
                    style: const TextStyle(
                      color: kOrange,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '★ ${product.rating} | Terjual ${product.sold} | ${product.category}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(product.description),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Tambah ke Keranjang'),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} ditambahkan ke keranjang'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PROFILE CARD (IDENTITAS PEMBUAT) =================

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: kOrange, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/profile.jpg',
                width: 104,
                height: 104,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  width: 104,
                  height: 104,
                  color: kOrange,
                  child: const Icon(Icons.person, size: 56, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'M. Lintang Sedayu Arif',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Pembuat Tugas',
              style: TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            _infoRow(Icons.badge, 'NPM', '5520124015'),
            _infoRow(Icons.school, 'Jurusan', 'Teknik Informatika'),
            _infoRow(Icons.group, 'Kelas', 'IF-A'),
          ],
        ),
      ),
    );
  }
}
