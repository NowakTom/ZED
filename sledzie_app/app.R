library(RCurl)
library(shiny)

ui <- shinyUI(fluidPage(
  
   titlePanel("Analiza wartosci atrybutow"),
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("przedzialy",
                     "Liczba przedziałów:",
                     min = 1,
                     max = 100,
                     value = 30),
         uiOutput("choose_dataset")
         
      ),
      
      mainPanel(
         plotOutput("distPlot")
      )
   )
))

server <- shinyServer(function(input, output) {
  data <- read.csv(text=getURL("https://raw.githubusercontent.com/NowakTom/ZED/master/sledzie.csv"), na.strings = "?")
  data <- na.omit(data)
  
  output$choose_dataset <- renderUI({
    selectInput("dataset", "Data set", choices=c("X"=1, "length"=2, "cfin1" = 3, "cfin2" = 4, "chel1" = 5, "chel2" = 6, "lcop1" = 7, "lcop2" = 8, "fbar" = 9, "recr" = 10, "cumf" = 11, "totaln"=12,"sst"=13, "sal" = 14, "xmonth" =15,"nao"=16 ))
  })
  
   output$distPlot <- renderPlot({
     colm<-as.numeric(input$dataset)
      x    <- data[,colm]
      
      bins <- seq(min(x), max(x), length.out = input$przedzialy + 1)
      
      hist(x, breaks = bins, col = '#0087BD', border = 'black', main = "Histogram", xlab = names(data[colm]))
   })
})

shinyApp(ui = ui, server = server)

