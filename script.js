/* ══════════════════════════════════════════════
   PULSE AI — Interactive JS
   Features: i18n (EN/FR), Dark/Light theme,
             Navbar scroll, Particles, AOS,
             Triage demo rotation, Smooth scroll
══════════════════════════════════════════════ */

(function () {
  'use strict';

  /* ══════════════════════════════
     1. TRANSLATIONS DICTIONARY
  ══════════════════════════════ */
  const i18n = {
    en: {
      /* Navbar */
      'nav.problem': 'Problem',
      'nav.solution': 'Solution',
      'nav.how': 'How It Works',
      'nav.whatsapp': 'WhatsApp',
      'nav.dashboard': 'Dashboard',
      'nav.vision': 'Vision',
      'nav.chatWA': 'Chat on WhatsApp',
      'nav.tryPulse': 'Try PULSE AI',

      /* Hero */
      'hero.badge': 'Built for Africa · Powered by AI',
      'hero.title1': 'AI-Powered Patient Routing',
      'hero.title2': 'for African Healthcare Systems',
      'hero.sub1': 'Helping patients reach the right care',
      'hero.sub2': "before it's too late.",
      'hero.sub3': 'Intelligent triage, real-time routing, and hospital coordination — at scale.',
      'hero.cta1': 'Try PULSE AI Web',
      'hero.cta2': 'Chat with PULSE AI on WhatsApp',
      'hero.stat1': 'African Countries',
      'hero.stat2num': 'Real-Time',
      'hero.stat2': 'Hospital Routing',
      'hero.stat3': 'Severity Scoring',
      'hero.scroll': 'Scroll to explore',

      /* Problem */
      'problem.tag': 'The Crisis',
      'problem.title': 'A Healthcare System in Crisis',
      'problem.sub': "Every day across Africa, thousands of preventable deaths occur — not because treatment doesn't exist, but because patients cannot access it in time.",
      'problem.card1.title': 'Overcrowded Hospitals',
      'problem.card1.body': 'Emergency units are overwhelmed with patients who could be treated elsewhere, while specialist facilities remain underutilized.',
      'problem.card2.title': 'Delayed Access to Care',
      'problem.card2.body': 'Patients travel blindly, unaware of where specialists or available beds exist — losing precious hours in critical situations.',
      'problem.card3.title': 'Preventable Deaths',
      'problem.card3.body': '1 in 3 emergency deaths in Africa are linked to delayed care — tragedies that proper routing and triage systems could prevent.',
      'problem.card4.title': 'No Real-Time Coordination',
      'problem.card4.body': 'Hospitals operate in silos with no shared data. Ambulances, patients, and healthcare workers have no visibility into system-wide capacity.',
      'problem.pstat1': 'Preventable deaths per year in Sub-Saharan Africa',
      'problem.pstat2': 'Higher mortality rate when patients miss the right facility',
      'problem.pstat3': 'Of African hospitals have real-time triage infrastructure',

      /* Solution */
      'solution.tag': 'The Solution',
      'solution.title': 'How PULSE AI Solves This',
      'solution.sub': 'A unified AI-powered platform that intelligently bridges patients and healthcare resources — in real time.',
      'solution.card1.title': 'Intelligent Symptom Analysis',
      'solution.card1.body': 'PULSE AI uses NLP and clinical reasoning models to interpret patient-reported symptoms and generate a precise medical profile.',
      'solution.card1.tag': 'AI-Powered NLP',
      'solution.card2.title': 'AI Severity Scoring',
      'solution.card2.body': 'Every case receives a dynamic severity score — from low to critical — to ensure urgent patients are prioritised and never lost in a queue.',
      'solution.card2.tag': 'Triage Intelligence',
      'solution.card3.title': 'Smart Real-Time Routing',
      'solution.card3.body': 'Our routing engine matches patients to the optimal hospital based on urgency, proximity, specialist availability, and live bed capacity.',
      'solution.card3.tag': 'Dynamic Routing',
      'solution.card4.title': 'Resource Optimization',
      'solution.card4.body': 'By distributing patient load intelligently, PULSE AI reduces hospital overcrowding and ensures maximum utilization of available resources across a region.',
      'solution.card4.tag': 'Load Balancing',

      /* How it works */
      'how.tag': 'The Process',
      'how.title': 'How PULSE AI Works',
      'how.sub': 'Five steps from symptoms to the right hospital \u2014 in under 2 minutes.',
      'how.step1.title': 'Describe Your Symptoms',
      'how.step1.body': 'Enter symptoms by text, voice, or photo via the PULSE AI web app or WhatsApp — available in French, English, Ewe, Hausa, Yoruba and more. Works offline too.',
      'how.step2.title': 'AI Preliminary Diagnosis (RuralDiag)',
      'how.step2.body': 'Our RAG-powered AI analyses symptoms using a curated medical corpus. It generates a preliminary diagnosis, first-aid advice, and an urgency score in seconds.',
      'how.step3.title': 'Live Hospital Availability',
      'how.step3.body': 'PULSE AI queries the hospital dashboard network in real time — checking bed occupancy, specialist schedules, and ER capacity across all registered facilities nearby.',
      'how.step4.title': 'Smart Routing to Best Hospital (SmartHosp)',
      'how.step4.body': 'Our SmartHosp algorithm ranks hospitals by urgency match, specialist availability, bed count, and distance — then gives turn-by-turn directions to the optimal facility.',
      'how.step5.title': 'Follow-Up & Case History (Lyra)',
      'how.step5.body': 'After your visit, PULSE AI stores your consultation history. Lyra, our mental health AI, follows up on your wellbeing. The hospital dashboard receives alerts for incoming critical patients.',
      'how.triage.header': 'PULSE AI · Live Triage Analysis',
      'how.triage.input': 'Patient Symptoms',
      'how.triage.critical': 'CRITICAL',

      /* WhatsApp */
      'wa.tag': 'No App Required',
      'wa.title1': 'Accessible via WhatsApp —',
      'wa.title2': 'Anywhere in Africa',
      'wa.sub': 'Smartphones are everywhere. PULSE AI leverages WhatsApp — the most widely used messaging platform on the continent — to deliver AI-powered healthcare assistance even in low-connectivity environments.',
      'wa.feat1.strong': 'No download required',
      'wa.feat1.rest': 'works on any basic smartphone with WhatsApp',
      'wa.feat2.strong': 'Multilingual support',
      'wa.feat2.rest': 'Swahili, Hausa, French, Yoruba & more',
      'wa.feat3.strong': 'Low-bandwidth optimized',
      'wa.feat3.rest': 'works even with 2G connections',
      'wa.feat4.strong': 'Instant AI triage',
      'wa.feat4.rest': 'get a severity score and hospital recommendation in under 60 seconds',
      'wa.cta': 'Message PULSE AI on WhatsApp',

      /* Dashboard */
      'dash.tag': 'For Hospitals',
      'dash.title': 'A Real-Time Control Center for Healthcare Facilities',
      'dash.sub': 'PULSE AI equips hospital administrators and emergency teams with a live intelligence dashboard — giving them the visibility they need to respond faster and smarter.',
      'dash.feat1.title': 'Monitor Incoming Patients',
      'dash.feat1.body': 'See who is en route, their severity score, and estimated arrival time in real time.',
      'dash.feat2.title': 'View Resource Availability',
      'dash.feat2.body': 'Live view of bed occupancy, specialist schedules, ICU status, and equipment availability.',
      'dash.feat3.title': 'Receive Urgent Case Alerts',
      'dash.feat3.body': 'Automatic push alerts for critical incoming cases — so your team can prepare before the patient arrives.',
      'dash.cta': 'Request Hospital Access →',

      /* Vision */
      'vision.tag': 'Our Vision',
      'vision.quote1': '"PULSE AI is not just an application —',
      'vision.quote2': 'it is an AI-powered healthcare coordination infrastructure built for Africa."',
      'vision.sub': 'We believe every patient on this continent deserves access to the right care, at the right time, regardless of geography or income. PULSE AI is our commitment to making that a reality — one routing decision at a time.',
      'vision.m1.title': 'Pan-African Reach',
      'vision.m1.body': 'Deploy across 10 pilot cities in 5 countries by 2026',
      'vision.m2.title': 'Hospital Network',
      'vision.m2.body': 'Partner with 500+ public and private facilities',
      'vision.m3.title': 'Lives Saved',
      'vision.m3.body': 'Target 50,000+ lives improved through timely routing',
      'vision.cta1': 'Start with WhatsApp',
      'vision.cta2': 'Partner with Us',

      /* Footer */
      'footer.brand': "AI-powered healthcare coordination infrastructure built for Africa. Routing patients to the right care before it's too late.",
      'footer.col1.title': 'Product',
      'footer.col1.l1': 'PULSE AI Web App',
      'footer.col1.l2': 'PULSE AI WhatsApp',
      'footer.col1.l3': 'Hospital Dashboard',
      'footer.col2.title': 'Company',
      'footer.col2.l1': 'Our Vision',
      'footer.col2.l2': 'About 34AI',
      'footer.col2.l3': 'Contact',
      'footer.copy': '© 2025 PULSE AI. AI-Powered Healthcare for Africa.',
      'footer.love': 'Made with love for African healthcare systems',
    },

    /* ────────────── FRENCH ────────────── */
    fr: {
      /* Navbar */
      'nav.problem': 'Problème',
      'nav.solution': 'Solution',
      'nav.how': 'Comment ça marche',
      'nav.whatsapp': 'WhatsApp',
      'nav.dashboard': 'Tableau de bord',
      'nav.vision': 'Vision',
      'nav.chatWA': 'Discuter sur WhatsApp',
      'nav.tryPulse': 'Essayer PULSE AI',

      /* Hero */
      'hero.badge': 'Conçu pour l\'Afrique · Propulsé par l\'IA',
      'hero.title1': 'Orientation des Patients par IA',
      'hero.title2': 'pour les Systèmes de Santé Africains',
      'hero.sub1': 'Aider les patients à accéder aux bons soins',
      'hero.sub2': 'avant qu\'il ne soit trop tard.',
      'hero.sub3': 'Triage intelligent, orientation en temps réel et coordination hospitalière — à grande échelle.',
      'hero.cta1': 'Essayer PULSE AI Web',
      'hero.cta2': 'Discuter avec PULSE AI sur WhatsApp',
      'hero.stat1': 'Pays Africains',
      'hero.stat2num': 'Temps Réel',
      'hero.stat2': 'Orientation Hospitalière',
      'hero.stat3': 'Score de Sévérité IA',
      'hero.scroll': 'Faites défiler pour explorer',

      /* Problem */
      'problem.tag': 'La Crise',
      'problem.title': 'Un Système de Santé en Crise',
      'problem.sub': 'Chaque jour en Afrique, des milliers de décès évitables surviennent — non pas parce que les traitements n\'existent pas, mais parce que les patients ne peuvent y accéder à temps.',
      'problem.card1.title': 'Hôpitaux Surchargés',
      'problem.card1.body': 'Les urgences sont submergées par des patients qui pourraient être soignés ailleurs, tandis que les établissements spécialisés restent sous-utilisés.',
      'problem.card2.title': 'Accès aux Soins Retardé',
      'problem.card2.body': 'Les patients errent sans information sur les spécialistes ou les lits disponibles, perdant des heures précieuses dans des situations critiques.',
      'problem.card3.title': 'Décès Évitables',
      'problem.card3.body': '1 décès d\'urgence sur 3 en Afrique est lié à des soins tardifs — des tragédies que des systèmes de triage appropriés pourraient éviter.',
      'problem.card4.title': 'Aucune Coordination en Temps Réel',
      'problem.card4.body': 'Les hôpitaux fonctionnent en silos sans données partagées. Les ambulances, les patients et les soignants n\'ont aucune visibilité sur la capacité globale du système.',
      'problem.pstat1': 'Décès évitables par an en Afrique subsaharienne',
      'problem.pstat2': 'Taux de mortalité plus élevé quand les patients manquent le bon établissement',
      'problem.pstat3': 'Des hôpitaux africains disposent d\'une infrastructure de triage en temps réel',

      /* Solution */
      'solution.tag': 'La Solution',
      'solution.title': 'Comment PULSE AI Résout Ce Problème',
      'solution.sub': 'Une plateforme IA unifiée qui relie intelligemment les patients aux ressources de santé — en temps réel.',
      'solution.card1.title': 'Analyse des Symptômes',
      'solution.card1.body': 'PULSE AI utilise le NLP et des modèles de raisonnement clinique pour interpréter les symptômes et générer un profil médical précis.',
      'solution.card1.tag': 'NLP Médical IA',
      'solution.card2.title': 'Score de Sévérité IA',
      'solution.card2.body': 'Chaque cas reçoit un score de sévérité dynamique — de faible à critique — pour prioriser les patients urgents et éviter qu\'ils ne soient perdus dans une file d\'attente.',
      'solution.card2.tag': 'Intelligence de Triage',
      'solution.card3.title': 'Orientation en Temps Réel',
      'solution.card3.body': 'Notre moteur d\'orientation oriente les patients vers l\'hôpital optimal en fonction de l\'urgence, de la proximité, de la disponibilité des spécialistes et de la capacité en lits.',
      'solution.card3.tag': 'Orientation Dynamique',
      'solution.card4.title': 'Optimisation des Ressources',
      'solution.card4.body': 'En distribuant la charge de patients intelligemment, PULSE AI réduit la surpopulation hospitalière et maximise l\'utilisation des ressources disponibles.',
      'solution.card4.tag': 'Équilibrage de Charge',

      /* How it works */
      'how.tag': 'Le Processus',
      'how.title': 'Comment Fonctionne PULSE AI',
      'how.sub': 'Cinq étapes, des symptômes au bon hôpital \u2014 en moins de 2 minutes.',
      'how.step1.title': 'Décrire les Symptômes',
      'how.step1.body': 'Saisissez les symptômes par texte, voix ou photo via l\'application web ou WhatsApp — disponible en français, anglais, ewe, haoussa, yoruba et plus. Fonctionne hors ligne.',
      'how.step2.title': 'Diagnostic Préliminaire IA (RuralDiag)',
      'how.step2.body': 'Notre IA RAG analyse les symptômes avec un corpus médical enrichi. Elle génère un diagnostic préliminaire, des premiers soins et un score d\'urgence en quelques secondes.',
      'how.step3.title': 'Disponibilité Hospitalière en Temps Réel',
      'how.step3.body': 'PULSE AI interroge le réseau de tableaux de bord hospitaliers — vérifiant l\'occupation des lits, les plannings des spécialistes et la capacité des urgences en temps réel.',
      'how.step4.title': 'Orientation Intelligente (SmartHosp)',
      'how.step4.body': 'L\'algorithme SmartHosp classe les hôpitaux proches selon l\'urgence, les spécialistes disponibles, le nombre de lits et la distance — puis fournit l\'itinéraire optimal.',
      'how.step5.title': 'Suivi & Historique (Lyra)',
      'how.step5.body': 'Après la consultation, PULSE AI conserve l\'historique. Lyra, notre IA de santé mentale, assure le suivi du bien-être. Le tableau de bord hospitalier reçoit des alertes pour les cas critiques entrants.',
      'how.triage.header': 'PULSE AI · Analyse de Triage en Direct',
      'how.triage.input': 'Symptômes du Patient',
      'how.triage.critical': 'CRITIQUE',

      /* WhatsApp */
      'wa.tag': 'Sans Téléchargement',
      'wa.title1': 'Accessible via WhatsApp —',
      'wa.title2': 'Partout en Afrique',
      'wa.sub': 'Les smartphones sont partout. PULSE AI exploite WhatsApp — la plateforme de messagerie la plus utilisée sur le continent — pour fournir une assistance médicale IA même dans des environnements à faible connectivité.',
      'wa.feat1.strong': 'Aucun téléchargement requis',
      'wa.feat1.rest': 'fonctionne sur tout smartphone basique avec WhatsApp',
      'wa.feat2.strong': 'Support multilingue',
      'wa.feat2.rest': 'Swahili, Haoussa, Français, Yoruba & plus',
      'wa.feat3.strong': 'Optimisé faible bande passante',
      'wa.feat3.rest': 'fonctionne même avec une connexion 2G',
      'wa.feat4.strong': 'Triage IA instantané',
      'wa.feat4.rest': 'obtenez un score de sévérité et une recommandation d\'hôpital en moins de 60 secondes',
      'wa.cta': 'Envoyer un message à PULSE AI sur WhatsApp',

      /* Dashboard */
      'dash.tag': 'Pour les Hôpitaux',
      'dash.title': 'Un Centre de Contrôle en Temps Réel pour les Établissements de Santé',
      'dash.sub': 'PULSE AI équipe les administrateurs hospitaliers et les équipes d\'urgence d\'un tableau de bord intelligent en direct — leur donnant la visibilité nécessaire pour répondre plus vite et plus intelligemment.',
      'dash.feat1.title': 'Surveiller les Patients Entrants',
      'dash.feat1.body': 'Voyez qui est en route, leur score de sévérité et l\'heure d\'arrivée estimée en temps réel.',
      'dash.feat2.title': 'Voir la Disponibilité des Ressources',
      'dash.feat2.body': 'Vue en direct de l\'occupation des lits, des plannings des spécialistes, du statut de la réanimation et de la disponibilité des équipements.',
      'dash.feat3.title': 'Recevoir des Alertes de Cas Urgents',
      'dash.feat3.body': 'Alertes push automatiques pour les cas critiques entrants — pour que votre équipe se prépare avant l\'arrivée du patient.',
      'dash.cta': 'Demander un Accès Hospitalier →',

      /* Vision */
      'vision.tag': 'Notre Vision',
      'vision.quote1': '"PULSE AI n\'est pas seulement une application —',
      'vision.quote2': 'c\'est une infrastructure de coordination des soins de santé propulsée par l\'IA, construite pour l\'Afrique."',
      'vision.sub': 'Nous croyons que chaque patient sur ce continent mérite d\'accéder aux bons soins, au bon moment, quelle que soit sa géographie ou ses revenus. PULSE AI est notre engagement à en faire une réalité — une décision d\'orientation à la fois.',
      'vision.m1.title': 'Portée Pan-Africaine',
      'vision.m1.body': 'Déploiement dans 10 villes pilotes dans 5 pays d\'ici 2026',
      'vision.m2.title': 'Réseau Hospitalier',
      'vision.m2.body': 'Partenariat avec 500+ établissements publics et privés',
      'vision.m3.title': 'Vies Sauvées',
      'vision.m3.body': 'Objectif : 50 000+ vies améliorées grâce à une orientation rapide',
      'vision.cta1': 'Commencer sur WhatsApp',
      'vision.cta2': 'Devenir Partenaire',

      /* Footer */
      'footer.brand': 'Infrastructure de coordination des soins propuls\u00e9e par l\'IA, construite pour l\'Afrique.',
      'footer.col1.title': 'Produit',
      'footer.col1.l1': 'PULSE AI Web App',
      'footer.col1.l2': 'PULSE AI WhatsApp',
      'footer.col1.l3': 'Tableau de bord hospitalier',
      'footer.col2.title': 'Entreprise',
      'footer.col2.l1': 'Notre Vision',
      'footer.col2.l2': '\u00c0 propos de 34AI',
      'footer.col2.l3': 'Contact',
      'footer.copy': '\u00a9 2025 PULSE AI. Soins de Sant\u00e9 IA pour l\'Afrique.',
      'footer.love': 'Fait avec amour pour les syst\u00e8mes de sant\u00e9 africains',
    }
  };

  /* ══════════════════════════════
     2. LANGUAGE SYSTEM
  ══════════════════════════════ */
  let currentLang = localStorage.getItem('pulse-lang') || 'en';

  function applyLanguage(lang) {
    currentLang = lang;
    localStorage.setItem('pulse-lang', lang);
    document.documentElement.lang = lang;

    const dict = i18n[lang];
    document.querySelectorAll('[data-i18n]').forEach(el => {
      const key = el.getAttribute('data-i18n');
      if (dict[key] !== undefined) {
        el.textContent = dict[key];
        /* Special: footer.copy has HTML entity — use innerHTML */
        if (key === 'footer.copy') el.innerHTML = dict[key];
      }
    });

    /* Highlight active lang button */
    document.querySelectorAll('.lang-btn').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.lang === lang);
    });
  }

  /* Event listeners for lang buttons */
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.addEventListener('click', () => applyLanguage(btn.dataset.lang));
  });

  /* Apply on load */
  applyLanguage(currentLang);

  /* ══════════════════════════════
     3. THEME — light only (toggle removed)
  ══════════════════════════════ */
  // Theme toggle removed from UI; page always uses light mode.
  document.documentElement.removeAttribute('data-theme');
  localStorage.removeItem('pulse-theme');

  /* ══════════════════════════════
     4. NAVBAR — SCROLL + MOBILE MENU
  ══════════════════════════════ */
  const navbar = document.getElementById('navbar');
  const hamburger = document.getElementById('hamburger');
  const mobileMenu = document.getElementById('mobileMenu');

  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 40);
  }, { passive: true });

  hamburger.addEventListener('click', () => {
    const isOpen = mobileMenu.classList.toggle('open');
    hamburger.classList.toggle('open', isOpen);
    hamburger.setAttribute('aria-expanded', String(isOpen));
  });

  // Close on nav link click
  mobileMenu.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
      mobileMenu.classList.remove('open');
      hamburger.classList.remove('open');
      hamburger.setAttribute('aria-expanded', 'false');
    });
  });

  /* ══════════════════════════════
     5. HERO PARTICLES
  ══════════════════════════════ */
  const particleContainer = document.getElementById('particles');
  for (let i = 0; i < 30; i++) {
    const p = document.createElement('div');
    p.classList.add('particle');
    p.style.left = `${Math.random() * 100}%`;
    p.style.top = `${Math.random() * 100}%`;
    p.style.setProperty('--dur', `${4 + Math.random() * 6}s`);
    p.style.setProperty('--delay', `${Math.random() * 4}s`);
    const size = 2 + Math.random() * 4;
    p.style.width = `${size}px`;
    p.style.height = `${size}px`;
    particleContainer.appendChild(p);
  }

  /* ══════════════════════════════
     6. SCROLL-REVEAL (AOS-lite)
  ══════════════════════════════ */
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      const el = entry.target;
      const delay = parseInt(el.dataset.aosDelay || '0', 10);
      setTimeout(() => el.classList.add('aos-animate'), delay);
      observer.unobserve(el);
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

  document.querySelectorAll('[data-aos]').forEach(el => observer.observe(el));

  /* ══════════════════════════════
     7. ACTIVE NAV HIGHLIGHT
  ══════════════════════════════ */
  const sections = document.querySelectorAll('section[id]');
  const navItems = document.querySelectorAll('.nav-links a');

  new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      navItems.forEach(link => {
        link.classList.toggle('active-link', link.getAttribute('href') === '#' + entry.target.id);
      });
    });
  }, { threshold: 0.4 }).observe && sections.forEach(sec =>
    new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        navItems.forEach(link => {
          link.classList.toggle('active-link', link.getAttribute('href') === '#' + entry.target.id);
        });
      });
    }, { threshold: 0.35 }).observe(sec)
  );

  /* ══════════════════════════════
     8. SMOOTH SCROLL
  ══════════════════════════════ */
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', (e) => {
      const target = document.querySelector(anchor.getAttribute('href'));
      if (target) {
        e.preventDefault();
        window.scrollTo({ top: target.getBoundingClientRect().top + window.scrollY - 80, behavior: 'smooth' });
      }
    });
  });

  /* ══════════════════════════════
     9. TRIAGE DEMO — removed
  ══════════════════════════════ */
  // triage demo section removed from HTML; rotation disabled.

  /* ══════════════════════════════
     10. DX LOG
  ══════════════════════════════ */
  console.log('%c PULSE AI 🌍 | Lang: EN/FR | Light Mode | by 34AI', 'color:#00C9B4;font-size:14px;font-weight:bold;');
})();
