# Kedul (Project discontinued)

Booking/Scheduling app project that has since been discontinued. Project archived and shared for educational/referential purposes

Bulk of work found in the following PR https://github.com/minheq/kedul_app_main/pull/12

## Localization

```zshrc
flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/l10n/localization.dart
flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/localization.dart lib/l10n/intl_*.arb
```
