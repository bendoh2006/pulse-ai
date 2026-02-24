# Architecture Dashboard Web — Documentation Technique

## 📋 Vue d'Ensemble

Le Dashboard Web PulseAI permet aux hôpitaux de :
- S'inscrire et gérer leur profil
- Publier leurs disponibilités en temps réel (lits, services, médecins)
- Mettre à jour les informations visibles dans l'app mobile

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────┐
│         Frontend (Vanilla JS)                │
│                                              │
│  ┌─────────┐  ┌──────────┐  ┌────────────┐ │
│  │  Auth   │  │   API    │  │   Store    │ │
│  │ Module  │  │  Module  │  │  (LocalSt) │ │
│  └─────────┘  └──────────┘  └────────────┘ │
│       │            │              │         │
└───────┼────────────┼──────────────┼─────────┘
        │            │              │
        ▼            ▼              ▼
┌──────────────────────────────────────────────┐
│            Supabase Cloud                    │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐  │
│  │   Auth   │  │PostgreSQL│  │  Storage  │  │
│  │ (Signup/ │  │   (RLS)  │  │  (Assets) │  │
│  │  Login)  │  │          │  │           │  │
│  └──────────┘  └──────────┘  └───────────┘  │
└──────────────────────────────────────────────┘
```

---

## 📂 Structure des Fichiers

```
DASHBOARD WEB PULSEAI/
├── public/
│   ├── index.html              # Landing page
│   ├── dashboard.html          # Dashboard principal
│   ├── admin.html              # Panel admin
│   ├── hospitals.html          # Liste publique hôpitaux
│   ├── profile.html            # Profil utilisateur
│   ├── _redirects              # Netlify redirects
│   ├── styles.css              # Styles globaux
│   ├── styles-v2.css           # Styles v2
│   └── src/
│       ├── auth.js             # Authentification
│       ├── dashboard.js        # Logique dashboard
│       ├── hospitals_public.js # Affichage hôpitaux
│       ├── profile.js          # Gestion profil
│       ├── supabase.js         # Client Supabase
│       ├── config.js           # Configuration
│       └── utils/
│           ├── api.js          # Helpers API
│           ├── cache.js        # Cache LocalStorage
│           ├── notifications.js # Notifications
│           ├── store.js        # State management
│           └── validation.js   # Validation formulaires
│
├── src/                        # (Duplicate structure - legacy)
├── sql/
│   ├── production_setup.sql    # Schema DB
│   ├── fix_signup_trigger.sql  # Fix triggers
│   └── update_dashboard_v2.sql # Migrations
│
├── netlify.toml                # Config Netlify
├── package.json                # Dépendances NPM
└── config.example.js           # Exemple config
```

---

## 🔐 Authentification

### Module : `public/src/auth.js`

#### Signup
```javascript
async function signup(email, password, metadata) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        full_name: metadata.full_name,
        hospital_name: metadata.hospital_name,
        role: 'hospital_admin'
      }
    }
  });
  
  if (error) throw error;
  
  // Créer entrée dans table hospitals
  await createHospitalProfile(data.user.id, metadata);
  
  return data;
}
```

#### Login
```javascript
async function login(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  });
  
  if (error) throw error;
  
  // Stocker session
  localStorage.setItem('user_session', JSON.stringify(data.session));
  
  return data;
}
```

#### Logout
```javascript
async function logout() {
  await supabase.auth.signOut();
  localStorage.clear();
  window.location.href = '/index.html';
}
```

---

## 🏥 Gestion Hôpitaux

### Schema Supabase

```sql
CREATE TABLE hospitals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  name TEXT NOT NULL,
  address TEXT,
  city TEXT,
  phone TEXT,
  email TEXT,
  latitude FLOAT,
  longitude FLOAT,
  available_beds INTEGER DEFAULT 0,
  total_beds INTEGER DEFAULT 0,
  services JSONB DEFAULT '[]'::jsonb,
  doctors JSONB DEFAULT '[]'::jsonb,
  opening_hours JSONB,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE hospitals ENABLE ROW LEVEL SECURITY;

-- Policy: lecture publique
CREATE POLICY "Public read access"
  ON hospitals FOR SELECT
  USING (true);

-- Policy: écriture par propriétaire
CREATE POLICY "Hospital admin can update own data"
  ON hospitals FOR UPDATE
  USING (auth.uid() = user_id);
