-- BEGIN EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW m_vue_utilisateurs_service'; EXCEPTION WHEN OTHERS THEN NULL; END; / BEGIN EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW m_vue_date_service'; EXCEPTION WHEN OTHERS THEN NULL; END; /

CREATE MATERIALIZED VIEW m_vue_utilisateurs_service
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
ENABLE QUERY REWRITE
AS
SELECT
    f.id_utilisateur,
    f.id_service,
    -- Precalcul
    COUNT(*) AS nombre_transactions,
    SUM(f.total_brut) AS total_brut,
    SUM(f.total_net) AS total_net,
    SUM(f.quantite_consommee) AS quantite_totale,
    AVG(f.total_brut) AS panier_moyen
FROM facturation f
GROUP BY f.id_utilisateur, f.id_service;

CREATE MATERIALIZED VIEW m_vue_date_service
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
ENABLE QUERY REWRITE
AS
SELECT
    d.annee,
    d.mois,
    d.numero_mois,
    s.nom_service,
    s.categorie,
    f.id_service,
    -- Precalcul
    COUNT(*) AS nombre_transactions,
    SUM(f.total_brut) AS ca_mensuel_brut,
    SUM(f.total_net) AS ca_mensuel_net,
    SUM(f.remise) AS total_remises
FROM facturation f
JOIN date_aws d ON f.id_date = d.id_date
JOIN service s ON f.id_service = s.id_service
GROUP BY d.annee, d.mois, d.numero_mois, s.nom_service, s.categorie, f.id_service;

-- Rafraichir les vue materialiser
-- BEGIN DBMS_MVIEW.REFRESH('m_vue_utilisateurs_service'); DBMS_MVIEW.REFRESH('m_vue_date_service'); END; /