import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/models/header_model.dart';
import 'package:food_restaurant_app/state_management/helpers/header_event.dart';

class HeaderBloc extends Bloc<HeaderEvent, HeaderModel> {
  HeaderBloc() : super(HeaderModel(title: '', imgUrl: '')) {
    on<HeaderUpdateEvent>(_updateHeader);
  }

  FutureOr<void> _updateHeader(
    HeaderUpdateEvent event,
    Emitter<HeaderModel> emit,
  ) {
    emit(HeaderModel(title: event.title, imgUrl: event.imgUrl));
  }
}
