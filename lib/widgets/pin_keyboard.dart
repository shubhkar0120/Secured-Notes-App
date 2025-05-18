// lib/widgets/pin_keyboard.dart
import 'package:flutter/material.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback? onSubmit;
  final bool showSubmitButton;

  const PinKeyboard({
    Key? key,
    required this.onKeyPressed,
    required this.onDelete,
    this.onSubmit,
    this.showSubmitButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberKey('1', context),
              _buildNumberKey('2', context),
              _buildNumberKey('3', context),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberKey('4', context),
              _buildNumberKey('5', context),
              _buildNumberKey('6', context),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberKey('7', context),
              _buildNumberKey('8', context),
              _buildNumberKey('9', context),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              showSubmitButton && onSubmit != null
                  ? _buildActionButton(
                      icon: Icons.check_circle_outline,
                      onPressed: onSubmit!,
                      context: context,
                    )
                  : const SizedBox(width: 72, height: 72),
              _buildNumberKey('0', context),
              _buildActionButton(
                icon: Icons.backspace_outlined,
                onPressed: onDelete,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberKey(String number, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => onKeyPressed(number),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.grey[800] : Colors.grey[200],
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.grey[800] : Colors.grey[200],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 28,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

