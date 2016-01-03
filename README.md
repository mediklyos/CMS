# Analysis of Medicare Part D Drug Claims

Code in support of this post: [Analysis of Medicare Part D Drug Claims](http://mlbernauer.com/pages/cms)

This repo provides scripts to download, process, and analyze data for over 23 million Medicare Part D records from the Centers for Medicare & Medicaid Public Use File.

## Instructions
First we need to downlaod the public use file and create the database. This is handled using the `setup.sh` script.

#### 1. Install SQLite if you have not already

#### 2. Run setup.sh script to download the PUF and create the database
This will also compute some aggregate statistics for each of the drugs and create
the file *data/cms_aggregates.csv* and *data/cms.db*

`./setup.sh`


#### 3. Analysis
Scritps to run the analysis are included in the *analysis* folder you can run the script using

`source('analysis.R')`

or write your own. Output figures from *analysis.R* is saved in *analysis/figures/*

## Schema
- NPI: National Provider Identification
- NPPES_PROVIDER_LAST_ORG_NAME
- NPPES_PROVIDER_FIRST_NAME
- NPPES_PRIVDER_CITY
- NPPES_PROVIDER_STATE
- SPECIALTY_DESC
- DESCRIPTION_FLAG
- DRUG_NAME
- GENERIC_NAME
- BENE_COUNT
- TOTAL_CLAIM_COUNT
- TOTAL_DAY_SUPPLY
- TOTAL_DRUG_SUPPLY
- BENE_COUNT_GE65
- BENE_COUNT_GE65_REDACT_FLAG
- TOTAL_CLAIM_COUNT_GE65
- GE65_REDACT_FLAG
- TOTAL_DAY_SUPPLY_GE65
- TOTAL_DRUG_COST_GE65

## Questions/issues/contact
mlbernauer@gmail.com
