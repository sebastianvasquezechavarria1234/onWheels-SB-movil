import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_chart_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (!auth.isAdmin) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Acceso Denegado'),
            ),
            body: const Center(
              child: Text(
                'No tienes permisos para acceder a esta sección',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black87),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No hay notificaciones nuevas'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuración en desarrollo'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - _animationController.value)),
                      child: Opacity(
                        opacity: _animationController.value,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue, Colors.blueAccent],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenido, ${auth.userName}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Panel de administración - Gestiona tu tienda',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                // Statistics cards
                Consumer2<ProductProvider, UserProvider>(
                  builder: (context, productProvider, userProvider, child) {
                    return AnimationLimiter(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            AdminStatCard(
                              title: 'Productos',
                              value: '${productProvider.products.length}',
                              icon: Icons.inventory_2_outlined,
                              color: Colors.blue,
                              onTap: () => context.go('/store'),
                            ),
                            AdminStatCard(
                              title: 'Usuarios',
                              value: '${userProvider.users.length}',
                              icon: Icons.people_outline,
                              color: Colors.green,
                              onTap: () => context.go('/admin/users'),
                            ),
                            AdminStatCard(
                              title: 'Ventas',
                              value: '\$12,450',
                              icon: Icons.trending_up,
                              color: Colors.orange,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Reporte de ventas en desarrollo'),
                                  ),
                                );
                              },
                            ),
                            AdminStatCard(
                              title: 'Pedidos',
                              value: '89',
                              icon: Icons.shopping_cart_outlined,
                              color: Colors.purple,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gestión de pedidos en desarrollo'),
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
                const SizedBox(height: 30),
                // Charts section
                const Text(
                  'Estadísticas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const AdminChartWidget(),
                const SizedBox(height: 30),
                // Quick actions
                const Text(
                  'Acciones Rápidas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 600),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        _buildQuickAction(
                          icon: Icons.people_outline,
                          title: 'Gestionar Usuarios',
                          subtitle: 'Ver y administrar usuarios del sistema',
                          onTap: () => context.go('/admin/users'),
                        ),
                        _buildQuickAction(
                          icon: Icons.school_outlined,
                          title: 'Gestionar Clases',
                          subtitle: 'Administrar clases y categorías',
                          onTap: () => context.go('/admin/classes'),
                        ),
                        _buildQuickAction(
                          icon: Icons.inventory_outlined,
                          title: 'Gestionar Productos',
                          subtitle: 'Agregar, editar y eliminar productos',
                          onTap: () => context.go('/store'),
                        ),
                        _buildQuickAction(
                          icon: Icons.analytics_outlined,
                          title: 'Reportes',
                          subtitle: 'Ver reportes y estadísticas detalladas',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reportes en desarrollo'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
