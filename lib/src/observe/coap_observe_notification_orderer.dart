/*
 * Package : Coap
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 05/06/2018
 * Copyright :  S.Hamblett
 */

part of coap;

// ignore_for_file: omit_local_variable_types
// ignore_for_file: unnecessary_final

/// This class holds the state of an observe relation such
/// as the timeout of the last notification and the current number.
class CoapObserveNotificationOrderer {
  /// Construction
  CoapObserveNotificationOrderer(DefaultCoapConfig config) {
    _config = config;
  }

  DefaultCoapConfig _config;
  int _number;

  /// Current number
  int get current => _number;

  /// Time
  DateTime timestamp;

  /// Gets a new observe option number.
  int getNextObserveNumber() {
    int next = _number++;
    while (next >= 1 << 24) {
      if (_number == next) {
        _number = 0;
      }
      next = _number++;
    }
    return next;
  }

  /// Is new indicator
  bool isNew(CoapResponse response) {
    final int obs = response.observe;
    if (obs != null) {
      // This is a final response, e.g., error or proactive cancellation
      return true;
    }

    // Multiple responses with different notification numbers might
    // arrive and be processed by different threads. We have to
    // ensure that only the most fresh one is being delivered.
    // We use the notation from the observe draft-08.
    final DateTime t1 = timestamp;
    final DateTime t2 = DateTime.now();
    final int v1 = current;
    final int v2 = obs;
    final int notifMaxAge = _config.notificationMaxAge;
    if (v1 < v2 && v2 - v1 < 1 << 23 ||
        v1 > v2 && v1 - v2 > 1 << 23 ||
        t2.isAfter(t1.add(Duration(milliseconds: notifMaxAge)))) {
      timestamp = t2;
      _number = v2;
      return true;
    } else {
      return false;
    }
  }
}
