library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    titlePanel("Text prediction"),
    plotOutput('plot'),
    fluidRow(
      column(4,h4("Total number of predicted words"),
             textOutput("totNum")
             )
    ),
    br(),
    
    fluidRow(
      column(4,h4("Document file name"),
             textOutput("doc1"),
             textOutput("doc2"),
             textOutput("doc3")
             ),
      
      column(6,h4("Predictions from individual documents"),
             textOutput("wordList1"),
             textOutput("wordList2"),
             textOutput("wordList3")
             )
    ),
    br(),
    
    fluidRow(
      column(6,h4("Top results from all texts combined"),
             textOutput("results")
             )
    ),
    br(),
    
    fluidRow(
      column(6,h4("Input text"),
             textInput("text",
                       label="Enter begining text",
                       value="Type something...")
             )
#       column(6,h4("Next random words"),
#              textOutput("nxt")
#       )
   )
  )
)