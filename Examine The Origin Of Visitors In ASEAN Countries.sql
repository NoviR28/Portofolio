SELECT * FROM visitor_asean;
DELETE 
	FROM visitor_asean 
		WHERE `Destination Country` = 'Destination Country';
SELECT COUNT(*) FROM visitor_asean;

----------------------------------------------------------------------------------------------------
--- DATA CLEANING ---------------
UPDATE visitor_asean SET `2020`=0 WHERE `2020` = 'NAN';
ALTER TABLE visitor_asean MODIFY COLUMN `2020` INT;

# General questions
-- 1. What are the trends in visitor numbers in ASEAN over time?
-- 2. How does the trend of visitors numbers in ASEAN countries over time?
-- 3. Between intra-ASEAN, What are the trends in visitor numbers in ASEAN countries over time?
-- 4. Between intra-ASEAN, How does the performance of visitors in ASEAN countries over time?
-- 5. What is the total visitor in ASEAN each year?
-- 6. Number of ASEAN countries as visitors in other ASEAN Countries year on year, from 2015 to 2020?
-- 7. Total visitors in ASEAN from all countries, including members of ASEAN and excluding members of ASEAN from 2015 to 2020?

# No. 1

SELECT `Destination Country`,
         SUM(`2015`) AS Total_2015,
		 SUM(`2016`) AS Total_2016,
	 	 SUM(`2017`) AS Total_2017,
		 SUM(`2018`) AS Total_2018,
		 SUM(`2019`) AS Total_2019,
		 SUM(`2020`) AS Total_2020
				FROM visitor_asean
					WHERE `Origin Country` NOT IN ('Total Country (World)', 'Total EU-28', 'Total EU-27', 'Total Intra-ASEAN')
	GROUP BY `Destination Country`
;

---------------------------------------------------------------------------------------------------------
# No.2 
WITH Asean AS (
    SELECT `Origin Country`
		FROM visitor_asean 
			WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
										'Cambodia [KH]',
                                        'Indonesia [ID]',
                                        'Lao PDR [LA]',
                                        'Malaysia [MY]',
                                        'Myanmar [MM]',
                                        'Philippines [PH]',
                                        'Singapore [SG]',
                                        'Thailand [TH]',
                                        'Viet Nam [VN]')
),
Total_EU27 AS (
    SELECT `Origin Country`
    FROM visitor_asean 
    WHERE `Origin Country` IN ('Austria [AT]', 'Belgium [BE]', 'Bulgaria [BG]', 'Croatia [HR]', 
                               'Cyprus [CY]', 'Czech Republic [CZ]', 'Denmark [DK]', 'Estonia [EE]',
                               'Finland [FI]', 'France [FR]', 'Germany [DE]', 'Greece [GR]', 
                               'Hungary [HU]', 'Ireland [IE]', 'Italy [IT]', 'Latvia [LV]', 
                               'Lithuania [LT]', 'Luxembourg [LU]', 'Malta [MT]', 'Netherlands [NL]',
                               'Poland [PL]', 'Portugal [PT]', 'Romania [RO]', 'Slovakia [SK]',
                               'Slovenia [SI]', 'Spain [ES]', 'Sweden [SE]')
)
SELECT 
    `Origin Country`,
    SUM(`2015`) AS Total_2015,
    SUM(`2016`) AS Total_2016,
    SUM(`2017`) AS Total_2017,
    SUM(`2018`) AS Total_2018,
    SUM(`2019`) AS Total_2019,
    SUM(`2020`) AS Total_2020
			FROM visitor_asean
				WHERE `Origin Country` NOT IN (SELECT `Origin Country` FROM Total_EU27)
					   AND `Origin Country` != 'Total EU-28'
                       AND `Origin Country` != 'Total Country (World)'
                       AND `Origin Country` NOT IN (SELECT `Origin Country` FROM Asean)
GROUP BY `Origin Country`;

---------------------------------------------------------------------------------------------------------
  # No. 3

