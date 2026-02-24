// API Configuration
const API_CONFIG = {
  baseURL: 'https://formspree.io/f', // Remplacer par votre ID Formspree
  formspreeId: 'YOUR_FORMSPREE_ID', // À configurer sur formspree.io
  endpoints: {
    contact: '/YOUR_FORMSPREE_ID',
    newsletter: '/YOUR_NEWSLETTER_ID'
  }
};

// Configuration Google Analytics
const GA_MEASUREMENT_ID = 'G-XXXXXXXXXX'; // Remplacer par votre ID Analytics

// Google Drive IDs pour téléchargements
const DOWNLOAD_LINKS = {
  apk: 'https://drive.google.com/uc?export=download&id=YOUR_APK_FILE_ID',
  pressKit: 'https://drive.google.com/uc?export=download&id=YOUR_PRESS_KIT_ID'
};

// Configuration de la version de l'app
const APP_VERSION = {
  current: '2.1.3',
  releaseDate: '2025-12-08',
  minAndroidVersion: '6.0'
};

// Statistiques à afficher
const STATS = {
  diagnostics: 50,
  hospitals: 150,
  satisfaction: 98,
  users: 50000
};

export { API_CONFIG, GA_MEASUREMENT_ID, DOWNLOAD_LINKS, APP_VERSION, STATS };
