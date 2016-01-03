# CSM Analysis of Drug Claims Data
_by [Michael L. Bernauer](http://mlbernauer.com)_

These analyses were used in support of [this](http://mlbernauer.com/pages/cms) blog post.

## Top drugs by total claim counts
#### 1. Install required packages

```{r}
require(dplyr)
require(rCharts)
require(data.table)
```
#### 2. Establishconnection to database
```{r}
cms_agg = fread("../data/cms_aggregates.csv", sep="|")
names(cms_agg) = c("drug", "claims", "cost", "bene")
cms_agg = cms_agg %>%
    mutate(cost_per_bene = cost/bene,
           claim_per_bene = claims/bene,
           cost_per_claim = cost/claims)
colnames(cms_agg) = c("drug", "claims", "cost", "beneficiaries", "cost_per_bene", "claim_per_bene", "cost_per_claim")
```
#### 3. Identify the top 5 drugs by popularity; claim count
```{r}
sort_by_claims = cms_agg %>%
    arrange(desc(claims))

```
#### 3.1 What is the total claims submited to medicare, what is total cost?
```{r}
medicare_claims = sum(cms_agg$claims)
medicare_cost = sum(cms_agg$cost)
c(medicare_claims, medicare_cost)
```
#### 3.3 Give top 10 drugs by claims
```{r}
sort_by_claims[1:10,]
```

#### 4. What fraction of total claims and total cost do the top 5 most popular drugs contribute
```{r}
tot_claims = (sum(sort_by_claims[1:5,]$claims) / medicare_claims)*100
tot_cost = (sum(sort_by_claims[1:5,]$cost) / medicare_cost)*100
c(tot_claims, tot_cost)
```

#### 5. Plot the top 200 most popular drugs according to claims
```{r}
claims_top_200 = sort_by_claims[1:200,]
drug_claims = rPlot(cost ~ beneficiaries, data = claims_top_200, size="claims", type="point",
    tooltip="#!function(item){return item.drug}!#")
drug_claims$set(title="Top 200 Medicare drugs by claim count, 2013")
drug_claims$addControls("y", value="cost", values=c("beneficiaries", "cost", "claims"))
drug_claims$addControls("x", value="bene", values=c("beneficiaries", "cost", "claims"))
drug_claims$addControls("size", value="claims", values=c("beneficiaries", "cost", "claims"))
drug_claims$save("./figures/top-drugs-by-claims.html", standalone=TRUE)
```

## Top drugs by cost
#### 6. Identify the top 5 drugs according to total cost
```{r}
sort_by_cost = cms_agg %>% arrange(desc(cost))
sort_by_cost[1:5,]
```

#### 6.1 Top 10 drugs by cost
```{r}
sort_by_cost[1:10,]
```

#### 7. What fraction of total claims and total cost do the top 5 most expensive drugs contribute
```{r}
tot_claims = (sum(sort_by_cost[1:5,]$claims) / medicare_claims)*100
tot_cost = (sum(sort_by_cost[1:5,]$cost) / medicare_cost)*100
c(tot_claims, tot_cost)
```
