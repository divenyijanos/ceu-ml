function(input, output) {

    values <- reactiveValues(
        errors = tibble(
            n = character(), sd = character(),
            `k=1` = numeric(), `k=5` = numeric()
        )
    )

    data <- eventReactive(input$run, {
        generate_data(input$n, as.numeric(input$error_sd))
    })

    linear_model <- reactive({
        lm(y ~ x, data())
    })

    quintic_model <- reactive({
        lm(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5), data())
    })

    output$xy_plot <- renderPlot({
        x <- seq(0, 1, 0.01)
        ggplot(
            tibble(x = x, y = f_y_x(x)),
            aes(x, y)
        ) +
            geom_point(data = data(), size = 3, alpha = 0.5) +
            geom_line(size = 1.5, linetype = "dashed") +
            geom_line(
                aes(col = "1", y = predict(linear_model(), tibble(x = x))),
                size = 1.5
            ) +
            geom_line(
                aes(col = "2", y = predict(quintic_model(), tibble(x = x))),
                size = 1.5
            ) +
            geom_vline(xintercept = x0, linetype = "dotted") +
            labs(col = 'Degree of the estimated polynomial') +
            coord_cartesian(ylim = c(-1, 4)) +
            theme(legend.position = "bottom")
    })



    observeEvent(input$run, {
        errors_so_far <- values$errors
        values$errors <- add_row(
            errors_so_far,
            n = input$n,
            sd = input$error_sd,
            `k=1` = f_y_x(x0) - predict(linear_model(), tibble(x = x0)),
            `k=5` = f_y_x(x0) - predict(quintic_model(), tibble(x = x0))
        )
    })

    errors <- reactive({
        if (nrow(values$errors) == 0) {
            return(NULL)
        } else {
            return(values$errors)
        }
    })

    mse <- function(x) {mean(x)^2 + var(x)}

    output$error_plot <- renderPlot({
        req(errors())
        data_to_plot <- pivot_longer(errors(), !n:sd)
        mse <- summarize(group_by(data_to_plot, name, n, sd), MSE = mse(value))
        plot <- ggplot(data_to_plot, aes(name, value, col = name)) +
            stat_summary(fun = mean, geom = "point", shape = "-", size = 30) +
            geom_point(size = 3, alpha = 0.5) +
            geom_hline(yintercept = 0, linetype = "dotted") +
            facet_grid(n ~ sd, labeller = label_both, scale = "free") +
            labs(x = "Model", y = "Error") +
            theme(legend.position = "none")
        if (nrow(errors()) > 1) {
            plot <- plot + geom_label(
                aes(y = 2, label = paste0("MSE=", round(MSE, 2))),
                data = mse
            )
        }
        plot
    })

    observeEvent(input$run100, {
        for (i in seq(100)) {
            shinyjs::click("run")
        }
    })

}