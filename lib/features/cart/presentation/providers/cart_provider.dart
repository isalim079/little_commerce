import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:little_commerce/features/products/data/models/product_model.dart';

// Cart state — holds list of cart items
class CartState {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  // Total number of items (sum of all quantities)
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Total price of entire cart
  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  // Check if a product is already in cart
  bool containsProduct(int productId) {
    return items.any((item) => item.product.id == productId);
  }

  // Get quantity of specific product
  int getQuantity(int productId) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return 0;
    return items[index].quantity;
  }

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}

// The provider
final cartProvider = NotifierProvider<CartNotifier, CartState>(
  () => CartNotifier(),
);

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  // Add product to cart
  void addToCart(ProductModel product) {
    final currentItems = [...state.items]; // copy list
    final existingIndex =
        currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // Product already in cart — increase quantity
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + 1,
      );
    } else {
      // New product — add with quantity 1
      currentItems.add(CartItemModel(product: product, quantity: 1));
    }

    state = state.copyWith(items: currentItems);
  }

  // Remove one quantity
  void decreaseQuantity(int productId) {
    final currentItems = [...state.items];
    final existingIndex =
        currentItems.indexWhere((item) => item.product.id == productId);

    if (existingIndex == -1) return;

    final currentQuantity = currentItems[existingIndex].quantity;

    if (currentQuantity <= 1) {
      // If quantity is 1, remove item completely
      currentItems.removeAt(existingIndex);
    } else {
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentQuantity - 1,
      );
    }

    state = state.copyWith(items: currentItems);
  }

  // Remove product completely from cart
  void removeFromCart(int productId) {
    final currentItems = state.items
        .where((item) => item.product.id != productId)
        .toList();
    state = state.copyWith(items: currentItems);
  }

  // Clear entire cart
  void clearCart() {
    state = const CartState();
  }
}