/// Discriminator for the five recurrence flavors a [ScheduledItem] supports.
///
/// Persisted by *name* (not index) so adding or reordering values does not
/// invalidate existing storage blobs. See
/// `docs/scheduler/architecture.md` §2.3.
enum RecurrenceKind { oneOff, daily, weekly, monthlyByDay, yearly }

extension RecurrenceKindCodec on RecurrenceKind {
  /// Stable JSON identifier — the enum's Dart name.
  String get jsonName {
    switch (this) {
      case RecurrenceKind.oneOff:
        return 'oneOff';
      case RecurrenceKind.daily:
        return 'daily';
      case RecurrenceKind.weekly:
        return 'weekly';
      case RecurrenceKind.monthlyByDay:
        return 'monthlyByDay';
      case RecurrenceKind.yearly:
        return 'yearly';
    }
  }

  /// Inverse of [jsonName]. Throws [ArgumentError] on an unknown identifier.
  static RecurrenceKind fromJsonName(String name) {
    switch (name) {
      case 'oneOff':
        return RecurrenceKind.oneOff;
      case 'daily':
        return RecurrenceKind.daily;
      case 'weekly':
        return RecurrenceKind.weekly;
      case 'monthlyByDay':
        return RecurrenceKind.monthlyByDay;
      case 'yearly':
        return RecurrenceKind.yearly;
      default:
        throw ArgumentError.value(name, 'name', 'Unknown RecurrenceKind');
    }
  }
}
