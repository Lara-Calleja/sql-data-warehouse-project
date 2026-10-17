/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files using 
    PL/pgSQL as the procedural programming language
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from csv Files to bronze tables.

Parameters:
    None.
      This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();

Note:
    The COPY paths point to '...\path\'.
    Change them to the folder where you saved the datasets.
===============================================================================
*/
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
	v_start_time 		TIMESTAMPTZ;
	v_end_time			TIMESTAMPTZ;
	v_batch_start_time	TIMESTAMPTZ;
	v_batch_end_time	TIMESTAMPTZ;
BEGIN
	v_batch_start_time := clock_timestamp();
	RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

	--CRM Tables
	RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';

	v_start_time := clock_timestamp();
	-- 1. CRM Customer Information
	RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;

	RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
	COPY bronze.crm_cust_info 
	FROM '...\path\'
	WITH (
		FORMAT CSV,
		HEADER TRUE,
		DELIMITER ','
	);
	v_end_time := clock_timestamp();

	RAISE NOTICE '>> Load Duration: % seconds',
		ROUND(EXTRACT(EPOCH FROM (v_end_time - v_start_time))::NUMERIC, 2);
	RAISE NOTICE '>>-------------';
	
	v_start_time := clock_timestamp();
	-- 2. CRM Product Information
	RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

	RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
	COPY bronze.crm_prd_info
	FROM '...\path\'
	WITH(
		FORMAT CSV,
		HEADER TRUE,
		DELIMITER ','
	);
	v_end_time := clock_timestamp();

	RAISE NOTICE '>> Load Duration: % seconds',
		ROUND(EXTRACT(EPOCH FROM (v_end_time - v_start_time))::NUMERIC, 2);
	RAISE NOTICE '>>-------------';

	v_start_time := clock_timestamp();
	-- 3. CRM Sales Details
	RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;

	RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
	COPY bronze.crm_sales_details
	FROM '...\path\'
	WITH(
		FORMAT CSV,
		HEADER TRUE,
		DELIMITER ','
	);
	v_end_time := clock_timestamp();

	RAISE NOTICE '>> Load Duration: % seconds',
		ROUND(EXTRACT(EPOCH FROM (v_end_time - v_start_time))::NUMERIC, 2);
	RAISE NOTICE '>>-------------';

	--ERP Tables
	RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';
	
	v_start_time := clock_timestamp();
	-- 4. ERP Location
	RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';	
	TRUNCATE TABLE bronze.erp_loc_a101;

	RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
	COPY bronze.erp_loc_a101
	FROM '...\path\'
	WITH(
		FORMAT CSV,
		HEADER TRUE,
		DELIMITER ','
	);
	v_end_time := clock_timestamp();

	RAISE NOTICE '>> Load Duration: % seconds',
		ROUND(EXTRACT(EPOCH FROM (v_end_time - v_start_time))::NUMERIC, 2);
	RAISE NOTICE '>>-------------';

	v_start_time := clock_timestamp();
	-- 5. ERP Customer Data
	RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;

	RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12
	FROM '...\path\'
	WITH(
		FORMAT CSV,
		HEADER TRUE,
		DELIMITER ','
	);
	v_end_time := clock_timestamp();
	
	RAISE NOTICE '>> Load Duration: % seconds',
		ROUND(EXTRACT(EPOCH FROM (v_end_time - v_start_time))::NUMERIC, 2);
	RAISE NOTICE '>>-------------';
	
	v_start_time := clock_timestamp();
	-- 6. ERP Product Category
	RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
	RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
	COPY bronze.erp_px_cat_g1v2
	FROM '...\path\'
	WITH(
		FORMAT CSV,
		HEADER TRUE,
		DELIMITER ','
	);
	v_end_time := clock_timestamp();
	
	RAISE NOTICE '>> Load Duration: % seconds',
		ROUND(EXTRACT(EPOCH FROM (v_end_time - v_start_time))::NUMERIC, 2);
	RAISE NOTICE '>>-------------';
	
	-- Batch Completion
	v_batch_end_time := clock_timestamp();

	RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';
    RAISE NOTICE 'Total Load Duration: % seconds',
		ROUND(EXTRACT(EPOCH FROM (v_batch_end_time - v_batch_start_time))::NUMERIC, 2);
	RAISE NOTICE '==========================================';
	
EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE '==========================================';

        RAISE;
END;
$$

