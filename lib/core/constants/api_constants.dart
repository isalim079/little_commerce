class ApiConstants {
  // Private constructor so no one can do ApiConstants()
  ApiConstants._();

  // Base URL of FakeStoreAPI
  static const String baseUrl = 'https://fakestoreapi.com';

  // Endpoints
  static const String products = '/products';
  static const String singleProduct = '/products/'; // usage: /products/1
  static const String categories = '/products/categories';
  static const String login = '/auth/login';
  static const String carts = '/carts';
}