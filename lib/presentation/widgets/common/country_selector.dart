import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/theme.dart';

enum Country {
  thailand('TH', 'Thaïlande', '🇹🇭'),
  vietnam('VN', 'Vietnam', '🇻🇳'),
  japan('JP', 'Japon', '🇯🇵'),
  china('CN', 'Chine', '🇨🇳');

  const Country(this.code, this.name, this.flag);

  final String code;
  final String name;
  final String flag;
}

final selectedCountryProvider = StateProvider<Country>((ref) => Country.japan);

class CountrySelector extends ConsumerWidget {
  const CountrySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(selectedCountryProvider);

    return Row(
      key: const Key('country_selector'),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Country.values.map((country) {
        final isSelected = country == selectedCountry;
        return _CountryButton(
          key: Key('country_${country.code.toLowerCase()}'),
          country: country,
          isSelected: isSelected,
          onTap: () {
            ref.read(selectedCountryProvider.notifier).state = country;
          },
        );
      }).toList(),
    );
  }
}

class _CountryButton extends StatelessWidget {
  final Country country;
  final bool isSelected;
  final VoidCallback onTap;

  const _CountryButton({
    super.key,
    required this.country,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.onBackground.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              country.flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              country.code,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
