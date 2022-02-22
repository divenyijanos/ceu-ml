fluidPage(
    shinyjs::useShinyjs(),
    titlePanel("Bias-Variance trade-off"),

    sidebarLayout(
        sidebarPanel(width = 3,
            radioButtons("n", "Number of observations", choices = c(100, 1000), selected = 100),
            radioButtons("error_sd", "Standard deviation of noise", choices = c(0.5, 1, 5), selected = 0.5),
            actionButton("run", "Simulate"),
            actionButton("run100", "Simulate 100x")
        ),
        mainPanel(width = 9,
            plotOutput("xy_plot", height = 370),
            plotOutput("error_plot", height = 370)
        )
    )
)