-- Cara CTE 1
  WITH Asean AS (
    SELECT `Origin Country`
				 FROM visitor_asean 
					WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
												'Cambodia [KH]',
												'Indonesia [ID]',
												'Lao PDR [LA]',
												'Malaysia [MY]',
												'Myanmar [MM]',
												'Philippines [PH]',
												'Singapore [SG]',
												'Thailand [TH]',
												'Viet Nam [VN]')
)
SELECT `Destination Country`,
         SUM(`2015`) AS Total_2015,
		 SUM(`2016`) AS Total_2016,
	 	 SUM(`2017`) AS Total_2017,
		 SUM(`2018`) AS Total_2018,
		 SUM(`2019`) AS Total_2019,
		 SUM(`2020`) AS Total_2020
				FROM visitor_asean
					WHERE `Origin Country` IN (SELECT `Origin Country` FROM Asean)
GROUP BY `Destination Country`;

-- Cara 3 bukan CTE

SELECT `Destination Country`,
         SUM(`2015`) AS Total_2015,
		 SUM(`2016`) AS Total_2016,
	 	 SUM(`2017`) AS Total_2017,
		 SUM(`2018`) AS Total_2018,
		 SUM(`2019`) AS Total_2019,
		 SUM(`2020`) AS Total_2020
				FROM visitor_asean
					WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
												'Cambodia [KH]',
												'Indonesia [ID]',
												'Lao PDR [LA]',
												'Malaysia [MY]',
												'Myanmar [MM]',
												'Philippines [PH]',
												'Singapore [SG]',
												'Thailand [TH]',
												'Viet Nam [VN]')
					GROUP BY `Destination Country`
;


SELECT DISTINCT `Origin Country` FROM visitor_asean;

SELECT * FROM visitor_asean WHERE `Origin Country` LIKE 'Total%';

---------------------------------------------------------------------------------------------------------
# No. 4
  
  -- Cara CTE 1
  WITH Asean AS (
    SELECT `Destination Country`,
			`Origin Country`
				FROM visitor_asean 
					WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
												'Cambodia [KH]',
												'Indonesia [ID]',
												'Lao PDR [LA]',
												'Malaysia [MY]',
												'Myanmar [MM]',
												'Philippines [PH]',
												'Singapore [SG]',
												'Thailand [TH]',
												'Viet Nam [VN]')
)
SELECT va.`Destination Country`,
		 va.`Origin Country`,
         SUM(`2015`) AS Total_2015,
		 SUM(`2016`) AS Total_2016,
	 	 SUM(`2017`) AS Total_2017,
		 SUM(`2018`) AS Total_2018,
		 SUM(`2019`) AS Total_2019,
		 SUM(`2020`) AS Total_2020
				FROM visitor_asean AS va
                RIGHT JOIN Asean AS a 
					ON va.`Destination Country`=a.`Destination Country` 
						AND va.`Origin Country`=a.`Origin Country`
					WHERE va.`Origin Country` IN (SELECT `Origin Country` FROM Asean)
GROUP BY `Destination Country`, `Origin Country`;

-- Cara CTE 2
  WITH Asean AS (
    SELECT 
			`Origin Country`
				FROM visitor_asean 
					WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
												'Cambodia [KH]',
												'Indonesia [ID]',
												'Lao PDR [LA]',
												'Malaysia [MY]',
												'Myanmar [MM]',
												'Philippines [PH]',
												'Singapore [SG]',
												'Thailand [TH]',
												'Viet Nam [VN]')
)
SELECT `Destination Country`,
		 `Origin Country`,
         SUM(`2015`) AS Total_2015,
		 SUM(`2016`) AS Total_2016,
	 	 SUM(`2017`) AS Total_2017,
		 SUM(`2018`) AS Total_2018,
		 SUM(`2019`) AS Total_2019,
		 SUM(`2020`) AS Total_2020
				FROM visitor_asean
					WHERE `Origin Country` IN (SELECT `Origin Country` FROM Asean)
GROUP BY `Destination Country`, `Origin Country`;       

SELECT * FROM visitor_asean;

-- Cara 3 bukan CTE

SELECT `Destination Country`,
		 `Origin Country`,
         SUM(`2015`) AS Total_2015,
		 SUM(`2016`) AS Total_2016,
	 	 SUM(`2017`) AS Total_2017,
		 SUM(`2018`) AS Total_2018,
		 SUM(`2019`) AS Total_2019,
		 SUM(`2020`) AS Total_2020
				FROM visitor_asean
					WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
												'Cambodia [KH]',
												'Indonesia [ID]',
												'Lao PDR [LA]',
												'Malaysia [MY]',
												'Myanmar [MM]',
												'Philippines [PH]',
												'Singapore [SG]',
												'Thailand [TH]',
												'Viet Nam [VN]')
					GROUP BY `Destination Country`,`Origin Country`
