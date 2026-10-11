read_leaders <- function(path) {
  read.csv(
    path,
    colClasses = c(
      term_id = "integer", leader_id = "integer", name = "character",
      party = "character", start_year = "integer", end_year = "integer",
      military_experience = "integer", military_summary = "character",
      military_evidence = "character", military_source = "character",
      tenure_source = "character", legacy_id = "integer"
    ),
    na.strings = "", check.names = FALSE, fill = FALSE,
    stringsAsFactors = FALSE, fileEncoding = "UTF-8"
  )
}

read_snapshot <- function(path = "data/snapshot.csv") {
  snapshot <- read.csv(path, colClasses = "character")
  as_of <- as.Date(snapshot$as_of, format = "%Y-%m-%d")
  stopifnot(length(as_of) == 1L, !is.na(as_of))
  as_of
}

validate_leaders <- function(leaders, as_of) {
  required <- c(
    "term_id", "leader_id", "name", "party", "start_year", "end_year",
    "military_experience", "military_summary", "military_evidence",
    "military_source", "tenure_source", "legacy_id"
  )
  if (!identical(names(leaders), required)) {
    stop("Leader data must match the documented schema.")
  }
  if (nrow(leaders) == 0L) {
    stop("Leader data must not be empty.")
  }
  for (column in c("term_id", "leader_id", "name", "start_year")) {
    if (anyNA(leaders[[column]])) {
      stop("Missing required values in ", column, ".")
    }
  }
  if (anyDuplicated(leaders$term_id)) {
    stop("term_id must be unique.")
  }
  if (!identical(leaders$term_id, seq_len(nrow(leaders)))) {
    stop("Terms must be ordered and numbered consecutively.")
  }
  if (any(leaders$leader_id < 1L | leaders$leader_id > leaders$term_id)) {
    stop("leader_id must identify the first term of a leader.")
  }
  current_year <- as.integer(format(as_of, "%Y"))
  if (
    any(leaders$start_year > current_year) ||
      any(diff(leaders$start_year) < 0L) ||
      any(leaders$end_year < leaders$start_year, na.rm = TRUE) ||
      any(leaders$end_year > current_year, na.rm = TRUE)
  ) {
    stop("Invalid or unordered tenure years.")
  }
  if (!identical(which(is.na(leaders$end_year)), nrow(leaders))) {
    stop("Only the last term may have an open end year.")
  }
  if (any(head(leaders$end_year, -1L) != tail(leaders$start_year, -1L))) {
    stop("Successive tenure years must meet without gaps or overlaps.")
  }
  if (any(!is.na(leaders$military_experience) & !leaders$military_experience %in% c(0L, 1L))) {
    stop("Military experience must be 0, 1, or missing.")
  }
  if (
    anyNA(leaders$military_evidence) ||
      any(!leaders$military_evidence %in% c("sourced", "legacy", "unknown"))
  ) {
    stop("Unknown military evidence category.")
  }
  missing_service <- is.na(leaders$military_experience)
  if (any(missing_service != (leaders$military_evidence == "unknown"))) {
    stop("Missing service status must be explicitly marked unknown.")
  }
  known <- !is.na(leaders$military_experience)
  if (
    anyNA(leaders$tenure_source) ||
      any(!grepl("^https://", leaders$tenure_source)) ||
      anyNA(leaders$military_source[known]) ||
      any(!grepl("^https://", leaders$military_source[known]))
  ) {
    stop("Tenures and known service classifications require source URLs.")
  }
  groups <- split(leaders, leaders$leader_id)
  for (person in groups) {
    if (
      length(unique(person$name)) != 1L ||
        length(unique(person$military_experience)) != 1L ||
        person$leader_id[1L] != min(person$term_id)
    ) {
      stop("Returning leaders must retain their identity and service status.")
    }
  }
  invisible(leaders)
}

service_status <- function(experience) {
  labels <- ifelse(is.na(experience), "Unknown", ifelse(experience == 1L, "Yes", "No"))
  factor(labels, levels = c("Yes", "No", "Unknown"))
}

summarize_leaders <- function(leaders, country) {
  people <- leaders[!duplicated(leaders$leader_id), ]
  data.frame(
    country = country,
    periods_in_office = nrow(leaders),
    people = nrow(people),
    military_yes = sum(people$military_experience == 1L, na.rm = TRUE),
    military_no = sum(people$military_experience == 0L, na.rm = TRUE),
    military_unknown = sum(is.na(people$military_experience))
  )
}

plot_leaders <- function(leaders, title, as_of, period_breaks = c(1799L, 1899L)) {
  .data <- rlang::.data
  plot_data <- leaders
  plot_data$service <- service_status(plot_data$military_experience)
  plot_data$period <- cut(
    plot_data$start_year,
    breaks = c(-Inf, period_breaks, Inf),
    labels = c(
      paste("Before", period_breaks[1] + 1L),
      paste0(period_breaks[1] + 1L, "-", period_breaks[2]),
      paste(period_breaks[2] + 1L, "onward")
    )
  )
  plot_data$term_label <- paste0(plot_data$name, " (", plot_data$start_year, ")")
  plot_data$term_label <- factor(
    plot_data$term_label,
    levels = rev(plot_data$term_label)
  )

  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = .data$start_year, y = .data$term_label,
      colour = .data$service, shape = .data$service
    )
  ) +
    ggplot2::geom_point(size = 2.5, show.legend = TRUE) +
    ggplot2::facet_wrap(ggplot2::vars(.data$period), scales = "free", nrow = 1) +
    ggplot2::scale_colour_manual(
      values = c(Yes = "#007C83", No = "#B34B35", Unknown = "#777777"),
      drop = FALSE
    ) +
    ggplot2::scale_shape_manual(values = c(Yes = 16, No = 15, Unknown = 1), drop = FALSE) +
    ggplot2::scale_x_continuous(breaks = scales::breaks_pretty(n = 3)) +
    ggplot2::labs(
      title = title,
      subtitle = paste(
        "Military service before first taking office;",
        "each point is a continuous period in office"
      ),
      x = "Year of taking office", y = NULL,
      colour = "Military service", shape = "Military service",
      caption = paste0(
        "Roster checked ", as_of,
        ". Unknown is not no. Some classifications are inherited; see data sources.\n",
        "Regular forces, militia, reserves and National Guard included; ",
        "civilian defence roles excluded."
      )
    ) +
    ggplot2::theme_minimal(base_size = 10) +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_line(colour = "#EEEEEE", linewidth = 0.3),
      panel.grid.minor = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(size = 7),
      strip.text = ggplot2::element_text(face = "bold", hjust = 0),
      legend.position = "top",
      plot.title = ggplot2::element_text(face = "bold", size = 18),
      plot.caption = ggplot2::element_text(hjust = 0),
      panel.spacing = grid::unit(1, "cm")
    )
}
