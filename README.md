# Colombie — carte interactive du voyage (15 août → 5 sept.)

## Contexte
Carte interactive pour présenter à ma copine notre itinéraire en Colombie, à deux.
Construite d'abord dans Claude.ai (artefact web), reprise ici dans un vrai environnement de dev.

## Contraintes du voyage (à respecter si l'itinéraire est modifié)
- Dates fixes : arrivée Bogotá le 15/08 à 19h25, départ Bogotá le 05/09 à 21h35 (21 nuits).
- **3 vols au total** : aller-retour Bogotá ↔ Leticia (Amazonie, injoignable par la route)
  + Santa Marta → Bogotá au retour, pour éviter un bus de 17h le dernier jour.
- Bus de nuit acceptés, max 3-4 sur tout le trajet (actuellement 2).
- Rythme : 1 à 4 nuits par **lieu de couchage**, jamais plus. Le bloc « Cartagena &
  les îles » compte 6 nuits mais réparties sur 2-3 lieux distincts, donc la règle tient.
- Pas de permis de conduire → aucun trajet en voiture de location, tout doit rester
  accessible en bus / bateau / à pied.

## Étapes actuelles (dans l'ordre)
| # | Étape | Dates | Nuits | Arrivée par |
|---|---|---|---|---|
| 1 | Bogotá (arrivée) | 15 août | 1 | vol international, 19h25 |
| 2 | Leticia & Amazonie | 16-19 août | 3 | vol direct Bogotá→Leticia (~2h) |
| 3 | Salento & Cocora | 20-21 août | 1 | vol retour le 19 + bus de nuit Bogotá→Salento |
| 4 | Medellín | 21-24 août | 3 | bus de jour Salento→Medellín (~6h) |
| 5 | Guatapé & le Peñón | 24-25 août | 1 | bus court Medellín→Guatapé (~1h30) |
| 6 | Cartagena & les îles | 26 août-1 sept. | 6 | bus de nuit Medellín→Cartagena (~12-14h) |
| ↳ | Cartagena — ville murée | 26-27 août | 2 | — |
| ↳ | Islas del Rosario | 28-29 août | 2 | lancha ~1h depuis Cartagena |
| ↳ | Îles de San Bernardo | 30-31 août | 2 | bateau ~1h30 depuis Rosario |
| 7 | Santa Marta & la Sierra | 1-4 sept. | 3 | bus de jour Cartagena→Santa Marta (~4-5h) |
| 8 | Bogotá (départ) | 4-5 sept. | 1 | **vol** direct Santa Marta→Bogotá (~1h30) |

**Bilan** : 19 nuits en lit + 2 nuits passées dans un bus de nuit = 21 nuits.
3 segments de vol, 2 bus de nuit.

### Le mode de transport composite `flightnight`
L'arrivée à Salento (étape 3) est un transfert unique qui enchaîne **deux modes** :
vol Leticia→Bogotá en journée, puis bus de nuit Bogotá→Salento. Le réduire à `flight`
ou à `night` fausserait le décompte affiché. D'où un mode dédié `flightnight`, déclaré
dans `MODES` / `LEG_TXT` / `LEG_CLASS` / `legStyle`, plus la carte de dégradés du ruban,
la CSS `.leg .l-line.flightnight` et `.lm.flightnight` de la légende. **Si tu ajoutes un
mode, ces 7 endroits doivent être mis à jour ensemble** — sinon le tracé retombe
silencieusement sur le style `day`.

### Le bloc Cartagena : une étape, trois lieux de couchage
L'étape 6 est **une seule entrée de `STOPS`** (sinon la carte afficherait 10 étapes au
lieu de 8), mais ses `subs` portent chacune `dates` + `nights` : ce sont de vrais lieux
où l'on dort, pas des excursions à la journée. Le rendu s'adapte tout seul :
- une `sub` avec `nights` affiche un badge « 2 n » dans sa puce (`.sub-stay`) ;
- `popupHTML` utilise déjà `s.dates` pour son sur-titre, donc les popups des îles
  affichent leurs dates sans code supplémentaire.