;

--------------------------------------------------------------------------------------------------------------
# No. 5
WITH Asean AS (
    SELECT `Origin Country`
		FROM visitor_asean 
			WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
										'Cambodia [KH]',
                                        'Indonesia [ID]',
                                        'Lao PDR [LA]',
                                        'Malaysia [MY]',
                                        'Myanmar [MM]',
                                        'Philippines [PH]',
                                        'Singapore [SG]',
                                        'Thailand [TH]',
                                        'Viet Nam [VN]')
),
Total_EU27 AS (
    SELECT `Origin Country`
    FROM visitor_asean 
    WHERE `Origin Country` IN ('Austria [AT]', 'Belgium [BE]', 'Bulgaria [BG]', 'Croatia [HR]', 
                               'Cyprus [CY]', 'Czech Republic [CZ]', 'Denmark [DK]', 'Estonia [EE]',
                               'Finland [FI]', 'France [FR]', 'Germany [DE]', 'Greece [GR]', 
                               'Hungary [HU]', 'Ireland [IE]', 'Italy [IT]', 'Latvia [LV]', 
                               'Lithuania [LT]', 'Luxembourg [LU]', 'Malta [MT]', 'Netherlands [NL]',
                               'Poland [PL]', 'Portugal [PT]', 'Romania [RO]', 'Slovakia [SK]',
                               'Slovenia [SI]', 'Spain [ES]', 'Sweden [SE]')
)
SELECT 
    
    SUM(`2015`) AS Total_2015,
    SUM(`2016`) AS Total_2016,
    SUM(`2017`) AS Total_2017,
    SUM(`2018`) AS Total_2018,
    SUM(`2019`) AS Total_2019,
    SUM(`2020`) AS Total_2020
			FROM visitor_asean
				WHERE `Origin Country` NOT IN (SELECT `Origin Country` FROM Total_EU27)
					   AND `Origin Country` != 'Total EU-28'
                       AND `Origin Country` != 'Total Country (World)'
                       AND `Origin Country` NOT IN (SELECT `Origin Country` FROM Asean)
;
            
 # No. 6 
 
 -- USING CTE
  WITH Asean AS (
    SELECT 
			`Origin Country`
				FROM visitor_asean 
					WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
												'Cambodia [KH]',
												'Indonesia [ID]',
												'Lao PDR [LA]',
												'Malaysia [MY]',
												'Myanmar [MM]',
												'Philippines [PH]',
												'Singapore [SG]',
												'Thailand [TH]',
												'Viet Nam [VN]')
)
 SELECT
 `Origin Country`,
	 SUM(`2015`) AS Total_2015,
     SUM(`2016`) AS Total_2016,
     SUM(`2017`) AS Total_2017,
     SUM(`2018`) AS Total_2018,
     SUM(`2019`) AS Total_2019,
     SUM(`2020`) AS Total_2020
		FROM visitor_Asean
			Where `Origin Country` IN (SELECT `Origin Country` FROM Asean)
	GROUP BY `Origin Country`;
    
-- USING NON-CTE

SELECT
 `Origin Country`,
	 SUM(`2015`) AS Total_2015,
     SUM(`2016`) AS Total_2016,
     SUM(`2017`) AS Total_2017,
     SUM(`2018`) AS Total_2018,
     SUM(`2019`) AS Total_2019,
     SUM(`2020`) AS Total_2020
		FROM visitor_Asean
			Where `Origin Country` IN ('Brunei Darussalam [BN]', 
												'Cambodia [KH]',
												'Indonesia [ID]',
												'Lao PDR [LA]',
												'Malaysia [MY]',
												'Myanmar [MM]',
												'Philippines [PH]',
												'Singapore [SG]',
												'Thailand [TH]',
												'Viet Nam [VN]')
	GROUP BY `Origin Country`;

# No.8 

