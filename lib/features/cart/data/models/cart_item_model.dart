import 'package:little_commerce/features/products/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  // Total price for this item (price × quantity)
  double get totalPrice => product.price * quantity;

  // Create new CartItem with updated quantity
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}
