import 'package:flutter/foundation.dart';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    // доступ до копії предметів. Ми не зможемо змінити _items (оригінал) в тому місці проекту, де ми звертаємось до items
    return [..._items];
  }
}
