// script.js - Professional interactions and features
(function() {
  'use strict';

  // Configuration
  const CONFIG = {
    apkUrl: '#', // Remplacer par l'URL réelle de votre APK
    formspreeId: 'YOUR_FORMSPREE_ID', // Configurer sur formspree.io
    stats: {
      diagnostics: 50,
      hospitals: 150,
      satisfaction: 98,
      users: 50000
    }
  };

  // ==================== INITIALIZATION ====================
  document.addEventListener('DOMContentLoaded', initializeApp);

  function initializeApp() {
    console.log('🚀 Pulse AI initializing...');
    
    // Core features
    setupNavigation();
    setupDownloadButtons();
    setupLazyLoading();
    setupIntersectionObserver();
    setupStatsCounter();
    setupFormHandling();
    setupPWA();
    setupNewsCards();
    setupSmoothScroll();
    setupFooterYear();
    
    console.log('✅ Pulse AI ready!');
  }

  // ==================== NAVIGATION ====================
  function setupNavigation() {
    const navToggle = document.getElementById('navToggle');
    const nav = document.querySelector('.nav');
    
    if (navToggle && nav) {
      navToggle.addEventListener('click', () => {
        const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
        navToggle.setAttribute('aria-expanded', !isExpanded);
        nav.classList.toggle('nav-open');
        document.body.classList.toggle('nav-active');
      });

      // Close nav when clicking on a link
      nav.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', () => {
          navToggle.setAttribute('aria-expanded', 'false');
          nav.classList.remove('nav-open');
          document.body.classList.remove('nav-active');
        });
      });

      // Close nav when clicking outside
      document.addEventListener('click', (e) => {
        if (!nav.contains(e.target) && !navToggle.contains(e.target)) {
          navToggle.setAttribute('aria-expanded', 'false');
          nav.classList.remove('nav-open');
          document.body.classList.remove('nav-active');
        }
      });
    }

    // Active nav link on scroll
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.nav a[href^="#"]');
    
    window.addEventListener('scroll', () => {
      let current = '';
      sections.forEach(section => {
        const sectionTop = section.offsetTop;
        if (pageYOffset >= sectionTop - 100) {
          current = section.getAttribute('id');
        }
      });

      navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
          link.classList.add('active');
        }
      });
    });
  }

  // ==================== SMOOTH SCROLL ====================
  function setupSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href === '#') return;
        
        e.preventDefault();
        const target = document.querySelector(href);
        if (target) {
          const headerOffset = 80;
          const elementPosition = target.getBoundingClientRect().top;
          const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

          window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
          });
        }
      });
    });
  }

  // ==================== DOWNLOAD BUTTONS ====================
  function setupDownloadButtons() {
    const apkDownload = document.getElementById('apkDownload');
    
    if (apkDownload) {
      apkDownload.addEventListener('click', (e) => {
        if (CONFIG.apkUrl === '#') {
          e.preventDefault();
          showNotification('info', 'Téléchargement bientôt disponible ! Suivez-nous pour être notifié.');
        } else {
          // Track download with Analytics
          if (typeof gtag !== 'undefined') {
            gtag('event', 'download', {
              'event_category': 'APK',
              'event_label': 'Pulse AI APK Download'
            });
          }
        }
      });
    }
  }

  // ==================== LAZY LOADING IMAGES ====================
  function setupLazyLoading() {
    const images = document.querySelectorAll('img[data-src]');
    
    if ('IntersectionObserver' in window) {
      const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const img = entry.target;
            img.src = img.dataset.src;
            img.classList.add('loaded');
            observer.unobserve(img);
          }
        });
      }, {
        rootMargin: '50px'
      });

      images.forEach(img => imageObserver.observe(img));
    } else {
      // Fallback for older browsers
      images.forEach(img => {
        img.src = img.dataset.src;
      });
    }
  }

  // ==================== INTERSECTION OBSERVER (ANIMATIONS) ====================
  function setupIntersectionObserver() {
    const animatedElements = document.querySelectorAll('.card, .stat-card, .team-member, .news-card, .flow-step');
    
    if ('IntersectionObserver' in window) {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry, index) => {
          if (entry.isIntersecting) {
            setTimeout(() => {
              entry.target.classList.add('fade-in-up');
            }, index * 100);
            observer.unobserve(entry.target);
          }
        });
      }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
      });

      animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        observer.observe(el);
      });
    }
  }

  // ==================== STATS COUNTER ANIMATION ====================
  function setupStatsCounter() {
    const statsNumbers = document.querySelectorAll('.stat-number');
    let hasAnimated = false;

    const animateCounter = (element, target) => {
      const duration = 2000;
      const increment = target / (duration / 16);
      let current = 0;

      const updateCounter = () => {
        current += increment;
        if (current < target) {
          element.textContent = Math.floor(current).toLocaleString('fr-FR');
          requestAnimationFrame(updateCounter);
        } else {
          element.textContent = target.toLocaleString('fr-FR');
        }
      };

      updateCounter();
    };

    const statsObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting && !hasAnimated) {
          hasAnimated = true;
          statsNumbers.forEach(stat => {
            const target = parseInt(stat.getAttribute('data-count'));
            animateCounter(stat, target);
          });
        }
      });
    }, { threshold: 0.5 });

    const statsSection = document.querySelector('.stats-section');
    if (statsSection) {
      statsObserver.observe(statsSection);
    }
  }

  // ==================== FORM HANDLING ====================
  function setupFormHandling() {
    const contactForm = document.getElementById('contactForm');
    
    if (contactForm) {
      // Check if using Formspree
      const action = contactForm.getAttribute('action');
      
      if (action && !action.includes('YOUR_FORMSPREE_ID')) {
        // Formspree is configured - add success message handling
        contactForm.addEventListener('submit', (e) => {
          const btn = contactForm.querySelector('button[type="submit"]');
          btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Envoi...';
          btn.disabled = true;
        });
      } else {
        // Formspree not configured - handle locally
        contactForm.addEventListener('submit', (e) => {
          e.preventDefault();
          
          const name = document.getElementById('name').value.trim();
          const email = document.getElementById('email').value.trim();
          const message = document.getElementById('message').value.trim();
          
          if (!name || !email || !message) {
            showNotification('error', 'Merci de remplir tous les champs obligatoires.');
            return;
          }

          const btn = contactForm.querySelector('button[type="submit"]');
          const originalText = btn.innerHTML;
          btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Envoi...';
          btn.disabled = true;

          // Simulate sending
          setTimeout(() => {
            btn.innerHTML = '<i class="fas fa-check"></i> Envoyé !';
            showNotification('success', `Merci ${name} ! Votre message a été envoyé. Nous vous répondrons sous 48h.`);
            contactForm.reset();
            
            setTimeout(() => {
              btn.innerHTML = originalText;
              btn.disabled = false;
            }, 3000);
          }, 1500);
        });
      }
    }
  }

  // ==================== PWA INSTALLATION ====================
  function setupPWA() {
    let deferredPrompt;

    window.addEventListener('beforeinstallprompt', (e) => {
      e.preventDefault();
      deferredPrompt = e;
      
      // Show install button
      const installBtn = document.createElement('button');
      installBtn.className = 'btn btn-primary install-pwa';
      installBtn.innerHTML = '<i class="fas fa-download"></i> Installer l\'App';
      installBtn.style.position = 'fixed';
      installBtn.style.bottom = '20px';
      installBtn.style.right = '20px';
      installBtn.style.zIndex = '9999';
      installBtn.style.boxShadow = '0 8px 24px rgba(37,99,235,0.3)';
      
      installBtn.addEventListener('click', async () => {
        deferredPrompt.prompt();
        const { outcome } = await deferredPrompt.userChoice;
        console.log(`User response to install prompt: ${outcome}`);
        deferredPrompt = null;
        installBtn.remove();
      });
      
      document.body.appendChild(installBtn);
    });

    // Check if already installed
    if (window.matchMedia('(display-mode: standalone)').matches) {
      console.log('✅ App running in standalone mode');
    }
  }

  // ==================== NEWS CARDS ====================
  function setupNewsCards() {
    const newsCards = document.querySelectorAll('.news-card');
    
    newsCards.forEach((card) => {
      card.style.cursor = 'pointer';
      
      card.addEventListener('click', (e) => {
        if (e.target.tagName === 'A') return;
        
        const newsLink = card.querySelector('.news-link');
        if (newsLink && newsLink.href) {
          // Track click with Analytics
          if (typeof gtag !== 'undefined') {
            gtag('event', 'click', {
              'event_category': 'News',
              'event_label': newsLink.textContent
            });
          }
          window.open(newsLink.href, '_blank');
        }
      });
    });
  }

  // ==================== NOTIFICATIONS ====================
  function showNotification(type, message) {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
      <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
      <span>${message}</span>
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => notification.classList.add('show'), 100);
    setTimeout(() => {
      notification.classList.remove('show');
      setTimeout(() => notification.remove(), 300);
    }, 5000);
  }

  // ==================== FOOTER YEAR ====================
  function setupFooterYear() {
    const yearElement = document.getElementById('year');
    if (yearElement) {
      yearElement.textContent = new Date().getFullYear();
    }
  }

  // ==================== ACCESSIBILITY ====================
  document.body.addEventListener('keyup', (e) => {
    if (e.key === 'Tab') {
      document.body.classList.add('show-focus');
    }
  });

  document.body.addEventListener('mousedown', () => {
    document.body.classList.remove('show-focus');
  });

  // ==================== PERFORMANCE MONITORING ====================
  if ('performance' in window) {
    window.addEventListener('load', () => {
      const perfData = performance.timing;
      const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
      console.log(`⚡ Page loaded in ${pageLoadTime}ms`);
      
      // Send to Analytics if configured
      if (typeof gtag !== 'undefined') {
        gtag('event', 'timing_complete', {
          'name': 'load',
          'value': pageLoadTime,
          'event_category': 'Performance'
        });
      }
    });
  }

  // ==================== SERVICE WORKER (PWA) ====================
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
      navigator.serviceWorker.register('/sw.js')
        .then(registration => console.log('✅ Service Worker registered:', registration.scope))
        .catch(err => console.log('❌ Service Worker registration failed:', err));
    });
  }

})();
