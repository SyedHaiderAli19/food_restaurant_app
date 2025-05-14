import 'package:flutter/material.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_button.dart';
import 'package:food_restaurant_app/utils/utils.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuList extends StatelessWidget {
  final List<MenuItemModel> menuItems;
  const MenuList({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Material(
          child: InkWell(
            onTap: () => showAddToBasketOption(context, menuItems[index]),
            child: ListTile(
              isThreeLine: false,
              leading: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://picsum.photos/250?image=9',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      menuItems[index].name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),

                  Text(
                    doubleToCurrency(menuItems[index].unitPrice),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              subtitle: Text(
                menuItems[index].description,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: menuItems.length,
      padding: EdgeInsets.zero,
    );
  }

  showAddToBasketOption(BuildContext context, MenuItemModel menuItem) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 16, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          menuItem.name,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),

                      Text(
                        doubleToCurrency(menuItem.unitPrice),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove, color: Colors.black26),
                      ),

                      Text('1', style: Theme.of(context).textTheme.titleMedium),

                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add, color: Colors.black26),
                      ),
                    ],
                  ),
                  CustomTextButton(
                    color: Theme.of(context).colorScheme.secondary,
                    text: 'Add to Basket',
                    size: Size(double.infinity, 45),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
    );
  }
}
