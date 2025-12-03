import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../widgets/custom_textform.dart';
import '../../../../../widgets/search.dart';
import '../../../../service/page_service.dart';
import '../../../../ticket/model/ticket_model.dart';
import '../../../../ticket/servicers/ticket_provider_service.dart';
import '../../../../utilities/appcolors.dart';





class AddTicket extends StatefulWidget {
  final TicketModel? preselectedTicket;

  const AddTicket({Key? key, this.preselectedTicket}) : super(key: key);

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  String? _selectedLocation;
  TicketModel? _selectedTicket;
  int _quantity = 0;
  final TextEditingController _ticketSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If a ticket was preselected, use it
    if (widget.preselectedTicket != null) {
      _selectedTicket = widget.preselectedTicket;
      _selectedLocation = widget.preselectedTicket!.location;
      _quantity = 1; // Default quantity

      // Set provider filters to match preselected ticket
      final provider = Provider.of<TicketProvider>(context, listen: false);
      provider.setSelectedLocation(_selectedLocation!);
    } else {
      // Clear any previous selections
      final provider = Provider.of<TicketProvider>(context, listen: false);
      provider.setSelectedLocation('');
      provider.setSearchQuery('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final filteredTickets = ticketProvider.filteredTickets;
    final locations = ticketProvider.getLocations();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add tickets to wishList', style: PageService.bigHeaderStyle),
            PageService.labelSpaceL,
            Text('Withdraw items seamlessly', style: PageService.subheaderStyle),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Selection
                  Text("Location", style: PageService.authLabelStyle),
                  PageService.textSpace,
                  GestureDetector(
                    onTap: () => _showLocationBottomSheet(context, locations),
                    child: CustomSearchField(
                      hintText: _selectedLocation ?? 'Select location',
                      suffixIcon: _selectedLocation != null
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _selectedLocation = null;
                            _selectedTicket = null;
                          });
                          ticketProvider.setSelectedLocation('');
                        },
                      )
                          : const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ),
                  PageService.authTextSpaceL,

                  // Ticket Selection
                  Text("Item", style: PageService.authLabelStyle),
                  PageService.textSpace,
                  GestureDetector(
                    onTap: () => _showTicketsBottomSheet(context, filteredTickets),
                    child: CustomSearchField(
                      hintText: _selectedTicket?.artist ?? 'Select item',
                      suffixIcon: _selectedTicket != null
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _selectedTicket = null;
                            _quantity = 0;
                          });
                        },
                      )
                          : const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ),
                  PageService.textSpace,

                  // Search Tickets
                  CustomSearchField(
                    hintText: 'Search tickets',
                    filled: true,
                    controller: _ticketSearchController,
                    onChanged: (value) {
                      ticketProvider.setSearchQuery(value);
                    },
                  ),

                  // Show Selected Ticket Details (as per design image)
                  if (_selectedTicket != null) ...[
                    PageService.authTextSpaceL,
                    Text("Selected Tickets", style: PageService.authLabelStyle),
                    PageService.textSpace,
                    _buildSelectedTicketDetails(_selectedTicket!),
                  ],

                  // Quantity Selector
                  if (_selectedTicket != null) ...[
                    PageService.authTextSpaceL,
                    Text("Quantity", style: PageService.authLabelStyle),
                    PageService.textSpace,
                    _buildQuantitySelector(),
                    const SizedBox(height: 8),
                    Text(
                      'Select unit',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  // Add to Wishlist Button
                  if (_selectedTicket != null) ...[
                    PageService.authTextSpaceL,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _quantity > 0 ? () {
                          ticketProvider.addToWishlist(_selectedTicket!, _quantity);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${_selectedTicket!.artist} to wishlist'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add to Wishlist',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTicketDetails(TicketModel ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket.artist,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ref No: ${ticket.ticketRef}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Location: ${ticket.location}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₦${ticket.ticketPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Show another ticket example (like in design image)
          if (_selectedLocation == "Lagos" && ticket.artist == "Davido") ...[
            const Divider(height: 24),
            Text(
              'Adekunle Gold',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ref No: 1068692',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Text(
                  '₦10,000',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Location: Lagos',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _quantity > 0
                ? () => setState(() => _quantity--)
                : null,
            icon: const Icon(Icons.remove),
            color: _quantity > 0 ? AppColor.primaryColor : Colors.grey,
            iconSize: 24,
          ),
          Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: _selectedTicket != null &&
                _quantity < _selectedTicket!.quantityAvailable
                ? () => setState(() => _quantity++)
                : null,
            icon: const Icon(Icons.add),
            color: _selectedTicket != null &&
                _quantity < _selectedTicket!.quantityAvailable
                ? AppColor.primaryColor
                : Colors.grey,
            iconSize: 24,
          ),
        ],
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context, List<String> locations) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return ListTile(
                      title: Text(location),
                      trailing: _selectedLocation == location
                          ? Icon(Icons.check, color: AppColor.primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedLocation = location;
                          // Clear selected ticket if location changes
                          if (_selectedTicket != null && _selectedTicket!.location != location) {
                            _selectedTicket = null;
                            _quantity = 0;
                          }
                        });
                        Provider.of<TicketProvider>(context, listen: false)
                            .setSelectedLocation(location);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTicketsBottomSheet(BuildContext context, List<TicketModel> tickets) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Ticket',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return ListTile(
                      title: Text(ticket.artist),
                      subtitle: Text(
                        '₦${ticket.ticketPrice.toStringAsFixed(0)} • ${ticket.location}',
                      ),
                      trailing: _selectedTicket?.ticketRef == ticket.ticketRef
                          ? Icon(Icons.check, color: AppColor.primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedTicket = ticket;
                          _selectedLocation = ticket.location;
                          _quantity = 1; // Default to 1
                        });
                        Provider.of<TicketProvider>(context, listen: false)
                            .setSelectedLocation(ticket.location);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _ticketSearchController.dispose();
    super.dispose();
  }
}