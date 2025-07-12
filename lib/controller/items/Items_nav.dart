import 'package:flutter_bloc/flutter_bloc.dart';

enum ItemsEvents {
  CategoryClickedEvent,
  ItemsClickedEvent,
  EditCategoryClickedEvent,
  EditItemsClickedEvent,
  ManageClickedEvent,
}

class ItemsNavCubit extends Cubit<ItemsEvents> {
  ItemsNavCubit() : super(ItemsEvents.CategoryClickedEvent);

  void Categories() {
    emit(ItemsEvents.CategoryClickedEvent);
  }

  void Items() {
    emit(ItemsEvents.ItemsClickedEvent);
  }

  void EditCategory() {
    emit(ItemsEvents.EditCategoryClickedEvent);
  }

  void EditItems() {
    emit(ItemsEvents.EditItemsClickedEvent);
  }

  void Manage() {
    emit(ItemsEvents.ManageClickedEvent);
  }
}
