#' Plot method for multicollinearity checks
#'
#' The \code{plot()} method for the \code{performance::check_collinearity()} function.
#'
#' @inheritParams data_plot
#' @inheritParams plot.see_check_normality
#'
#' @return A ggplot2-object.
#'
#' @examples
#' library(performance)
#' m <- lm(mpg ~ wt + cyl + gear + disp, data = mtcars)
#' result <- check_collinearity(m)
#' result
#' plot(result)
#' @importFrom rlang .data
#' @export
plot.see_check_collinearity <- function(x, data = NULL, colors = c("#3aaf85", "#1b6ca8", "#cd201f"), ...) {
  if (is.null(data)) {
    dat <- .compact_list(.retrieve_data(x))
  } else {
    dat <- data
  }

  if (is.null(dat)) {
    return(NULL)
  }

  dat$group <- "low"
  dat$group[dat$VIF >= 5 & dat$VIF < 10] <- "moderate"
  dat$group[dat$VIF >= 10] <- "high"

  if (ncol(dat) == 5) {
    colnames(dat) <- c("x", "y", "se", "facet", "group")
    dat[, c("x", "y", "facet", "group")]
  } else {
    colnames(dat) <- c("x", "y", "se", "group")
    dat[, c("x", "y", "group")]
  }

  if (length(unique(dat$facet)) == 1) {
    dat <- dat[, -which(colnames(dat) == "facet")]
  }

  .plot_diag_vif(dat, colors = colors)
}
