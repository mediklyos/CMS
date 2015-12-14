CREATE TABLE cms (
npi text,
last_name text,
first_name text,
city text,
state text,
specialty text,
description text,
drug_name text,
generic_name text,
bene_count int,
claim_count int,
day_supply int,
drug_cost real,
bene_count_65 int,
bene_count_65_redact_flag text,
claim_count_65 int,
redact_flag_65 text,
day_supply_65 int,
total_drug_cost_65 real);

.separator \t
.import data/PARTD_PRESCRIBER_PUF_NPI_DRUG_13.tab cms

CREATE INDEX idx ON CMS (drug_name, generic_name, city, state);

DELETE FROM cms WHERE drug_name = "DRUG_NAME";
