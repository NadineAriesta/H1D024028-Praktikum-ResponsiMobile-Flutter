class CurrentWeather {
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DailyForecastItem {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final int precipitationProbability;
  final int weatherCode;

  DailyForecastItem({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.precipitationProbability,
    required this.weatherCode,
  });
}

class WeatherForecastModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final List<DailyForecastItem> dailyForecast;

  WeatherForecastModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.dailyForecast,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};

    final times = (dailyJson['time'] as List<dynamic>?)?.cast<String>() ?? [];
    final maxTemps = (dailyJson['temperature_2m_max'] as List<dynamic>?) ?? [];
    final minTemps = (dailyJson['temperature_2m_min'] as List<dynamic>?) ?? [];
    final precips =
        (dailyJson['precipitation_probability_max'] as List<dynamic>?) ?? [];
    final weatherCodes =
        (dailyJson['weather_code'] as List<dynamic>?) ?? [];

    final dailyList = <DailyForecastItem>[];
    for (int i = 0; i < times.length; i++) {
      dailyList.add(DailyForecastItem(
        date: DateTime.tryParse(times[i]) ?? DateTime.now(),
        maxTemperature: (i < maxTemps.length && maxTemps[i] != null)
            ? (maxTemps[i] as num).toDouble()
            : 0.0,
        minTemperature: (i < minTemps.length && minTemps[i] != null)
            ? (minTemps[i] as num).toDouble()
            : 0.0,
        precipitationProbability: (i < precips.length && precips[i] != null)
            ? (precips[i] as num).toInt()
            : 0,
        weatherCode: (i < weatherCodes.length && weatherCodes[i] != null)
            ? (weatherCodes[i] as num).toInt()
            : 0,
      ));
    }

    return WeatherForecastModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'auto',
      current: CurrentWeather.fromJson(currentJson),
      dailyForecast: dailyList,
    );
  }
}
