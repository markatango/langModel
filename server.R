if(.Platform$OS.type == "unix") {
  source("rSource/startup.R",echo=TRUE, verbose=FALSE)
} else {
  source("rSource\\startup.R",echo=TRUE, verbose=FALSE)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  s1 <- reactive({predictFromTextSmall(input$text)})
  lens <- reactive({length(s1()$tdl)})
  output$lens <- renderText(lens())
  
#   s2 <- reactive({ mostLikelyNWords(5,paste(input$text,s1()$uSAD[1]))})
#   output$nxt <- renderText(s2())
  
  
  include <- reactive({  sapply(1:lens(), function(i) { sum(is.na(s1()$tdl[[i]])*1)==0 })  })
  wordList <- reactive({s1()$tdl})
  
  wordListLengths <- reactive({sapply(wordList(),length)})
  wordList <- reactive({s1()$tdl[include()]})

  mins <- reactive({ sapply(wordListLengths(),function(w) min(10, max(w,1)))})
  output$doc1 <- renderText(docNames[1])
  output$doc2 <- renderText(docNames[2])
  output$doc3 <- renderText(docNames[3])
  
#   output$e1 <- renderText(exists("include()[1]")*1)
#   output$e2 <- renderText(exists("include()[2]")*1)
#   output$e3 <- renderText(exists("include()[3]")*1)
# #   
#   output$i1 <- renderText(include()[1]*1)
#   output$i2 <- renderText(include()[2]*1)
#   output$i3 <- renderText(include()[3]*1)
#   

  output$wordList1 <- reactive({if(include()[1]) {paste(wordList()[[1]][1:mins()[1]], sep=" ")} else {""}})
  output$wordList2 <- reactive({if(include()[2]) {paste(wordList()[[2]][1:mins()[2]], sep=" ")} else {""}})
  output$wordList3 <- reactive({if(include()[3]) {paste(wordList()[[3]][1:mins()[3]], sep=" ")} else {""}})
  
  output$totNum <- renderText(s1()$totalNumPred)
  
  output$plot <- renderPlot({ plotAll(s1()$adNgrams) })
  output$results <- renderText({ s1()$uSAD[1:min(length(s1()$uSAD), RPTLEN)] })
  

})


