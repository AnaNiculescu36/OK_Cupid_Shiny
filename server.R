source("data_management.R")
source("plots_by_sex.R")
shinyServer(function(input, output, session) {
    # Define a reactive expression for the document term matrix
    terms <- reactive({
        # Change when the "update" button is pressed...
        input$update
        # ...but not for anything else
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                getTermMatrix(input$selection)
            })
        })
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    bar_plot_reactive <- reactive({
        create_bar_count_plot(cupid_data, input$over_bar_x, "count",
                              input$over_exclude_na)
    })
    
    density_plot_reactive <- reactive({
        create_density_plot(cupid_data, input$density_x, "age",
                              input$density_exclude_na)
    })
    
    stack_plot_reactive <- reactive({
        create_stacked_bar_plot(cupid_data, input$stack_x, input$stack_y,
                                input$exclude_na)
    })
    
    gender_plot_reactive <- reactive({
        if (input$select_plot == "gender distribution") {
           sex_dist
        } else if (input$select_plot == "gender density") {
            dens

        } else if (input$select_plot == "number of people by age") {
            age_graph
        } else if (input$select_plot == "proportion of gender by age") {
            proportion_age
        } else if (input$select_plot == "mosaic plot") {
            mosaic_plot
        } else if (input$select_plot == "ethnicity by gender") {
            gender_ethnicity
        } else if (input$select_plot == "status by gender") {
            gender_status
        }
    })
    
    output$wordcloud <- renderPlot({
        v <- terms()
        wordcloud_rep(names(v), v, scale = c(5, 1),
                      min.freq = input$freq, max.words = input$max,
                      colors = brewer.pal(9, "RdBu")[-c(5, 6, 7)],
                      rot.per = 0.35)
    })

    output$stack_plot <- renderPlot({
        stack_plot_reactive()
    })
    
    output$bar_plot <- renderPlot({
        bar_plot_reactive()
    })
    
    output$density_plot <- renderPlot({
        density_plot_reactive()
    })
    
    output$gender_plot <- renderPlot({
      gender_plot_reactive()  
    })
   
})

