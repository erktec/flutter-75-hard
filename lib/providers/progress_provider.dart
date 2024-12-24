import 'package:flutter/foundation.dart';

class ProgressProvider with ChangeNotifier {
  int? _day;
  double _diet = 0.0;
  double _picture = 0.0;
  double _reading = 0.0;
  double _workout1 = 0.0;
  double _workout2 = 0.0;
  double _water = 0.0;

  int? get day => _day;
  double get diet => _diet;
  double get picture => _picture;
  double get reading => _reading;
  double get workout1 => _workout1;
  double get workout2 => _workout2;
  double get water => _water;

  void setDay(int? day) {
    _day = day;
    notifyListeners();
  }

  void setDiet(double diet) {
    _diet = diet;
    notifyListeners();
  }

  void setPicture(double picture) {
    _picture = picture;
    notifyListeners();
  }

  void setReading(double reading) {
    _reading = reading;
    notifyListeners();
  }

  void setWorkout1(double workout1) {
    _workout1 = workout1;
    notifyListeners();
  }

  void setWorkout2(double workout2) {
    _workout2 = workout2;
    notifyListeners();
  }

  void setWater(double water) {
    _water = water;
    notifyListeners();
  }

  void setProgress({
    required int? day,
    required double diet,
    required double reading,
    required double picture,
    required double workout1,
    required double workout2,
    required double water,
  }) {
    _day = day;
    _diet = diet;
    _reading = reading;
    _picture = picture;
    _workout1 = workout1;
    _workout2 = workout2;
    _water = water;
    notifyListeners();
  }
}
