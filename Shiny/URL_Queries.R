library(shiny)
library(tidyverse)

head(mtcars)

cars <- mtcars %>% rownames_to_column(var = "car_types") %>% 
  mutate(cyl = as.factor(cyl),
         am = as.factor(am)) %>% 
  select(car_types, mpg, cyl, am, disp, wt)

summary(cars)

## UI

ui <- fluidPage(
  title = "Cars",
  
  sidebarPanel(
    selectInput(
      inputId = "cyl",
      label   = "Cylinders",
      choices = sort(unique(cars$cyl)),
      selected= NULL,
      multiple=FALSE
    ),
    selectInput(
      inputId = "am",
      label   = "Transmission",
      choices = sort(unique(cars$am)),
      selected= NULL,
      multiple=FALSE
    )
  ),
  mainPanel(
    plotOutput(outputId = "xy_plt"),
    plotOutput(outputId = "box_plt"),
    tableOutput(outputId = "tbl")
  )
)


## Server
server <- function(input, output, session){
  #Update based on URL parameters
  observe({
    query <- parseQueryString(session$ClientData$url_search)
    
    if(!is.null(query[['cyl']])){
      updateSelectInput(session, "cyl",selected = query[['cyl']])
    }
    if(!is.null(query[['am']])){
      updateSelectInput(session, "am",selected = query[['am']])
    }
    
  })
  
  ##get data
  dat <- reactive({
    cars %>% 
      filter(cyl == input$cyl,
             am  == input$am)
  })
  
  ##xy plot
  output$xy_plt <- renderPlot({
    dat() %>% 
      ggplot(aes(x = disp, y=mpg))+
      geom_jitter(size = 5,
                  color = "green") +
      geom_smooth(method = "lm",
                  se = FALSE,
                  color = "black",
                  size = 1.2) +
      theme_light()
  })
  
  ## box plot
  output$box_plt <- renderPlot({
    dat() %>%
      ggplot(aes(x = "1", y = wt)) +
      geom_boxplot(color = "black",
                   fill = "light grey") +
      theme_light()
  })
  
  ## Table output
  output$tbl <- renderTable({
    dat() %>% select(car_types)
  })
}

shiny_query <- shiny::shinyApp(ui = ui, server = server)

##run on port 5862 of my local computer ( 127.0.0.1 is the ipv4 address)
runApp(shiny_query, port = 5862, host = "127.0.0.1",launch.browser = TRUE)


# http://127.0.0.1:5862/?cyl=6 
# http://127.0.0.1:5862/?cyl=4 
# http://127.0.0.1:5862/?cyl=8  
# http://127.0.0.1:5862/?cyl=6&&am=1  













