ALTER SYSTEM SET max_connections TO '256';
SELECT pg_reload_conf();