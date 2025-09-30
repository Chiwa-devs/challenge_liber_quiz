// Conditional export helper: on web we use the web implementation, otherwise IO.
// Conditional export helper: on web we use the web implementation, otherwise IO.
export 'database_service_io.dart'
    if (dart.library.html) 'database_service_web.dart';