La somme des nuits des `subs` doit égaler le `nights` de l'étape parente (6) — c'est
vérifié en test, pas garanti par le code.

**Progression géographique** : Cartagena → Rosario → San Bernardo descend vers le sud,
donc chaque saut est court (~1h, puis ~1h30). Le prix à payer est la remontée du
1ᵉʳ septembre : lancha directe San Bernardo→Cartagena (~2h) + bus →Santa Marta (~4-5h).
Inverser Rosario et San Bernardo rendrait ce dernier jour plus léger, au prix de deux
sauts plus longs au milieu.

### Logements (`LODGING`) — 10 lieux, 81 hébergements réels
Un panneau modal par **lieu de couchage** (bouton « 🛏 Logements » dans la fiche
dépliée), avec trois catégories : abordable / haut du budget / original. Les données
ont été relevées **sur les pages de résultats Airbnb et Booking en direct**, aux dates
exactes de chaque étape — nom, prix par nuit, total, note, nombre d'avis, plateforme.
`CURATED_ON` porte la date du relevé, affichée dans le modal.

**Ce que les URLs peuvent pré-régler** (vérifié en navigateur réel, pas supposé) :
lieu, check-in/check-out, 2 adultes / 1 chambre, devise EUR. **Ce qu'elles ne peuvent
pas** : la fourchette de prix et le type de logement — testé en 3 variantes chez Airbnb
(`price_max` seul, + `price_filter_input_type`/`num_nights`, + `search_type=filter_change`)
et 2 chez Booking (`nflt=price=EUR-min-45-1`, `EUR-0-45-1`). Aucune ne s'applique. Ces
paramètres ont donc été **retirés** des liens plutôt que de faire semblant, et les
critères manuels sont affichés dans le modal pour les catégories sans sélection.

Airbnb veut `", "` écrit `--` dans son segment d'URL (`airbnbSlug`), sinon il affiche
un `%2C` littéral dans sa propre interface.

**Trois étapes n'ont pas 9 propositions, volontairement** — la consigne était de le dire
plutôt que de compléter avec du médiocre :
- **Medellín (8)** : la ville n'a pas de logement atypique dans ce budget, l'offre est
  massivement composée d'appartements modernes.
- **Islas del Rosario (5)** : 12 annonces Airbnb sur 18 et 23 résultats Booking sur 25
  dépassent le plafond de 80 €. Une seule option sous 45 €. L'étape la plus contrainte.
- **Îles de San Bernardo (6)** : un seul hébergement réellement *sur* les îles tient
  sous 80 € (Tintipán). Le reste est à Rincón del Mar, sur le continent.

### Guatapé : sous-lieu → étape
Guatapé était un `sub` de Medellín (excursion à la journée). C'est maintenant une étape
principale avec nuitée, donc retirée des `subs` de Medellín. Medellín n'a plus de
sous-lieu du tout, ce qui est normal.

### Historique des réordonnancements
1. **Prototype** : Leticia au milieu, comme pont Medellín→Leticia→Cartagena — 4 segments
   de vol, chacun via Bogotá en correspondance.
2. **1ʳᵉ refonte** : Leticia déplacée juste après l'arrivée, en aller-retour direct
   depuis Bogotá (2 segments, sans correspondance). La distance Antioquia→Caraïbe,
   auparavant portée par le vol, devient un bus de nuit Medellín→Cartagena.
3. **Refonte actuelle** : Guatapé promu en étape, bloc Cartagena étendu à 6 nuits sur
   plusieurs lieux, et le bus de nuit final Santa Marta→Bogotá remplacé par un vol
   (~1h30 au lieu de ~17h) pour ne pas sacrifier la dernière journée. D'où 3 vols.

## Lancer en local
Les tuiles de carte et `/images` ne se chargent pas en `file://` — il faut un serveur.