```

### CRUD Operations

#### Create Hospital
```javascript
async function createHospital(hospitalData) {
  const { data, error } = await supabase
    .from('hospitals')
    .insert([{
      user_id: currentUser.id,
      name: hospitalData.name,
      address: hospitalData.address,
      city: hospitalData.city,
      phone: hospitalData.phone,
      latitude: hospitalData.latitude,
      longitude: hospitalData.longitude,
      available_beds: hospitalData.available_beds,
      total_beds: hospitalData.total_beds,
      services: hospitalData.services,
      doctors: hospitalData.doctors
    }])
    .select()
    .single();
  
  return data;
}
```

#### Update Availability (Temps Réel)
```javascript
async function updateAvailability(hospitalId, updates) {
  const { data, error } = await supabase
    .from('hospitals')
    .update({
      available_beds: updates.available_beds,
      services: updates.services,
      doctors: updates.doctors,
      updated_at: new Date().toISOString()
    })
    .eq('id', hospitalId)
    .select();
  
  // Trigger notification aux clients connectés
  await notifyClients(hospitalId, 'availability_updated');
  
  return data;
}
```

#### Get Nearby Hospitals
```javascript
async function getNearbyHospitals(latitude, longitude, radius = 10) {
  // Formule Haversine pour distance
  const { data, error } = await supabase
    .rpc('get_nearby_hospitals', {
      user_lat: latitude,
      user_lon: longitude,
      radius_km: radius
    });
  
  return data;
}
```

SQL Function:
```sql
CREATE OR REPLACE FUNCTION get_nearby_hospitals(
  user_lat FLOAT,
  user_lon FLOAT,
  radius_km FLOAT
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  distance FLOAT,
  available_beds INTEGER,
  services JSONB
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    h.id,
    h.name,
    (6371 * acos(
      cos(radians(user_lat)) * cos(radians(h.latitude)) *
      cos(radians(h.longitude) - radians(user_lon)) +
      sin(radians(user_lat)) * sin(radians(h.latitude))
    )) AS distance,
    h.available_beds,
    h.services
  FROM hospitals h
  WHERE h.is_verified = TRUE
  ORDER BY distance
  LIMIT 50;
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 Dashboard Interface

### Module : `public/src/dashboard.js`

#### Components

##### 1. Stats Overview
```javascript
function renderStats(hospitalData) {
  return `
    <div class="stats-grid">
      <div class="stat-card">
        <h3>Lits Disponibles</h3>
        <p class="stat-value">${hospitalData.available_beds}</p>
        <p class="stat-total">sur ${hospitalData.total_beds}</p>
      </div>
      
      <div class="stat-card">
        <h3>Services Actifs</h3>
        <p class="stat-value">${hospitalData.services.length}</p>
      </div>
      
      <div class="stat-card">
        <h3>Médecins Disponibles</h3>
        <p class="stat-value">${hospitalData.doctors.filter(d => d.available).length}</p>
        <p class="stat-total">sur ${hospitalData.doctors.length}</p>
      </div>
    </div>
  `;
}
```

##### 2. Quick Update Form
```javascript
function renderQuickUpdateForm() {
  return `
    <form id="quick-update-form">
      <label>Lits disponibles</label>
      <input type="number" name="available_beds" min="0" required>
      
      <label>Services disponibles</label>
      <div class="services-checkboxes">
        <label><input type="checkbox" name="service" value="urgence"> Urgence</label>
        <label><input type="checkbox" name="service" value="pediatrie"> Pédiatrie</label>
        <label><input type="checkbox" name="service" value="maternite"> Maternité</label>
        <label><input type="checkbox" name="service" value="chirurgie"> Chirurgie</label>
      </div>
      
      <button type="submit">Mettre à jour</button>
    </form>
  `;
}

document.getElementById('quick-update-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const formData = new FormData(e.target);
  
  const updates = {
    available_beds: parseInt(formData.get('available_beds')),
    services: formData.getAll('service'),
    updated_at: new Date().toISOString()
  };
  
  await updateAvailability(currentHospitalId, updates);
  showNotification('Disponibilités mises à jour !', 'success');
});
```

##### 3. Doctors Management
```javascript
function renderDoctorsTable(doctors) {
  return `
    <table class="doctors-table">
      <thead>
        <tr>
          <th>Nom</th>
          <th>Spécialité</th>
          <th>Disponible</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        ${doctors.map(doc => `
          <tr>
            <td>Dr. ${doc.name}</td>
            <td>${doc.specialty}</td>
            <td>
              <label class="toggle">
                <input type="checkbox" ${doc.available ? 'checked' : ''}
                  onchange="toggleDoctorAvailability('${doc.id}', this.checked)">
                <span class="slider"></span>
              </label>
            </td>
            <td>
              <button onclick="editDoctor('${doc.id}')">✏️</button>
              <button onclick="deleteDoctor('${doc.id}')">🗑️</button>
            </td>
          </tr>
        `).join('')}
      </tbody>
    </table>
  `;
}
```

---

## 🔄 Temps Réel (Real-time Updates)

### Supabase Realtime

```javascript
// Subscribe aux changements de la table hospitals
const hospitalSubscription = supabase
  .channel('hospitals-changes')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'hospitals',
    filter: `id=eq.${currentHospitalId}`
  }, (payload) => {
    console.log('Hospital data updated:', payload.new);
    refreshDashboard(payload.new);
  })
  .subscribe();

// Unsubscribe on page leave
window.addEventListener('beforeunload', () => {
  hospitalSubscription.unsubscribe();
});
```

---

## 🗺️ Géolocalisation

### Obtenir Coordonnées

#### Browser Geolocation API
```javascript
function getCurrentLocation() {
  return new Promise((resolve, reject) => {
    if (!navigator.geolocation) {
      reject(new Error('Geolocation not supported'));
    }
    
    navigator.geolocation.getCurrentPosition(
      (position) => {
        resolve({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude,
          accuracy: position.coords.accuracy
        });
      },
      (error) => reject(error),
      { enableHighAccuracy: true, timeout: 10000 }
    );
  });
}
```

#### Geocoding (Address → Coords)
```javascript
async function geocodeAddress(address) {
  const response = await fetch(
    `https://nominatim.openstreetmap.org/search?` +
    `q=${encodeURIComponent(address)}&format=json&limit=1`
  );
  const data = await response.json();
  
  if (data.length === 0) {
    throw new Error('Address not found');
  }
  
  return {
    latitude: parseFloat(data[0].lat),
    longitude: parseFloat(data[0].lon)
  };
}
```

---

## 📱 Responsive Design

### Breakpoints

```css
/* Mobile */
@media (max-width: 767px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .dashboard-sidebar {
    display: none;
  }
}

