#!/usr/bin/env python3
"""Statistiques réseau cyclable - Vélo Québec"""

from osgeo import ogr
import json

gpkg = ogr.Open('/data/cyclable_proche_parcs.gpkg')
layer = gpkg.GetLayer('reseau_cyclable')

stats = {'total_km': 0, 'securise_km': 0, 'par_type': {}}

for feature in layer:
    km = feature.GetField('LONGUEUR') / 1000.0
    type_voie = feature.GetField('TYPE_VOIE_DESC')
    
    stats['total_km'] += km
    if 'site propre' in type_voie:
        stats['securise_km'] += km
    
    stats['par_type'][type_voie] = stats['par_type'].get(type_voie, 0) + km

stats['taux_securite'] = round(stats['securise_km'] / stats['total_km'] * 100, 1)

print(json.dumps(stats, indent=2, ensure_ascii=False))
