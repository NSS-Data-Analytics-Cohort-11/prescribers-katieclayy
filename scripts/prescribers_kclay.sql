SELECT *
FROM cbsa

SELECT *
FROM drug

SELECT *
FROM fips_county

SELECT *
FROM overdose_deaths

SELECT *
FROM population

SELECT * 
FROM prescriber

SELECT *
FROM prescription

SELECT *
FROM zip_fips

--Q1a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
SELECT prescriber.npi, SUM(prescription.total_claim_count) AS total_claim
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
GROUP BY prescriber.npi
ORDER BY total_claim DESC;

--answer1a.) 1881634483, 99707

--Q1b.)Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.
SELECT prescriber.npi, prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claim
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
GROUP BY prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, prescriber.specialty_description, prescriber.npi
ORDER BY total_claim DESC;
--answer 1b.) Bruce Pendley, Family Practice

SELECT *
FROM cbsa

SELECT *
FROM drug

SELECT *
FROM fips_county

SELECT *
FROM overdose_deaths

SELECT *
FROM population

SELECT * 
FROM prescriber

SELECT *
FROM prescription

SELECT *
FROM drug


--Q2a.) Which specialty had the most total number of claims (totaled over all drugs)?
SELECT prescriber.specialty_description, SUM(prescription.total_claim_count)
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
GROUP BY prescriber.specialty_description
ORDER BY SUM(prescription.total_claim_count) DESC;
--answer 2a: Family Practice


--Q2b.)  Which specialty had the most total number of claims for opioids?
SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claim, drug.opioid_drug_flag
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
INNER JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE drug.opioid_drug_flag = 'Y'
GROUP BY prescriber.specialty_description, drug.opioid_drug_flag
ORDER BY total_claim DESC;

--answer 9b.) Nurse Practitioner



SELECT *
FROM cbsa

SELECT *
FROM drug

SELECT *
FROM fips_county

SELECT *
FROM overdose_deaths

SELECT *
FROM population

SELECT * 
FROM prescriber

SELECT *
FROM prescription

SELECT *
FROM zip_fips

--Q3a.) Which drug (generic_name) had the highest total drug cost?
SELECT drug.generic_name, SUM(prescription.total_drug_cost) AS total_drug_cost
FROM prescription
INNER JOIN drug
ON prescription.drug_name = drug.drug_name
GROUP BY drug.generic_name
ORDER BY SUM(prescription.total_drug_cost) DESC;
--answer 3a.) Insulin glargine


SELECT *
FROM drug

SELECT *
FROM prescription

--Q3b.)Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works
SELECT drug.generic_name, ROUND(SUM(prescription.total_drug_cost)/SUM(prescription.total_day_supply),2) AS total_cost_per_day
FROM prescription
INNER JOIN drug
ON prescription.drug_name = drug.drug_name
GROUP BY drug.generic_name
ORDER BY total_cost_per_day DESC;
--answer3b.) C1 Esterase Inhibitor


--Q4a.) For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y'
THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y'
THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug;
--Q4a.) see query

SELECT *
FROM drug

SELECT *
FROM prescription

--Q4b.) Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
SELECT MONEY(SUM(prescription.total_drug_cost)),
CASE WHEN drug.opioid_drug_flag = 'Y'
THEN 'opioid'
WHEN drug.antibiotic_drug_flag = 'Y'
THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug
INNER JOIN prescription
ON drug.drug_name = prescription.drug_name
WHERE drug.antibiotic_drug_flag = 'Y'
OR drug.opioid_drug_flag = 'Y'
GROUP BY drug_type
ORDER BY money DESC;
--answer 4b.) opioid

SELECT *
FROM cbsa

SELECT *
FROM population


--Q5a.) How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.
SELECT COUNT(cbsaname)
FROM cbsa
WHERE cbsaname LIKE '%TN%';
--answer5a.) 56


--Q5b.)Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
SELECT cbsa.cbsaname, SUM(population.population)
FROM cbsa
INNER JOIN population
ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsaname
ORDER BY SUM(population.population) DESC;
--answer 5b.) Largest:Nashville-Davidson-Murfreeboro-Franklin,TN- 1,830,410  ; Smallest: Morristown,TN- 116,352



SELECT *
FROM fips_county

SELECT *
FROM population



--Q5c.)What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population
SELECT 
	p.population, 
	f.county 
FROM population AS p
LEFT JOIN fips_county AS f
USING (fipscounty)
LEFT JOIN cbsa AS c
USING (fipscounty)
WHERE c.fipscounty IS NULL
ORDER BY p.population DESC
--answer 5c.) Sevier - 95,523

SELECT *
FROM cbsa

SELECT *
FROM drug

SELECT *
FROM fips_county

SELECT *
FROM overdose_deaths

SELECT *
FROM population

SELECT * 
FROM prescriber

SELECT *
FROM prescription



--Q6a.)  Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
SELECT 
	drug_name,
	total_claim_count
FROM prescription
WHERE total_claim_count >= 3000
--answer6a: see query for answer

--Q6b.) For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
SELECT 
	p.drug_name,
	p.total_claim_count,
	d.opioid_drug_flag
FROM prescription AS p
LEFT JOIN drug AS d
USING (drug_name)
WHERE p.total_claim_count >= 3000
--answer6b.) see query for answer

--Q6c.) Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
SELECT 
	p.drug_name,
	p.total_claim_count,
	d.opioid_drug_flag,
	prescriber.nppes_provider_first_name,
	prescriber.nppes_provider_last_org_name
FROM prescription AS p
LEFT JOIN drug AS d
USING (drug_name)
LEFT JOIN prescriber 
ON p.npi = prescriber.npi
WHERE p.total_claim_count >= 3000
--answer6c: see query for answer


SELECT *
FROM cbsa

SELECT *
FROM drug

SELECT *
FROM fips_county

SELECT *
FROM overdose_deaths

SELECT *
FROM population

SELECT * 
FROM prescriber

SELECT *
FROM prescription


--Q7a.)First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.
SELECT
	p.npi,
	d.drug_name
FROM prescriber AS p
CROSS JOIN drug AS d
WHERE p.specialty_description ILIKE 'Pain Management'
	AND p.nppes_provider_city ILIKE 'Nashville'
	AND d.opioid_drug_flag = 'Y';
--answer7a: see query for answer

--Q7b.)Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
SELECT
	p1.npi,
	d.drug_name,
	SUM(p2.total_claim_count)
FROM prescriber AS p1
CROSS JOIN drug AS d
LEFT JOIN prescription AS p2
ON d.drug_name = p2.drug_name
WHERE p1.specialty_description ILIKE 'Pain Management'
	AND p1.nppes_provider_city ILIKE 'Nashville'
	AND d.opioid_drug_flag = 'Y'
GROUP BY p1.npi, d.drug_name