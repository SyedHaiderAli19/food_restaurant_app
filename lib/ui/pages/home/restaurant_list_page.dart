import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/models/header_model.dart';
import 'package:food_restaurant_app/state_management/auth/auth_bloc.dart';
import 'package:food_restaurant_app/state_management/auth/auth_event.dart';
import 'package:food_restaurant_app/state_management/auth/auth_state.dart'
    as authState;
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
  final AuthServiceContract? authService;
  const RestaurantListPage({
    super.key,
    required this.adapter,
    this.authService,
  });

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<RestaurantBloc>(
        context,
      ).add(GetAllRestaurantsEvent(page: 1));
    });
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
        leading: IconButton(
          onPressed: () {
            logOut();
          },
          icon: Icon(
            Icons.power_settings_new_outlined,
            size: 36,
            color: Colors.white,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: BlocBuilder<HeaderBloc, HeaderModel>(
                builder: (context, HeaderModel header) => buildHeader(header),
              ),
            ),

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
            Align(
              alignment: Alignment.center,
              child: BlocListener<AuthBloc, authState.AuthState>(
                child: Container(),
                listener: (context, authState.AuthState state) {
                  if (state is LoadingState) {
                    showLoader();
                  }

                  if (state is authState.SignOutSuccessState) {
                    widget.adapter.onUserLogout(context);
                  }

                  if (state is authState.ErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    );

                    hideLoader();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  logOut() {
    BlocProvider.of<AuthBloc>(
      context,
    ).add(SignOutEvent(authService: widget.authService!));
  }

  showLoader() {
    final alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white70),
      ),
    );

    showDialog(
      context: context,
      builder: (context) => alert,
      barrierDismissible: true,
    );
  }

  hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget buildHeader(HeaderModel header) {
    if (restaurants.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: Colors.transparent),
      );
    }
    return Container(
      // decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      height: 230,
      child: Stack(
        children: [
          buildDynamicHeaderInfo(header: header),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
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
  }

  buildDynamicHeaderInfo({required HeaderModel header}) => Stack(
    children: [
      FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: header.imgUrl,
        height: 230,
        width: double.infinity,
        fit: BoxFit.cover,
      ),

      // Container(
      //   color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      // ),
      Positioned(
        top: 20,
        left: 20,
        right: 20,
        child: Text(
          header.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  updateHeader() {
    int index = currentIndex.toInt();
    if (index >= 0 && index < restaurants.length) {
      final RestaurantModel restaurant = restaurants[index];
      BlocProvider.of<HeaderBloc>(context).add(
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
