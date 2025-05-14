import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/models/header_model.dart';
import 'package:food_restaurant_app/state_management/helpers/header_bloc.dart';
import 'package:food_restaurant_app/state_management/helpers/header_event.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_bloc.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_event.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_state.dart';
import 'package:food_restaurant_app/ui/pages/home/i_home_page_adapter.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_field.dart';
import 'package:food_restaurant_app/ui/widgets/restaurant_list_item.dart';
import 'package:food_restaurant_app/utils/utils.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantListPage extends StatefulWidget {
  final IHomePageAdapter adapter;
  const RestaurantListPage({super.key, required this.adapter});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  PageLoadedState? currentState;
  final List<RestaurantModel> restaurants = [];
  double currentIndex = 0;
  double previousIndex = 0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<RestaurantBloc>(
      context,
    ).add(GetAllRestaurantsEvent(page: 1));
    onScrollListener();
    super.initState();
  }

  void onScrollListener() {
    scrollController.addListener(() {
      currentIndex = (scrollController.offset.round() / 240).floorToDouble();

      if (currentState != null &&
          scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          currentState!.nextPage != null) {
        BlocProvider.of<RestaurantBloc>(
          context,
        ).add(GetAllRestaurantsEvent(page: currentState!.nextPage!));
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_basket_outlined, size: 38.8),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(child: header(), alignment: Alignment.topCenter),

            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.75,
                child: BlocConsumer<RestaurantBloc, RestaurantState>(
                  builder: (BuildContext context, RestaurantState state) {
                    if (state is PageLoadedState) {
                      currentState = state;
                      restaurants.addAll(state.restaurants);
                      updateHeader();
                    }

                    if (currentState == null) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return buildListOfRestaurants();
                  },
                  listener: (BuildContext context, RestaurantState state) {
                    if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  header() => Container(
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
    height: 350,
    child: Stack(
      children: [
        BlocBuilder<HeaderBloc, HeaderModel>(
          builder:
              (BuildContext context, HeaderModel state) =>
                  buildDynamicHeaderInfo(header: state),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
            child: CustomTextField(
              hint: 'Find Restaurants',
              keyboardType: TextInputType.text,
              inputAction: TextInputAction.search,
              isPassword: false,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              height: 48,
              onChanged: (val) {},
              onSubmitted: (query) {
                if (query.isEmpty) return;
                widget.adapter.onSearchQuery(context: context, query: query);
              },
            ),
          ),
        ),
      ],
    ),
  );

  buildDynamicHeaderInfo({required HeaderModel header}) => Stack(
    children: [
      FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: 'https://picsum.photos/250?image=9',
        height: 350,
        width: double.infinity,
        fit: BoxFit.cover,
      ),

      Container(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      ),

      Align(
        child: Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              header.title,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    ],
  );

  updateHeader() {
    int index = currentIndex.toInt();
    if (index >= 0 && index < restaurants.length) {
      final RestaurantModel restaurant = restaurants[index];

      context.read<HeaderBloc>().add(
        HeaderUpdateEvent(
          title: restaurant.name,
          imgUrl: restaurant.displayImageUrl,
        ),
      );
    }
  }

  buildListOfRestaurants() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (_) {
        if (currentIndex != previousIndex) {
          updateHeader();
          previousIndex = currentIndex;
        }
        return true;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 40),
        itemBuilder: (BuildContext context, index) {
          return index >= restaurants.length
              ? bottomLoader()
              : GestureDetector(
                onTap:
                    () => widget.adapter.onRestaurantSelected(
                      context: context,
                      restaurant: restaurants[index],
                    ),
                child: RestaurantListItem(restaurant: restaurants[index]),
              );
        },
        physics: BouncingScrollPhysics(),
        itemCount:
            currentState!.nextPage == null
                ? restaurants.length
                : restaurants.length + 1,
        controller: scrollController,
      ),
    );
  }
}
