library(testthat)
library(gbifexplorer)

# example df
df <- data.frame(
  scientificName = c("Quercus ilex", "Quercus pyrenaica", "Quercus suber", "Quercus faginea", "Fagus sylvatica",
                     "Pinus nigra", "Pinus halepensis", "Pinus sylvestris", "Pinus radiata", "Pinus pinea"),
  genus = c(rep("Quercus", 5), rep("Pinus", 5)),
  family = c(rep("Fagaceae", 5), rep("Pinacea", 5)),
  order = c(rep("Fagales", 5), rep("Pinales", 5)),
  class = c(rep("Magnoliopsida", 5), rep("Pinopsida", 5)),
  phylum = rep("Tracheophyta", 10),
  kingdom = rep("Plantae", 10)
)

# define the categories to compute the taxonomic coverage
categories <- c("scientificName", "genus")

# calculate taxonomic coverage
result <- taxonomic_cov(df, category = categories)

# Test the taxonomic_cov function
test_that("taxonomic_cov returns correct dimensions (a list with the length of categories)", {
  expect_true(length(result) == length(categories))  # Two categories
})

test_that("category include in the argument categories is return as part of the list", {
expect_true("scientificName" %in% names(result))}
)

