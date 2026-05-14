\\# NexusOps: Secure Time-Series Monitoring System







\\## Overview







NexusOps is a PostgreSQL-based time-series monitoring system designed to simulate real-world infrastructure telemetry, security management, and database performance optimization.







It models devices generating continuous CPU and memory metrics over time while implementing:







\\- Role-Based Access Control (RBAC)



\\- Query logging and monitoring



\\- Performance analysis using `EXPLAIN ANALYZE`



\\- Index-based query optimization



\\- Multi-user database access simulation







The goal is to demonstrate practical database engineering concepts with a focus on security, observability, and performance at scale.







\\---







\\# Project Objectives







The system is built around three core operational goals:







1\\. Secure the database using role-based access control (RBAC)



2\\. Monitor system activity through query logging and telemetry data



3\\. Improve query performance using indexing and execution analysis







\\---







\\# Tech Stack







\\- PostgreSQL 18



\\- pgAdmin 4



\\- PowerShell



\\- SQL







\\---







\\# Database Architecture







\\## devices







Stores infrastructure nodes in the system.







| Column      | Description                     |



| ------------ | ------------------------------- |



| id           | Unique device identifier (UUID) |



| device\\\_name  | Name of the device              |



| location     | Device location                 |







\\---







\\## device\\\_metrics







Stores time-series telemetry data.







| Column      | Description                |



| ------------ | -------------------------- |



| time         | Timestamp of metric record |



| device\\\_id    | Linked device identifier   |



| cpu\\\_usage    | Simulated CPU usage        |



| mem\\\_usage    | Simulated memory usage     |







\\---







\\## query\\\_logs







Stores query monitoring and audit data.







| Column              | Description           |



| ------------------- | --------------------- |



| log\\\_id              | Unique log identifier |



| query\\\_text          | Executed SQL query    |



| executed\\\_at         | Execution timestamp   |



| execution\\\_time\\\_ms   | Query duration        |



| note                | Additional metadata   |







\\---







\\# Security Implementation







The system uses Role-Based Access Control (RBAC) to enforce least-privilege access.







\\## Roles







| Role            | Responsibility            |



| ---------------- | ------------------------- |



| nexus\\\_admin      | Full database control     |



| nexus\\\_analyst    | Read-only access          |



| nexus\\\_writer     | Insert-only operations    |



| nexus\\\_auditor    | Log monitoring \\\& updates  |







\\---







\\# Monitoring \\\& Observability







The system simulates production-style monitoring by:







\\- Tracking device telemetry over time



\\- Logging SQL query execution activity



\\- Identifying high CPU and memory usage patterns



\\- Supporting execution plan analysis







\\---







\\# Performance Optimization







Query performance was evaluated using:







\\- `EXPLAIN ANALYZE` for execution tracing



\\- Large-scale synthetic datasets



\\- Time-based query filtering







Indexes were introduced to improve query efficiency.







\\## Implemented Indexes







| Index                          | Purpose                      |



| ------------------------------ | ---------------------------- |



| idx\\\_device\\\_metrics\\\_time        | Optimizes time-range queries |



| idx\\\_device\\\_metrics\\\_device\\\_id   | Optimizes joins \\\& lookups    |







\\---







\\# PostgreSQL Concepts Used







| Feature             | Purpose                         |



| ------------------- | ------------------------------- |



| pgcrypto            | UUID generation                 |



| generate\\\_series()   | Time-series data simulation     |



| random()            | Synthetic workload generation   |



| EXPLAIN ANALYZE     | Query performance analysis      |



| CREATE INDEX        | Performance optimization        |



| GRANT               | Access control management       |







\\---







\\# Sample Query Workloads







\\## Time-based filtering







```sql



SELECT \\\*



FROM device\\\_metrics



WHERE time > NOW() - INTERVAL '1 hour';



```







\\---







\\## Aggregation







