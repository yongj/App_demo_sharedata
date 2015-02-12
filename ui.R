library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Demonstration of file persistence in Shiny"),

  # Define the side-panel
  sidebarLayout(
    sidebarPanel(
      textInput("name", "Name:"),
      textInput("comment", "Comment:"),
      submitButton("Comment"),
      uiOutput("readonly")
    ),

    mainPanel(
      verbatimTextOutput("log")
    )
  )
))
