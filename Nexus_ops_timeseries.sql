/* =========================================================
   1. EXTENSIONS
   ========================================================= */

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
-- Enables UUID generation and cryptographic functions


/* =========================================================
   2. TABLES
   ========================================================= */

CREATE TABLE devices (
    id UUID PRIMARY KEY,
    device_name TEXT NOT NULL,
    location TEXT
);

CREATE TABLE device_metrics (
    time TIMESTAMPTZ NOT NULL,
    device_id UUID NOT NULL,
    cpu_usage DOUBLE PRECISION,
    mem_usage DOUBLE PRECISION,
    FOREIGN KEY (device_id) REFERENCES devices (id)
);

CREATE TABLE query_logs (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    query_text TEXT NOT NULL,
    executed_at TIMESTAMPTZ DEFAULT NOW(),
    execution_time_ms DOUBLE PRECISION,
    note TEXT
);


/* =========================================================
   3. ROLES & USERS
   ========================================================= */

CREATE ROLE nexus_admin;
CREATE ROLE nexus_analyst;
CREATE ROLE nexus_writer;
CREATE ROLE nexus_auditor;

CREATE USER admin_user WITH PASSWORD 'REDACTED';
CREATE USER analyst_user WITH PASSWORD 'REDACTED';
CREATE USER writer_user WITH PASSWORD 'REDACTED';
CREATE USER auditor_user WITH PASSWORD 'REDACTED';

GRANT nexus_admin TO admin_user;
GRANT nexus_analyst TO analyst_user;
GRANT nexus_writer TO writer_user;
GRANT nexus_auditor TO auditor_user;


/* =========================================================
   4. PERMISSIONS
   ========================================================= */

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO nexus_admin;

GRANT SELECT ON devices TO nexus_analyst;
GRANT SELECT ON device_metrics TO nexus_analyst;

GRANT INSERT ON device_metrics TO nexus_writer;

GRANT SELECT ON query_logs TO nexus_auditor;
GRANT INSERT ON query_logs TO nexus_auditor;
GRANT UPDATE ON query_logs TO nexus_auditor;


/* =========================================================
   5. SEED DATA
   ========================================================= */

INSERT INTO devices (id, device_name, location)
VALUES
(gen_random_uuid(), 'Edge Router 1', 'Lagos'),
(gen_random_uuid(), 'Edge Router 2', 'Abuja'),
(gen_random_uuid(), 'Core Server 1', 'Lagos DC'),
(gen_random_uuid(), 'Core Server 2', 'Lagos DC'),
(gen_random_uuid(), 'API Gateway', 'Cloud'),
(gen_random_uuid(), 'Auth Service', 'Cloud'),
(gen_random_uuid(), 'Analytics Node', 'Lagos'),
(gen_random_uuid(), 'Cache Server', 'Abuja'),
(gen_random_uuid(), 'Backup Node', 'Lagos'),
(gen_random_uuid(), 'IoT Aggregator', 'Remote Site');

INSERT INTO device_metrics (time, device_id, cpu_usage, mem_usage)
SELECT
    NOW() - (interval '1 minute' * gs),
    d.id,
    (random() * 80 + 10),
    (random() * 70 + 15)
FROM generate_series(1, 100000) gs
CROSS JOIN devices d;


/* =========================================================
   6. QUERIES (TESTING)
   ========================================================= */

SELECT MIN(time), MAX(time)
FROM device_metrics;

SELECT *
FROM device_metrics
ORDER BY time DESC
LIMIT 10;

SELECT *
FROM device_metrics
WHERE cpu_usage > 80
AND time > NOW() - INTERVAL '24 hours';

SELECT *
FROM device_metrics
WHERE mem_usage > 70
ORDER BY time DESC;

SELECT *
FROM query_logs
ORDER BY executed_at DESC;


/* =========================================================
   7. INDEXES
   ========================================================= */

CREATE INDEX idx_device_metrics_time
ON device_metrics (time);

CREATE INDEX idx_device_metrics_device_id
ON device_metrics (device_id);

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'device_metrics';


/* =========================================================
   8. PERFORMANCE VALIDATION
   ========================================================= */

EXPLAIN ANALYZE
SELECT *
FROM device_metrics
WHERE time > NOW() - INTERVAL '1 hour';

EXPLAIN ANALYZE
SELECT device_id, AVG(cpu_usage)
FROM device_metrics
WHERE time > NOW() - INTERVAL '6 hours'
GROUP BY device_id;