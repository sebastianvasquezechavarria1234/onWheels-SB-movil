import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue, Colors.blueAccent],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menú Principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.store,
                  title: 'Tienda',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/store');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_cart,
                  title: 'Carrito',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/cart');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person,
                  title: 'Mi Cuenta',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/profile');
                  },
                ),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    if (auth.isAdmin) {
                      return _buildMenuItem(
                        context,
                        icon: Icons.admin_panel_settings,
                        title: 'Admin Dashboard',
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/admin');
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: 'Cerrar Sesión',
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AuthProvider>().logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.blue.withOpacity(0.1),
    );
  }
}
