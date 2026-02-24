// Dashboard Web - Configuration Example
// Copiez ce fichier vers config.js et remplissez avec vos vraies valeurs

const CONFIG = {
  // Supabase Configuration
  supabase: {
    url: 'https://your-project.supabase.co',
    anonKey: 'your_anon_key_here',
  },

  // Backend API Configuration
  api: {
    baseUrl: 'https://your-backend.onrender.com',
    endpoints: {
      hospitals: '/api/hospitals',
      diagnostic: '/api/diagnostic',
      lyra: '/api/lyra',
    },
  },

  // Map Configuration
  map: {
    defaultCenter: {
      lat: 0.0,
      lng: 0.0,
    },
    defaultZoom: 12,
  },

  // Application Settings
  app: {
    name: 'PulseAI Dashboard',
    version: '1.0.0',
    locale: 'fr-FR',
  },

  // Feature Flags
  features: {
    realTimeUpdates: true,
    notifications: true,
    analytics: false,
  },
};

// Export configuration
if (typeof module !== 'undefined' && module.exports) {
  module.exports = CONFIG;
}
