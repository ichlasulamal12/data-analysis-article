function(input, output) {
    output$plot_ranking <- renderPlotly({
        data_vis1 <- workers_clean %>% 
            mutate(gap_earnings = total_earnings_male-total_earnings_female) %>% 
            filter(year == input$tahun) %>% 
            group_by(major_category) %>% 
            summarise(gap_earnings = mean(gap_earnings))
        
        m <- list(t = 50,
                  b = 50,
                  l = 50,
                  r = 50,
                  pad = 20)
        
        plot <- data_vis1 %>% 
            ggplot(aes(x = gap_earnings, 
                       y = reorder(major_category, gap_earnings),
                       text = glue("{major_category}
                         Gap Earnings: {round(gap_earnings,2)}"))) +
            geom_col(fill = "dodgerblue4") +
            geom_col(data = filter(data_vis1, major_category == "Computer, Engineering, and Science"), fill = "firebrick") +
            labs( x = NULL,
                  y = NULL,
                  title = "Gap Earnings on Male and Female 2016") +
            scale_y_discrete(labels = wrap_format(30)) + #title tdk terlalu panjang
            # menambahkan dollar symbol
            scale_x_continuous(labels = dollar_format(prefix = "$")) +
            theme_algoritma
        
        ggplotly(plot, tooltip = "text") %>% 
            layout(margin = m)
    })
    
    output$plot_corr <- renderPlotly({
        
        pilih <- input$num %>% 
            str_to_lower() %>% 
            str_replace_all(pattern = " ", replacement = "_")
        
        workers_clean <- workers_clean %>% 
            filter(year == input$tahun)
        
        plot2 <- workers_clean %>% 
            ggplot(aes(x = total_earnings_male, 
                       y = workers_clean[,pilih], 
                       col = major_category,
                       text = glue("{str_to_upper(major_category)}
                         Earnings Male: {total_earnings_male}
                         Earnings Female: {total_earnings_female}"))) +
            geom_jitter() +
            labs(y = glue("{input$num}"),
                 x = "Total Earnings Male",
                 title = "Correlation Plot of Total Earnings Male and Female") +
            scale_color_brewer(palette = "Set3") +
            theme_algoritma +
            theme(legend.position = "none")
        
        ggplotly(plot2, tooltip = "text")
    })
    
    output$dat <- renderDataTable({
        datatable(workers_clean, options = list(scrollX = T))
    })
}