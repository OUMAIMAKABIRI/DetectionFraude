# Guide des Visualisations - Détection de Fraude Bancaire

**Projet:** Détection de fraude bancaire  
**Étudiante:** Oumaima Kabiri

---

## Vue d'ensemble

Ce document explique les 10 visualisations générées pour votre projet de détection de fraude. Chaque graphique illustre un aspect important de votre analyse.

---

## Liste des Graphiques

### 1. **Distribution des Transactions (Original)**
**Fichier:** `1_distribution_original.png`

**Ce qu'il montre:**
- Nombre total de transactions normales vs frauduleuses dans le dataset original
- Met en évidence le déséquilibre extrême des classes

**Interprétation:**
- 284,315 transactions normales (vert)
- 492 transactions frauduleuses (rouge)
- Ratio: ~578:1 (problème de classe déséquilibrée)

---

### 2. **Répartition Normal vs Fraude**
**Fichier:** `2_pourcentage_fraude.png`

**Ce qu'il montre:**
- Diagramme circulaire montrant les pourcentages exacts
- Normal: 99.83%
- Fraude: 0.17%

**Pourquoi c'est important:**
Cette visualisation justifie l'utilisation de SMOTE pour équilibrer les classes.

---

### 3. **Impact de SMOTE sur l'Équilibrage des Classes**
**Fichier:** `3_smote_comparison.png`

**Ce qu'il montre:**
- Comparaison Avant/Après SMOTE sur le dataset d'entraînement
- **Avant SMOTE:** 227,456 normales, ~390 fraudes
- **Après SMOTE:** 227,456 normales, 4,290 fraudes

**Interprétation:**
SMOTE a créé des exemples synthétiques de fraudes pour améliorer l'apprentissage du modèle sur la classe minoritaire.

---

### 4. **Comparaison des Performances des Modèles**
**Fichier:** `4_performance_comparison.png`

**Ce qu'il montre:**
Graphique comparatif des 3 modèles sur 4 métriques:
- **Accuracy** (précision globale)
- **Sensitivity** (taux de détection des transactions normales)
- **Specificity** (taux de détection des fraudes)
- **Kappa** (accord au-delà du hasard)

**Points clés:**
- RF et RF+SMOTE ont une accuracy quasi-identique (~99.96%)
- RF+SMOTE a la meilleure Specificity (84.31%) = meilleure détection des fraudes
- Isolation Forest a la plus faible performance globale (Kappa = 0.25)

---

### 5-7. **Matrices de Confusion**
**Fichiers:** 
- `5_confusion_matrix_rf.png` (Random Forest)
- `6_confusion_matrix_iso.png` (Isolation Forest)
- `7_confusion_matrix_smote.png` (RF + SMOTE)

**Ce qu'elles montrent:**
Tableau 2x2 pour chaque modèle:
- **Coins supérieur gauche et inférieur droit:** Prédictions correctes (vert foncé)
- **Coins supérieur droit et inférieur gauche:** Erreurs (rouge foncé)

**Lecture:**
| Prédiction ↓ / Réalité → | Normal | Fraude |
|---------------------------|--------|--------|
| **Normal**                | Vrais Négatifs | Faux Négatifs (MANQUÉS) |
| **Fraude**                | Faux Positifs | Vrais Positifs (DÉTECTÉS) |

**Comparaison:**
- **Random Forest:** 83 fraudes détectées, 19 manquées
- **Isolation Forest:** 65 fraudes détectées, 37 manquées
- **RF + SMOTE:** 86 fraudes détectées, 16 manquées ✓ MEILLEUR

---

### 8. **Performance de Détection des Fraudes**
**Fichier:** `8_fraud_detection_performance.png`

**Ce qu'il montre:**
Graphique empilé montrant pour chaque modèle:
- Fraudes correctement détectées (vert)
- Fraudes manquées (rouge)

**Résultats:**
Sur 102 transactions frauduleuses dans le test:
- Random Forest: 83 détectées (81%)
- Isolation Forest: 65 détectées (64%)
- RF + SMOTE: **86 détectées (84%)** 🏆

---

### 9. **Taux de Détection des Fraudes (Recall)**
**Fichier:** `9_recall_comparison.png`

**Ce qu'il montre:**
Le taux de détection (Recall) pour chaque modèle en pourcentage

**Classement:**
1. **RF + SMOTE: 84.3%** (champion)
2. Random Forest: 81.4%
3. Isolation Forest: 63.7%

**Pourquoi c'est important:**
Dans la détection de fraude, manquer une fraude coûte cher. Un Recall élevé est crucial.

---

### 10. **Dashboard - Métriques Clés**
**Fichier:** `10_dashboard_metrics.png`

**Ce qu'il montre:**
Vue d'ensemble en 3 panneaux:
- **Accuracy:** Performance globale
- **Recall Fraude:** Capacité à détecter les fraudes
- **Specificity:** Capacité à identifier les transactions normales

**Synthèse:**
Ce graphique permet de comparer rapidement les 3 modèles sur les métriques essentielles.

---

## Comment Utiliser ces Graphiques dans votre Présentation

### Structure Suggérée:

1. **Introduction du Problème**
   - Montrer graphiques #1 et #2 (déséquilibre des classes)

2. **Solution Proposée: SMOTE**
   - Montrer graphique #3 (équilibrage)

3. **Résultats Globaux**
   - Montrer graphiques #4 et #10 (comparaison des performances)

4. **Focus sur la Détection de Fraudes**
   - Montrer graphiques #8 et #9 (performances spécifiques)

5. **Détails Techniques**
   - Montrer graphiques #5, #6, #7 (matrices de confusion)

---

## Conclusion Principale

**Modèle Recommandé:** Random Forest + SMOTE

**Justification:**
- ✓ Meilleur taux de détection des fraudes (84.3%)
- ✓ Seulement 16 fraudes manquées (vs 19 pour RF classique)
- ✓ Excellent équilibre entre précision et recall
- ✓ Kappa le plus élevé (0.8864)

---

## Points Clés pour votre Rapport

1. **Problème:** Dataset très déséquilibré (99.83% normal, 0.17% fraude)
2. **Solution:** Application de SMOTE pour créer des exemples synthétiques
3. **Résultat:** Amélioration de 2.9 points de pourcentage du recall fraude
4. **Impact:** 3 fraudes supplémentaires détectées sur 102 dans le test set

---

## Suggestions d'Amélioration Future

1. Tester d'autres techniques d'équilibrage (ADASYN, Borderline-SMOTE)
2. Optimiser les hyperparamètres avec GridSearch
3. Tester d'autres algorithmes (XGBoost, LightGBM)
4. Analyser l'importance des features (variables V1-V28)
5. Calculer le coût-bénéfice des faux positifs vs faux négatifs

---

## Pour Exécuter les Visualisations

```r
# Dans RStudio ou R Console:
source("visualizations_fraud.R")
```

**Prérequis:**
- Le fichier `creditcard.csv` doit être dans le même répertoire
- Packages nécessaires: readr, dplyr, ggplot2, gridExtra, scales, tidyr

**Résultat:**
10 fichiers PNG haute résolution (300 DPI) prêts pour votre présentation!

---

