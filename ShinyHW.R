#I had to do this on my roommate's computer and couldnt get github to work on that machine
#sorry for the lack of commits
ui <- fluidPage(
  
  # App title
  titlePanel("Presidential Forecasts"),
  
# Sidebar layout and the inputs and outputs
sidebarLayout(
    
# Sidebar panel for the inputs
sidebarPanel(
      
      
# Clarifying Text
      helpText("These are the results of presidential forecasts from various models, 1952-2008"),
      
# Take in forecast model to plot with acutal results ----
      selectInput("variable", "Forecast model:",
                  c("Campbell","Lewis-Beck","EWT2C2","Fair","Hibbs","Abramowitz"))
      
    ),
    
# Main panel that displays outputs
    mainPanel(
      
# Outputs a table with observations
      tableOutput("view"),
      
# Outputs the plots of the election results
      plotOutput("plot", click = "plot_click"),
      verbatimTextOutput("info")
    )
  )
)

# Get the surver logic to summarize the table
server <- function(input, output) {
  
  library(EBMAforecast)
  data("presidentialForecast")
  
  # Show the chosen number of observations
  output$view <- renderTable({
    presidentialForecast
  })
  
  # Plot the actual results
  output$plot <- renderPlot({
    plot(as.numeric(row.names(presidentialForecast)), presidentialForecast$Actual,
         xlab = "Year", ylab = "Voting Percentage", col = "green", main = "Voting Percentage by Year")
    if (input$variable == "Campbell"){
      points(as.numeric(row.names(presidentialForecast)), presidentialForecast$Campbell, col = "blue")
    } else if (input$variable == "Lewis-Beck"){
      points(as.numeric(row.names(presidentialForecast)), presidentialForecast$`Lewis-Beck`, col = "blue")
    } else if (input$variable == "EWT2C2"){
      points(as.numeric(row.names(presidentialForecast)), presidentialForecast$EWT2C2, col = "blue")
    } else if (input$variable == "Fair"){
      points(as.numeric(row.names(presidentialForecast)), presidentialForecast$Fair, col = "blue")
    } else if (input$variable == "Hibbs"){
      points(as.numeric(row.names(presidentialForecast)), presidentialForecast$Hibbs, col = "blue")
    } else {
      points(as.numeric(row.names(presidentialForecast)), presidentialForecast$Abramowitz, col = "blue")
    }
  })
  
  # output from click inputs
  output$info <- renderText({
    paste0("Year =", input$plot_click$x, "Voting Percentage =", input$plot_click$y)
  })
  
}

# hopefully this works
shinyApp(ui = ui, server = server)