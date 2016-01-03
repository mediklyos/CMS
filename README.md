# CSM Analysis of Drug Claims Data
_by [Michael L. Bernauer](http://mlbernauer.com)_

These analyses were used in support of [this](http://mlbernauer.com/pages/cms) blog post.

## Top drugs by total claim counts
#### 1. Install required packages


```r
require(dplyr)
```

```
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
require(rCharts)
```

```
## Loading required package: rCharts
```

```r
require(data.table)
```

```
## Loading required package: data.table
## 
## Attaching package: 'data.table'
## 
## The following objects are masked from 'package:dplyr':
## 
##     between, last
```
#### 2. Establishconnection to database

```r
cms_agg = fread("./data/cms_aggregates.csv", sep="|")
names(cms_agg) = c("drug", "claims", "cost", "bene")
cms_agg = cms_agg %>%
    mutate(cost_per_bene = cost/bene,
           claim_per_bene = claims/bene,
           cost_per_claim = cost/claims)
colnames(cms_agg) = c("drug", "claims", "cost", "beneficiaries", "cost_per_bene", "claim_per_bene", "cost_per_claim")
```
#### 3. Identify the top 5 drugs by popularity; claim count

```r
sort_by_claims = cms_agg %>%
    arrange(desc(claims))
```
#### 3.1 What is the total claims submited to medicare, what is total cost?

```r
medicare_claims = sum(cms_agg$claims)
medicare_cost = sum(cms_agg$cost)
c(medicare_claims, medicare_cost)
```

```
## [1]  1188393892 80941760814
```
#### 3.3 Give top 10 drugs by claims

```r
sort_by_claims[1:10,]
```

```
##                          drug   claims      cost beneficiaries
##  1:                LISINOPRIL 36206291 302019576       8096678
##  2:               SIMVASTATIN 36175328 427240349       7810370
##  3:      LEVOTHYROXINE SODIUM 34546833 389054553       6570208
##  4:       AMLODIPINE BESYLATE 33923856 337070650       7048170
##  5: HYDROCODONE-ACETAMINOPHEN 33492392 554669704      10840998
##  6:                OMEPRAZOLE 31496868 628358924       6902028
##  7:      ATORVASTATIN CALCIUM 26069230 891069462       5686493
##  8:                FUROSEMIDE 25697659 141268740       5609185
##  9:             METFORMIN HCL 21518057 221369317       4427457
## 10:       METOPROLOL TARTRATE 20368173 157284500       4147614
##     cost_per_bene claim_per_bene cost_per_claim
##  1:      37.30167       4.471746       8.341633
##  2:      54.70168       4.631705      11.810269
##  3:      59.21495       5.258103      11.261656
##  4:      47.82385       4.813144       9.936095
##  5:      51.16408       3.089420      16.561066
##  6:      91.03975       4.563422      19.949886
##  7:     156.69930       4.584413      34.180889
##  8:      25.18525       4.581353       5.497339
##  9:      49.99920       4.860139      10.287607
## 10:      37.92168       4.910817       7.722072
```

#### 4. What fraction of total claims and total cost do the top 5 most popular drugs contribute

```r
tot_claims = (sum(sort_by_claims[1:5,]$claims) / medicare_claims)*100
tot_cost = (sum(sort_by_claims[1:5,]$cost) / medicare_cost)*100
c(tot_claims, tot_cost)
```

```
## [1] 14.670616  2.483335
```

#### 5. Plot the top 200 most popular drugs according to claims

```r
claims_top_200 = sort_by_claims[1:200,]
drug_claims = rPlot(cost ~ beneficiaries, data = claims_top_200, size="claims", type="point",
    tooltip="#!function(item){return item.drug}!#")
drug_claims$set(title="Top 200 Medicare drugs by claim count, 2013")
drug_claims$addControls("y", value="cost", values=c("beneficiaries", "cost", "claims"))
drug_claims$addControls("x", value="bene", values=c("beneficiaries", "cost", "claims"))
drug_claims$addControls("size", value="claims", values=c("beneficiaries", "cost", "claims"))
drug_claims$save("./figures/top-drugs-by-claims.html", standalone=TRUE)
```

```
## Loading required package: base64enc
```

## Top drugs by cost
#### 6. Identify the top 5 drugs according to total cost

```r
sort_by_cost = cms_agg %>% arrange(desc(cost))
sort_by_cost[1:5,]
```

```
##             drug  claims       cost beneficiaries cost_per_bene
## 1:        NEXIUM 7622616 2320290927       1060846      2187.208
## 2:       CRESTOR 8602219 2089238350       1405895      1486.056
## 3: ADVAIR DISKUS 6050345 2069281702       1071364      1931.446
## 4:       ABILIFY 2612198 1878588440        282963      6638.990
## 5:       SPIRIVA 5237141 1778776055        775823      2292.760
##    claim_per_bene cost_per_claim
## 1:       7.185412       304.3956
## 2:       6.118678       242.8720
## 3:       5.647329       342.0105
## 4:       9.231589       719.1600
## 5:       6.750433       339.6464
```

#### 6.1 Top 10 drugs by cost

```r
sort_by_cost[1:10,]
```

```
##                drug  claims       cost beneficiaries cost_per_bene
##  1:          NEXIUM 7622616 2320290927       1060846      2187.208
##  2:         CRESTOR 8602219 2089238350       1405895      1486.056
##  3:   ADVAIR DISKUS 6050345 2069281702       1071364      1931.446
##  4:         ABILIFY 2612198 1878588440        282963      6638.990
##  5:         SPIRIVA 5237141 1778776055        775823      2292.760
##  6:        CYMBALTA 6362098 1777236646        630632      2818.183
##  7:         NAMENDA 6535308 1452009849        579477      2505.725
##  8:         JANUVIA 3983386 1308958749        410522      3188.523
##  9: LANTUS SOLOSTAR 3400142 1210243289        485722      2491.638
## 10:        REVLIMID  134976 1182223854          6861    172310.721
##     claim_per_bene cost_per_claim
##  1:       7.185412       304.3956
##  2:       6.118678       242.8720
##  3:       5.647329       342.0105
##  4:       9.231589       719.1600
##  5:       6.750433       339.6464
##  6:      10.088448       279.3476
##  7:      11.277942       222.1793
##  8:       9.703222       328.6045
##  9:       7.000181       355.9390
## 10:      19.672934      8758.7709
```

#### 7. What fraction of total claims and total cost do the top 5 most expensive drugs contribute

```r
tot_claims = (sum(sort_by_cost[1:5,]$claims) / medicare_claims)*100
tot_cost = (sum(sort_by_cost[1:5,]$cost) / medicare_cost)*100
c(tot_claims, tot_cost)
```

```
## [1]  2.534893 12.522801
```
