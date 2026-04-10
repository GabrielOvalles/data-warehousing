if OBJECT_ID ('silver.crm_cust_info', 'U') is not null
	drop table silver.crm_cust_info;
create table silver.crm_cust_info (
cst_id int,
cst_key nvarchar (50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_material_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date datetime,
dwh_create_date datetime2 default getdate()
);

if OBJECT_ID ('silver.crm_prd_info', 'U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info (
prd_id int,
prd_key nvarchar (50),
prd_nm nvarchar (50),
prd_cost int,
prd_line nvarchar (50),
prd_start_dt datetime,
prd_end_dt datetime,
dwh_create_date datetime2 default getdate()
);

if OBJECT_ID ('silver.crm_sales_details', 'U') is not null
	drop table silver.crm_sales_details;

create table silver.crm_sales_details (
sls_order_num nvarchar (50),
sls_prd_key nvarchar (50),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_pice int,
dwh_create_date datetime2 default getdate()
);

if OBJECT_ID ('silver.erp_cust_az12', 'U') is not null
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12(
cid nvarchar (50),
bdate date,
gen nvarchar(50),
dwh_create_date datetime2 default getdate()
);

if OBJECT_ID ('silver.erp_loc_a101', 'U') is not null
	drop table silver.erp_loc_a101;

create table silver.erp_loc_a101(
cid nvarchar(50),
cntry nvarchar (50),
dwh_create_date datetime2 default getdate()
);


if OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') is not null
	drop table silver.erp_px_cat_g1v2;

create table silver.erp_px_cat_g1v2 (
id nvarchar (50),
cat nvarchar (50),
subcat nvarchar (50),
maintenance nvarchar (50),
dwh_create_date datetime2 default getdate()
);

data cleansing (removing duplicates, spaces,):            
------------------------------------------------------------------------------------------------------------------
create or alter procedure silver.load_silver as
BEGIN
	declare @start_time datetime , @end_time datetime , @batch_start_time datetime , @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();

		print 'Loading the silver layer'
		print'------------------------------------'

		print'Loading CRM tables'
		print'------------------------------------'

		set @start_time = GETDATE();
		print 'truncating table silver.crm_cust_info'
		truncate table silver.crm_cust_info;
		print 'inserting data into table silver.crm_prd_info'
		insert into silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_material_status,
		cst_gndr,
		cst_create_date
		)

		 select cst_id, cst_key, 
		trim(cst_firstname) as cst_firstname, 
		trim(cst_lastname) as cst_lastname,

		case when upper ( trim(cst_material_status)) = 'M' then 'Married'
			 when upper ( trim(cst_material_status)) = 'S' then 'single'
			 else 'Unknown' 
		end cst_material_status,

		case when upper ( trim(cst_gndr)) = 'M' then 'Male'
			 when upper ( trim(cst_gndr)) = 'F' then 'Female'
			 else 'Unknown'
		end cst_gndr,

		cst_create_date
		from 
		(select *, ROW_NUMBER () over (partition by cst_id order by cst_create_date desc) as flag_last 
		from bronze.crm_cust_info)t where flag_last = 1;
		set @end_time = getdate()
		print '>>Load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds'

		set @start_time = GETDATE();
		print 'truncating table silver.crm_prd_info'
		truncate table silver.crm_prd_info;
		print 'inserting data into table silver.crm_prd_info'
		insert into silver.crm_prd_info (
		prd_id, 
		cat_id, 
		prd_key, prd_nm, 
		prd_cost, 
		prd_line, 
		prd_start_dt, 
		prd_end_dt
		)
		select 
		prd_id, 
		replace(SUBSTRING (prd_key, 1, 5), '-', '_') as cat_id,
		SUBSTRING (prd_key, 7, len(prd_key)) as prd_key,
		prd_nm, 
		isnull(prd_cost, 0) as prd_cost,
		case upper(trim(prd_line)) 
			 when  'M' then 'Mountain'
			 when  'R' then 'Road'
			 when  'S' then 'Other sales'
			 when  'T' then 'Touring'
			 else 'N/A' 
		end as prd_line,
		cast(prd_start_dt as date) as prd_start_dt, 
		cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
		from bronze.crm_prd_info
		set @end_time = getdate()
		print '>>Load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds'

		set @start_time = GETDATE();
		print 'truncating table silver.crm_sales_details'
		truncate table silver.crm_sales_details;
		print 'inserting data into table silver.crm_sales_details'
		insert into silver.crm_sales_details(
		sls_order_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_pice
		)
		select 
		sls_order_num,
		sls_prd_key,
		sls_cust_id,
		case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
		else cast(cast(sls_order_dt as varchar) as date)
		end as sls_order_dt,

		case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
		else cast(cast(sls_ship_dt as varchar) as date)
		end as sls_ship_dt,

		case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
		else cast(cast(sls_due_dt as varchar) as date)
		end as sls_due_dt,

		case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_pice) then sls_quantity * abs(sls_pice)
		else sls_sales
		end as sls_sales,

		sls_quantity,

		case when sls_pice is null or sls_pice <= 0 then sls_sales / nullif(sls_quantity, 0)
		else sls_pice
		end as sls_price
		from bronze.crm_sales_details
		set @end_time = getdate()
		print '>>Load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds'

		set @start_time = GETDATE();
		print 'truncating table silver.erp_cust_az12'
		truncate table silver.erp_cust_az12;
		print 'inserting data into table silver.erp_cust_az12'
		insert into silver.erp_cust_az12 (cid, bdate, gen)
		select
		case when cid like 'NAS%' then substring(cid, 4, len(cid)) else cid
		end as cid,
		case when bdate > GETDATE() then null else bdate
		end as bdate,
		case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
			 when upper(trim(gen)) in ('M', 'MALE') then 'Male'
			 else 'N/A'
		end as gen
		from bronze.erp_cust_az12
		set @end_time = getdate()
		print '>>Load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds'

		set @start_time = GETDATE();
		print 'truncating table silver.erp_loc_a101'
		truncate table silver.erp_loc_a101;
		print 'inserting data into table silver.erp_loc_a101'
		insert into silver.erp_loc_a101 (cid, cntry)
		select 
		replace(cid, '-', '') as cid,
		case when trim(cntry) in ('US', 'USA', 'UNITED STATES') then 'United States'
			 when trim(cntry) = ('DE') then 'Germany'
			 when trim(cntry) = '' or cntry is null then 'N/A'
			 else trim(cntry)
		end as cntry
		from bronze.erp_loc_a101
		set @end_time = getdate()
		print '>>Load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds'

		set @start_time = GETDATE();
		print 'truncating table silver.erp_px_cat_g1v2'
		truncate table silver.erp_px_cat_g1v2;
		print 'inserting data into table silver.erp_px_cat_g1v2'
		insert into silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
		select id, cat, subcat, maintenance
		from bronze.erp_px_cat_g1v2
		set @end_time = getdate()
		print '>>Load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds'
		print '------------------------------------'

		set @batch_end_time = getdate();
		print'Silver layer load completed successfully'
		print 'Total batch duration' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds'
		print '------------------------------------'
	end try
	begin catch
	print 'Error occurred while loading silver layer'
		print 'Error message: ' + ERROR_MESSAGE()
		print 'Error number: ' + cast(ERROR_NUMBER() as nvarchar)
		print 'Error severity: ' + cast(ERROR_SEVERITY() as nvarchar)
		print 'Error state: ' + cast(ERROR_STATE() as nvarchar)
		print 'Error line: ' + cast(ERROR_LINE() as nvarchar)
	end catch
END
