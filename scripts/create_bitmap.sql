BEGIN EXECUTE IMMEDIATE 'DROP INDEX BJI_CA_PAR_SERVICE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE BITMAP INDEX BJI_CA_PAR_SERVICE
ON facturation (s.nom_service)
FROM facturation f, service s
WHERE f.id_service = s.id_service
;