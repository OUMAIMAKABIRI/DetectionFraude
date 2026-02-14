###########################################################
# Visualisations - Détection de fraude bancaire
# Etudiante : Oumaima Kabiri
###########################################################

library(readr)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(scales)

# Charger les données
df <- read_csv("creditcard.csv")

###########################################################
# 1. Distribution des classes (Original)
###########################################################

plot1 <- ggplot(df, aes(x = factor(Class), fill = factor(Class))) +
  geom_bar(width = 0.6) +
  geom_text(stat='count', aes(label=comma(..count..)), vjust=-0.5, size=5) +
  scale_fill_manual(values = c("0" = "#2ecc71", "1" = "#e74c3c"),
                    labels = c("Normal", "Fraude")) +
  labs(title = "Distribution des Transactions (Original)",
       x = "Type de Transaction",
       y = "Nombre de Transactions",
       fill = "Classe") +
  scale_x_discrete(labels = c("Normal", "Fraude")) +
  scale_y_continuous(labels = comma) +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        legend.position = "right")

ggsave("1_distribution_original.png", plot1, width = 10, height = 6, dpi = 300)
print(plot1)

###########################################################
# 2. Pourcentage de fraude
###########################################################

fraud_stats <- df %>%
  group_by(Class) %>%
  summarise(count = n()) %>%
  mutate(percentage = count/sum(count) * 100,
         label = paste0(round(percentage, 2), "%"))

plot2 <- ggplot(fraud_stats, aes(x = "", y = percentage, fill = factor(Class))) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = label), 
            position = position_stack(vjust = 0.5),
            size = 6, fontface = "bold") +
  scale_fill_manual(values = c("0" = "#2ecc71", "1" = "#e74c3c"),
                    labels = c("Normal (99.83%)", "Fraude (0.17%)")) +
  labs(title = "Répartition Normal vs Fraude",
       fill = "Type") +
  theme_void(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))

ggsave("2_pourcentage_fraude.png", plot2, width = 8, height = 6, dpi = 300)
print(plot2)

###########################################################
# 3. Comparaison Avant/Après SMOTE
###########################################################

smote_comparison <- data.frame(
  Type = rep(c("Avant SMOTE", "Après SMOTE"), each = 2),
  Class = rep(c("Normal", "Fraude"), 2),
  Count = c(227846 - 390, 390, 227456, 4290)  # Approximations basées sur les résultats
)

plot3 <- ggplot(smote_comparison, aes(x = Type, y = Count, fill = Class)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = comma(Count)), 
            position = position_dodge(width = 0.7),
            vjust = -0.5, size = 4) +
  scale_fill_manual(values = c("Normal" = "#2ecc71", "Fraude" = "#e74c3c")) +
  scale_y_continuous(labels = comma, limits = c(0, 240000)) +
  labs(title = "Impact de SMOTE sur l'Équilibrage des Classes",
       subtitle = "Dataset d'entraînement",
       x = "",
       y = "Nombre de Transactions",
       fill = "Classe") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        plot.subtitle = element_text(hjust = 0.5, size = 12))

ggsave("3_smote_comparison.png", plot3, width = 10, height = 6, dpi = 300)
print(plot3)

###########################################################
# 4. Comparaison des Performances des Modèles
###########################################################

# Données de performance basées sur les résultats
performance_data <- data.frame(
  Modele = rep(c("Random Forest", "Isolation Forest", "RF + SMOTE"), each = 4),
  Metrique = rep(c("Accuracy", "Sensitivity", "Specificity", "Kappa"), 3),
  Valeur = c(
    # Random Forest
    0.9996, 0.9999, 0.8137, 0.8781,
    # Isolation Forest
    0.9933, 0.9940, 0.6373, 0.2528,
    # RF + SMOTE
    0.9996, 0.9999, 0.8431, 0.8864
  )
)

