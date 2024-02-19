import 'package:da_order/common/const/data.dart';
import 'package:da_order/common/layout/default_layout.dart';
import 'package:da_order/product/component/product_card.dart';
import 'package:da_order/restaurant/component/restaurant_card.dart';
import 'package:da_order/restaurant/model/restaurant_detail_model.dart';
import 'package:da_order/restaurant/model/restaurant_model.dart';
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

  Future<Map<String, dynamic>> _getRestaurantDetail() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final dio = Dio();

    final response = await dio.get('http://$ip/restaurant/${widget.id}',
        options: Options(
          headers: {'authorization': 'Bearer $accessToken'},
        ));

    setState(() {
      title = response.data['name'];
    });

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: title,
        child: FutureBuilder(
          future: _getRestaurantDetail(),
          builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final item = RestaurantDetailModel.fromJson(json: snapshot.data!);
              return CustomScrollView(
                slivers: [
                  _renderTop(model: item),
                  _renderLabel(),
                  _renderProducts(),
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

  SliverPadding _renderProducts() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard(),
            );
          },
          childCount: 10,
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
