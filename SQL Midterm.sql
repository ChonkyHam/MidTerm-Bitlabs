-- NO 1
SELECT 
  hotel,
  arrival_date_year,
  ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM 
  data_hotel 
GROUP BY 
  hotel, 
  arrival_date_year
ORDER BY 
  hotel, 
  arrival_date_year;
 
 
 -- NO 2
WITH avg_lead_time_cte AS (
    SELECT AVG(lead_time) AS overall_avg_lead_time
    FROM data_hotel
)
SELECT
    total_of_special_requests,
    ROUND(CAST(AVG(lead_time) AS NUMERIC), 2) AS average_lead_time
FROM
    data_hotel
WHERE
    lead_time > (SELECT overall_avg_lead_time FROM avg_lead_time_cte)
GROUP BY
    total_of_special_requests
ORDER BY
    total_of_special_requests;
    
   
   
  --no 3
SELECT
    reservation_status_date,
    ROUND(AVG(adr), 2) AS total_revenue
FROM
    data_hotel
WHERE
    reservation_status = 'Check-Out'
    AND total_of_special_requests > 2
GROUP BY
    reservation_status_date
ORDER BY
    total_revenue DESC
LIMIT 1;


-- no 4
WITH lead_time_groups AS (
    SELECT
        CASE
            WHEN lead_time BETWEEN 0 AND 30 THEN '0-30 days'
            WHEN lead_time BETWEEN 31 AND 60 THEN '31-60 days'
            WHEN lead_time BETWEEN 61 AND 90 THEN '61-90 days'
            WHEN lead_time BETWEEN 91 AND 120 THEN '91-120 days'
            WHEN lead_time > 120 THEN '> 120 days'
            ELSE 'Unknown'        
	END AS lead_time_range,
        adr
    FROM data_hotel
)

SELECT
    lead_time_range,
    ROUND(AVG(adr), 2) AS average_adr
FROM
    lead_time_groups
GROUP BY
    lead_time_range
ORDER BY
    lead_time_range;
