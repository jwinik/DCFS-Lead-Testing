library(DT)
library(shiny)
library(ggplot2)

setwd("C:/Users/jwini/OneDrive/Documents/Python Scripts/DCFS-Lead-Testing/Facility Lookup")

lead <- read.csv("DCFS_clean_8_27.csv")
lead_zip <- read.csv("DCFS_county_8_27.csv")
lead_county <- read.csv("DCFS_zip_8_27.csv")


ui <- fluidPage(
  title = "Examples of DataTables",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "lead"',
        checkboxGroupInput("show_vars", "Columns in Lead to show:",
                           names(lead), selected = names(lead))
      ),
      conditionalPanel(
        'input.dataset === "mtcars"',
        helpText("Click the column header to sort a column.")
      ),
      conditionalPanel(
        'input.dataset === "iris"',
        helpText("Display 5 records by default.")
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("lead", DT::dataTableOutput("mytable1")),
        tabPanel("lead zip", DT::dataTableOutput("mytable2")),
        tabPanel("lead county", DT::dataTableOutput("mytable3"))
      )
    )
  )
)

server <- function(input, output) {
  
  # choose columns to display
  lead2 = lead[sample(nrow(lead), 1000), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(lead2[, input$show_vars, drop = FALSE])
  })
  
  # sorted columns are colored now because CSS are attached to them
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(mtcars, options = list(orderClasses = TRUE))
  })
  
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(iris, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  
}

shinyApp(ui, server)