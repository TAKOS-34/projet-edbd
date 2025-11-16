------------------------------------------------
-- REQUETES SUR LA FACTURATION
------------------------------------------------

-- Le service génère le plus de chiffre d'affaire
SELECT s.nom_service, SUM(f.total_brut) AS chiffre_affaire_total
FROM Facturation f
JOIN Service s ON f.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY chiffre_affaire_total DESC

-- Le pays avec les utilisateurs qui paye le plus
SELECT u.pays_utilisateur, SUM(f.total_brut) AS chiffre_affaire_total
FROM Facturation f
JOIN Utilisateur u ON f.id_utilisateur = u.id_utilisateur
GROUP BY u.pays_utilisateur
ORDER BY chiffre_affaire_total DESC

-- Le mois est le plus rentable de l'année
SELECT d.annee, d.mois, SUM(f.total_brut) AS revenu_mensuel
FROM Facturation f
JOIN Date d ON f.id_date = d.id_date
-- WHERE d.annee = 2025 | Pour année spécifique
GROUP BY d.annee, d.mois
ORDER BY revenu_mensuel DESC

-- Le service le plus populaire (même s'il est pas le plus rentable)
SELECT s.nom_service, COUNT(DISTINCT f.id_utilisateur) AS nombre_utilisateurs
FROM Facturation f
JOIN Service s ON f.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY nombre_utilisateurs DESC

-- Le type de service par secteur d'activité et le prix moyen dépense
SELECT s.categorie, u.secteur_activite, AVG(f.total_brut) AS prix_moyen_depense
FROM Facturation f
JOIN Service s ON f.id_service = s.id_service
JOIN Utilisateur u ON f.id_utilisateur = u.id_utilisateur
GROUP BY s.categorie, u.secteur_activite;

------------------------------------------------
-- REQUETES SUR LES COUTS OPERATIONNELS
------------------------------------------------

-- La localisation qui coûte le plus cher
SELECT r.nom_az, r.data_center, SUM(a.cout_total_HC) AS cout_operationnel_total
FROM Actifs a
JOIN Region r ON a.id_localisation = r.id_localisation
GROUP BY r.nom_az, r.data_center
ORDER BY cout_operationnel_total DESC

-- Le type de service qui pèse le plus au cours d'une année
SELECT s.nom_service, SUM(a.cout_total_HC) AS cout_annuel_par_service
FROM Actifs a
JOIN Service s ON a.id_service = s.id_service
JOIN Date d ON a.id_date = d.id_date
-- WHERE d.annee = 2025 | Pour année spécifique
GROUP BY s.nom_service
ORDER BY cout_annuel_par_service DESC;

-- Le type de ressource le moins fiable, soit celui qui a le plus de panne
SELECT r.type_ressource, SUM(a.nb_prob_materiel) AS total_pannes
FROM Actifs a
JOIN Ressource r ON a.id_ressource = r.id_ressource
GROUP BY r.type_ressource
ORDER BY total_pannes DESC

------------------------------------------------
-- REQUETES SUR LE MONITORING
------------------------------------------------

-- Le service qui consomme le plus de CPU
SELECT s.nom_service, AVG(m.CPU_utilisation) AS avg_cpu_utilisation
FROM Monitoring m
JOIN Service s ON m.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY avg_cpu_utilisation DESC

-- Quelles sont les utilisateurs les plus consommateur en ressource
SELECT u.id_utilisateur, u.nom_legal, SUM(m.temps_total_actif) AS consommation_totale_temps
FROM Monitoring m
JOIN Utilisateur u ON m.id_utilisateur = u.id_utilisateur
GROUP BY u.id_utilisateur, u.nom_legal
ORDER BY consommation_totale_temps DESC

-- Le mois de l’année le plus solliciter
SELECT d.annee, d.mois, SUM(m.temps_total_actif) AS sollicitation_totale
FROM Monitoring m
JOIN Date d ON m.id_date = d.id_date
-- WHERE d.annee = 2025 | Pour année spécifique
GROUP BY d.annee, d.mois
ORDER BY sollicitation_totale DESC

-- Temps réel d'utilisation d'un service, grâce au temps total actif
SELECT s.nom_service, SUM(m.temps_total_actif) AS utilisation_reelle_totale
FROM Monitoring m
JOIN Service s ON m.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY utilisation_reelle_totale DESC;