plot4 <- ggplot(performance_data, aes(x = Metrique, y = Valeur, fill = Modele)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = sprintf("%.3f", Valeur)), 
            position = position_dodge(width = 0.7),
            vjust = -0.5, size = 3.5) +
  scale_fill_manual(values = c("Random Forest" = "#3498db", 
                                "Isolation Forest" = "#e67e22",
                                "RF + SMOTE" = "#9b59b6")) +
  labs(title = "Comparaison des Performances des Modèles",
       x = "Métriques",
       y = "Valeur",
       fill = "Modèle") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        axis.text.x = element_text(angle = 0)) +
  ylim(0, 1.1)

ggsave("4_performance_comparison.png", plot4, width = 12, height = 6, dpi = 300)
print(plot4)

###########################################################
# 5. Matrice de Confusion - Random Forest
###########################################################

# Données pour RF
rf_matrix <- data.frame(
  Prediction = c("Normal", "Normal", "Fraude", "Fraude"),
  Reference = c("Normal", "Fraude", "Normal", "Fraude"),
  Count = c(56855, 19, 4, 83)
)

plot5 <- ggplot(rf_matrix, aes(x = Reference, y = Prediction, fill = Count)) +
  geom_tile(color = "white", size = 1.5) +
  geom_text(aes(label = Count), size = 8, fontface = "bold", color = "white") +
  scale_fill_gradient(low = "#3498db", high = "#e74c3c", labels = comma) +
  labs(title = "Matrice de Confusion - Random Forest",
       x = "Classe Réelle",
       y = "Classe Prédite") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        panel.grid = element_blank())

ggsave("5_confusion_matrix_rf.png", plot5, width = 8, height = 6, dpi = 300)
print(plot5)

###########################################################
# 6. Matrice de Confusion - Isolation Forest
###########################################################

iso_matrix <- data.frame(
  Prediction = c("Normal", "Normal", "Fraude", "Fraude"),
  Reference = c("Normal", "Fraude", "Normal", "Fraude"),
  Count = c(56516, 37, 343, 65)
)

plot6 <- ggplot(iso_matrix, aes(x = Reference, y = Prediction, fill = Count)) +
  geom_tile(color = "white", size = 1.5) +
  geom_text(aes(label = Count), size = 8, fontface = "bold", color = "white") +
  scale_fill_gradient(low = "#3498db", high = "#e74c3c", labels = comma) +
  labs(title = "Matrice de Confusion - Isolation Forest",
       x = "Classe Réelle",
       y = "Classe Prédite") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        panel.grid = element_blank())

ggsave("6_confusion_matrix_iso.png", plot6, width = 8, height = 6, dpi = 300)
print(plot6)

###########################################################
# 7. Matrice de Confusion - RF + SMOTE
###########################################################

smote_matrix <- data.frame(
  Prediction = c("Normal", "Normal", "Fraude", "Fraude"),
  Reference = c("Normal", "Fraude", "Normal", "Fraude"),
  Count = c(56853, 16, 6, 86)
)

plot7 <- ggplot(smote_matrix, aes(x = Reference, y = Prediction, fill = Count)) +
  geom_tile(color = "white", size = 1.5) +
  geom_text(aes(label = Count), size = 8, fontface = "bold", color = "white") +
  scale_fill_gradient(low = "#3498db", high = "#e74c3c", labels = comma) +
  labs(title = "Matrice de Confusion - Random Forest + SMOTE",
       x = "Classe Réelle",
       y = "Classe Prédite") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        panel.grid = element_blank())

ggsave("7_confusion_matrix_smote.png", plot7, width = 8, height = 6, dpi = 300)
print(plot7)

###########################################################
# 8. Comparaison Spécifique : Détection des Fraudes
###########################################################

fraud_detection <- data.frame(
  Modele = c("Random Forest", "Isolation Forest", "RF + SMOTE"),
  Detectees = c(83, 65, 86),
  Manquees = c(19, 37, 16),
  Total = c(102, 102, 102)
)

