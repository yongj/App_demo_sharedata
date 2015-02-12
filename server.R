library(shiny)


# Use the RAmazonS3 Package for S3 interactions: http://www.omegahat.org/RAmazonS3/
# Not availalbe on CRAN, but can be installed from OmegaHat:
#   install.packages("RAmazonS3", repos = "http://www.omegahat.org/R")
library(RAmazonS3)

# Retrieve log from S3. This file if public, so anyone can read this whether
# or not they're authorized with their S3 account.
log <- getFile("youngjohn-test-bucket", "log1.txt")

shinyServer(function(input, output, session) {
  
  # Format the log to include the existing log + all comments
  logText <- reactive({
    if (is.null(input$name) || input$name == ""){
      # There's nothing new to update here, just return the existing log.
      return(log)
    }
    
    # Format the new entry
    newEntry <- paste0(input$name, ": ", input$comment, "\r\n")
    log <<- paste0(log, newEntry)
    
    # Save the file back to S3. Note that you'll need to have your AWS credentials
    # configured in options("AmazonS3") and be using a bucket on which you have write
    # permissions (i.e. not `rstudio-public`) in order to be able to write.
    addFile(I(log), "youngjohn-test-bucket", "log1.txt")
    
    return(log)
  })  
  
  # Render the output log
  output$log <- renderText({
    txt <- logText()
    
    # Clear out the current value
    updateTextInput(session, "name", value="")
    updateTextInput(session, "comment", value="")
    
    txt
  })
  
  output$readonly <- renderUI({
    if (is.null(options("AmazonS3")[[1]])){
      return(HTML("<hr><strong>Warning:</strong> It looks like you don't have write access to the bucket you're trying to use. You'd need to configure the application to use your own S3 bucket and access keys before you can write to S3. See <a href=\"http://www.omegahat.org/RAmazonS3/s3amazon.html\">the documentation.</a>"))
    }
  })
  
})
