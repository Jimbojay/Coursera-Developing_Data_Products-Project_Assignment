library(shiny)



shinyUI(pageWithSidebar(
        headerPanel('Coursera - Developing Data Products - Course Project'),
        sidebarPanel(
                h3('Instructions'),
                'This application predicts the average miles per gallon based on the following input:',
                br(),
                br(uiOutput("myList")),            
                h4('Please enter the inputs below:'),
                numericInput('hp', 'Gross horsepower:', 150, min = 55, max = 335, step = 5), # example of numeric input                
                radioButtons('cyl', 'Number of cylinders:', c('4' = 4, '6' = 6, '8' = 8), selected = '6'), # example of radio button input
                numericInput('wt', 'Weight (lbs):', 3300, min = 1500, max = 5500, step = 100)
        ),
        mainPanel(
                h6('Course Project by Imre Dekker'),
                h3('Predicted MPG'),
                h4('Entered values:'),
                verbatimTextOutput("inputValues"),
                h4('Prediction based on inputs'),
                verbatimTextOutput("prediction"),
                h4('MPG relative to input values'),
                plotOutput('plots')
                
        )
))