Le plus simple : double-clique **`Ouvrir la carte.command`** dans le Finder. Il démarre
le serveur s'il ne tourne pas déjà, puis ouvre `http://127.0.0.1:8777` dans le navigateur
par défaut. Le serveur continue de tourner en arrière-plan (visible dans le Moniteur
d'activité sous `node`) ; relancer le `.command` plus tard réutilise ce même serveur au
lieu d'en ouvrir un second.

En ligne de commande, c'est équivalent à :

```
node serve.mjs      # http://127.0.0.1:8777
```

(`.claude/launch.json` déclare le même serveur pour l'outil de preview.)

Remarque : ceci reste un serveur **local** (accessible uniquement depuis ce Mac). Ce
n'est pas une URL publique — voir la discussion dans l'historique de conversation si un
vrai lien partageable (GitHub Pages ou équivalent) est souhaité un jour ; la carte
dépend de tuiles externes (Esri, CARTO) que les Artifacts ne peuvent pas charger, donc
ce n'est pas publiable tel quel via ce chemin-là.

## Fichiers
- `index.html` — la carte (Leaflet + panneau latéral). Un seul fichier autonome :
  le contour de la Colombie (`window.COL_GEO`) et les crédits photo sont injectés
  inline dans un `<script>`, dupliqués depuis `data/colombia.geojson` et
  `images/credits.json`.
- `serve.mjs` — serveur statique minimal pour le dev.
- `images/` — 19 photos (Wikimedia Commons, licences libres) + `credits.json`
  (auteur / licence / URL source pour chacune). `PHOTO_CREDITS` dans `index.html`
  est un miroir inline de ce fichier : **si tu ajoutes une photo, mets à jour les deux**,
  sinon la ligne de crédit manquera dans le pied de page.
- `data/colombia.geojson` — contour de la Colombie (simplifié, Natural Earth 50m).
- `data/neighbors.geojson` — pays voisins (simplifiés, Natural Earth 50m).
  **Plus utilisé** depuis le passage aux vraies tuiles ; conservé au cas où.

## Fond de carte
Deux couches, bascule par le bouton en haut à gauche :
- **Relief** (défaut) — Esri World Hillshade, avec CARTO Voyager par-dessus en
  `mix-blend-mode: multiply`, puis les labels Voyager. Le hillshade est poussé en
  contraste (`.tl-relief`) pour que les cordillères ressortent dès le zoom 5 sans
  assombrir les plaines.
- **Satellite** — Esri World Imagery + labels Voyager. Les tracés passent
  automatiquement en blanc (`legFor`), sinon ils disparaissent dans l'imagerie.

## Détails d'implémentation à connaître
- **Photos et fallback** — chaque visuel superpose une `<img class="ph">` au couple
  dégradé + illustration SVG. Un handler `error` en phase de capture retire l'`<img>`
  si le fichier manque, et l'illustration reprend la main. L'illustration est
  enveloppée dans `.ph-art` (contexte d'empilement) : sans ça, la règle Leaflet
  `.leaflet-map-pane svg { z-index:200 }` la fait passer **au-dessus** de la photo
  dans les popups, parce qu'un `z-index` s'applique à un enfant de grille même en
  `position:static`.
- **Tracé animé** — `traceLine()` dessine chaque segment via `stroke-dasharray` /
  `stroke-dashoffset`, puis `settle()` restaure le vrai motif (plein / tirets /
  pointillés). Le retour au motif passe par un `setTimeout`, pas par `transitionend`,
  pour que la ligne réapparaisse même si la transition ne se déclenche jamais.
  Un `zoomstart`/`movestart` en cours d'animation la termine d'un coup (un pan
  réécrit la géométrie du path et invaliderait les longueurs).
- **Mode présentation** — boucle `async` gardée par un jeton (`tourToken`) ;
  tout arrêt (bouton, Échap, Espace, clic manuel, changement de filtre) incrémente
  le jeton et purge les timers, donc une boucle périmée ne peut pas reprendre la main.
- **DETAILS[]** — trajet / budget / météo, volontairement séparé de `STOPS[]` pour
  que les données d'itinéraire (étapes, dates) restent intactes. Budgets et météo
  sont des **estimations**, signalées comme telles dans le pied de page.
