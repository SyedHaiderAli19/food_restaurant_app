import 'package:flutter/material.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_button.dart';
import 'package:food_restaurant_app/utils/utils.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuList extends StatefulWidget {
  final MenuModel menu;
  final List<MenuItemModel> menuItems;

  const MenuList({super.key, required this.menuItems, required this.menu});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Material(
          child: InkWell(
            onTap: () {
              counter = 1;
              showAddToBasketOption(context, widget.menuItems[index]);
            },
            child: ListTile(
              isThreeLine: false,
              leading: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.menu.displayImageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.menuItems[index].name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),

                  Text(
                    doubleToCurrency(widget.menuItems[index].unitPrice),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              subtitle: Text(
                widget.menuItems[index].description,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: widget.menuItems.length,
      padding: EdgeInsets.zero,
    );
  }

void showAddToBasketOption(BuildContext context, MenuItemModel menuItem) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(35)),
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
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        doubleToCurrency(menuItem.unitPrice),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (counter > 1) {
                            setModalState(() {
                              counter--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove, color: Colors.black26),
                      ),
                      Text(
                        counter.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () {
                          setModalState(() {
                            counter++;
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.black26),
                      ),
                    ],
                  ),
                  CustomTextButton(
                    color: Theme.of(context).colorScheme.secondary,
                    text: 'Add to Basket',
                    size: const Size(double.infinity, 45),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}
