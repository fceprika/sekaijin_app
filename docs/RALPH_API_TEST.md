/ralph-loop:ralph-loop

# Test complet des endpoints API Sekaijin

## Objectif
Tester tous les endpoints API de l'application Sekaijin pour vérifier qu'ils fonctionnent correctement et retournent les données au format attendu.

## Configuration
- **Base URL:** `https://www.sekaijin.fr/api`
- **Spécification:** `docs/API_SPECIFICATION.md`

## Instructions

Pour chaque endpoint, tu dois:
1. Faire une requête avec `curl`
2. Vérifier le code HTTP de réponse
3. Vérifier que la structure JSON correspond au format attendu
4. Noter le résultat (OK / ERREUR + détails)
5. Créer un rapport final dans `docs/API_TEST_REPORT.md`

## Endpoints à tester

### 1. Authentification

#### POST /auth/login
```bash
curl -X POST https://www.sekaijin.fr/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```
**Attendu:** `{"success": true/false, "message": "...", "token": "...", "user": {...}}`

#### POST /auth/register
```bash
curl -X POST https://www.sekaijin.fr/api/auth/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"name": "TestUser", "email": "newuser@test.com", "password": "password123", "password_confirmation": "password123", "terms": true}'
```
**Attendu:** `{"success": true/false, "message": "...", "token": "...", "user": {...}}`

### 2. Lieux (Places)

#### GET /places
```bash
curl -X GET "https://www.sekaijin.fr/api/places?status=approved&page=1&per_page=5" \
  -H "Accept: application/json"
```
**Attendu:** `{"success": true, "data": [...], "pagination": {...}}`

#### GET /places avec filtres
```bash
curl -X GET "https://www.sekaijin.fr/api/places?category=restaurants&page=1" \
  -H "Accept: application/json"
```

#### GET /places/{slug}
```bash
curl -X GET "https://www.sekaijin.fr/api/places/nom-du-lieu" \
  -H "Accept: application/json"
```
**Attendu:** `{"success": true, "data": {"id": ..., "title": "...", ...}}`

### 3. Articles

#### GET /articles
```bash
curl -X GET "https://www.sekaijin.fr/api/articles?status=published&page=1&per_page=5" \
  -H "Accept: application/json"
```
**Attendu:** `{"success": true, "data": [...], "pagination": {...}}`

#### GET /articles/{slug}
```bash
curl -X GET "https://www.sekaijin.fr/api/articles/nom-article" \
  -H "Accept: application/json"
```
**Attendu:** `{"success": true, "data": {"id": ..., "title": "...", "content": "...", ...}}`

### 4. Événements

#### GET /events
```bash
curl -X GET "https://www.sekaijin.fr/api/events?status=published&page=1&per_page=5" \
  -H "Accept: application/json"
```
**Attendu:** `{"success": true, "data": [...], "pagination": {...}}`

#### GET /events avec filtre upcoming
```bash
curl -X GET "https://www.sekaijin.fr/api/events?upcoming=1" \
  -H "Accept: application/json"
```

#### GET /events/{slug}
```bash
curl -X GET "https://www.sekaijin.fr/api/events/nom-event" \
  -H "Accept: application/json"
```
**Attendu:** `{"success": true, "data": {"id": ..., "title": "...", ...}}`

### 5. Endpoints authentifiés (après login réussi)

Récupérer le token du login puis tester:

#### GET /user/profile
```bash
curl -X GET https://www.sekaijin.fr/api/user/profile \
  -H "Accept: application/json" \
  -H "Authorization: Bearer {TOKEN}"
```

#### POST /auth/logout
```bash
curl -X POST https://www.sekaijin.fr/api/auth/logout \
  -H "Accept: application/json" \
  -H "Authorization: Bearer {TOKEN}"
```

#### GET /users/{id}/reviews
```bash
curl -X GET "https://www.sekaijin.fr/api/users/1/reviews" \
  -H "Accept: application/json"
```

### 6. Tests d'erreur

#### 401 Unauthorized (endpoint protégé sans token)
```bash
curl -X GET https://www.sekaijin.fr/api/user/profile \
  -H "Accept: application/json"
```
**Attendu:** Code 401

#### 404 Not Found
```bash
curl -X GET https://www.sekaijin.fr/api/places/slug-inexistant-12345 \
  -H "Accept: application/json"
```
**Attendu:** Code 404

#### 422 Validation Error
```bash
curl -X POST https://www.sekaijin.fr/api/auth/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"email": "invalid-email", "password": "123"}'
```
**Attendu:** Code 422 avec `{"success": false, "errors": {...}}`

## Format du rapport

Crée `docs/API_TEST_REPORT.md` avec ce format:

```markdown
# Rapport de test API Sekaijin

**Date:** [DATE]
**Base URL:** https://www.sekaijin.fr/api

## Résumé

| Catégorie | Testés | OK | Erreurs |
|-----------|--------|-----|---------|
| Auth | X | X | X |
| Places | X | X | X |
| Articles | X | X | X |
| Events | X | X | X |
| Errors | X | X | X |

## Détails

### Authentification

#### POST /auth/login
- **Status:** OK / ERREUR
- **Code HTTP:** XXX
- **Réponse:** ...
- **Notes:** ...

[... etc pour chaque endpoint ...]

## Problèmes identifiés

1. [Liste des problèmes trouvés]

## Recommandations

1. [Suggestions d'amélioration]
```

## Credentials de test

Si tu as besoin de credentials pour tester le login, demande-les à l'utilisateur avant de commencer les tests.

## Go!

Commence par tester les endpoints publics (places, articles, events) puis demande les credentials pour tester l'authentification.
