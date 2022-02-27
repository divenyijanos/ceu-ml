function(input, output) {

    values <- reactiveValues(
        data = generate_data(default_n, default_sd),
        n_run = numeric(),
        errors = tibble(
            n = character(), sd = character(),
            `k=1` = numeric(), `k=5` = numeric()
        )
    )

    output$xy_plot <- renderPlot({
        x <- seq(0, 1, 0.01)
        plot <- ggplot(tibble(x = x, y = f_y_x(x)), aes(x, y)) +
            geom_point(data = values$data, size = 3, alpha = 0.5) +
            geom_line(size = 1.5, linetype = "dashed") +
            labs(col = 'Degree of the estimated polynomial') +
            coord_cartesian(ylim = c(-1, 4)) +
            theme(legend.position = "top")
        if (!is.null(errors())) {
            plot <- plot +
                geom_vline(xintercept = x0, linetype = "dotted") +
                geom_line(
                    aes(col = "1", y = predict(linear_model(values$data), tibble(x = x))),
                    size = 1.5
                ) +
                geom_line(
                    aes(col = "5", y = predict(quintic_model(values$data), tibble(x = x))),
                    size = 1.5
                )
        }
        plot
    })
    
    observeEvent(input$run, values$n_run <- 1)
    observeEvent(input$run100, values$n_run <- 100)
    
    observeEvent(c(input$run, input$run100), {
        message("some of the buttons were clicked")
        message(paste("value of run:", input$run))
        message(paste("value of run100:", input$run100))
        for (i in 1:values$n_run) {
            values$data <- generate_data(input$n, as.numeric(input$error_sd))
            errors_so_far <- values$errors
            values$errors <- add_row(
                errors_so_far,
                n = input$n,
                sd = input$error_sd,
                `k=1` = f_y_x(x0) - predict(linear_model(values$data), tibble(x = x0)),
                `k=5` = f_y_x(x0) - predict(quintic_model(values$data), tibble(x = x0))
            )
            message(paste("number of calculated errors:", nrow(values$errors)))
        }
    }, ignoreInit = TRUE)

    errors <- reactive({
        if (nrow(values$errors) == 0) {
            return(NULL)
        } else {
            return(values$errors)
        }
    })

    output$error_plot <- renderPlot({
        req(errors())
        data_to_plot <- pivot_longer(errors(), !n:sd)
        mse <- summarize(group_by(data_to_plot, name, n, sd), MSE = calculate_mse(value))
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

}