# Sekaijin API - Cahier des Charges

Ce document décrit tous les endpoints API requis par l'application mobile Sekaijin.

**Base URL:** `https://www.sekaijin.fr/api`

---

## Table des matières

1. [Format des réponses](#format-des-réponses)
2. [Authentification](#authentification)
3. [Utilisateurs](#utilisateurs)
4. [Lieux (Places)](#lieux-places)
5. [Avis (Reviews)](#avis-reviews)
6. [Articles](#articles)
7. [Événements](#événements)
8. [Données de référence](#données-de-référence)

---

## Format des réponses

### Réponse standard (ApiResponse)

Toutes les réponses API doivent suivre ce format :

```json
{
  "success": true,
  "message": "Message descriptif",
  "data": { ... },
  "errors": null,
  "pagination": {
    "current_page": 1,
    "per_page": 15,
    "total": 100,
    "last_page": 7
  }
}
```

| Champ | Type | Description |
|-------|------|-------------|
| `success` | boolean | `true` si la requête a réussi |
| `message` | string | Message descriptif |
| `data` | object/array | Données retournées |
| `errors` | object | Erreurs de validation (optionnel) |
| `pagination` | object | Infos de pagination (pour les listes) |

### Réponse d'authentification (AuthResponse)

```json
{
  "success": true,
  "message": "Connexion réussie",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": { ... }
}
```

---

## Authentification

### POST `/auth/login`

Connexion d'un utilisateur.

**Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Connexion réussie",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "name_slug": "john-doe",
    "email": "user@example.com",
    "email_verified_at": "2024-01-15T10:30:00.000Z",
    "first_name": "John",
    "last_name": "Doe",
    "birth_date": "1990-05-15",
    "phone": "+33612345678",
    "bio": "Passionné de voyages",
    "avatar": "https://example.com/avatars/user1.jpg",
    "country_residence": "France",
    "city_residence": "Paris",
    "interest_country": "Japon",
    "latitude": 48.8566,
    "longitude": 2.3522,
    "is_visible_on_map": true,
    "country_id": 1,
    "youtube_username": "johndoe",
    "instagram_username": "john.doe",
    "tiktok_username": null,
    "linkedin_username": "johndoe",
    "twitter_username": "johndoe",
    "facebook_username": null,
    "telegram_username": null,
    "role": "free",
    "is_verified": true,
    "is_public_profile": true,
    "last_login": "2024-01-20T08:00:00.000Z",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
}
```

**Response (401 Unauthorized):**
```json
{
  "success": false,
  "message": "Email ou mot de passe incorrect"
}
```

---

### POST `/auth/register`

Inscription d'un nouvel utilisateur.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "country_residence": "France",
  "interest_country": "Japon",
  "terms": true
}
```

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `name` | string | Oui | Pseudo de l'utilisateur |
| `email` | string | Oui | Email unique |
| `password` | string | Oui | Mot de passe (min 8 caractères) |
| `password_confirmation` | string | Oui | Confirmation du mot de passe |
| `country_residence` | string | Non | Pays de résidence |
| `interest_country` | string | Non | Pays d'intérêt |
| `terms` | boolean | Oui | Acceptation des CGU |

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Inscription réussie",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": { ... }
}
```

**Response (422 Unprocessable Entity):**
```json
{
  "success": false,
  "message": "Erreur de validation",
  "errors": {
    "email": ["Cet email est déjà utilisé"],
    "password": ["Le mot de passe doit contenir au moins 8 caractères"]
  }
}
```

---

### POST `/auth/logout`

Déconnexion de l'utilisateur.

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Déconnexion réussie"
}
```

---

### POST `/auth/refresh`

Rafraîchir le token d'authentification.

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Token rafraîchi",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## Utilisateurs

### GET `/user/profile`

Récupérer le profil de l'utilisateur connecté.

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Profil récupéré",
  "data": {
    "id": 1,
    "name": "John Doe",
    "name_slug": "john-doe",
    "email": "user@example.com",
    ...
  }
}
```

---

### PUT `/user/profile`

Mettre à jour le profil de l'utilisateur connecté.

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "John Updated",
  "first_name": "John",
  "last_name": "Updated",
  "bio": "Nouvelle bio",
  "phone": "+33612345678",
  "country_residence": "France",
  "city_residence": "Lyon",
  "is_visible_on_map": true,
  "is_public_profile": true,
  "youtube_username": "johndoe",
  "instagram_username": "john.updated"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Profil mis à jour",
  "data": { ... }
}
```

---

### GET `/users/{userId}/reviews`

Récupérer les avis d'un utilisateur.

**Query Parameters:**
| Paramètre | Type | Défaut | Description |
|-----------|------|--------|-------------|
| `page` | int | 1 | Numéro de page |
| `per_page` | int | 15 | Nombre d'éléments par page |

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Avis récupérés",
  "data": [
    {
      "id": 1,
      "place_id": 5,
      "user_id": 1,
      "comment": "Super endroit !",
      "rating": 5,
      "is_approved": true,
      "created_at": "2024-01-15T10:00:00.000Z",
      "updated_at": "2024-01-15T10:00:00.000Z",
      "place": {
        "id": 5,
        "title": "Restaurant Tokyo",
        "slug": "restaurant-tokyo",
        "image_url": "https://example.com/places/tokyo.jpg"
      }
    }
  ],
  "pagination": { ... }
}
```

---

## Lieux (Places)

### GET `/places`

Liste des lieux avec filtres et pagination.

**Query Parameters:**
| Paramètre | Type | Défaut | Description |
|-----------|------|--------|-------------|
| `country_id` | int | - | Filtrer par pays |
| `city_id` | int | - | Filtrer par ville |
| `user_id` | int | - | Filtrer par créateur |
| `category` | string | - | Filtrer par catégorie |
| `search` | string | - | Recherche textuelle |
| `status` | string | "approved" | Statut (pending, approved, rejected) |
| `sort_by` | string | "created_at" | Champ de tri |
| `sort_order` | string | "desc" | Ordre de tri (asc, desc) |
| `page` | int | 1 | Numéro de page |
| `per_page` | int | 15 | Éléments par page |

**Catégories disponibles:**
- `restaurants`
- `cafes`
- `coworkings`
- `logements`
- `activites`
- `transports`
- `services`
- `autres`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Lieux récupérés",
  "data": [
    {
      "id": 1,
      "title": "Café Sakura",
      "slug": "cafe-sakura",
      "description": "Un café traditionnel japonais...",
      "seo_content": null,
      "user_id": 1,
      "city_id": 5,
      "category": "cafes",
      "google_maps_url": "https://maps.google.com/...",
      "google_place_id": "ChIJ...",
      "address": "123 Rue de Tokyo, Paris",
      "latitude": 48.8566,
      "longitude": 2.3522,
      "image_url": "https://example.com/places/sakura1.jpg",
      "image_url_2": "https://example.com/places/sakura2.jpg",
      "image_url_3": null,
      "menu_url": "https://example.com/menu.pdf",
      "website_url": "https://cafesakura.com",
      "youtube_url": null,
      "wifi_speed": 50,
      "rating_average": 4.5,
      "reviews_count": 12,
      "status": "approved",
      "rejection_reason": null,
      "is_featured": false,
      "created_at": "2024-01-10T00:00:00.000Z",
      "updated_at": "2024-01-15T00:00:00.000Z",
      "user": {
        "id": 1,
        "name": "John Doe",
        "name_slug": "john-doe",
        "avatar": "https://example.com/avatars/user1.jpg"
      },
      "city": {
        "id": 5,
        "name": "Tokyo",
        "slug": "tokyo",
        "country_id": 1,
        "country": {
          "id": 1,
          "name_fr": "Japon",
          "slug": "japon",
          "emoji": "🇯🇵"
        }
      }
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 15,
    "total": 50,
    "last_page": 4
  }
}
```

---

### GET `/places/{slug}`

Détails d'un lieu par son slug.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Lieu récupéré",
  "data": {
    "id": 1,
    "title": "Café Sakura",
    "slug": "cafe-sakura",
    "description": "Un café traditionnel japonais...",
    ...
    "reviews": [
      {
        "id": 1,
        "place_id": 1,
        "user_id": 2,
        "comment": "Excellent café !",
        "rating": 5,
        "is_approved": true,
        "created_at": "2024-01-12T00:00:00.000Z",
        "updated_at": "2024-01-12T00:00:00.000Z",
        "user": {
          "id": 2,
          "name": "Jane Smith",
          "avatar": "https://example.com/avatars/user2.jpg"
        }
      }
    ]
  }
}
```

---

### POST `/places`

Créer un nouveau lieu.

**Headers:**
```
Authorization: Bearer {token}
Content-Type: multipart/form-data
```

**Request Body (FormData):**
| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `title` | string | Oui | Nom du lieu |
| `city_id` | int | Oui | ID de la ville |
| `category` | string | Oui | Catégorie |
| `description` | string | Oui | Description |
| `google_maps_url` | string | Oui | URL Google Maps |
| `address` | string | Non | Adresse complète |
| `menu_url` | string | Non | URL du menu |
| `website_url` | string | Non | Site web |
| `youtube_url` | string | Non | Vidéo YouTube |
| `wifi_speed` | int | Non | Vitesse WiFi (Mbps) |
| `images[]` | file[] | Non | Images (max 3) |

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Lieu créé avec succès",
  "data": {
    "id": 10,
    "title": "Nouveau Café",
    "slug": "nouveau-cafe",
    "status": "pending",
    ...
  }
}
```

---

## Avis (Reviews)

### GET `/places/{placeSlug}/reviews`

Liste des avis d'un lieu.

**Query Parameters:**
| Paramètre | Type | Défaut | Description |
|-----------|------|--------|-------------|
| `page` | int | 1 | Numéro de page |
| `per_page` | int | 15 | Éléments par page |
| `sort_by` | string | "created_at" | Champ de tri |
| `sort_order` | string | "desc" | Ordre de tri |

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Avis récupérés",
  "data": [
    {
      "id": 1,
      "place_id": 5,
      "user_id": 2,
      "comment": "Super endroit, je recommande !",
      "rating": 5,
      "is_approved": true,
      "created_at": "2024-01-15T10:00:00.000Z",
      "updated_at": "2024-01-15T10:00:00.000Z",
      "user": {
        "id": 2,
        "name": "Jane Smith",
        "name_slug": "jane-smith",
        "avatar": "https://example.com/avatars/user2.jpg"
      }
    }
  ],
  "pagination": { ... }
}
```

---

### POST `/places/{placeSlug}/reviews`

Créer un avis sur un lieu.

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "rating": 5,
  "comment": "Super endroit, je recommande !"
}
```

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `rating` | int | Oui | Note de 1 à 5 |
| `comment` | string | Oui | Commentaire |

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Avis créé avec succès",
  "data": {
    "id": 10,
    "place_id": 5,
    "user_id": 1,
    "comment": "Super endroit, je recommande !",
    "rating": 5,
    "is_approved": false,
    "created_at": "2024-01-20T10:00:00.000Z",
    "updated_at": "2024-01-20T10:00:00.000Z"
  }
}
```

---

### PUT `/places/{placeSlug}/reviews/{reviewId}`

Modifier un avis existant.

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "rating": 4,
  "comment": "Commentaire modifié"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Avis mis à jour",
  "data": { ... }
}
```

---

### DELETE `/places/{placeSlug}/reviews/{reviewId}`

Supprimer un avis.

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Avis supprimé"
}
```

---

## Articles

### GET `/articles`

Liste des articles avec filtres.

**Query Parameters:**
| Paramètre | Type | Défaut | Description |
|-----------|------|--------|-------------|
| `country_id` | int | - | Filtrer par pays |
| `category` | string | - | Filtrer par catégorie |
| `status` | string | "published" | Statut |
| `page` | int | 1 | Numéro de page |
| `per_page` | int | 15 | Éléments par page |

**Catégories d'articles:**
- `temoignage`
- `guide`
- `actualite`
- `conseil`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Articles récupérés",
  "data": [
    {
      "id": 1,
      "title": "Mon expatriation au Japon",
      "slug": "mon-expatriation-au-japon",
      "summary": "Résumé de mon expérience...",
      "content": "<p>Contenu complet de l'article...</p>",
      "category": "temoignage",
      "image_url": "https://example.com/articles/japon.jpg",
      "country_id": 1,
      "author_id": 1,
      "status": "published",
      "is_featured": true,
      "published_at": "2024-01-10T00:00:00.000Z",
      "likes": 25,
      "reading_time": 5,
      "created_at": "2024-01-05T00:00:00.000Z",
      "country": {
        "id": 1,
        "name_fr": "Japon",
        "slug": "japon",
        "emoji": "🇯🇵"
      },
      "author": {
        "id": 1,
        "name": "John Doe",
        "avatar": "https://example.com/avatars/user1.jpg"
      }
    }
  ],
  "pagination": { ... }
}
```

