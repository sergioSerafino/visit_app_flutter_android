// lib/presentation/widgets/custom_text_field.dart
import 'dart:async';

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final IconData? prefixIcon;
  final void Function(String)? onChanged;
  final String? initialValue;
  final Duration debounceDuration;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.onChanged,
    this.initialValue,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? "1469653179";

    _controller.addListener(() {
      final text = _controller.text;

      // ✏️ Validierung
      if (widget.validator != null) {
        setState(() {
          _errorText = widget.validator!(text);
        });
      }
      // 🕒 Debounced onChanged
      if (widget.onChanged != null) {
        _debounce?.cancel();
        _debounce = Timer(widget.debounceDuration, () {
          widget.onChanged!(text);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearText() {
    _controller.clear();
    setState(() {
      _errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface,
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon,
                color: theme.colorScheme.onSurface.withAlpha(120))
            : null,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear,
                    color: theme.colorScheme.onSurface.withAlpha(120)),
                onPressed: _clearText,
              )
            : null,
        // border: const OutlineInputBorder(),
        errorText: _errorText,
      ),
    );
  }
}
