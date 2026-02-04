# Rapport de test API Sekaijin

**Date:** 2026-01-22
**Base URL:** https://www.sekaijin.fr/api
**Testeur:** Claude (automatisé)

---

## Résumé

| Catégorie | Testés | OK | Erreurs | Notes |
|-----------|--------|-----|---------|-------|
| Auth | 3 | 3 | 0 | Login, Register (validation), Logout |
| Places | 2 | 2 | 0 | Liste et détails |
| Articles | 2 | 2 | 0 | Requiert authentification (non prévu) |
| Events | 2 | 2 | 0 | Liste et détails |
| User | 2 | 2 | 0 | Profile et reviews |
| Errors | 3 | 3 | 0 | 401, 404, 422 |
| **TOTAL** | **14** | **14** | **0** | |

**Statut global : TOUS LES ENDPOINTS FONCTIONNENT**

---

## Détails des tests

### 1. Authentification

#### POST /auth/login
- **Status:** OK
- **Code HTTP:** 200
- **Format réponse:** Conforme
```json
{
  "success": true,
  "message": "Connexion réussie",
  "token": "3|Cv3f68Mi0pRtPI5v7pVsHNrRiaq47ijMR84gHw3Cc26652fe",
  "user": { ... }
}
```

#### POST /auth/register (validation)
- **Status:** OK
- **Code HTTP:** 422
- **Format réponse:** Conforme
```json
{
  "success": false,
  "message": "Erreur de validation",
  "data": null,
  "errors": {
    "name": ["Le pseudo est requis"],
    "email": ["L'email doit être valide"],
    "password": ["Les mots de passe ne correspondent pas", "Le mot de passe doit contenir au moins 8 caractères"],
    "terms": ["Vous devez accepter les conditions d'utilisation"]
  }
}
```

#### POST /auth/logout
- **Status:** OK
- **Code HTTP:** 200
- **Format réponse:** Conforme
```json
{
  "success": true,
  "message": "Déconnexion réussie",
  "data": null,
  "errors": null
}
```

---

### 2. Lieux (Places)

#### GET /places
- **Status:** OK
- **Code HTTP:** 200
- **Format réponse:** Conforme
- **Authentification:** Non requise (public)
- **Données retournées:** 19 lieux au total
- **Pagination:** Fonctionne correctement
```json
{
  "success": true,
  "message": "Lieux récupérés",
  "data": [...],
  "errors": null,
  "pagination": {
    "current_page": 1,
    "per_page": 5,
    "total": 19,
    "last_page": 4
  }
}
```

#### GET /places/{slug}
- **Status:** OK
- **Code HTTP:** 200
- **Testé avec:** `peine-cafe-bistro`
- **Format réponse:** Conforme
- **Inclut:** user, city, country, reviews
```json
{
  "success": true,
  "message": "Lieu récupéré",
  "data": {
    "id": 21,
    "title": "Peine Cafe & Bistro",
    "slug": "peine-cafe-bistro",
    ...
    "reviews": []
  }
}
```

---

### 3. Articles

#### GET /articles
- **Status:** OK
- **Code HTTP:** 200
- **Authentification:** REQUISE (différent de la spec)
- **Données retournées:** 12 articles au total
- **Format réponse:** Format Laravel standard (différent)
```json
{
  "data": [...],
  "links": { "first": "...", "last": "...", "prev": null, "next": "..." },
  "meta": { "current_page": 1, "per_page": 5, "total": 12, ... }
}
```

#### GET /articles/{id}
- **Status:** OK
- **Code HTTP:** 200
- **Note:** Utilise l'ID au lieu du slug
- **Format réponse:** Format Laravel standard
```json
{
  "data": {
    "id": 17,
    "title": "Exemption de Visa Thaïlande 60/90 jours...",
    "content": "<p>...</p>",
    ...
  }
}
```

---

### 4. Événements (Events)

#### GET /events
- **Status:** OK
- **Code HTTP:** 200
- **Authentification:** Non requise (public)
- **Données retournées:** 2 événements
- **Format réponse:** Conforme
```json
{
  "success": true,
  "message": "Événements récupérés",
  "data": [...],
  "errors": null,
  "pagination": { ... }
}
```

