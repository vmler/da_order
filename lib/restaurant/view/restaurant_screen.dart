import 'package:da_order/common/const/data.dart';
import 'package:da_order/common/dio/dio.dart';
import 'package:da_order/restaurant/component/restaurant_card.dart';
import 'package:da_order/restaurant/model/restaurant_model.dart';
import 'package:da_order/restaurant/repository/restaurant_repository.dart';
import 'package:da_order/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final repository = RestaurantRepository(dio, baseUrl: "http://$ip/restaurant");
    final response = await repository.paginate();

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<RestaurantModel>>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return ListView.separated(
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                    id: item.id,
                                  )));
                        },
                        child: RestaurantCard.fromModel(
                          model: item,
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
