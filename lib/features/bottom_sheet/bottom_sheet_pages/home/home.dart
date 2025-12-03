import 'package:flutter/cupertino.dart' as PagerService;
import 'package:flutter/material.dart';
import 'package:untitled/features/utilities/route.dart';


import '../../../../widgets/custom_date_picker.dart';
import '../../../../widgets/search.dart';
import '../../../../widgets/ticket_card.dart';
import '../../../service/page_service.dart';
import '../../../ticket/model/ticket_model.dart';
import '../../../ticket/servicers/ticket_provider_service.dart';
import '../../../utilities/appcolors.dart';
import 'package:intl/intl.dart';

import '../all_tickets/screens/add_ticket.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load wishlist tickets when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TicketProvider>(context, listen: false);
      provider.loadWishlist(); // This should load tickets from SharedPreferences
    });
  }

  // Generate event dots based on wishlist tickets
  Map<DateTime, List<Color>> _generateEventDots(List<TicketModel> wishlistTickets) {
    Map<DateTime, List<Color>> dots = {};

    debugPrint('=== GENERATING EVENT DOTS ===');
    debugPrint('Total wishlist tickets: ${wishlistTickets.length}');

    // Add dots for wishlist tickets based on event date
    for (var ticket in wishlistTickets) {
      try {
        // Parse event date from string - ensure it's a valid date
        if (ticket.eventDate.isEmpty) {
          debugPrint('Skipping ticket ${ticket.artist} - empty event date');
          continue;
        }

        final eventDate = DateTime.parse(ticket.eventDate);
        // Normalize to remove time component
        final dateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);

        debugPrint('Processing ticket: ${ticket.artist}, Event date: ${ticket.eventDate}');

        if (!dots.containsKey(dateKey)) {
          dots[dateKey] = [];
        }

        // Add different colors based on ticket price or other criteria
        Color dotColor;
        if (ticket.ticketPrice >= 20000) {
          dotColor = Colors.orange;
        } else if (ticket.ticketPrice >= 10000) {
          dotColor = Colors.blue;
        } else {
          dotColor = Colors.green;
        }

        dots[dateKey]!.add(dotColor);
        debugPrint('Added $dotColor dot for ticket: ${ticket.artist} on ${DateFormat('yyyy-MM-dd').format(dateKey)}');
      } catch (e) {
        debugPrint('Error parsing date for ticket ${ticket.artist}: $e');
        debugPrint('Event date string: "${ticket.eventDate}"');
      }
    }

    // Debug: Print all dots
    debugPrint('=== EVENT DOTS SUMMARY ===');
    if (dots.isEmpty) {
      debugPrint('No event dots generated');
    } else {
      dots.forEach((date, colors) {
        debugPrint('Date: ${DateFormat('yyyy-MM-dd').format(date)}, Dots: ${colors.length}');
      });
    }

    return dots;
  }

  /// Filter wishlist tickets by selected date
  List<TicketModel> _filterTicketsByDate(List<TicketModel> tickets) {
    if (tickets.isEmpty) {
      debugPrint('No tickets to filter');
      return [];
    }

    debugPrint('Filtering ${tickets.length} tickets for date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');

    final filtered = tickets.where((ticket) {
      try {
        if (ticket.eventDate.isEmpty) {
          return false;
        }

        final eventDate = DateTime.parse(ticket.eventDate);
        final normalizedEventDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
        final normalizedSelectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

        final matches = normalizedEventDate == normalizedSelectedDate;
        if (matches) {
          debugPrint('Found matching ticket: ${ticket.artist} on ${DateFormat('yyyy-MM-dd').format(eventDate)}');
        }
        return matches;
      } catch (e) {
        debugPrint('Error filtering ticket by date: $e');
        return false;
      }
    }).toList();

    debugPrint('Found ${filtered.length} tickets for selected date');
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final wishlistTickets = ticketProvider.wishlistTickets;
    final filteredTickets = _filterTicketsByDate(wishlistTickets);

    // Generate event dots based on wishlist tickets
    final eventDots = _generateEventDots(wishlistTickets);

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTicket()),
                );
              },
              child: Text('Tickets', style: PageService.bigHeaderStyle),
            ),
            PageService.labelSpaceL,
            Text('See all tickets', style: PageService.subheaderStyle),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              ticketProvider.loadWishlist();
              setState(() {}); // Force rebuild
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchCustomSearchField(
                  hintText: 'Search in wishlist',
                  filled: true,
                  onChanged: (value) {
                    // Optional: Add search functionality here
                  },
                ),
                PageService.textSpace12,
              ],
            ),
          ),

          /// Date Picker
          HorizontalDatePicker(
            selectedDate: selectedDate,
            selectedColor: Colors.transparent,
            todayBorderColor: Colors.blue,
            eventDots: eventDots,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
              debugPrint('Selected date: ${DateFormat('yyyy-MM-dd').format(date)}');
            },
          ),

          PageService.textSpacexxL,

          /// Persistent Bottom Sheet - Takes remaining space
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  // Date display row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            DateFormat('dd EEEE, yyyy').format(selectedDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Show total tickets count
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${wishlistTickets.length} total',
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable content area
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: wishlistTickets.isEmpty
                          ? _buildEmptyWishlistState()
                          : filteredTickets.isEmpty
                          ? _buildNoTicketsForDateState(wishlistTickets.length)
                          : ListView(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        children: [
                          // Display filtered tickets for selected date
                          ...filteredTickets.map((ticket) => TicketCard(
                            time: ticket.duration,
                            title: ticket.artist,
                            amount: '₦${ticket.ticketPrice.toStringAsFixed(0).replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]},',
                            )}',
                            location: ticket.location,
                            accentColor: Colors.black,
                            onMenuTap: () {
                              _showTicketOptions(context, ticket, ticketProvider);
                            },
                          )).toList(),

                          // Show message if there are more tickets on other dates
                          if (filteredTickets.length < wishlistTickets.length)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                              child: Text(
                                'You have ${wishlistTickets.length - filteredTickets.length} more ticket${(wishlistTickets.length - filteredTickets.length) == 1 ? '' : 's'} on other dates',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlistState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_num_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No ticket has been added to your wishlist',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTicket()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Tickets to Wishlist',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTicketsForDateState(int totalTickets) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tickets found for ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have $totalTickets ticket${totalTickets == 1 ? '' : 's'} in your wishlist',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Find a date that has tickets and select it
                final provider = Provider.of<TicketProvider>(context, listen: false);
                final wishlistTickets = provider.wishlistTickets;

                if (wishlistTickets.isNotEmpty) {
                  for (var ticket in wishlistTickets) {
                    try {
                      if (ticket.eventDate.isNotEmpty) {
                        final ticketDate = DateTime.parse(ticket.eventDate);
                        setState(() {
                          selectedDate = ticketDate;
                        });
                        break;
                      }
                    } catch (e) {
                      debugPrint('Error parsing ticket date: $e');
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Show My Tickets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketOptions(BuildContext context, TicketModel ticket, TicketProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.remove_circle_outline, color: Colors.red),
                title: const Text('Remove from Wishlist'),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveConfirmation(context, ticket, provider);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.blue),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showTicketDetails(context, ticket);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRemoveConfirmation(BuildContext context, TicketModel ticket, TicketProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Wishlist'),
        content: Text('Are you sure you want to remove "${ticket.artist}" from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeFromWishlist(ticket.ticketRef);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${ticket.artist} from wishlist'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showTicketDetails(BuildContext context, TicketModel ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ticket.artist),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Reference:', ticket.ticketRef),
              _buildDetailRow('Price:', '₦${ticket.ticketPrice.toStringAsFixed(0)}'),
              _buildDetailRow('Location:', ticket.location),
              _buildDetailRow('Duration:', ticket.duration),
              _buildDetailRow('Event Date:', ticket.eventDate.isNotEmpty
                  ? DateFormat('MMM dd, yyyy').format(DateTime.parse(ticket.eventDate))
                  : 'Not set'),
              _buildDetailRow('Available Quantity:', ticket.quantityAvailable.toString()),
              _buildDetailRow('Status:', ticket.purchased ? 'Purchased' : 'Not Purchased'),
              if (ticket.purchased && ticket.purchasedAt.isNotEmpty)
                _buildDetailRow('Purchased On:', ticket.purchasedAt),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}