import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/auth_provider.dart';

class AdminClassesScreen extends StatefulWidget {
  const AdminClassesScreen({Key? key}) : super(key: key);

  @override
  State<AdminClassesScreen> createState() => _AdminClassesScreenState();
}

class _AdminClassesScreenState extends State<AdminClassesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  
  final List<Map<String, dynamic>> _classes = [
    {
      'id': '1',
      'name': 'Skateboard Básico',
      'description': 'Aprende los fundamentos del skateboard',
      'instructor': 'Carlos Rodríguez',
      'students': 15,
      'duration': '2 horas',
      'price': 50.0,
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Skateboard Avanzado',
      'description': 'Técnicas avanzadas y trucos profesionales',
      'instructor': 'María González',
      'students': 8,
      'duration': '3 horas',
      'price': 80.0,
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'Skateboard para Niños',
      'description': 'Clases especiales para los más pequeños',
      'instructor': 'Juan Pérez',
      'students': 12,
      'duration': '1.5 horas',
      'price': 35.0,
      'isActive': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
              child: Text('No tienes permisos para acceder a esta sección'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Gestión de Clases',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black87),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddClassDialog(context),
              ),
            ],
          ),
          body: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildClassCard(_classes[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    classData['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: classData['isActive'] ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    classData['isActive'] ? 'Activa' : 'Inactiva',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              classData['description'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  Icons.person,
                  classData['instructor'],
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  Icons.group,
                  '${classData['students']} estudiantes',
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  Icons.access_time,
                  classData['duration'],
                  Colors.orange,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  Icons.attach_money,
                  '\$${classData['price']}',
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showEditClassDialog(context, classData),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _showDeleteClassDialog(context, classData),
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Eliminar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Clase'),
        content: const Text('Funcionalidad de agregar clase en desarrollo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showEditClassDialog(BuildContext context, Map<String, dynamic> classData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Clase'),
        content: Text('Editar información de ${classData['name']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteClassDialog(BuildContext context, Map<String, dynamic> classData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Clase'),
        content: Text('¿Estás seguro de que quieres eliminar ${classData['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${classData['name']} eliminada correctamente'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
