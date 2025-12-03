// providers/ticket_provider.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ticket_model.dart';


class TicketProvider extends ChangeNotifier {
  TicketModel? _selectedTicket;

  TicketModel? get selectedTicket => _selectedTicket;

  // Method to select a single ticket
  void selectTicket(TicketModel ticket) {
    _selectedTicket = ticket;
    notifyListeners();
  }

  // Method to clear selection
  void clearSelection() {
    _selectedTicket = null;
    notifyListeners();
  }

  // Method to check if a ticket is selected
  bool isTicketSelected(String ticketRef) {
    return _selectedTicket?.ticketRef == ticketRef;
  }
  List<TicketModel> _tickets = [];
  List<TicketModel> _wishlistTickets = [];
  String _selectedLocation = '';
  String _searchQuery = '';

  List<TicketModel> get tickets => _tickets;
  List<TicketModel> get wishlistTickets => _wishlistTickets;
  List<TicketModel> get filteredTickets => _getFilteredTickets();

  /// Mock data - you can load this from an API
  final List<TicketModel> _mockTickets = [
    TicketModel(
      ticketPrice: 15000,
      artist: "Davido",
      duration: "08:00PM-05:00AM",
      location: "Lagos",
      locationHex: "#000000",
      eventDate: "2025-12-05",
      ticketRef: "1068692",
      quantityAvailable: 50,
      purchased: false,
      purchasedAt: "",
    ),
    TicketModel(
      ticketPrice: 5000,
      artist: "Adekunle Gold",
      duration: "12:00PM-08:00PM",
      location: "Lagos",
      locationHex: "#000000",
      eventDate: "2025-12-03",
      ticketRef: "1068691",
      quantityAvailable: 100,
      purchased: false,
      purchasedAt: "",
    ),
    TicketModel(
      ticketPrice: 8000,
      artist: "Tiwa Savage",
      duration: "10:00AM-02:00PM",
      location: "Abuja",
      locationHex: "#000000",
      eventDate: "2025-12-05",
      ticketRef: "1068693",
      quantityAvailable: 75,
      purchased: false,
      purchasedAt: "",
    ),
    TicketModel(
      ticketPrice: 15000,
      artist: "Burna Boy",
      duration: "02:00PM-06:00PM",
      location: "Lagos",
      locationHex: "#000000",
      eventDate: "2025-12-01",
      ticketRef: "1068694",
      quantityAvailable: 30,
      purchased: false,
      purchasedAt: "",
    ),
  ];

  TicketProvider() {
    _loadTickets();
    _loadWishlist();
  }

  // Load tickets from mock data
  void _loadTickets() {
    _tickets = List.from(_mockTickets);
    notifyListeners();
  }

  /// Load wishlist from SharedPreferences
  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = prefs.getString('wishlist_tickets');

    if (wishlistJson != null) {
      final List<dynamic> wishlistData = json.decode(wishlistJson);
      _wishlistTickets = wishlistData
          .map((item) => TicketModel.fromJson(item))
          .toList();
      notifyListeners();
    }
  }

  /// Save wishlist to SharedPreferences
  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = json.encode(
      _wishlistTickets.map((ticket) => ticket.toJson()).toList(),
    );
    await prefs.setString('wishlist_tickets', wishlistJson);
  }

  /// Add ticket to wishlist
  Future<void> addToWishlist(TicketModel ticket, int quantity) async {
    /// Check if already in wishlist
    final existingIndex = _wishlistTickets.indexWhere((t) => t.ticketRef == ticket.ticketRef);

    if (existingIndex != -1) {
      /// Update quantity or remove based on your logic
      /// For now, we'll replace it
      _wishlistTickets[existingIndex] = ticket.copyWith(
        quantityAvailable: quantity,
      );
    } else {
      /// Add new ticket with selected quantity
      _wishlistTickets.add(ticket.copyWith(
        quantityAvailable: quantity,
      ));
    }

    await _saveWishlist();
    notifyListeners();
  }

  /// Remove ticket from wishlist
  Future<void> removeFromWishlist(String ticketRef) async {
    _wishlistTickets.removeWhere((ticket) => ticket.ticketRef == ticketRef);
    await _saveWishlist();
    notifyListeners();
  }

  /// Update selected location
  void setSelectedLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  /// Update search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Get filtered tickets based on location and search
  List<TicketModel> _getFilteredTickets() {
    List<TicketModel> filtered = List.from(_tickets);

    /// Filter by location
    if (_selectedLocation.isNotEmpty) {
      filtered = filtered.where((ticket) =>
          ticket.location.toLowerCase().contains(_selectedLocation.toLowerCase())
      ).toList();
    }

    /// Filter by search query (searches in artist name, location, and ticket ref)
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((ticket) =>
      ticket.artist.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket.ticketRef.contains(_searchQuery)
      ).toList();
    }

    return filtered;
  }
  /// Add this method to your TicketProvider class
  Future<void> loadWishlist() async {
    await _loadWishlist(); // This calls the existing private method
    notifyListeners();
  }

  /// Get unique locations from tickets
  List<String> getLocations() {
    final locations = _tickets.map((ticket) => ticket.location).toSet().toList();
    return locations..sort();
  }

  /// Clear all data (for logout)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wishlist_tickets');
    _wishlistTickets.clear();
    _selectedLocation = '';
    _searchQuery = '';
    notifyListeners();
  }
}