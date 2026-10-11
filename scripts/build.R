source("R/military_experience.R")

as_of <- read_snapshot()
us_presidents <- read_leaders("data/us_presidents.csv")
uk_prime_ministers <- read_leaders("data/uk_prime_ministers.csv")
validate_leaders(us_presidents, as_of)
validate_leaders(uk_prime_ministers, as_of)
dir.create("figures", showWarnings = FALSE)

for (country in c("us", "uk")) {
  leaders <- if (country == "us") us_presidents else uk_prime_ministers
  title <- if (country == "us") "US presidents" else "UK prime ministers"
  period_breaks <- if (country == "us") c(1849L, 1949L) else c(1799L, 1899L)
  plot <- plot_leaders(leaders, title, as_of, period_breaks)
  ggplot2::ggsave(
    file.path("figures", paste0(country, "_military_experience.png")),
    plot = plot, width = 21, height = 11, dpi = 150, bg = "white"
  )
}
knitr::knit("README.Rmd", output = "README.md", quiet = TRUE)
