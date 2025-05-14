import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_bloc.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_event.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_state.dart';
import 'package:food_restaurant_app/ui/pages/search_restaurants/i_search_restaurants_page_adapter.dart';
import 'package:food_restaurant_app/utils/utils.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchRestaurantsPage extends StatefulWidget {
  final RestaurantBloc restaurantBloc;
  final String searchQuery;
  final ISearchRestaurantsPageAdapter adapter;
  const SearchRestaurantsPage({
    super.key,
    required this.restaurantBloc,
    required this.searchQuery,
    required this.adapter,
  });

  @override
  State<SearchRestaurantsPage> createState() => _SearchRestaurantsPageState();
}

class _SearchRestaurantsPageState extends State<SearchRestaurantsPage> {
  PageLoadedState? currentState;
  bool fetchMore = false;
  List<RestaurantModel> restaurants = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.restaurantBloc.add(
      FindRestaurantsEvent(page: 1, query: widget.searchQuery),
    );
    onScrollListener();
    super.initState();
  }

  void onScrollListener() {
    scrollController.addListener(() {
      if (currentState != null &&
          scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          currentState!.nextPage != null) {
        fetchMore = true;
        widget.restaurantBloc.add(
          FindRestaurantsEvent(
            page: currentState!.nextPage!,
            query: widget.searchQuery,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
          iconSize: 30,
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${widget.searchQuery} Results',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(color: Colors.black),
              ),
            ),

            Expanded(child: buildResults()),
          ],
        ),
      ),
    );
  }

  buildResults() {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      bloc: widget.restaurantBloc,
      builder: (BuildContext context, RestaurantState state) {
        if (state is PageLoadedState) {
          currentState = state;
          fetchMore = false;
          restaurants.addAll(state.restaurants);
        }

        if (state is ErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          );
        }

        if (state is LoadingState && currentState == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (currentState == null) {
          return Center(child: CircularProgressIndicator());
        }

        return buildResultsList();
      },
    );
  }

  buildResultsList() => ListView.separated(
    itemBuilder: (BuildContext context, index) {
      return index >= restaurants.length
          ? bottomLoader()
          : GestureDetector(
            onTap:
                () => widget.adapter.onRestaurantSelected(
                  context: context,
                  restaurant: restaurants[index],
                ),
            child: ListTile(
              leading: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://picsum.photos/250?image=9',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurants[index].name,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),

                  RatingBarIndicator(
                    rating: 4.5,
                    itemBuilder:
                        (BuildContext context, index) =>
                            Icon(Icons.star, color: Colors.amber),
                    itemSize: 25,
                  ),
                ],
              ),
              subtitle: Text(
                '${restaurants[index].address.street}, ${restaurants[index].address.city}, ${restaurants[index].address.parish}',
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          );
    },
    physics: BouncingScrollPhysics(),
    controller: scrollController,
    separatorBuilder: (BuildContext context, index) => Divider(),
    itemCount: !fetchMore ? restaurants.length : restaurants.length + 1,
  );
}
