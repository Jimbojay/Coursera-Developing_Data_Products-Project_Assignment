#Load shiny
library(devtools)
library(shiny)
data(mtcars)

#Setup linear regression model
Reg_model <- lm(mpg ~ hp + cyl + wt, data=mtcars)

#Setup prediction function based on the regression model
mpg <- function(hp, cyl, wt) {
        Reg_model$coefficients[1] + 
        Reg_model$coefficients[2] * hp +
        Reg_model$coefficients[3] * cyl + 
        Reg_model$coefficients[4] * wt
}



#Setup Shiny Server
shinyServer(
        function(input, output) {
                
                output$myList <- renderUI(HTML("<ol><li>Gross Horsepower</li><li>Number of Cylinders</li><li>Weight in lbs. </oi></ul>"))
                
                #Produce overview of input-values
                output$inputValues <- renderPrint({
                        paste(input$hp, "horsepower, ",
                              input$cyl, "cylinders, ",
                              input$wt, "lbs")
                })
                
                #Convert input weight to the format as used by the regression model
                weight <- reactive({input$wt/1000})
                
                #Perform predicion based on input-values
                Mpg_prediction <- reactive({
                        mpg(
                        input$hp,
                        as.numeric(input$cyl), 
                        weight()
                        )
                })
    
                
                #Store prediction outome into a variable
                output$prediction <- renderPrint({paste(round(Mpg_prediction(), 2), "miles per gallon")})
                
                #Create plots of variables in the regression model vs. Mpg
                output$plots <- renderPlot({
                        par(mfrow = c(1, 3))
                        # (1, 1)
                        
                        with(mtcars, plot(cyl, mpg,
                                          xlab='# of cylinders',
                                          ylab='MPG',
                                          main='MPG vs # of cylinders'))
                        points(as.numeric(input$cyl), Mpg_prediction(), col='red', cex=3)
                        
                        # (1, 2)
                        with(mtcars, plot(hp, mpg,
                                          xlab='Gross horsepower',
                                          ylab='MPG',
                                          main='MPG vs horsepower'))
                        points(input$hp, Mpg_prediction(), col='red', cex=3)
                        
                        
                        
                        # (1, 3)
                        with(mtcars, plot(wt, mpg,
                                          xlab='Weight (lb/1000)',
                                          ylab='MPG',
                                          main='MPG vs weight'))
                        points(weight(), Mpg_prediction(), col='red', cex=3)  
                })
        }
        
)