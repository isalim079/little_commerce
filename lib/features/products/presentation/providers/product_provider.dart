import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_commerce/core/constants/api_constants.dart';
import 'package:little_commerce/core/network/dio_client.dart';
import 'package:little_commerce/features/products/data/models/product_model.dart';

final productsProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  try {
    final dio = DioClient.instance;
    final response = await dio.get(ApiConstants.products);
    final data = response.data as List<dynamic>;

    return data
        .map(
          (json) => ProductModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  } on DioException catch (e) {
    throw e.message ?? 'Failed to load products';
  } catch (e) {
    throw e.toString();
  }
});

