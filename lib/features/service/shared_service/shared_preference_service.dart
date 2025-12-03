// services/shared_preferences_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ticket/model/ticket_model.dart';

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const wishlistTicketsKey = 'wishlist_tickets';

  /// Save wishlist tickets
  Future<void> saveWishlistTickets(List<TicketModel> tickets) async {
    final ticketsJson = json.encode(
      tickets.map((ticket) => ticket.toJson()).toList(),
    );
    await sharedPreferences.setString(wishlistTicketsKey, ticketsJson);
    log('Wishlist tickets saved: ${tickets.length} tickets');
  }

  /// Get wishlist tickets
  List<TicketModel> getWishlistTickets() {
    final ticketsJson = sharedPreferences.getString(wishlistTicketsKey);
    if (ticketsJson == null || ticketsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> ticketsData = json.decode(ticketsJson);
      return ticketsData
          .map((item) => TicketModel.fromJson(item))
          .toList();
    } catch (e) {
      log('Error parsing wishlist tickets: $e');
      return [];
    }
  }

  /// Clear wishlist tickets
  Future<void> clearWishlistTickets() async {
    await sharedPreferences.remove(wishlistTicketsKey);
    log('Wishlist tickets cleared');
  }

  /// Clear all data
  Future<void> clear() async {
    await sharedPreferences.clear();
    log('SharedPreferences cleared');
  }
}