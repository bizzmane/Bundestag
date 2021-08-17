library(shiny)
library(ggplot2)
library(plotly)
library(data.table)

source('mappings.R')


ui <- fluidPage(
  
  # Application title
  titlePanel("Bundestag 19 Abstimmungsergebnisse"),
  fluidRow(column(12,HTML(DESC["intro"]))),
  tags$hr(style="border-color: gray;"),
  fluidRow(
    column(7, plotlyOutput("plot_absentee_votes")),
    column(1),
    column(4,
           HTML(
             DESC["plot_absentee_votes"]
           ))
  ),
  tags$hr(style="border-color: gray;"),
  fluidRow(h2("  Parteiliche Einigkeit innerhalb der Abstimmungen")),
  br(),
  fluidRow(
    column(2,
           HTML(
             DESC["plot_variance_within1"]
           )),   
    #column(1),
    column(5, plotlyOutput("plot_variance_within")),
    column(5, HTML(DESC["plot_variance_within2"]))
  ),
  tags$hr(style="border-color: gray;"),
  fluidRow(
    column(7, plotlyOutput("plot_member_varience")),
    column(1),
    column(4,
           HTML(
             DESC["plot_member_varience"]
           ))
  ),
  tags$hr(style="border-color: gray;"),
  fluidRow(
    column(4,            
           fluidRow(column(12, htmlOutput("pca_description"))),
           br(),
           fluidRow(
             column(12, selectInput(inputId = "pca_plot_type",
                                    label = "PCA Plot Typ",
                                    choices = c("2D", "Erklärte Varianz", "3D"),
                                    selected = "2D")))),
    column(1),
    column(7, plotlyOutput("plot_PCA"))
  ),
  tags$hr(style="border-color: gray;"),
  fluidRow(h2(" Alle Abstimmungsergebnisse in einer Tabelle")),
  br(),
  fluidRow(
    column(12, dataTableOutput('table'))
  )
)