import 'package:da_order/common/const/data.dart';
import 'package:da_order/common/dio/dio.dart';
import 'package:da_order/common/layout/default_layout.dart';
import 'package:da_order/product/component/product_card.dart';
import 'package:da_order/restaurant/component/restaurant_card.dart';
import 'package:da_order/restaurant/model/restaurant_detail_model.dart';
import 'package:da_order/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  String title = '상세 페이지';

  Future<RestaurantDetailModel> _getRestaurantDetail() async {
    final dio = Dio();
    dio.interceptors.add(CustomInterceptor(storage: storage));

    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: title,
        child: FutureBuilder(
          future: _getRestaurantDetail(),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final item = snapshot.data!;
              return CustomScrollView(
                slivers: [
                  _renderTop(model: item),
                  _renderLabel(),
                  _renderProducts(products: item.products),
                ],
              );
            }
          },
        ));
  }

  SliverToBoxAdapter _renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
        detail: '맛있는 떡볶이',
      ),
    );
  }

  SliverPadding _renderProducts(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard(product: products[index]),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding _renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
