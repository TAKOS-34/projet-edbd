-- =============================================
------------------ Table pont ------------------
-- =============================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE intervention CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/

CREATE TABLE intervention (
    id_agent NUMBER(20),
    id_incident NUMBER(20),
    id_ressource NUMBER(20),
    CONSTRAINT pk_intervention PRIMARY KEY (id_agent, id_incident, id_ressource),
    CONSTRAINT fk_intervention_agent FOREIGN KEY (id_agent) REFERENCES agent (id_agent),
    CONSTRAINT fk_intervention_incident FOREIGN KEY (id_incident) REFERENCES incident (id_incident),
    CONSTRAINT fk_intervention_ressource FOREIGN KEY (id_ressource) REFERENCES ressource (id_ressource)
)