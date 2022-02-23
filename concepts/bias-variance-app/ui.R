fluidPage(
    shinyjs::useShinyjs(),
    titlePanel("Bias-Variance trade-off"),

    sidebarLayout(
        sidebarPanel(width = 3,
            withMathJax("Our true model is $$Y = \\beta_1 X^5 + \\beta_2 X^4 + ... + \\beta_5 X + \\varepsilon$$"),
            withMathJax("where $$\\varepsilon \\sim \\mathcal{N}(0, \\sigma)$$"),
            br(),
            HTML("We estimate two polynoms to predict <I>Y</I>: one of degree 5 (true model) and one of degree 1 (simple linear)."),
            br(),
            br(),
            radioButtons("n", "Number of observations", choices = c(100, 1000), selected = default_n),
            radioButtons("error_sd", withMathJax("Standard deviation of noise (sigma)"), choices = c(0.5, 1, 5), selected = default_sd),
            actionButton("run", "Simulate"),
            actionButton("run100", "Simulate 100x")
        ),
        mainPanel(width = 9,
            plotOutput("xy_plot", height = 370),
            plotOutput("error_plot", height = 370)
        )
    )
)