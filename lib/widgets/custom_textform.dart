import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool filled;
  final bool showClearIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchField({
    Key? key,
    this.controller,
    this.hintText = "Search...",
    this.onChanged,
    this.filled = false,
    this.showClearIcon = true,
    this.suffixIcon,
    this.enabled = true,
    this.onClear,
  }) : super(key: key);

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late TextEditingController _internalController;
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(CustomSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _internalController.removeListener(_onTextChanged);
      _internalController = widget.controller ?? TextEditingController();
      _internalController.addListener(_onTextChanged);
      _updateClearIcon();
    }
  }

  void _onTextChanged() {
    _updateClearIcon();
    widget.onChanged?.call(_internalController.text);
  }

  void _updateClearIcon() {
    final shouldShow = _internalController.text.isNotEmpty && widget.showClearIcon;
    if (_showClearIcon != shouldShow) {
      setState(() {
        _showClearIcon = shouldShow;
      });
    }
  }

  void _clearText() {
    _internalController.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _internalController,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      enabled: widget.enabled,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: widget.filled,
        fillColor: widget.filled ? Color(0xffF5F5F5) : Colors.transparent,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Color(0xff8A96A3),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        suffixIcon: _buildSuffixIcon(),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDEDEDE)),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDEDEDE)),
          borderRadius: BorderRadius.circular(6),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDEDEDE)),
          borderRadius: BorderRadius.circular(6),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDEDEDE)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    // If custom suffix icon is provided, use it
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    // Show clear icon when there's text
    if (_showClearIcon) {
      return IconButton(
        icon: Icon(
          Icons.clear,
          color: Color(0xff8A96A3),
          size: 20,
        ),
        onPressed: _clearText,
      );
    }

    // Default suffix icon (down arrow)
    return const Icon(
      Icons.keyboard_arrow_down_rounded,
      color: Color(0xff8A96A3),
    );
  }

  @override
  void dispose() {
    _internalController.removeListener(_onTextChanged);
    // Only dispose if we created it internally
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }
}