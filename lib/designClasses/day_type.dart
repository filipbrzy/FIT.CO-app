
enum DayType { monday, tuesday, wednesday, thursday, friday, saturday, sunday;
    @override
    String toString() {
      switch (this) {
        case DayType.monday:
          return 'Mon';
        case DayType.tuesday:
          return 'Tue';
        case DayType.wednesday:
          return 'Wed';
        case DayType.thursday:
          return 'Thu';
        case DayType.friday:
          return 'Fri';
        case DayType.saturday:
          return 'Sat';
        case DayType.sunday:
          return 'Sun';
      }
    }
}