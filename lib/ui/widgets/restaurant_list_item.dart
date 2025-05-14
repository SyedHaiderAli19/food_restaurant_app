import 'package:flutter/material.dart';
import 'package:restaurant/restaurant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantListItem extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantListItem({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary,
              blurRadius: 0,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                restaurant.name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            SizedBox(height: 12),

            FractionallySizedBox(
              widthFactor: 0.7,
              child: Text(
                '${restaurant.address.street}, ${restaurant.address.city}, ${restaurant.address.parish}',
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black54),
              ),
            ),

            SizedBox(height: 8),

            RatingBarIndicator(
              rating: 4.5,
              itemBuilder:
                  (context, index) =>
                      Icon(Icons.star_rate_sharp, color: Colors.amber),
              itemCount: 5,
              itemSize: 50,
            ),

            Text('4.5', style: Theme.of(context).textTheme.headlineSmall),

            SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                createChip(label: 'Vegetarian', context: context),
                createChip(label: 'Vegan', context: context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createChip({required String label, required BuildContext context}) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(color: Colors.white),
      ),
    );
  }
}
