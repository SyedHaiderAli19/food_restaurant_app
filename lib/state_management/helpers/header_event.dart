abstract class HeaderEvent {}

class HeaderUpdateEvent extends HeaderEvent {
  final String title;
  final String imgUrl;

  HeaderUpdateEvent({required this.title, required this.imgUrl});
}
