import 'package:flutter/material.dart';
import 'screens/lab9_1_assets_screen.dart';
import 'screens/lab9_2_storage_screen.dart';
import 'screens/lab9_3_crud_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Lab9App());
}

class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 09 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigationHub(),
    );
  }
}

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    Lab91AssetsScreen(),
    Lab92StorageScreen(),
    Lab93CrudScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_open),
            label: 'Lab 9.1',
          ),
          NavigationDestination(
            icon: Icon(Icons.save_as_outlined),
            selectedIcon: Icon(Icons.save_as),
            label: 'Lab 9.2',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage),
            label: 'Lab 9.3',
          ),
        ],
      ),
    );
  }
}

/// Dashboard Overview Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PRM393 - Lab 09'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            tooltip: 'About Lab 09',
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Header
          Card(
            elevation: 0,
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.data_object,
                          color: theme.colorScheme.onPrimary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Working with Local JSON Storage',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Flutter + JSON Persistence Lab',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Dự án hoàn chỉnh cả 3 phần yêu cầu của Lab 09: Đọc dữ liệu từ Assets (Lab 9.1), Lưu trữ và phục hồi dữ liệu từ Device Storage (Lab 9.2), và Quản lý cơ sở dữ liệu CRUD đầy đủ bằng JSON (Lab 9.3).',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'Danh mục bài thực hành',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Card Lab 9.1
          _buildLabCard(
            context: context,
            title: 'Lab 9.1: Read JSON From Assets',
            subtitle: 'Đọc & phân tích dữ liệu JSON nhúng cục bộ từ thư mục assets/data/courses.json bằng rootBundle.loadString().',
            icon: Icons.folder_open,
            iconColor: Colors.blue,
            tag: 'Assets & ListView',
            onTap: () {
              final hubState = context.findAncestorStateOfType<_MainNavigationHubState>();
              hubState?._onTabSelected(1);
            },
          ),

          const SizedBox(height: 12),

          // Card Lab 9.2
          _buildLabCard(
            context: context,
            title: 'Lab 9.2: Save & Load Device Storage',
            subtitle: 'Ghi và đọc file JSON trong application documents directory bằng path_provider. Dữ liệu tồn tại bền vững qua các lần khởi động lại app.',
            icon: Icons.save_as,
            iconColor: Colors.teal,
            tag: 'path_provider & Persistence',
            onTap: () {
              final hubState = context.findAncestorStateOfType<_MainNavigationHubState>();
              hubState?._onTabSelected(2);
            },
          ),

          const SizedBox(height: 12),

          // Card Lab 9.3
          _buildLabCard(
            context: context,
            title: 'Lab 9.3: Local JSON CRUD Mini Database',
            subtitle: 'Hệ thống mini database hoàn chỉnh: Thêm mới, Sửa, Xóa, Tìm kiếm & Lọc sản phẩm theo danh mục. Tự động lưu JSON (Auto-save) sau mỗi thao tác.',
            icon: Icons.storage,
            iconColor: Colors.deepOrange,
            tag: 'Full CRUD & Auto-Save',
            onTap: () {
              final hubState = context.findAncestorStateOfType<_MainNavigationHubState>();
              hubState?._onTabSelected(3);
            },
          ),

          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Tiêu chí đánh giá hoàn thành (100%)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildCheckItem('JSON Reading (25%): Đọc và parse courses.json từ assets.'),
                  _buildCheckItem('JSON Writing (25%): Ghi/đọc JSON vào bộ nhớ thiết bị.'),
                  _buildCheckItem('Local Persistence (20%): Lưu giữ dữ liệu khi thoát/khởi động lại app.'),
                  _buildCheckItem('CRUD Functionality (20%): Thêm, Sửa, Xóa, Tìm kiếm sản phẩm.'),
                  _buildCheckItem('UI/UX Quality (10%): Giao diện Material 3 đẹp mắt, phản hồi mượt mà.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.done, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildLabCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String tag,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.indigo),
            SizedBox(width: 8),
            Text('PRM393 - Lab 09'),
          ],
        ),
        content: const Text(
          'Môn học: PRM393 - Mobile Programming\n'
          'Chủ đề: Working with Local JSON Storage\n'
          'Công nghệ: Flutter + Dart\n'
          'Thư viện chính: dart:convert, path_provider\n'
          'Hoàn thiện đầy đủ Lab 9.1, Lab 9.2, Lab 9.3.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
