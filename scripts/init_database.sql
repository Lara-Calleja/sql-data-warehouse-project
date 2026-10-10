/*
=========================================================================================
Create Database and Schemas
=========================================================================================
Script Purpose: 
    This script creates a new database named 'datawarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.
Database: PostgreSQL/pgAdmin 4
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

-- Drop and recreate the 'DataWarehouse' database
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'DataWarehouse'
  AND pid <> pg_backend_pid();

DROP DATABASE IF EXISTS "DataWarehouse";

-- Create the 'datawarehouse' database
CREATE DATABASE datawarehouse;

USE datawarehouse;

-- Create Schemas
CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;
