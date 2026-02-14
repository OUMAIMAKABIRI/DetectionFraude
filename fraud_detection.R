###########################################################
# Projet : Détection de fraude bancaire
# Etudiante : Oumaima Kabiri
# Objectif : Détecter les transactions frauduleuses
###########################################################

############################
# 1. Installer les packages (une seule fois)
############################

# install.packages("readr")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("caret")
# install.packages("randomForest")
# install.packages("isotree")

############################
# 2. Charger les bibliothèques
############################

library(readr)
library(dplyr)
library(ggplot2)
library(caret)
library(randomForest)
library(isotree)

############################
# 3. Charger les données
############################

df <- read_csv("creditcard.csv")

cat("Dimensions du dataset :\n")
print(dim(df))

cat("Aperçu des données :\n")
head(df)

############################
# 4. Analyse exploratoire
############################

cat("Nombre de transactions normales et frauduleuses :\n")
print(table(df$Class))

# Graphique
ggplot(df, aes(x = factor(Class))) +
  geom_bar(fill = "steelblue") +
  ggtitle("Distribution des transactions") +
  xlab("Classe (0 = Normal, 1 = Fraude)") +
  ylab("Nombre")

############################
# 5. Séparer Train et Test
############################

set.seed(42)

trainIndex <- createDataPartition(df$Class, p = 0.8, list = FALSE)

train <- df[trainIndex, ]

test <- df[-trainIndex, ]

cat("Train size :", nrow(train), "\n")
cat("Test size :", nrow(test), "\n")

############################
# 6. Modèle Random Forest
############################

cat("\nEntraînement Random Forest...\n")

model_rf <- randomForest(
  as.factor(Class) ~ .,
  data = train,
  ntree = 100
)

cat("Modèle Random Forest entraîné.\n")

############################
# 7. Evaluation Random Forest
############################

pred_rf <- predict(model_rf, test)

cat("\nRésultats Random Forest :\n")

print(confusionMatrix(pred_rf, as.factor(test$Class)))

############################
# 8. Modèle Isolation Forest
############################

cat("\nEntraînement Isolation Forest...\n")

model_iso <- isolation.forest(train[, -31])

pred_iso <- predict(model_iso, test[, -31])

pred_iso <- ifelse(pred_iso > 0.5, 1, 0)

cat("\nRésultats Isolation Forest :\n")

print(confusionMatrix(as.factor(pred_iso), as.factor(test$Class)))

############################
# 9. Sauvegarder les modèles
############################

saveRDS(model_rf, "fraud_model_rf.rds")

saveRDS(model_iso, "fraud_model_iso.rds")

cat("\nModèles sauvegardés avec succès.\n")

############################
# 10. Charger modèle sauvegardé (exemple)
############################

model_loaded <- readRDS("fraud_model_rf.rds")

cat("\nModèle chargé avec succès.\n")
###########################################################
# 11. Application de SMOTE
###########################################################

library(smotefamily)

cat("\nApplication de SMOTE...\n")

# convertir Class en numérique
train$Class <- as.numeric(as.character(train$Class))

# Séparer X et y
X_train <- train[, -31]
y_train <- train$Class

# Appliquer SMOTE
smote_result <- SMOTE(
  X_train,
  y_train,
  K = 5,
  dup_size = 10
)

# Nouveau dataset
train_smote <- smote_result$data

colnames(train_smote)[31] <- "Class"

train_smote$Class <- as.factor(train_smote$Class)

cat("\nDistribution après SMOTE :\n")

print(table(train_smote$Class))

###########################################################
# 12. Random Forest avec SMOTE
###########################################################

cat("\nEntraînement Random Forest avec SMOTE...\n")

model_rf_smote <- randomForest(
  
  Class ~ .,
  
  data = train_smote,
  
  ntree = 100
  
)

###########################################################
# 13. Test du modèle SMOTE
###########################################################

pred_smote <- predict(model_rf_smote, test)

cat("\nRésultats Random Forest avec SMOTE :\n")

print(confusionMatrix(pred_smote, as.factor(test$Class)))

###########################################################
# 14. Sauvegarder modèle
###########################################################

saveRDS(model_rf_smote, "fraud_model_rf_smote.rds")

cat("\nModèle SMOTE sauvegardé.\n")


###########################################################
# FIN DU SCRIPT
###########################################################
