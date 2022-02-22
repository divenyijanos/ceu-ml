library(tidyverse)
theme_set(theme_bw(base_size = 16))


f_y_x <- function(x) {
    8 * x^5 - x^4 - 10 * x^3 - 0.5 * x^2 + 4 * x
}

x0 <- 0.75