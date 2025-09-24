import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: '1',
      name: 'Tabla Lightning',
      price: 120.0000,
      description: 'Tabla de skateboard Lightning de alta calidad',
      imageUrl: '/placeholder.svg?height=200&width=200',
      category: 'Skateboards',
    ),
    Product(
      id: '2',
      name: 'Gorra gris',
      price: 120.0000,
      description: 'Gorra gris con letra C bordada',
      imageUrl: '/placeholder.svg?height=200&width=200',
      category: 'Accesorios',
    ),
    Product(
      id: '3',
      name: 'Camiseta Skate',
      price: 85.0000,
      description: 'Camiseta con diseño gráfico de skateboard',
      imageUrl: '/placeholder.svg?height=200&width=200',
      category: 'Ropa',
    ),
    Product(
      id: '4',
      name: 'Gorra negra',
      price: 95.0000,
      description: 'Gorra negra estilo urbano',
      imageUrl: '/placeholder.svg?height=200&width=200',
      category: 'Accesorios',
    ),
  ];

  List<Product> get products => _products;
  
  List<Product> get availableProducts => 
      _products.where((product) => product.isAvailable).toList();

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return availableProducts;
    
    return availableProducts.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
