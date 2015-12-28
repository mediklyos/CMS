require(dplyr, warn.conflicts=FALSE)
require(rCharts, warn.conflicts=FALSE)

df = tbl(src_sqlite("../data/cms.db"), "cms")

top_200 = df %>% mutate(Drug = drug_name) %>% group_by(Drug) %>%
    summarize(Cost = sum(drug_cost),
              Beneficiaries = sum(bene_count),
              Claims = sum(claim_count)) %>%
    arrange(desc(Claims))

top_200_claim = collect(top_200)[1:200,]

# Summarize by drug, cost, beneficiary and claims drugs sorted by most claims
drug_cost = rPlot(Cost ~ Beneficiaries, data = top_200_claim, size="Claims", type="point",
    tooltip="#!function(item){return item.Drug}!#")
drug_cost$set(title="Medicare Drug Claims: Top 200 by Claims, 2013")
drug_cost$addControls("x", value="Beneficiaries", values=c("Beneficiaries", "Cost", "Claims"))
drug_cost$addControls("y", value="Cost", values=c("Beneficiaries", "Cost", "Claims"))
drug_cost$addControls("size", value="Claims", values=c("Beneficiaries", "Cost", "Claims"))
drug_cost$save("./figures/drug-claim.html", standalone=TRUE)

# Summarize b drug, cost, beneficiary and claims drugs sorted by cost
top_200_cost = top_200 %>% arrange(desc(Cost))
top_200_cost = collect(top_200_cost)[1:200,]

drug_cost = rPlot(Cost ~ Beneficiaries, data = top_200_cost, color="red", size="Claims", type="point",
    color=list(const="red"), tooltip="#!function(item){return item.Drug}!#")
drug_cost$set(title="Medicare Drug Claims: Top 200 by Total Cost, 2013")
drug_cost$addControls("x", value="Beneficiaries", values=c("Beneficiaries", "Cost", "Claims"))
drug_cost$addControls("y", value="Cost", values=c("Beneficiaries", "Cost", "Claims"))
drug_cost$addControls("size", value="Claims", values=c("Beneficiaries", "Cost", "Claims"))
drug_cost$save("./figures/drug-cost.html", standalone=TRUE)


top_200_drugs = df %>% mutate(Drug = drug_name) %>% group_by(Drug) %>% summarize(cnt=n()) %>% arrange(desc(cnt))
top_200_drugs = collect(top_200_drugs)$Drug[1:200]

# Repeat the analysis by state
top_drug_by_state = df %>% mutate(Drug = drug_name, State = state) %>%
    group_by(State) %>%
    mutate(total_drug_cost = sum(drug_cost)) %>%
    ungroup() %>%
    filter(Drug %in% top_200_drugs) %>%
    group_by(State, Drug) %>%
    summarize(Cost = sum(drug_cost) / mean(total_drug_cost),
              Beneficiaries = sum(bene_count),
              Claims = sum(claim_count))

    
