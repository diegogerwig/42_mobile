String decodeWMO(int code) {
  switch (code) {
    case 0: return 'Clear sky';
    case 1: return 'Mainly clear';
    case 2: return 'Partly cloudy';
    case 3: return 'Overcast';
    case 45: case 48: return 'Fog';
    case 51: case 53: case 55: return 'Drizzle';
    case 56: case 57: return 'Freezing Drizzle';
    case 61: case 63: case 65: return 'Rain';
    case 66: case 67: return 'Freezing Rain';
    case 71: case 73: case 75: return 'Snow fall';
    case 77: return 'Snow grains';
    case 80: case 81: case 82: return 'Rain showers';
    case 85: case 86: return 'Snow showers';
    case 95: return 'Thunderstorm';
    case 96: case 99: return 'Thunderstorm with hail';
    default: return 'Unknown';
  }
}

class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  CurrentWeather({required this.temperature, required this.windSpeed, required this.weatherCode});
}

class HourlyWeather {
  final String time;
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  HourlyWeather({required this.time, required this.temperature, required this.windSpeed, required this.weatherCode});
}

class DailyWeather {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;
  DailyWeather({required this.date, required this.maxTemp, required this.minTemp, required this.weatherCode});
}

class WeatherData {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherData({required this.current, required this.hourly, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // Parse current
    final currentJson = json['current'] ?? {};
    final current = CurrentWeather(
      temperature: (currentJson['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (currentJson['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      weatherCode: currentJson['weather_code'] ?? 0,
    );

    // Parse hourly
    final hourlyJson = json['hourly'] ?? {};
    final List<dynamic> times = hourlyJson['time'] ?? [];
    final List<dynamic> temps = hourlyJson['temperature_2m'] ?? [];
    final List<dynamic> winds = hourlyJson['wind_speed_10m'] ?? [];
    final List<dynamic> codes = hourlyJson['weather_code'] ?? [];
    
    List<HourlyWeather> hourlyList = [];
    int hourlyCount = times.length < 24 ? times.length : 24; // Grabbing just the first 24 hrs for 'Today'
    for (int i = 0; i < hourlyCount; i++) {
      hourlyList.add(HourlyWeather(
        time: times[i],
        temperature: (temps[i] as num?)?.toDouble() ?? 0.0,
        windSpeed: (winds[i] as num?)?.toDouble() ?? 0.0,
        weatherCode: codes[i] ?? 0,
      ));
    }

    // Parse daily
    final dailyJson = json['daily'] ?? {};
    final List<dynamic> dTimes = dailyJson['time'] ?? [];
    final List<dynamic> dMax = dailyJson['temperature_2m_max'] ?? [];
    final List<dynamic> dMin = dailyJson['temperature_2m_min'] ?? [];
    final List<dynamic> dCodes = dailyJson['weather_code'] ?? [];

    List<DailyWeather> dailyList = [];
    int dailyCount = dTimes.length < 7 ? dTimes.length : 7; // Grabbing 7 days
    for (int i = 0; i < dailyCount; i++) {
      dailyList.add(DailyWeather(
        date: dTimes[i],
        maxTemp: (dMax[i] as num?)?.toDouble() ?? 0.0,
        minTemp: (dMin[i] as num?)?.toDouble() ?? 0.0,
        weatherCode: dCodes[i] ?? 0,
      ));
    }

    return WeatherData(current: current, hourly: hourlyList, daily: dailyList);
  }
}
