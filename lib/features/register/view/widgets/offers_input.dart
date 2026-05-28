import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class OffersInput extends StatelessWidget {
  final List<String> offers;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const OffersInput({
    super.key,
    required this.offers,
    required this.onAdd,
    required this.onRemove,
  });

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kSurfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Agregar servicio',
          style: TextStyle(color: kTextPrimary, fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: kTextPrimary),
          decoration: InputDecoration(
            hintText: 'Ej: Tortas de cumpleaños',
            hintStyle: const TextStyle(color: kTextSecondary),
            filled: true,
            fillColor: kBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (v) {
            onAdd(v);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar',
                style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () {
              onAdd(controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Agregar',
                style: TextStyle(color: kAccentBlue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...offers.map(
          (offer) => _OfferChip(
            label: offer,
            onRemove: () => onRemove(offer),
          ),
        ),
        GestureDetector(
          onTap: () => _showAddDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: kSurfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kTextSecondary.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: kTextSecondary, size: 14),
                SizedBox(width: 4),
                Text(
                  'Agregar',
                  style: TextStyle(color: kTextSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OfferChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _OfferChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccentBlue.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: kTextPrimary, fontSize: 13),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, color: kTextSecondary, size: 14),
          ),
        ],
      ),
    );
  }
}