```sql



SELECT device\\\_id, AVG(cpu\\\_usage)



FROM device\\\_metrics



GROUP BY device\\\_id;



```







\\---







\\## Anomaly Detection







```sql



SELECT \\\*



FROM device\\\_metrics



WHERE cpu\\\_usage > 80;



```







\\---







\\# Learning Outcomes







This project demonstrates:







\\- Time-series database design



\\- PostgreSQL security architecture



\\- Query optimization strategies



\\- Observability and logging systems



\\- Multi-user database simulation







\\---







\\# Future Improvements







\\- Automated audit triggers



\\- Table partitioning for scalability



\\- Backup and recovery workflows



\\- Dashboard visualization layer



\\- API integration using FastAPI







\\---







\\# Project Structure







```text



Nexus\\\_ops\\\_timeseries/



├── Nexus\\\_ops\\\_timeseries.sql



├── README.md



└── images/



\&#x20;   ├── admin\\\_login.png



\&#x20;   ├── analyst\\\_select.png



\&#x20;   ├── writer\\\_insert.png



\&#x20;   └── auditor\\\_logs.png



```







\\---







\\# UML Relationship Diagram







```text



devices (1) ─────── (many) device\\\_metrics







devices



\&#x20; id (PK)



\&#x20; device\\\_name



\&#x20; location







device\\\_metrics



\&#x20; time



\&#x20; device\\\_id (FK)



\&#x20; cpu\\\_usage



\&#x20; mem\\\_usage







query\\\_logs



\&#x20; log\\\_id (PK)



\&#x20; query\\\_text



\&#x20; executed\\\_at



\&#x20; execution\\\_time\\\_ms



\&#x20; note



```







\\---







\\# PowerShell Access Testing







The system simulates multi-user database access using PostgreSQL roles and PowerShell authentication testing.







\\---







\\## Admin Access







```powershell



psql -U admin\\\_user -d nexus\\\_timeseries\\\_db



```







Full administrative access validation.







!\\\[Admin Login](images/admin\\\_login.png)







\\---







\\## Analyst Access







```powershell



psql -U analyst\\\_user -d nexus\\\_timeseries\\\_db



```







The analyst role is limited to read-only operations.







Successful SELECT query:







```sql



SELECT \\\* FROM devices;



```







!\\\[Analyst Select](images/analyst\\\_select.png)







Blocked INSERT operation:







```sql



INSERT INTO devices VALUES (gen\\\_random\\\_uuid(), 'Test Device', 'Lagos');



```







!\\\[Analyst Denied](images/analyst\\\_denied.png)







This demonstrates RBAC privilege enforcement through restricted write access.







\\---







\\## Writer Access







```powershell



psql -U writer\\\_user -d nexus\\\_timeseries\\\_db



```







The writer role can insert operational telemetry data.







```sql



INSERT INTO device\\\_metrics (time, device\\\_id, cpu\\\_usage, mem\\\_usage)



SELECT NOW(), id, 50, 40



FROM devices



LIMIT 1;



```







!\\\[Writer Insert](images/writer\\\_insert.png)







This validates controlled ingestion permissions within the telemetry pipeline.







\\---







\\## Auditor Access







```powershell



psql -U auditor\\\_user -d nexus\\\_timeseries\\\_db



```







The auditor role is responsible for monitoring and managing query logs.







```sql



SELECT \\\* FROM query\\\_logs;



```







!\\\[Auditor Logs](images/auditor\\\_logs.png)







This demonstrates observability and audit-level database access.







\\---







\\# Final Summary







NexusOps simulates a secure and optimized PostgreSQL-based monitoring system for time-series telemetry.







The project demonstrates:







\\- Structured database design



\\- Role-based security enforcement



\\- Observability through query logging



\\- Performance optimization via indexing



\\- Realistic multi-user database behavior



\\- Practical PostgreSQL administration workflows







The system reflects foundational backend database engineering concepts commonly used in production monitoring environments.





