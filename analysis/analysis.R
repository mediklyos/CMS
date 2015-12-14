require(dplyr)
require(ggplot2)
require(grid)
require(knitr)

# Function to add credit to image
add_credits = function(fontsize = 12, color = "#777777", xpos = 0.99) {
  grid.text("www.mlbernauer.com",
            x = xpos,
            y = 0.02,
            just = "right",
            gp = gpar(fontsize = fontsize, col = color))
}

conn = src_sqlite("../data/cms.db")
cms = tbl(conn, "cms")

# Compute summaries of cms data, 2013.
#cms_summary = cms %>% group_by(drug_name) %>%
#    summarize(claim_cnt = n(),
#              bene_cnt = sum(bene_count),
#              pres_cnt = count(distinct(npi)),
#              drug_cst = sum(drug_cost))
#cms_summary = collect(cms_summary)

# Top ten drug claim count, 2013.
#top_ten = (cms_summary %>% arrange(desc(claim_cnt)))[1:10,]
#kable(top_ten, format = "markdown")

# Top ten drugs by cost, 2013.
#top_ten = (cms_summary %>% arrange(desc(drug_cst)))[1:10,]
#kable(top_ten, format="markdown")

# Average cost and number of unique products for specialties with
# highest number of prescribers, 2013.
top_specialties = cms %>% group_by(specialty) %>%
    summarize(prescriber_number = count(distinct(npi)),
              average_total_cost = sum(drug_cost),
              cost_per_claim = mean(drug_cost),
              avg_num_product = count(distinct(drug_cost))/count(distinct(npi))) %>%
    arrange(desc(prescriber_number))
top_specialties = collect(top_specialties)
kable(top_specialties[1:10,])

# Prescriber specialties with highest total drug costs, 2013.
top_prescriber_plot = ggplot(top_specialties[1:10,], aes(x=reorder(specialty, -prescriber_number), y=prescriber_number)) +
    geom_bar(stat="identity") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle=45, hjust=TRUE)) +
    labs(title="Presciber Specialties with the Highest Total Drug Costs, 2013", x="Practitioner", y="Total Costs")

pdf("./figures/top_prescriber_plot.pdf")
print(top_prescriber_plot)
add_credits()
dev.off()

# Average cost per claim versus total drug costs for selected top specialties, 2013.
cost = ggplot(top_specialties[1:10,], aes(x=average_total_cost, y=cost_per_claim, size=prescriber_number, label= specialty)) +
    geom_text() +
    scale_size(range = c(4,10)) +
    theme_minimal() +
    labs(title="Average Cost per Claim versus Total Drug Costs for Selected Top Specialties, 2013", x="Total Drug Costs", y="Cost per Claim") +
    geom_point()
