fluidPage(
    shinyjs::useShinyjs(),
    titlePanel("Bias-Variance trade-off"),

    sidebarLayout(
        sidebarPanel(
            withMathJax("Our true model is $$Y = \\beta_1 X^5 + \\beta_2 X^4 + ... + \\beta_5 X + \\varepsilon$$"),
            withMathJax("where $$\\varepsilon \\sim \\mathcal{N}(0, \\sigma)$$"),
            br(),
            HTML("We estimate two polynomials to predict <I>Y</I>:
                 one of degree 5 (true model) and one of degree 1 (simple linear)."),
            br(),
            br(),
            HTML("We evaluate our estimators on a new data point: <I>X=0.75</I>.
                 The resulting errors are shown as dots on a second plot.
                 Thick line segments depict their averages (the bias).
                 The calculated MSE values are added as labels."),
            br(),
            br(),
            radioButtons("n", "Number of observations", choices = c(100, 1000), selected = default_n),
            radioButtons("error_sd", withMathJax("Standard deviation of noise (sigma)"), choices = c(0.5, 5), selected = default_sd),
            actionButton("run", "Simulate"),
            actionButton("run100", "Simulate 100x"),
            br(),
            hr(style = "border-top: 1px solid #909090;"),
            HTML("<B>Lesson:</B> You can realize that estimating the wrong model might result in a better predictor
                 than estimating the true one if the noise is relatively large (few observations, large variance of noise). 
                 This is because the wrong model is a simpler one
                 that is easier to estimate, so its prediction variance is going to be much smaller. 
                 This could compensate for not being able to predict the true value on average (bias).")
        ),
        mainPanel(
            plotOutput("xy_plot", height = 370),
            plotOutput("error_plot", height = 370)
        )
    )
)