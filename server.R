
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output) {
	
	message("START shinyServer")
	
	data_collected <- reactive({
		
		message("data collection...")
		
		from <- as_datetime(input$start)
		to   <- as_datetime(input$start + days(1))
		historydata_int <- 
			data_get(historydata, from, to)
		historydata_int
		
	})
	
# 	output$distPlot <- renderPlot({
# 
# 		message("Rendering plot...")
# 
# 		ggplot(data_collected(), aes(x = time, y = value)) +
# 			geom_line() 
# 			# scale_y_log10()
# 
# 				fake_plot
# 
#   })
# 	
	output$distPlot <- renderPlotly({
		# data_collected <- function() historydata_int
		plot_ly(data_collected() , x = ~time, y = ~value, name = 'trace 0', type = 'scatter', mode = 'lines')
	})

	message("END shinyServer")
	
})