---

### GET `/articles/{slug}`

Détails d'un article par son slug.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Article récupéré",
  "data": {
    "id": 1,
    "title": "Mon expatriation au Japon",
    "slug": "mon-expatriation-au-japon",
    "summary": "Résumé...",
    "content": "<p>Contenu complet...</p>",
    ...
  }
}
```

---

## Événements

### GET `/events`

Liste des événements avec filtres.

**Query Parameters:**
| Paramètre | Type | Défaut | Description |
|-----------|------|--------|-------------|
| `country_id` | int | - | Filtrer par pays |
| `is_online` | int (0/1) | - | Événements en ligne |
| `upcoming` | int (0/1) | - | Événements à venir |
| `status` | string | "published" | Statut |
| `page` | int | 1 | Numéro de page |
| `per_page` | int | 15 | Éléments par page |

**Catégories d'événements:**
- `meetup`
- `conference`
- `workshop`
- `networking`
- `cultural`
- `other`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Événements récupérés",
  "data": [
    {
      "id": 1,
      "title": "Meetup Expats Tokyo",
      "slug": "meetup-expats-tokyo",
      "description": "Rencontre mensuelle...",
      "full_description": "Description complète...",
      "category": "meetup",
      "image_url": "https://example.com/events/meetup.jpg",
      "country_id": 1,
      "organizer_id": 1,
      "status": "published",
      "is_featured": false,
      "start_date": "2024-02-15T18:00:00.000Z",
      "end_date": "2024-02-15T21:00:00.000Z",
      "location": "Shibuya",
      "address": "123 Shibuya Street, Tokyo",
      "google_maps_url": "https://maps.google.com/...",
      "latitude": 35.6595,
      "longitude": 139.7004,
      "is_online": false,
      "online_link": null,
      "price": 0,
      "max_participants": 50,
      "current_participants": 25,
      "created_at": "2024-01-01T00:00:00.000Z",
      "country": {
        "id": 1,
        "name_fr": "Japon",
        "slug": "japon",
        "emoji": "🇯🇵"
      },
      "organizer": {
        "id": 1,
        "name": "John Doe",
        "avatar": "https://example.com/avatars/user1.jpg"
      }
    }
  ],
  "pagination": { ... }
}
```

