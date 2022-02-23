library(tibble)
library(tidyr)
library(dplyr)
library(ggplot2)
library(shinyjs)
theme_set(theme_bw(base_size = 16))

f_y_x <- function(x) {
    8 * x^5 - x^4 - 10 * x^3 - 0.5 * x^2 + 4 * x
}

default_n <- 100
default_sd <- 0.5
x0 <- 0.75

generate_data <- function(n, sd) {
    x <- runif(n)
    tibble(x = x, y = f_y_x(x) + rnorm(n, sd = sd))
}

calculate_mse <- function(x) {
    mean(x)^2 + var(x)
}