/* Tablet */
@media (min-width: 768px) and (max-width: 1023px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .stats-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
```

---

## 🚀 Déploiement Netlify

### Configuration (`netlify.toml`)

```toml
[build]
  publish = "public"
  command = "echo 'No build step needed'"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    X-XSS-Protection = "1; mode=block"
    Referrer-Policy = "strict-origin-when-cross-origin"
```

### Environment Variables

Netlify Dashboard → Site Settings → Environment Variables :
```
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJxxx...
```

---

## 🧪 Tests

### Tests Manuels

#### 1. Signup Flow
- [ ] Créer compte avec email valide
- [ ] Vérifier email de confirmation
- [ ] Compléter profil hôpital
- [ ] Vérifier entrée dans DB

#### 2. Dashboard
- [ ] Affichage des stats
- [ ] Update lits disponibles
- [ ] Toggle services
- [ ] Ajouter/modifier médecin
- [ ] Vérifier temps réel

#### 3. Public View
- [ ] Liste hôpitaux triée par distance
- [ ] Filtres par services
- [ ] Détails hôpital
- [ ] Itinéraire

---

## 🔐 Sécurité

### Best Practices Implémentées

1. **Row Level Security (RLS)**
   - Lecture publique limitée
   - Écriture par propriétaire uniquement

2. **Input Validation**
   ```javascript
   function validateHospitalData(data) {
     if (!data.name || data.name.length < 3) {
       throw new Error('Nom invalide');
     }
     if (data.available_beds < 0 || data.available_beds > data.total_beds) {
       throw new Error('Nombre de lits invalide');
     }
     // ... autres validations
   }
   ```

3. **XSS Prevention**
   ```javascript
   function sanitizeHTML(str) {
     const div = document.createElement('div');
     div.textContent = str;
     return div.innerHTML;
   }
   ```

4. **HTTPS Only**
   - Netlify force HTTPS automatiquement

---

## 📊 Analytics (À Implémenter)

### Events à Tracker

```javascript
function trackEvent(eventName, properties) {
  // Google Analytics
  gtag('event', eventName, properties);
  
  // Supabase custom events (optionnel)
  supabase.from('analytics_events').insert({
    event_name: eventName,
    properties: properties,
    user_id: currentUser?.id,
    timestamp: new Date().toISOString()
  });
}

// Usage
trackEvent('hospital_updated', {
  hospital_id: hospitalId,
  field_updated: 'available_beds',
  new_value: 25
});
```

---

## 🚀 Roadmap

- [ ] Dashboard mobile app (React Native)
- [ ] Notifications push (FCM)
- [ ] Rapports automatisés (PDF)
- [ ] Intégration calendrier médecins
- [ ] Chat inter-hôpitaux
- [ ] API publique pour partenaires

---

## 👨‍💻 Contribution

Consultez [CONTRIBUTING.md](../CONTRIBUTING.md) pour :
- Conventions de code (ES6+, JSDoc)
- Structure des commits
- Process de review
