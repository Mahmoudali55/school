import 'dart:math';

/// حساب المسافة بين نقطتين جغرافيتين باستخدام صيغة Haversine
class DistanceCalculator {
  /// حساب المسافة بالكيلومترات
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// حساب المسافة بالأمتار
  static double calculateDistanceInMeters(double lat1, double lon1, double lat2, double lon2) {
    return calculateDistance(lat1, lon1, lat2, lon2) * 1000;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
