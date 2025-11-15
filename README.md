# 🚴 Analyse du Réseau Cyclable de Montréal - Vélo Québec

**Projet réalisé par:** Ibrahimakhalil Mbacke  
**Diplôme:** Maîtrise en Géomatique - UQAM  
**Dans le cadre de:** Candidature Cartographe-Géomaticien chez Vélo Québec  
**Date:** 15 novembre 2025  
**Entretien:** 17 novembre 2025

---

## 📋 TABLE DES MATIÈRES

1. [Aperçu du Projet](#aperçu-du-projet)
2. [Résultats Clés](#résultats-clés)
3. [Installation et Lancement](#installation-et-lancement)
4. [Structure du Projet](#structure-du-projet)
5. [Méthodologie Technique](#méthodologie-technique)
6. [Utilisation](#utilisation)
7. [Fichiers Livrables](#fichiers-livrables)
8. [Recommandations](#recommandations)

---

## 📊 APERÇU DU PROJET

Ce projet analyse l'accessibilité du réseau cyclable de Montréal par rapport aux espaces verts municipaux. L'objectif est d'identifier les pistes cyclables situées à moins de 500 mètres des parcs pour évaluer la qualité et la sécurité du réseau.

### Problématique
Quelle est la qualité de l'accès cyclable aux parcs de Montréal? Quelle proportion du réseau est réellement sécurisée?

### Hypothèse
Une analyse spatiale basée sur des buffers de 500m permettra d'identifier les zones bien desservies et les enjeux de sécurité du réseau cyclable montréalais.

---

## 🎯 RÉSULTATS CLÉS

| Indicateur | Valeur | Signification |
|------------|--------|---------------|
| **Linéaire total analysé** | 968 km | Pistes à moins de 500m des parcs |
| **Nombre de segments** | 8,300 | Tronçons de voies cyclables |
| **Parcs desservis** | 2,239 | Espaces verts avec accès cyclable |
| **⚠️ Taux de sécurité** | **16.9%** | Seulement en site propre (séparé) |
| **🚨 Sans séparateur** | **71.5%** | Aucune protection physique |

### Répartition par type de voie
1. Bandes cyclables: 256.6 km (26.5%)
2. Chaussées désignées: 224.2 km (23.1%) 
3. Pistes sur rue: 199.0 km (20.6%)
4. **Pistes en site propre: 163.4 km (16.9%)** ✅
5. Sentiers polyvalents: 97.8 km (10.1%)
6. Autres types: 27.4 km (2.8%)

### Top 5 Arrondissements
1. Rivière-des-Prairies–Pointe-aux-Trembles: 96.7 km
2. Rosemont–La Petite-Patrie: 84.5 km
3. Mercier–Hochelaga-Maisonneuve: 79.6 km
4. Ahuntsic-Cartierville: 73.6 km
5. Saint-Laurent: 72.7 km

### Insight majeur
**83.1% du réseau partage la chaussée avec les automobiles**, représentant un enjeu de sécurité critique pour Vélo Québec.

---

## 🚀 INSTALLATION ET LANCEMENT

### Prérequis
- Docker et Docker Compose installés
- Python 3.x (pour le serveur web local)
- Navigateur web moderne
- (Optionnel) QGIS 3.x pour l'analyse avancée

### Étape 1 : Lancer le conteneur Docker
```bash
docker-compose up -d
```

### Étape 2 : Lancer le serveur web
```bash
cd /workspaces/gdal-docker
python3 -m http.server 8000
```

### Étape 3 : Ouvrir le dashboard
Dans votre navigateur :
```
http://localhost:8000/dashboard_final.html
```

### Arrêter les services
```bash
# Arrêter le serveur web : Ctrl+C dans le terminal
# Arrêter Docker :
docker-compose down
```

---

## 📁 STRUCTURE DU PROJET
```
gdal-docker/
│
├── data/                          # Données géospatiales
│   ├── analyse_velo_mtl.json     # Réseau cyclable (GeoJSON WGS84)
│   ├── buffer_fusionne.json      # Zones 500m fusionnées
│   └── analyse_velo_quebec_complete.gpkg  # GeoPackage complet
│
├── outputs/                       # Livrables finaux
│   ├── package_velo_quebec_mbacke_diop.zip  # Archive complète (6.4 MB)
│   ├── analyse_velo_quebec_complete.gpkg    # Données SIG (14 MB)
│   ├── style_pistes_cyclables.qml           # Style QGIS
│   ├── README.md                            # Documentation
│   └── analyse_stats.py                     # Script Python
│
├── dashboard_final.html           # 👑 DASHBOARD PRINCIPAL
├── carte_velo_mtl.html           # Carte interactive simple
├── docker-compose.yml            # Configuration Docker
├── Dockerfile                    # Image GDAL personnalisée
└── README.md                     # Cette documentation
```

---

## 🛠️ MÉTHODOLOGIE TECHNIQUE

### Pipeline de traitement GDAL

#### 1. Téléchargement des données (API directe)
```bash
# Réseau cyclable
ogr2ogr -f GPKG cyclable_clean.gpkg -makevalid -t_srs EPSG:32188 \
  /vsicurl/https://donnees.montreal.ca/.../reseau_cyclable.geojson

# Espaces verts
ogr2ogr -f GPKG parcs.gpkg -t_srs EPSG:32188 \
  /vsicurl/https://donnees.montreal.ca/.../espace_vert.json
```

#### 2. Création des buffers (500m)
```bash
ogr2ogr -f GPKG parcs_500m.gpkg \
  -dialect sqlite \
  -sql "SELECT ST_Buffer(geom, 500) AS geom, Nom FROM espaces_verts" \
  parcs.gpkg
```

#### 3. Intersection spatiale
```bash
ogr2ogr -f GPKG cyclable_proche_parcs.gpkg \
  cyclable_clean.gpkg \
  -clipsrc parcs_500m.gpkg
```

#### 4. Analyse statistique
```bash
ogrinfo -sql "SELECT 
  TYPE_VOIE_DESC, 
  COUNT(*) as nb_segments,
  ROUND(SUM(LONGUEUR)/1000.0, 2) as km_total
FROM reseau_cyclable 
GROUP BY TYPE_VOIE_DESC 
ORDER BY km_total DESC" \
cyclable_proche_parcs.gpkg
```

#### 5. Export web (WGS84)
```bash
ogr2ogr -f GeoJSON -t_srs EPSG:4326 \
  analyse_velo_mtl.json \
  cyclable_proche_parcs.gpkg
```

### Technologies utilisées
- **GDAL 3.9** - Traitement vectoriel et analyses spatiales
- **SQLite/PostGIS** - Requêtes spatiales (ST_Buffer, ST_Intersects, ST_Union)
- **Docker** - Containerisation et reproductibilité
- **Leaflet.js** - Cartographie web interactive
- **Python + GDAL/OGR** - Automatisation et statistiques

### Projections cartographiques
- **Source:** EPSG:4326 (WGS84) - Données brutes
- **Traitement:** EPSG:32188 (NAD83 / MTM zone 8) - Précision métrique
- **Visualisation:** EPSG:4326 (WGS84) - Compatibilité web

### Sources de données
- Réseau cyclable: [Données ouvertes Ville de Montréal](https://donnees.montreal.ca)
- Espaces verts: [Données ouvertes Ville de Montréal](https://donnees.montreal.ca)
- Licence: ODbL (Open Database License)

---

## 💻 UTILISATION

### Dashboard interactif

**Accès:** `http://localhost:8000/dashboard_final.html`

**Fonctionnalités:**
- ✅ KPIs en temps réel (linéaire, sécurité, parcs)
- ✅ Carte interactive avec 8 types de voies colorées
- ✅ Survol des pistes pour afficher les détails
- ✅ Contrôle de couches (fonds de carte, pistes, zones 500m)
- ✅ Légende dynamique
- ✅ Tableaux statistiques détaillés par type et arrondissement
- ✅ Sidebar redimensionnable

**Interactions:**
1. **Survoler** une piste → Info box affiche type, longueur, arrondissement
2. **Contrôle de couches** (coin supérieur gauche) → Activer/désactiver les couches
3. **Légende** (coin inférieur droit) → Référence des couleurs par type de voie
4. **Redimensionner** la sidebar → Glisser le bord pour ajuster la largeur

### Analyse dans QGIS

**Ouvrir le GeoPackage:**
```
1. QGIS → Couche → Ajouter une couche → Vecteur
2. Sélectionner: outputs/analyse_velo_quebec_complete.gpkg
3. Charger les 2 couches:
   - reseau_cyclable (lignes - 8,300 segments)
   - zones_500m (polygones - buffers)
```

**Appliquer le style professionnel:**
```
1. Clic droit sur "reseau_cyclable" → Propriétés
2. Symbologie → Charger le style
3. Sélectionner: outputs/style_pistes_cyclables.qml
```

### Script Python d'analyse
```bash
# Exécuter dans le conteneur Docker
docker exec gdal-toolbox python3 /workspaces/gdal-docker/outputs/analyse_stats.py

# Sortie : Statistiques JSON détaillées
```

---

## 📦 FICHIERS LIVRABLES

### Package complet (6.4 MB)
`outputs/package_velo_quebec_mbacke_diop.zip`

**Contenu:**
1. `analyse_velo_quebec_complete.gpkg` (14 MB) - GeoPackage multi-couches
2. `style_pistes_cyclables.qml` - Symbologie QGIS professionnelle
3. `README.md` - Documentation complète
4. `analyse_stats.py` - Script Python reproductible

### Visualisations web
- `dashboard_final.html` - Dashboard analytique complet avec KPIs
- `carte_velo_mtl.html` - Carte interactive simple

### Données géospatiales
- Format: GeoPackage (norme OGC)
- Projection: NAD83 / MTM zone 8 (EPSG:32188)
- Géométries: Validées avec `-makevalid`
- Couches: reseau_cyclable (LineString), zones_500m (MultiPolygon)

---

## 🎯 RECOMMANDATIONS STRATÉGIQUES

### Priorité 1: SÉCURITÉ CYCLISTE
**Enjeu:** Seulement 16.9% du réseau est en site propre, 71.5% sans séparateur physique.

**Actions:**
- Convertir les 256.6 km de bandes cyclables en pistes séparées
- Installer des séparateurs physiques (délinéateurs, mail, surélévation) sur les 692 km non protégés
- Prioriser les axes à fort débit et les corridors scolaires
- **Budget estimé:** ~150M$ (à 200$/mètre linéaire pour séparateurs)

### Priorité 2: ÉQUITÉ TERRITORIALE
**Enjeu:** Disparités importantes entre arrondissements centraux et périphériques.

**Actions:**
- Renforcer le réseau au Plateau-Mont-Royal (56.99 km vs densité élevée)
- Améliorer Ville-Marie (58.55 km) - sous-desservi par rapport à la densité de population
- Connecter les parcs encore isolés (5-10% estimé)
- Créer des corridors verts inter-arrondissements

### Priorité 3: MONITORING ET DONNÉES
**Enjeu:** Besoin de suivi continu pour mesurer l'évolution du réseau.

**Actions:**
- Pipeline GDAL automatisé (cron jobs annuels pour mise à jour)
- Intégration API compteurs cyclistes (Eco-Visio) pour flux temps réel
- Dashboard interactif public pour transparence
- Collecte systématique données accidents (SAAQ)

---

## 🔬 EXTENSIONS POSSIBLES

### Analyses multi-critères
1. **Topographie:** Intégration MNT pour calcul des pentes et identification des axes difficiles
2. **Sécurité:** Données accidents SAAQ + points noirs + éclairage nocturne
3. **Flux cyclistes:** Intégration compteurs Eco-Visio + données BIXI (origine-destination)
4. **Déneigement:** Analyse de priorisation hivernale et accessibilité 4 saisons
5. **Qualité du revêtement:** État de la chaussée et besoins d'entretien

### Modélisation avancée
- **Isochrones:** Temps de parcours vélo depuis points d'intérêt
- **Origine-destination:** Trajets domicile-travail optimaux
- **Plus court chemin sécurisé:** Algorithmes de routage priorisant la sécurité
- **Analyse de réseau:** Centralité, connectivité, points de coupure critiques

### Scalabilité provinciale
- Déploiement à l'échelle du Québec (adaptation des seuils de distance)
- API REST pour accès temps réel aux données
- CI/CD (GitHub Actions) pour mises à jour automatiques
- Serveur PostGIS pour performances optimales sur grandes volumétries

---

## 📧 CONTACT

**Ibrahimakhalil Mbacke**  
Maîtrise en Géomatique - UQAM  
Email: [votre-email]  
GitHub: [@ibrahimakhalil2701](https://github.com/ibrahimakhalil2701)  
LinkedIn: [Votre profil LinkedIn]

---

## 📄 LICENCE ET CRÉDITS

**Projet réalisé dans le cadre d'une candidature professionnelle.**

**Sources de données:**
- Ville de Montréal - Données ouvertes (Licence ODbL)
- Réseau cyclable de Montréal (mise à jour novembre 2025)
- Espaces verts municipaux (mise à jour novembre 2025)

**Technologies open source:**
- GDAL/OGR (MIT License)
- Leaflet.js (BSD 2-Clause License)
- Docker (Apache License 2.0)

---

**Projet réalisé avec ❤️ pour Vélo Québec**  
*"Promouvoir la sécurité et l'accessibilité du vélo au Québec"*

---

## 🏆 MÉTADONNÉES DU PROJET

**Temps de réalisation:** 4 heures  
**Temps de calcul:** 5 minutes (analyse complète)  
**Taille des données:** 14 MB (GeoPackage final)  
**Nombre de features:** 8,300 segments + 2,239 parcs  
**Précision spatiale:** ±5m (GPS standard)  
**Date d'analyse:** 15 novembre 2025  
**Version GDAL:** 3.9.0  
**Projection native:** NAD83 / MTM zone 8 (EPSG:32188)