-- Including  ASEAN COUNTRY
WITH Asean AS (
    SELECT `Origin Country`
		FROM visitor_asean 
			WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
										'Cambodia [KH]',
                                        'Indonesia [ID]',
                                        'Lao PDR [LA]',
                                        'Malaysia [MY]',
                                        'Myanmar [MM]',
                                        'Philippines [PH]',
                                        'Singapore [SG]',
                                        'Thailand [TH]',
                                        'Viet Nam [VN]')
),
Total_EU27 AS (
    SELECT `Origin Country`
    FROM visitor_asean 
    WHERE `Origin Country` IN ('Austria [AT]', 'Belgium [BE]', 'Bulgaria [BG]', 'Croatia [HR]', 
                               'Cyprus [CY]', 'Czech Republic [CZ]', 'Denmark [DK]', 'Estonia [EE]',
                               'Finland [FI]', 'France [FR]', 'Germany [DE]', 'Greece [GR]', 
                               'Hungary [HU]', 'Ireland [IE]', 'Italy [IT]', 'Latvia [LV]', 
                               'Lithuania [LT]', 'Luxembourg [LU]', 'Malta [MT]', 'Netherlands [NL]',
                               'Poland [PL]', 'Portugal [PT]', 'Romania [RO]', 'Slovakia [SK]',
                               'Slovenia [SI]', 'Spain [ES]', 'Sweden [SE]')
)
SELECT 
    SUM(`2015`) AS Total_2015,
    SUM(`2016`) AS Total_2016,
    SUM(`2017`) AS Total_2017,
    SUM(`2018`) AS Total_2018,
    SUM(`2019`) AS Total_2019,
    SUM(`2020`) AS Total_2020,
    SUM(`2015`)+SUM(`2016`)+SUM(`2017`)+SUM(`2018`)+SUM(`2019`)+SUM(`2020`) AS TOTAL
			FROM visitor_asean
				WHERE `Origin Country` NOT IN (SELECT `Origin Country` FROM Total_EU27)
					   AND `Origin Country` != 'Total EU-28'
                       AND `Origin Country` != 'Total Country (World)'
                       AND `Origin Country` NOT IN (SELECT `Origin Country` FROM Asean);
                       
-- excluding  ASEAN COUNTRY
WITH Asean AS (
    SELECT `Origin Country`
		FROM visitor_asean 
			WHERE `Origin Country` IN ('Brunei Darussalam [BN]', 
										'Cambodia [KH]',
                                        'Indonesia [ID]',
                                        'Lao PDR [LA]',
                                        'Malaysia [MY]',
                                        'Myanmar [MM]',
                                        'Philippines [PH]',
                                        'Singapore [SG]',
                                        'Thailand [TH]',
                                        'Viet Nam [VN]')
),
Total_EU27 AS (
    SELECT `Origin Country`
    FROM visitor_asean 
    WHERE `Origin Country` IN ('Austria [AT]', 'Belgium [BE]', 'Bulgaria [BG]', 'Croatia [HR]', 
                               'Cyprus [CY]', 'Czech Republic [CZ]', 'Denmark [DK]', 'Estonia [EE]',
                               'Finland [FI]', 'France [FR]', 'Germany [DE]', 'Greece [GR]', 
                               'Hungary [HU]', 'Ireland [IE]', 'Italy [IT]', 'Latvia [LV]', 
                               'Lithuania [LT]', 'Luxembourg [LU]', 'Malta [MT]', 'Netherlands [NL]',
                               'Poland [PL]', 'Portugal [PT]', 'Romania [RO]', 'Slovakia [SK]',
                               'Slovenia [SI]', 'Spain [ES]', 'Sweden [SE]')
)
SELECT 
    SUM(`2015`) AS Total_2015,
    SUM(`2016`) AS Total_2016,
    SUM(`2017`) AS Total_2017,
    SUM(`2018`) AS Total_2018,
    SUM(`2019`) AS Total_2019,
    SUM(`2020`) AS Total_2020,
    SUM(`2015`)+SUM(`2016`)+SUM(`2017`)+SUM(`2018`)+SUM(`2019`)+SUM(`2020`) AS TOTAL
			FROM visitor_asean
				WHERE `Origin Country` NOT IN (SELECT `Origin Country` FROM Total_EU27)
					   AND `Origin Country` != 'Total EU-28'
                       AND `Origin Country` != 'Total Country (World)'
                       AND `Origin Country` != 'Total Intra-ASEAN'
                       AND `Origin Country` NOT IN (SELECT `Origin Country` FROM Asean);