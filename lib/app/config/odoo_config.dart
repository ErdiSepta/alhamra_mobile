class OdooConfig {
  // GANTI dengan URL server Odoo Anda
  // Contoh: 'https://your-domain.odoo.com' atau 'http://localhost:8069'
  static const String baseUrl = 'https://v16alhamra.cendana2000.id/';
  
  // GANTI dengan nama database Anda (dari {{db}} di Postman)
  static const String database = 'db_alhamra_prod';
  
  // API endpoints
  static const String loginEndpoint = '/web/session/authenticate';
  static const String logoutEndpoint = '/web/session/destroy';
  
  // Timeout settings
  static const int timeoutSeconds = 30;
}