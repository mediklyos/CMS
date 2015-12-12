#!/bin/bash
wget -P data/ http://download.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Downloads/PartD_Prescriber_PUF_NPI_DRUG_13.zip
ls data/*.zip | xargs -I % unzip -o % -d data/
sqlite3 cms.db < schema.sql
rm data/*sas
