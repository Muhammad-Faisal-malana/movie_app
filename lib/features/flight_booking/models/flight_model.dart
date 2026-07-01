class FlightModel {
  final String id;
  final String airline;
  final String airlineCode;
  final String logo;
  final String from;
  final String fromCode;
  final String to;
  final String toCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String date;
  final double price;
  final int availableSeats;
  final String flightClass;
  final bool hasWifi;
  final bool hasMeals;
  final double rating;

  const FlightModel({
    required this.id,
    required this.airline,
    required this.airlineCode,
    required this.logo,
    required this.from,
    required this.fromCode,
    required this.to,
    required this.toCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.date,
    required this.price,
    required this.availableSeats,
    required this.flightClass,
    required this.hasWifi,
    required this.hasMeals,
    required this.rating,
  });

  static List<FlightModel> getSampleFlights() {
    return [
      const FlightModel(
        id: 'FL001',
        airline: 'SkyPrime Airways',
        airlineCode: 'SP',
        logo: '✈',
        from: 'New York',
        fromCode: 'JFK',
        to: 'London',
        toCode: 'LHR',
        departureTime: '08:30',
        arrivalTime: '20:45',
        duration: '7h 15m',
        date: 'Feb 21, 2026',
        price: 849.0,
        availableSeats: 12,
        flightClass: 'Business',
        hasWifi: true,
        hasMeals: true,
        rating: 4.8,
      ),
      const FlightModel(
        id: 'FL002',
        airline: 'AeroLux',
        airlineCode: 'AL',
        logo: '✈',
        from: 'New York',
        fromCode: 'JFK',
        to: 'London',
        toCode: 'LHR',
        departureTime: '11:15',
        arrivalTime: '23:00',
        duration: '6h 45m',
        date: 'Feb 21, 2026',
        price: 649.0,
        availableSeats: 28,
        flightClass: 'Economy',
        hasWifi: true,
        hasMeals: false,
        rating: 4.5,
      ),
      const FlightModel(
        id: 'FL003',
        airline: 'CloudStar Airlines',
        airlineCode: 'CS',
        logo: '✈',
        from: 'New York',
        fromCode: 'JFK',
        to: 'London',
        toCode: 'LHR',
        departureTime: '15:00',
        arrivalTime: '03:20',
        duration: '7h 20m',
        date: 'Feb 21, 2026',
        price: 1299.0,
        availableSeats: 4,
        flightClass: 'First Class',
        hasWifi: true,
        hasMeals: true,
        rating: 4.9,
      ),
      const FlightModel(
        id: 'FL004',
        airline: 'HorizonJet',
        airlineCode: 'HJ',
        logo: '✈',
        from: 'New York',
        fromCode: 'JFK',
        to: 'London',
        toCode: 'LHR',
        departureTime: '22:45',
        arrivalTime: '10:30',
        duration: '6h 45m',
        date: 'Feb 21, 2026',
        price: 520.0,
        availableSeats: 45,
        flightClass: 'Economy',
        hasWifi: false,
        hasMeals: true,
        rating: 4.2,
      ),
    ];
  }
}
