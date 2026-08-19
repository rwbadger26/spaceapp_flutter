class Constants {
  // NASA APOD API
  static const String nasaApiKey = String.fromEnvironment(
    'NASA_API_KEY',
    defaultValue: 'DEMO_KEY',
  );
  static const String apodBaseUrl = 'https://api.nasa.gov/planetary/apod';
  static const String launchLibraryUrl =
      'https://ll.thespacedevs.com/2.3.0/launches/upcoming/?limit=10';
  //static const String apodBaseUrl = 'pogger';
}
