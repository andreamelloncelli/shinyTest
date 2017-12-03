
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
	
	message("START shinyServer")
	
	data_collected <- reactive({
		
		message("data collection...")
		
		from <- as_datetime(ymd("2017-08-30"))
		to   <- as_datetime(ymd("2017-08-31"))
		historydata_int <- 
			data_get(historydata, from, to)
		historydata_int
		
	})
	
	output$distPlot <- renderPlot({

		data_collected <- function() historydata_int
		
		message("Rendering plot...")

		ggplot(data_collected(), aes(x = time, y = value)) +
			geom_line() 
			# scale_y_log10()

  })

	message("END shinyServer")
	
})
