# Get TaxonTerms from DWC
# https://dwc.tdwg.org/xml/tdwg_dwcterms.xsd

# Load required libraries
library(xml2)

# Read XSD file
# xsd_file <- read_xml("/Users/ajpelu/Downloads/tdwg_dwcterms.xsd")
xsd_file <- read_xml("https://dwc.tdwg.org/xml/tdwg_dwcterms.xsd")


# Extract xs:element terms within the target xs:group. Note that there is an intermediate xs:sequence
elements <- xml_find_all(xsd_file, "//xs:group[@name='TaxonTerms']/xs:sequence/xs:element")

# Extrat the terms ref
term_names <- xml_attr(elements, "ref")

# Remove "dwc:"
dwc_terms <- gsub("dwc:", "", term_names)

# Remove terms contains, or starts_with (^...)
patterns <- c("ID", "verbatim", "NameUsage", "nomenclatural", "^name", "^taxon")
pattern <- paste(patterns, collapse = "|")

# potential_dwc_terms
dwc_terms <- dwc_terms[!grepl(pattern, dwc_terms)]

usethis::use_data(dwc_terms, internal = TRUE)


