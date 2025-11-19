-- ===================================================
------------------ Vues virtuelles -------------------
-- ===================================================

BEGIN BEGIN EXECUTE IMMEDIATE 'DROP VIEW vue_utilisateurs CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END; BEGIN EXECUTE IMMEDIATE 'DROP VIEW vue_service CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END; BEGIN EXECUTE IMMEDIATE 'DROP VIEW vue_localisation CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END; BEGIN EXECUTE IMMEDIATE 'DROP VIEW vue_date CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END; BEGIN EXECUTE IMMEDIATE 'DROP VIEW vue_heure CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END; BEGIN EXECUTE IMMEDIATE 'DROP VIEW vue_ressource CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END; BEGIN EXECUTE IMMEDIATE 'DROP VIEW vue_agent CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END; END;
/

CREATE VIEW vue_utilisateurs AS
    SELECT 
        id_utilisateur,
        type_utilisateur,
        nom_legal,
        secteur_activite,
        pays_utilisateur,
        date_inscription
    FROM
        utilisateurs;

CREATE VIEW vue_service AS
    SELECT 
        id_service,
        nom_service,
        categorie,
        famille_service,
        statut_service
    FROM
        service;

CREATE VIEW vue_localisation AS
    SELECT 
        id_localisation,
        ville,
        departement_province,
        pays,
        continent,
        nom_az
    FROM
        localisation;

CREATE VIEW vue_date AS
    SELECT 
        id_date,
        date_complete,
        numero_jour,
        jour,
        numero_mois,
        mois,
        trimestre,
        annee,
        jour_semaine,
        est_weekend,
        jour_ferie,
        numero_semaine_annee
    FROM
        date_aws;

CREATE VIEW vue_heure AS
    SELECT 
        id_heure,
        heure_complete,
        heure_minute,
        heure,
        minute,
        seconde,
        periode_journee,
        est_heure_ouvrable
    FROM
        heure;

CREATE VIEW vue_ressource AS
    SELECT 
        id_ressource,
        nom_ressource,
        type_ressource,
        statut_ressource,
        DT_mise_en_route,
        DT_fin_service,
        OS,
        data_center
    FROM
        ressource;

CREATE VIEW vue_agent AS
    SELECT
        id_agent,
        nom_agent,
        equipe,
        niveau_support,
        date_entree
    FROM
        agent;