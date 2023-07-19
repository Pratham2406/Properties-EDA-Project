-- 1.) Let's look at number of columns in the table 

SELECT 
  COUNT(*) AS num_columns
FROM 
  INFORMATION_SCHEMA.COLUMNS
WHERE 
  TABLE_SCHEMA = 'properties'
  AND TABLE_NAME = 'Properties_india';
  
-- 2.) Let's look at how many rows do we have in the table

SELECT 
  COUNT(*)
FROM 
  properties.properties_india;

-- 3.) Let's look at which cities property Data do we have

SELECT 
  DISTINCT City_name
FROM 
  properties.properties_india;

-- 4.) Looking at the distribution of property types (e.g., apartment, Villa, Independent House etc.) in the dataset

SELECT 
  Property_type,
  COUNT(Property_type) AS Num_of_properties
FROM 
  Properties.properties_india
GROUP BY 
  Property_type
ORDER BY 
  Num_of_properties DESC;

-- 5.) Let's look at number of properties city-wise

SELECT City_name,
       COUNT(*) AS Num_of_properties
FROM 
  properties.properties_india
GROUP BY 
  City_name
ORDER BY 
  Num_of_properties DESC;

-- 6.) Let's look at the avg Area(sq.ft) of property city-wise

SELECT 
  City_name,
  ROUND(AVG(Size_sq_ft),0) AS AVG_Area
FROM 
  properties.properties_india
GROUP BY 
  City_name
ORDER BY 
  AVG_Area DESC;

-- 7.) Looking at an Average price of property in each city
SELECT 
  City_name,
  ROUND(AVG(Price),0) AS Avg_Price
FROM 
  properties.properties_india
GROUP BY 
  City_name
ORDER BY 
  Avg_Price DESC;

-- 8.) Let's look at which City has the highest average price per unit area

SELECT 
  City_name,
  ROUND(AVG(Price_per_unit_area),0) AS Avg_price_per_unit_area
FROM 
  properties.properties_india
GROUP BY 
  City_name
ORDER BY 
  Avg_price_per_unit_area DESC;

-- 9.) Let's look at Which City has the best price of Apartment Compared to other cities

SELECT 
  City_name,
  ROUND(AVG(Price),0) AS AVG_Apartment_price,
  ROUND(AVG(Size_sq_ft),0) AS AVG_Apartment_area,
  ROUND(AVG(Price_per_unit_area),0) AS AVG_Price_per_unit_area
FROM 
  properties.properties_india
WHERE 
  Property_type LIKE 'Apartment' AND Property_building_status LIKE 'ACTIVE'
GROUP BY 
  City_name
ORDER BY 
  avg_Apartment_price ASC;

-- 10.) Let's find out which City has the best price of Independent House Compared to other cities

SELECT 
  City_name,
  ROUND(AVG(Price),0) AS AVG_PRICE,
  ROUND(AVG(Size_sq_ft),0) AS AVG_AREA,
  ROUND(AVG(Price_per_unit_area),0) AS AVG_Price_per_unit_area
FROM 
  properties.properties_india
WHERE 
  Property_type LIKE 'Independent House' AND Property_building_status LIKE 'ACTIVE'
GROUP BY 
  City_name
ORDER BY 
  avg_price ASC;

-- 11.) Looking at which Cites have the best price of Villa Compared to other cities

SELECT 
  City_name,
  ROUND(AVG(Price),0) AS AVG_PRICE,
  ROUND(AVG(Size_sq_ft),0) AS AVG_AREA,
  ROUND(AVG(Price_per_unit_area),0) AS AVG_Price_per_unit_area
FROM 
  properties.properties_india
WHERE 
  Property_type LIKE 'Villa' AND Property_building_status LIKE 'ACTIVE'
GROUP BY 
  City_name
ORDER BY 
  avg_price ASC;

-- 12.) Let's look at number of properties per furnishing type

SELECT 
  is_furnished,
  COUNT(is_furnished) AS Num_of_properties
FROM 
  properties.properties_india
GROUP BY 
  is_furnished
ORDER BY 
  Num_of_properties DESC;

-- 13.) Let's find out locality has the best price per sq.ft

SELECT 
Locality_Name,
 ROUND(AVG(Price),0) AS AVG_PRICE, 
 ROUND(AVG(Size_sq_ft),0) AS AVG_AREA, 
 ROUND(AVG(Price_per_unit_area),0) AS AVG_Price_per_unit_area
FROM 
  properties.properties_india
GROUP BY 
  Locality_Name
ORDER BY 
  AVG_Price_per_unit_area ASC;

-- 14.) Let's look at how many properties do we have in the dataset by furnishing type

SELECT 
  Furnishing_type, 
  Num_of_properties, 
  ROUND((Num_of_properties/332096)*100,2) AS Percetage_of_total
FROM 
  (SELECT 
    is_furnished AS Furnishing_type, 
	COUNT(is_furnished) AS Num_of_properties
   FROM 
     Properties.properties_in_india
   GROUP BY 
     is_furnished
   ORDER BY 
     Num_of_properties DESC) AS O;
      
-- 15.) Let's find out what are the properties that fall within the top 10% based on their values

SELECT 
  Property_Name, 
  Property_id, 
  Property_type, 
  Builder_name, 
  Percent_ranking*100 AS Percentage_ranking, Price
FROM  
  (SELECT 
     Property_Name, 
     Property_id, 
     Property_type, 
     Builder_name, 
     ROUND(PERCENT_RANK () OVER (partition by Property_type order by price ASC),2) AS Percent_ranking, Price
	FROM 
      properties.properties_india) AS O
WHERE 
  Percent_ranking*100 > 90
ORDER BY 
  Percent_ranking;


-- 16.) Looking at the properties that are available in price range of 10 to 20 Lakhs

SELECT
  property_id,
  property_type, 
  price, Size_sq_ft AS Area, 
  City_name,
CASE 
WHEN price >= 1000000 AND price <= 2000000 THEN 'In Range'
ELSE 'Out of Range'
END = 'In Range'
FROM 
  properties.properties_india;

-- 17.) Let's look at How much does the price differ for 1 & 2 BHK from furnishing type

SELECT 
  City_name AS City, 
  is_furnished AS Furnishing_type, 
  ROUND(AVG(price),0) AS AVG_PRICE, 
  ROUND(AVG(Size_sq_ft),0) AS AVG_AREA_Sqft, 
  ROUND(SUM(Price)/SUM(Size_sq_ft),0) AS AVG_PRICE_PER_SQ_FT
FROM 
  Properties.properties_india
WHERE 
  No_of_BHK IN ('1 BHK', '2 BHK')
GROUP BY 
  is_furnished, City_name
ORDER BY 
  City_name, AVG_PRICE Desc;


-- 18.) Looking at how many properties in the dataset are RERA registered

SELECT
  DISTINCT(is_RERA_registered),
  COUNT(is_RERA_registered) AS Num_of_properties,
  ROUND(COUNT(is_RERA_registered)/332096*100,2) AS Percentage_of_total
FROM 
  Properties.properties_india
GROUP BY 
  is_RERA_registered
ORDER BY 
  Percentage_of_total DESC;
  






