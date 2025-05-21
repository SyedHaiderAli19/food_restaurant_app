import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_bloc.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_event.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_state.dart';
import 'package:food_restaurant_app/ui/widgets/restaurant/menu_list.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantPage extends StatefulWidget {
  final RestaurantModel restaurant;
  final RestaurantBloc restaurantBloc;
  const RestaurantPage({
    super.key,
    required this.restaurant,
    required this.restaurantBloc,
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final List<MenuModel> menus = [];

  @override
  void initState() {
    widget.restaurantBloc.add(
      GetRestaurantMenuEvent(restaurantId: widget.restaurant.id),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_basket_outlined, color: Colors.white),
            iconSize: 30,
          ),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(child: menu(), alignment: Alignment.bottomLeft),
          Align(child: header(), alignment: Alignment.topCenter),
        ],
      ),
    );
  }

  menu() => FractionallySizedBox(
    heightFactor: 0.5,
    child: BlocBuilder<RestaurantBloc, RestaurantState>(
      bloc: widget.restaurantBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is ErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          );
        }

        if (state is MenuLoadedState && state.menus.isNotEmpty) {
          return buildMenuList(state.menus);
        }
        return Center(
          child: Text(
            'No Menu Available',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        );
      },
    ),
  );

  Widget buildMenuList(List<MenuModel> menus) {
    return DefaultTabController(
      length: menus.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            automaticIndicatorColorAdjustment: true,
            tabs: menus.map<Widget>((menu) => Tab(text: menu.name)).toList(),
            isScrollable: true,
            labelColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.black26,
            unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
            labelStyle: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TabBarView(
              children:
                  menus
                      .map<Widget>(
                        (menu) => MenuList(menuItems: menu.items, menu: menu),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  header() {
    final double rating =
        (widget.restaurant.rating * 100).roundToDouble() / 100;
    return FractionallySizedBox(
      heightFactor: 0.48,
      child: Stack(
        children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.restaurant.displayImageUrl,
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.secondary,
                      blurRadius: 4,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                      ),
                      child: Text(
                        widget.restaurant.name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                    SizedBox(height: 12),
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Text(
                        '${widget.restaurant.address.street}, ${widget.restaurant.address.city}, ${widget.restaurant.address.parish}',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall!.copyWith(color: Colors.black54),
                      ),
                    ),

                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          rating: rating,
                          itemBuilder:
                              (context, index) =>
                                  Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 30,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          rating.toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
