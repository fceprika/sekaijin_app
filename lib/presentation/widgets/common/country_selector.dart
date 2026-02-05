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

    return Wrap(
      key: const Key('country_selector'),
      spacing: 12,
      runSpacing: 12,
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
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lagoon50 : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? scheme.secondary : AppColors.outline,
            width: isSelected ? 1.25 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10),
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
                fontWeight: FontWeight.w700,
                color: isSelected ? scheme.secondary : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
