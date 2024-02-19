import 'package:da_order/common/const/data.dart';
import 'package:da_order/restaurant/component/restaurant_card.dart';
import 'package:da_order/restaurant/model/restaurant_model.dart';
import 'package:da_order/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final response = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );

    return response.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return ListView.separated(
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      final pItem = RestaurantModel.fromJson(
                        json: item,
                      );
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                            RestaurantDetailScreen(id: pItem.id,)
                          ));
                        },
                        child: RestaurantCard.fromModel(
                          model: pItem,
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                }
              },
            )),
      ),
    );
  }
}
