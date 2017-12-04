
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

inputDefaults <- list( start = ymd("2017-08-01") )

shinyUI(fluidPage(

  # Application title
  titlePanel("Date interval"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      dateInput("start",
      					"Day",
      					min = ymd("2017-07-31"),
      					max = ymd("2017-08-31"),
      					value = inputDefaults$start)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("distPlot")
    )
  )
))
