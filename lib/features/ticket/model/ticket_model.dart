
import 'dart:convert';

class TicketModel {
  final double ticketPrice;
  final String artist;
  final String duration;
  final String location;
  final String locationHex;
  final String eventDate;
  final String ticketRef;
  final int quantityAvailable;
  final bool purchased;
  final String purchasedAt;

  TicketModel({
    required this.ticketPrice,
    required this.artist,
    required this.duration,
    required this.location,
    required this.locationHex,
    required this.eventDate,
    required this.ticketRef,
    required this.quantityAvailable,
    required this.purchased,
    required this.purchasedAt,
  });

  /// From JSON
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketPrice: (json['ticketPrice'] ?? 0).toDouble(),
      artist: json['artist'] ?? '',
      duration: json['duration'] ?? '',
      location: json['location'] ?? '',
      locationHex: json['locationHex'] ?? '',
      eventDate: json['eventDate'] ?? '',
      ticketRef: json['ticketRef'] ?? '',
      quantityAvailable: json['quantityAvailable'] ?? 0,
      purchased: json['purchased'] ?? false,
      purchasedAt: json['purchasedAt'] ?? '',
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'ticketPrice': ticketPrice,
      'artist': artist,
      'duration': duration,
      'location': location,
      'locationHex': locationHex,
      'eventDate': eventDate,
      'ticketRef': ticketRef,
      'quantityAvailable': quantityAvailable,
      'purchased': purchased,
      'purchasedAt': purchasedAt,
    };
  }

  /// To JSON String
  String toJsonString() => json.encode(toJson());

  /// From JSON String
  factory TicketModel.fromJsonString(String jsonString) {
    return TicketModel.fromJson(json.decode(jsonString));
  }

  /// Copy with method for updates
  TicketModel copyWith({
    double? ticketPrice,
    String? artist,
    String? duration,
    String? location,
    String? locationHex,
    String? eventDate,
    String? ticketRef,
    int? quantityAvailable,
    bool? purchased,
    String? purchasedAt,
  }) {
    return TicketModel(
      ticketPrice: ticketPrice ?? this.ticketPrice,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      locationHex: locationHex ?? this.locationHex,
      eventDate: eventDate ?? this.eventDate,
      ticketRef: ticketRef ?? this.ticketRef,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      purchased: purchased ?? this.purchased,
      purchasedAt: purchasedAt ?? this.purchasedAt,
    );
  }

  @override
  String toString() {
    return 'TicketModel(artist: $artist, price: $ticketPrice, location: $location, ref: $ticketRef)';
  }
}