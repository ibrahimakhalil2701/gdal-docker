# 🚴 Analyse Réseau Cyclable Montréal - Vélo Québec

**Candidat:** Mbacke Diop  
**Poste:** Cartographe-Géomaticien  
**Date:** 15 novembre 2025  
**Entretien:** 17 novembre 2025

## �� CONTENU DU PACKAGE

1. **analyse_velo_quebec_complete.gpkg** - GeoPackage (968 km analysés)
2. **style_pistes_cyclables.qml** - Style QGIS
3. **README.md** - Ce fichier

## 📊 RÉSULTATS CLÉS

- **968 km** de pistes à <500m des parcs
- **16.9%** seulement en site propre (ENJEU!)
- **71.5%** sans séparateur physique
- **Top arrondissement:** RDP (96.7 km)

## 🛠️ UTILISATION

### Dans QGIS:
1. Layer → Add Vector Layer
2. Sélectionner: analyse_velo_quebec_complete.gpkg
3. Charger le style: style_pistes_cyclables.qml

### Méthodologie:
- GDAL 3.9 (ogr2ogr, ST_Buffer, ST_Intersects)
- Docker containerisé
- Données: Ville de Montréal (Open Data)
- Projection: MTM8 (EPSG:32188)

## 💡 RECOMMANDATIONS

1. **Sécurité:** Convertir 257 km de bandes en pistes séparées
2. **Équité:** Renforcer Plateau & Ville-Marie
3. **Monitoring:** Pipeline automatisé annuel

---

**Contact:** Mbacke Diop | Géomaticien M.Sc. (UQAM)
