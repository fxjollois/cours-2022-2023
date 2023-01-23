library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(ggplot2)

resume = txhousing %>% 
  group_by(city) %>% 
  summarise(volume = sum(volume, na.rm = T), 
            median = median(median, na.rm = T))

ui = dashboardPage(
  dashboardHeader(title = "Test DT"),
  dashboardSidebar(),
  dashboardBody(
    dataTableOutput("tableau"),
    plotOutput("graphique")
  ),
  title = "Test DT",
  skin = "yellow"
)

server = function(input, output) {
  output$tableau <- renderDataTable({
    datatable(resume)
  })
  
  output$graphique <- renderPlot({
    df = resume %>%
      mutate(affiche = ifelse(row_number() %in% input$tableau_rows_current, "oui", "non"),
             selection = ifelse(row_number() %in% input$tableau_rows_selected, "oui", "non"))
    ggplot(df, aes(median, volume, label = city, color = affiche, size = selection)) +
      geom_point() +
      theme_classic()
  })
}

shinyApp(ui, server)