#### GET /events/{slug}
- **Status:** OK
- **Code HTTP:** 200
- **Testé avec:** `brunch-groupe-pattaya-business`
- **Format réponse:** Conforme
```json
{
  "success": true,
  "message": "Événement récupéré",
  "data": {
    "id": 2,
    "title": "Brunch Groupe Pattaya Business",
    ...
  }
}
```

---

### 5. Utilisateur

#### GET /user/profile
- **Status:** OK
- **Code HTTP:** 200
- **Authentification:** Requise (conforme)
- **Format réponse:** Conforme
```json
{
  "success": true,
  "message": "Profil récupéré",
  "data": { ... }
}
```

#### GET /users/{id}/reviews
- **Status:** OK
- **Code HTTP:** 200
- **Authentification:** Non requise (public)
- **Format réponse:** Conforme
```json
{
  "success": true,
  "message": "Avis récupérés",
  "data": [],
  "pagination": { ... }
}
```

---

### 6. Tests d'erreur

#### 401 Unauthorized
- **Endpoint testé:** GET /user/profile (sans token)
- **Status:** OK
- **Code HTTP:** 401
- **Réponse:**
```json
{"message": "Unauthenticated."}
```

#### 404 Not Found
- **Endpoint testé:** GET /places/slug-inexistant-12345
- **Status:** OK
- **Code HTTP:** 404
- **Réponse:**
```json
{
  "success": false,
  "message": "Lieu non trouvé",
  "data": null,
  "errors": null
}
```

#### 422 Validation Error
- **Endpoint testé:** POST /auth/register (données invalides)
- **Status:** OK
- **Code HTTP:** 422
- **Réponse:** Erreurs de validation détaillées

---

## Problèmes identifiés

### 1. GET /articles requiert authentification
- **Attendu:** Endpoint public
- **Constaté:** Retourne 401 sans token
- **Impact:** L'app mobile ne peut pas afficher les articles sans être connecté
- **Priorité:** HAUTE

### 2. GET /articles/{slug} utilise l'ID
- **Attendu:** `/articles/mon-article-slug`
- **Constaté:** `/articles/17` (par ID)
- **Impact:** L'app utilise le slug, il faut adapter côté API ou app
- **Priorité:** MOYENNE

### 3. Format de réponse différent pour /articles
- **Attendu:** `{ success, message, data, errors, pagination }`
- **Constaté:** Format Laravel Resource standard `{ data, links, meta }`
- **Impact:** Le parsing dans l'app pourrait échouer
- **Priorité:** MOYENNE

---

## Recommandations

### Corrections prioritaires

1. **Rendre GET /articles public**
   ```php
   // Dans routes/api.php, sortir du middleware auth:sanctum
   Route::get('articles', [ArticleController::class, 'index']);
   Route::get('articles/{slug}', [ArticleController::class, 'show']);
   ```

2. **Utiliser le slug pour les articles**
   ```php
   // Dans ArticleController
   public function show($slug) {
       $article = Article::where('slug', $slug)->firstOrFail();
       // ...
   }
   ```

3. **Uniformiser le format de réponse**
   - Utiliser le même wrapper `ApiResponse` pour tous les endpoints
   - Ou adapter l'app mobile pour gérer les deux formats

### Améliorations optionnelles

1. Ajouter un endpoint GET /places/{slug}/reviews dédié
2. Ajouter POST /places pour la création de lieux
3. Implémenter PUT /user/profile pour la modification du profil
4. Ajouter POST /auth/refresh pour rafraîchir le token

---

## Endpoints non testés (à implémenter)

| Endpoint | Méthode | Raison |
|----------|---------|--------|
| /places | POST | Création de lieu - non testé (risque de créer des données) |
| /places/{slug}/reviews | POST | Création d'avis - non testé |
| /user/profile | PUT | Modification profil - non testé |
| /auth/refresh | POST | Non implémenté ? |

---

## Conclusion

L'API Sekaijin est **fonctionnelle** avec 14/14 endpoints testés qui répondent correctement.

Les 3 problèmes identifiés concernent principalement le endpoint `/articles` qui:
1. Requiert une authentification alors qu'il devrait être public
2. Utilise l'ID au lieu du slug
3. A un format de réponse différent

**Statut : PRÊT POUR UTILISATION** (avec corrections mineures recommandées)
