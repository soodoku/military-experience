source("R/military_experience.R")
options(warn = 2)

as_of <- read_snapshot()
us_presidents <- read_leaders("data/us_presidents.csv")
uk_prime_ministers <- read_leaders("data/uk_prime_ministers.csv")
validate_leaders(us_presidents, as_of)
validate_leaders(uk_prime_ministers, as_of)

stopifnot(
  nrow(us_presidents) == 47L,
  nrow(uk_prime_ministers) == 81L,
  length(unique(us_presidents$leader_id)) == 45L,
  length(unique(uk_prime_ministers$leader_id)) == 59L,
  all(us_presidents$leader_id[c(22, 24)] == 22L),
  all(us_presidents$leader_id[c(45, 47)] == 45L),
  summarize_leaders(us_presidents, "US")$military_yes == 30L,
  summarize_leaders(us_presidents, "US")$military_no == 15L,
  all(us_presidents$military_experience[c(3, 43)] == 1L),
  us_presidents$military_experience[13] == 0L,
  all(uk_prime_ministers$military_experience[c(3, 10, 66)] == 1L),
  uk_prime_ministers$start_year[11] == 1768L,
  us_presidents$start_year[44] == 2009L,
  summarize_leaders(uk_prime_ministers, "UK")$military_unknown == 46L,
  summarize_leaders(uk_prime_ministers, "UK")$military_no == 0L,
  as.character(service_status(NA_integer_)) == "Unknown"
)

old_us <- read.csv("data-raw/USPresMilExp.csv")
old_uk <- read.csv("data-raw/UKPMMilExp.csv")
first_presidencies <- old_us[!duplicated(old_us[[2]]), ]
stopifnot(
  identical(us_presidents$legacy_id[1:44], first_presidencies$ID),
  identical(uk_prime_ministers$legacy_id[1:74], old_uk$ID),
  sum(is.na(old_uk$Mil..Exp.)) == 59L,
  sum(first_presidencies$Mil..Exp.Dummy == 1L, na.rm = TRUE) == 28L,
  abs(sum(old_us$Years.Months.Of.Rule[
    which(old_us$Mil..Exp.Dummy == 1L)
  ], na.rm = TRUE) - 137) < 1e-6
)

for (column in c("term_id", "start_year", "military_experience", "military_source")) {
  broken <- us_presidents
  broken[[column]][1] <- NA
  stopifnot(inherits(try(validate_leaders(broken, as_of), silent = TRUE), "try-error"))
}
broken <- us_presidents
broken$term_id[2] <- broken$term_id[1]
stopifnot(inherits(try(validate_leaders(broken, as_of), silent = TRUE), "try-error"))
broken <- us_presidents
broken$military_experience[1] <- 2L
stopifnot(inherits(try(validate_leaders(broken, as_of), silent = TRUE), "try-error"))

for (leaders in list(us_presidents, uk_prime_ministers)) {
  plot <- plot_leaders(leaders, "Test roster", as_of)
  points <- ggplot2::ggplot_build(plot)$data[[1]]
  stopifnot(
    nrow(points) == nrow(leaders),
    !anyNA(points$x), !anyNA(points$y),
    sum(points$shape == 1L) == sum(is.na(leaders$military_experience))
  )
}
cat("Data and plot checks passed.\n")
