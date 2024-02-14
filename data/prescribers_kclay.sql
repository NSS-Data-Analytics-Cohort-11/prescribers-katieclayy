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
ORDER BY SUM(prescription.total_drug_cost) DESC
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
ORDER BY total_cost_per_day DESC
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
WHERE cbsaname LIKE '%TN%'
--answer5a.) 56


--Q5b.)Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
SELECT cbsa.cbsaname, SUM(population.population)
FROM cbsa
INNER JOIN population
ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsaname
ORDER BY SUM(population.population) DESC
--answer 5b.) Nashville-Davidson-Murfreeboro-Franklin,TN