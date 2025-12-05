------------------------------------------------
-- REQUETES SUR LA FACTURATION
------------------------------------------------

-- Le service génère le plus de chiffre d'affaire
SELECT s.nom_service, SUM(f.total_brut) AS chiffre_affaire_total
FROM facturation f
JOIN Service s ON f.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY chiffre_affaire_total DESC
;

-- Le pays avec les utilisateurs qui paye le plus
SELECT u.pays_utilisateur, SUM(f.total_brut) AS chiffre_affaire_total
FROM facturation f
JOIN vue_utilisateurs_dynamique u ON f.id_utilisateur = u.id_utilisateur
WHERE u.est_actif = 'Y'
GROUP BY u.pays_utilisateur
ORDER BY chiffre_affaire_total DESC
;

-- Le mois est le plus rentable de l'année
SELECT d.annee, d.mois, SUM(f.total_brut) AS revenu_mensuel
FROM facturation f
JOIN vue_date d ON f.id_date = d.id_date
-- WHERE d.annee = 2025 | Pour année spécifique
GROUP BY d.annee, d.mois
ORDER BY revenu_mensuel DESC
;

-- Le service le plus populaire (même s'il est pas le plus rentable)
SELECT s.nom_service, COUNT(DISTINCT f.id_utilisateur) AS nombre_utilisateurs
FROM facturation f
JOIN vue_service s ON f.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY nombre_utilisateurs DESC
;

-- Le type de service par secteur d'activité et le prix moyen dépense
SELECT s.categorie, u.secteur_activite, AVG(f.total_brut) AS prix_moyen_depense
FROM facturation f
JOIN vue_service s ON f.id_service = s.id_service
JOIN vue_utilisateurs_dynamique u ON f.id_utilisateur = u.id_utilisateur
WHERE u.est_actif = 'Y'
GROUP BY s.categorie, u.secteur_activite
;

-- Évolution annuelle du prix unitaire moyen par service
SELECT d.annee, s.nom_service, AVG(f.prix_unitaire) AS prix_unitaire_moyen
FROM facturation f
JOIN vue_date d ON f.id_date = d.id_date
JOIN vue_service s ON f.id_service = s.id_service
GROUP BY d.annee, s.nom_service
ORDER BY d.annee, s.nom_service
;

------------------------------------------------
-- REQUETES SUR LES COUTS OPERATIONNELS
------------------------------------------------

-- La localisation qui coûte le plus cher
SELECT r.nom_az, SUM(a.cout_total) AS cout_operationnel_total
FROM actifs a
JOIN vue_localisation r ON a.id_localisation = r.id_localisation
GROUP BY r.nom_az
ORDER BY cout_operationnel_total DESC
;

-- Le type de service qui pèse le plus au cours d'une année
SELECT s.nom_service, SUM(a.cout_total) AS cout_annuel_par_service
FROM actifs a
JOIN vue_service s ON a.id_service = s.id_service
JOIN vue_date d ON a.id_date = d.id_date
-- WHERE d.annee = 2025 | Pour année spécifique
GROUP BY s.nom_service
ORDER BY cout_annuel_par_service DESC
;

-- Le mois de l'année qui coûte le plus cher
SELECT d.annee, d.mois, SUM(a.cout_total) as cout_total_mensuel
FROM actifs a
JOIN vue_date d ON a.id_date = d.id_date
GROUP BY d.annee, d.mois
ORDER BY cout_total_mensuel DESC
;

------------------------------------------------
-- REQUETES SUR LES INCIDENTS
------------------------------------------------

-- Le type de la ressource la plus souvent en panne (sans table pont, très coûteux)
SELECT r.type_ressource, COUNT(DISTINCT i.id_incident) as nombre_pannes
FROM incident i
JOIN vue_ressource r ON i.id_ressource = r.id_ressource
GROUP BY r.type_ressource
ORDER BY nombre_pannes DESC
;

-- Le type de la ressource la plus souvent en panne (avec table pont)
SELECT r.type_ressource, COUNT(DISTINCT iv.id_incident) as nombre_pannes_intervenues
FROM intervention iv
JOIN vue_ressource r ON iv.id_ressource = r.id_ressource
GROUP BY r.type_ressource
ORDER BY nombre_pannes_intervenues DESC
;

-- Le type de la ressource qui coûte le plus cher cher / impact le plus d'utilisateurs lors d'une panne (sans table pont)
SELECT 
    r.type_ressource,
    SUM(i.cout_agent + i.cout_remboursement_estime) AS cout_total,
    SUM(i.nb_utilisateurs_impactes) AS impact_total_utilisateurs
FROM incident i
JOIN vue_ressource r ON i.id_ressource = r.id_ressource
GROUP BY r.type_ressource
ORDER BY cout_total DESC, impact_total_utilisateurs DESC
;

-- Les agents ayant résolu le plus de pannes (avec table pont)
SELECT a.prenom_agent, a.nom_agent, COUNT(DISTINCT iv.id_incident) AS nombre_incidents_resolus
FROM intervention iv
JOIN agent a ON iv.id_agent = a.id_agent
JOIN incident i ON iv.id_incident = i.id_incident
JOIN statut s ON i.id_statut = s.id_statut
WHERE s.nom_statut = 'closed'
GROUP BY a.id_agent, a.prenom_agent, a.nom_agent
ORDER BY nombre_incidents_resolus DESC
;

-- Classement des agents par performance (coût et volume) (avec table pont)
SELECT 
    a.nom_agent,
    a.prenom_agent,
    COUNT(DISTINCT p.id_incident) AS nombre_incidents_geres,
    AVG(i.cout_agent) AS cout_moyen_par_incident,
    SUM(i.cout_agent) AS cout_total_genere 
FROM intervention p
JOIN incident i ON p.id_incident = i.id_incident
JOIN agent a ON p.id_agent = a.id_agent
GROUP BY a.id_agent, a.nom_agent, a.prenom_agent
ORDER BY cout_moyen_par_incident ASC, nombre_incidents_geres DESC
;

------------------------------------------------
-- REQUETES SUR LE MONITORING
------------------------------------------------

-- Le service qui consomme le plus de CPU
SELECT s.nom_service, AVG(m.CPU_utilisation) AS avg_cpu_utilisation
FROM monitoring m
JOIN vue_service s ON m.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY avg_cpu_utilisation DESC
;

-- Quelles sont les utilisateurs les plus consommateur en ressource
SELECT u.id_utilisateur, u.nom_legal, SUM(m.temps_total_actif) AS consommation_totale_temps
FROM monitoring m
JOIN vue_utilisateurs_statique u ON m.id_utilisateur = u.id_utilisateur
GROUP BY u.id_utilisateur, u.nom_legal
ORDER BY consommation_totale_temps DESC
;

-- Le mois de l’année le plus solliciter
SELECT d.annee, d.mois, SUM(m.temps_total_actif) AS sollicitation_totale
FROM monitoring m
JOIN vue_date d ON m.id_date = d.id_date
-- WHERE d.annee = 2025 | Pour année spécifique
GROUP BY d.annee, d.mois
ORDER BY sollicitation_totale DESC
;

-- Temps réel d'utilisation d'un service, grâce au temps total actif
SELECT s.nom_service, SUM(m.temps_total_actif) AS utilisation_reelle_totale
FROM monitoring m
JOIN vue_service s ON m.id_service = s.id_service
GROUP BY s.nom_service
ORDER BY utilisation_reelle_totale DESC
;