fraud_detection_long <- fraud_detection %>%
  select(Modele, Detectees, Manquees) %>%
  tidyr::pivot_longer(cols = c(Detectees, Manquees), 
                      names_to = "Type", 
                      values_to = "Count")

plot8 <- ggplot(fraud_detection_long, aes(x = Modele, y = Count, fill = Type)) +
  geom_bar(stat = "identity", position = "stack", width = 0.6) +
  geom_text(aes(label = Count), 
            position = position_stack(vjust = 0.5),
            size = 5, fontface = "bold", color = "white") +
  scale_fill_manual(values = c("Detectees" = "#27ae60", "Manquees" = "#e74c3c"),
                    labels = c("Fraudes Détectées", "Fraudes Manquées")) +
  labs(title = "Performance de Détection des Fraudes",
       subtitle = "Sur 102 transactions frauduleuses dans le test set",
       x = "Modèle",
       y = "Nombre de Fraudes",
       fill = "") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        plot.subtitle = element_text(hjust = 0.5, size = 12),
        axis.text.x = element_text(angle = 0))

ggsave("8_fraud_detection_performance.png", plot8, width = 10, height = 6, dpi = 300)
print(plot8)

###########################################################
# 9. Taux de Détection (Recall) Comparaison
###########################################################

recall_data <- data.frame(
  Modele = c("Random Forest", "Isolation Forest", "RF + SMOTE"),
  Recall = c(83/102, 65/102, 86/102) * 100
)

plot9 <- ggplot(recall_data, aes(x = reorder(Modele, Recall), y = Recall, fill = Modele)) +
  geom_bar(stat = "identity", width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = paste0(round(Recall, 1), "%")), 
            vjust = -0.5, size = 6, fontface = "bold") +
  scale_fill_manual(values = c("Random Forest" = "#3498db", 
                                "Isolation Forest" = "#e67e22",
                                "RF + SMOTE" = "#9b59b6")) +
  labs(title = "Taux de Détection des Fraudes (Recall)",
       x = "Modèle",
       y = "Recall (%)") +
  ylim(0, 100) +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))

ggsave("9_recall_comparison.png", plot9, width = 10, height = 6, dpi = 300)
print(plot9)

###########################################################
# 10. Dashboard Récapitulatif
###########################################################

# Créer un graphique combiné avec les métriques clés
key_metrics <- data.frame(
  Modele = rep(c("RF", "Iso Forest", "RF + SMOTE"), 3),
  Metrique = rep(c("Accuracy (%)", "Recall Fraude (%)", "Specificity (%)"), each = 3),
  Valeur = c(
    99.96, 99.33, 99.96,  # Accuracy
    81.37, 63.73, 84.31,   # Recall fraude (Specificity dans confusion matrix)
    99.99, 99.40, 99.99    # Sensitivity
  )
)

plot10 <- ggplot(key_metrics, aes(x = Modele, y = Valeur, fill = Modele)) +
  geom_bar(stat = "identity", width = 0.7, show.legend = TRUE) +
  geom_text(aes(label = sprintf("%.2f", Valeur)), 
            vjust = -0.5, size = 3.5, fontface = "bold") +
  facet_wrap(~Metrique, scales = "free_y", ncol = 3) +
  scale_fill_manual(values = c("RF" = "#3498db", 
                                "Iso Forest" = "#e67e22",
                                "RF + SMOTE" = "#9b59b6")) +
  labs(title = "Tableau de Bord - Métriques Clés",
       x = "",
       y = "Valeur (%)",
       fill = "Modèle") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
        axis.text.x = element_text(angle = 45, hjust = 1),
        strip.text = element_text(face = "bold", size = 11))

ggsave("10_dashboard_metrics.png", plot10, width = 14, height = 5, dpi = 300)
print(plot10)

cat("\n✓ Toutes les visualisations ont été générées avec succès!\n")
cat("✓ 10 graphiques PNG sauvegardés dans le répertoire de travail\n")
