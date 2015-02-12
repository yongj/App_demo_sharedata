library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Post Your Comments On Cloud!"),

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
