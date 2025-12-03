import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/service/page_service.dart';

import '../../../../../widgets/custom_textform.dart';
import '../../../../../widgets/search.dart';
import '../../../../ticket/model/ticket_model.dart';
import '../../../../ticket/servicers/ticket_provider_service.dart';
import '../../../../utilities/appcolors.dart';
import 'add_ticket.dart';

class AllTicketHomeScreen extends StatefulWidget {
  const AllTicketHomeScreen({Key? key}) : super(key: key);

  @override
  State<AllTicketHomeScreen> createState() => _AllTicketHomeScreenState();
}

class _AllTicketHomeScreenState extends State<AllTicketHomeScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ticketController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TicketProvider>(context, listen: false);
      provider.setSelectedLocation('');
      provider.setSearchQuery('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final filteredTickets = ticketProvider.filteredTickets;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('List of Tickets', style: PageService.bigHeaderStyle),
            PageService.labelSpaceL,
            Text(
              'Select the tickets you wish to pay for',
              style: PageService.subheaderStyle,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Filter
                  Text("Location", style: PageService.authLabelStyle),
                  PageService.textSpace,
                  CustomSearchField(
                    hintText: 'Select location',
                    controller: _locationController,
                    onChanged: (value) {
                      ticketProvider.setSelectedLocation(value);
                    },
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _locationController.clear();
                        ticketProvider.setSelectedLocation('');
                      },
                    ),
                  ),
                  PageService.authTextSpaceL,

                  // Ticket Filter
                  Text("Tickets", style: PageService.authLabelStyle),
                  PageService.textSpace,
                  CustomSearchField(
                    hintText: 'Select Tickets',
                    controller: _ticketController,
                    onChanged: (value) {
                      ticketProvider.setSearchQuery(value);
                    },
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _ticketController.clear();
                        ticketProvider.setSearchQuery('');
                      },
                    ),
                  ),
                  PageService.textSpace,

                  // Search Filter
                  SearchCustomSearchField(
                    hintText: 'Search by artist, location, or ref number',
                    filled: true,
                    onChanged: (value) {
                      ticketProvider.setSearchQuery(value);
                    },
                  ),
                  PageService.textSpaceL,

                  // Tickets List
                  if (filteredTickets.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No tickets found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    ...filteredTickets
                        .map((ticket) => _buildTicketTile(ticket))
                        .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTile(TicketModel ticket) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTicket(preselectedTicket: ticket),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            // Rectangular Checkbox (always unselected - just for visual)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),

            // Ticket Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.artist,
                    style: PageService.ticketLabelStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: PageService.ticketSpan1LabelStyle.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(text: 'Ref No:'),
                        TextSpan(
                          text: ' ${ticket.ticketRef}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Price and Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₦${ticket.ticketPrice.toStringAsFixed(0)}',
                  style: PageService.ticketLabelStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Location: ${ticket.location}',
                  style: PageService.ticketSpan1LabelStyle.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _ticketController.dispose();
    super.dispose();
  }
}
