import 'package:flutter/material.dart';
import '../models/product_item.dart';
import '../services/crud_database_service.dart';

class Lab93CrudScreen extends StatefulWidget {
  const Lab93CrudScreen({super.key});

  @override
  State<Lab93CrudScreen> createState() => _Lab93CrudScreenState();
}

class _Lab93CrudScreenState extends State<Lab93CrudScreen> {
  final CrudDatabaseService _crudService = CrudDatabaseService();
  List<ProductItem> _items = [];
  List<ProductItem> _filteredItems = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _filePath = '';

  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Laptop',
    'Smartphone',
    'Audio',
    'Monitor',
    'Accessories',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDatabase() async {
    setState(() => _isLoading = true);
    final path = await _crudService.getFilePath();
    final data = await _crudService.readAll();

    setState(() {
      _filePath = path;
      _items = data;
      _isLoading = false;
      _applyFilter();
    });
  }

  void _applyFilter() {
    final query = _searchQuery.toLowerCase().trim();
    setState(() {
      _filteredItems = _items.where((item) {
        final matchesQuery = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query) ||
            item.id.toString().contains(query);

        final matchesCategory =
            _selectedCategory == 'All' || item.category == _selectedCategory;

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _showAddEditDialog({ProductItem? itemToEdit}) {
    final isEditing = itemToEdit != null;
    final titleController = TextEditingController(text: itemToEdit?.title ?? '');
    final priceController =
        TextEditingController(text: itemToEdit != null ? itemToEdit.price.toString() : '');
    final quantityController =
        TextEditingController(text: itemToEdit != null ? itemToEdit.quantity.toString() : '1');

    String selectedCat = itemToEdit?.category ?? 'General';
    String selectedStatus = itemToEdit?.status ?? 'In Stock';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'Edit Item #${itemToEdit.id}' : 'Add New Item (Mini-DB)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Product Title *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _categories.contains(selectedCat) ? selectedCat : 'General',
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: _categories
                              .where((c) => c != 'All')
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => selectedCat = val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'In Stock', child: Text('In Stock')),
                            DropdownMenuItem(value: 'Low Stock', child: Text('Low Stock')),
                            DropdownMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => selectedStatus = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Price (\$) *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: Icon(isEditing ? Icons.check : Icons.save),
                      label: Text(
                        isEditing ? 'Save Changes' : 'Create & Auto-Save',
                        style: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final price = double.tryParse(priceController.text.trim());
                        final quantity = int.tryParse(quantityController.text.trim());

                        if (title.isEmpty || price == null || quantity == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter valid title, price, and quantity.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        Navigator.pop(ctx);

                        if (isEditing) {
                          final updated = itemToEdit.copyWith(
                            title: title,
                            category: selectedCat,
                            price: price,
                            quantity: quantity,
                            status: selectedStatus,
                          );
                          final newItems = await _crudService.updateProduct(_items, updated);
                          setState(() {
                            _items = newItems;
                            _applyFilter();
                          });
                          _showFeedbackSnackBar('Item #${updated.id} updated and auto-saved!');
                        } else {
                          final newItems = await _crudService.addProduct(
                            _items,
                            title: title,
                            category: selectedCat,
                            price: price,
                            quantity: quantity,
                            status: selectedStatus,
                          );
                          setState(() {
                            _items = newItems;
                            _applyFilter();
                          });
                          _showFeedbackSnackBar('New item added and auto-saved to JSON!');
                        }
                      },
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

  void _confirmDelete(ProductItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${item.title}" (ID: #${item.id})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final newItems = await _crudService.deleteProduct(_items, item.id);
              setState(() {
                _items = newItems;
                _applyFilter();
              });
              _showFeedbackSnackBar('Item #${item.id} deleted and auto-saved.', isDestructive: true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFeedbackSnackBar(String message, {bool isDestructive = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isDestructive ? Icons.delete : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isDestructive ? Colors.red[700] : Colors.green[700],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmResetDatabase() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Database'),
        content: const Text(
          'This will reset your local JSON file back to the initial sample seed. All manual changes will be replaced.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final resetItems = await _crudService.resetDatabase();
              setState(() {
                _items = resetItems;
                _applyFilter();
              });
              _showFeedbackSnackBar('Database reset to initial template seed!');
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showRawJsonSheet() async {
    final raw = await _crudService.exportRawJson(_items);
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Local JSON Database',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              Text(
                'File: $_filePath',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      raw,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      case 'Out of Stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 - JSON CRUD Database'),
        actions: [
          IconButton(
            tooltip: 'View Raw JSON Database',
            icon: const Icon(Icons.code),
            onPressed: _showRawJsonSheet,
          ),
          IconButton(
            tooltip: 'Reset to Sample Data',
            icon: const Icon(Icons.restore),
            onPressed: _confirmResetDatabase,
          ),
        ],
      ),
      body: Column(
        children: [
          // Auto-save & Database banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
            child: Row(
              children: [
                const Icon(Icons.cloud_done, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Auto-Save active: All Create, Update & Delete actions are saved automatically to JSON.',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
                  ),
                ),
                Chip(
                  label: Text('${_items.length} items', style: const TextStyle(fontSize: 11)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _searchQuery = query;
                _applyFilter();
              },
              decoration: InputDecoration(
                hintText: 'Search by title, category, ID...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchQuery = '';
                          _applyFilter();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // Category Chips Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _applyFilter();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Product List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 54, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            const Text('No items match your filter criteria.'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _showAddEditDialog(),
                              child: const Text('Add New Item'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDatabase,
                        child: ListView.builder(
                          itemCount: _filteredItems.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final statusColor = _getStatusColor(item.status);

                            return Card(
                              elevation: 1.5,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    // ID Badge
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      child: Text(
                                        '#${item.id}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: theme.colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Product Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${item.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.teal,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Qty: ${item.quantity}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  item.category,
                                                  style: const TextStyle(fontSize: 10),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withValues(alpha: 0.15),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  item.status,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Edit / Delete actions
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 20),
                                          tooltip: 'Edit item',
                                          onPressed: () => _showAddEditDialog(itemToEdit: item),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          tooltip: 'Delete item',
                                          onPressed: () => _confirmDelete(item),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
