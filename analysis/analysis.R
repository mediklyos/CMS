#!/usr/bin/R
require(dplyr)
require(rCharts)

# Load aggregate statistics that have been precomputed in SQL
cms_agg = read.csv("../data/cms_aggregates.csv", sep="|")
names(cms_agg) = c("drug", "claims", "cost", "bene")
cms_agg = cms_agg %>%
    mutate(cost_per_bene = cost/bene,
           claim_per_bene = claims/bene,
           cost_per_claim = cost/claims)
colnames(cms_agg) = c("drug", "claims", "cost", "beneficiaries", "cost_per_bene", "claim_per_bene", "cost_per_claim")

# Sort drugs by total number of claims
sort_by_claims = cms_agg %>%
    arrange(desc(claims))

# Compute the total number of claims and total cost of prescriptions submitted to medicaid
medicare_claims = sum(cms_agg$claims)
medicare_cost = sum(cms_agg$cost)
c(medicare_claims, medicare_cost)

# Return the top 5 drugs by claims
sort_by_claims[1:5,]

# Compute the fraction of total claims represented by the top-5 most prescribed drugs
tot_claims = (sum(sort_by_claims[1:5,]$claims) / medicare_claims)*100
tot_cost = (sum(sort_by_claims[1:5,]$cost) / medicare_cost)*100
c(tot_claims, tot_cost)

# Identify the top 200 drugs arrange by total claims
claims_top_200 = sort_by_claims[1:200,]
colnames(claims_top_200)

# Create plot containing top 200 drugs by claims
drug_claims = rPlot(cost ~ beneficiaries, data = claims_top_200, size="claims", type="point", tooltip="#!function(item){return item.drug}!#")
drug_claims$set(title="Top 200 Medicare drugs by claim count, 2013")
drug_claims$addControls("y", value="cost", values=c("beneficiaries", "cost", "claims"))
drug_claims$addControls("x", value="bene", values=c("beneficiaries", "cost", "claims"))
drug_claims$addControls("size", value="claims", values=c("beneficiaries", "cost", "claims"))
drug_claims$save("./figures/top-drugs-by-claims.html", standalone=TRUE)

# Identify the top 5 most costly drugs
sort_by_cost = cms_agg %>% arrange(desc(cost))
sort_by_cost[1:5,]

# Compute the percetage of claims and total cost represented by the top 5 most costly drugs
tot_claims = (sum(sort_by_cost[1:5,]$claims) / medicare_claims)*100
tot_cost = (sum(sort_by_cost[1:5,]$cost) / medicare_cost)*100
c(tot_claims, tot_cost)