---

### GET `/events/{slug}`

Détails d'un événement par son slug.

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Événement récupéré",
  "data": {
    "id": 1,
    "title": "Meetup Expats Tokyo",
    ...
  }
}
```

---

## Données de référence

### Modèle Country (Pays)

```json
{
  "id": 1,
  "name_fr": "Japon",
  "slug": "japon",
  "emoji": "🇯🇵",
  "description": "Description du pays..."
}
```

### Modèle City (Ville)

```json
{
  "id": 1,
  "name": "Tokyo",
  "slug": "tokyo",
  "country_id": 1,
  "latitude": 35.6762,
  "longitude": 139.6503,
  "is_major": true,
  "order": 1,
  "description": "Capitale du Japon...",
  "country": { ... }
}
```

### Modèle User (Utilisateur)

```json
{
  "id": 1,
  "name": "John Doe",
  "name_slug": "john-doe",
  "email": "user@example.com",
  "email_verified_at": "2024-01-15T10:30:00.000Z",
  "first_name": "John",
  "last_name": "Doe",
  "birth_date": "1990-05-15",
  "phone": "+33612345678",
  "bio": "Ma bio...",
  "avatar": "https://example.com/avatars/user1.jpg",
  "country_residence": "France",
  "city_residence": "Paris",
  "interest_country": "Japon",
  "latitude": 48.8566,
  "longitude": 2.3522,
  "is_visible_on_map": true,
  "country_id": 1,
  "youtube_username": "johndoe",
  "instagram_username": "john.doe",
  "tiktok_username": null,
  "linkedin_username": "johndoe",
  "twitter_username": "johndoe",
  "facebook_username": null,
  "telegram_username": null,
  "role": "free",
  "is_verified": true,
  "is_public_profile": true,
  "last_login": "2024-01-20T08:00:00.000Z",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

**Rôles utilisateur:**
- `free` - Utilisateur gratuit
- `premium` - Utilisateur premium
- `admin` - Administrateur

---

## Codes d'erreur HTTP

| Code | Description |
|------|-------------|
| 200 | Succès |
| 201 | Créé avec succès |
| 400 | Requête invalide |
| 401 | Non authentifié |
| 403 | Non autorisé |
| 404 | Ressource non trouvée |
| 422 | Erreur de validation |
| 500 | Erreur serveur |

---

## Authentification des requêtes

Toutes les requêtes authentifiées doivent inclure le header :

```
Authorization: Bearer {token}
```

Le token est obtenu via `/auth/login` ou `/auth/register`.

---

## Résumé des endpoints

| Méthode | Endpoint | Auth | Description |
|---------|----------|------|-------------|
| POST | `/auth/login` | Non | Connexion |
| POST | `/auth/register` | Non | Inscription |
| POST | `/auth/logout` | Oui | Déconnexion |
| POST | `/auth/refresh` | Oui | Rafraîchir token |
| GET | `/user/profile` | Oui | Profil utilisateur |
| PUT | `/user/profile` | Oui | Modifier profil |
| GET | `/users/{id}/reviews` | Non | Avis d'un utilisateur |
| GET | `/places` | Non | Liste des lieux |
| GET | `/places/{slug}` | Non | Détails d'un lieu |
| POST | `/places` | Oui | Créer un lieu |
| GET | `/places/{slug}/reviews` | Non | Avis d'un lieu |
| POST | `/places/{slug}/reviews` | Oui | Créer un avis |
| PUT | `/places/{slug}/reviews/{id}` | Oui | Modifier un avis |
| DELETE | `/places/{slug}/reviews/{id}` | Oui | Supprimer un avis |
| GET | `/articles` | Non | Liste des articles |
| GET | `/articles/{slug}` | Non | Détails d'un article |
| GET | `/events` | Non | Liste des événements |
| GET | `/events/{slug}` | Non | Détails d'un événement |

---

## Notes d'implémentation Laravel

### Middleware recommandés

```php
// Routes publiques
Route::group(['prefix' => 'api'], function () {
    Route::post('auth/login', [AuthController::class, 'login']);
    Route::post('auth/register', [AuthController::class, 'register']);

    Route::get('places', [PlaceController::class, 'index']);
    Route::get('places/{slug}', [PlaceController::class, 'show']);
    // ...
});

// Routes protégées
Route::group(['prefix' => 'api', 'middleware' => 'auth:sanctum'], function () {
    Route::post('auth/logout', [AuthController::class, 'logout']);
    Route::get('user/profile', [UserController::class, 'profile']);
    Route::put('user/profile', [UserController::class, 'update']);
    Route::post('places', [PlaceController::class, 'store']);
    Route::post('places/{slug}/reviews', [ReviewController::class, 'store']);
    // ...
});
```

### Package recommandé

- **Laravel Sanctum** pour l'authentification API avec tokens

---

*Document généré pour l'application Sekaijin Mobile v1.0*
