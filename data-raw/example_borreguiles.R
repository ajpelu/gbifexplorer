# URL of a Darwin Core Archive.
url <- 'https://ipt.gbif.es/archive.do?r=borreguiles'

# Download the DwcA
temp_dir <- tempdir()
temp_zip <- file.path(temp_dir, "file.zip")

download.file(url, destfile = temp_zip, mode = "wb")
unzip(temp_zip, exdir = temp_dir)
borreguiles <- read.csv(file = paste0(temp_dir, "/occurrence.txt"), sep = '\t')

usethis::use_data(borreguiles, overwrite = TRUE)


