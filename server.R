library(shiny)
library(ggplot2)
library(plotly)
library(data.table)

source('mappings.R')
source('helpers.R')

VotingData         = readRDS("./r_data/voting_data.RDS")
AbsenteeVotes      = readRDS("./r_data/absentee_vote_dt.RDS")
OutlierDT          = readRDS("./r_data/absentee_outlier_dt.RDS")
AbsVariance        = readRDS("./r_data/party_variance_dt.RDS")
MemberVarianceAggr = readRDS("./r_data/member_variance_dt.RDS")
VarianceExplained  = readRDS("./r_data/pca_variances.RDS")
PCA_for_Plot2d     = readRDS("./r_data/pca_2d_dt.RDS")
PCA_for_Plot3d     = readRDS("./r_data/pca_3d_dt.RDS")


server <- function(input, output) { 
  
  output$plot_absentee_votes <- renderPlotly({
    plot_ly(OutlierDT, y=~AbsentSum, 
            colors = get_color_palette(unique(OutlierDT$Party)),
            x=~Member, type = "bar", color= ~Party) %>% 
      layout(xaxis=list(title=FALSE))
  })  
  
  output$plot_variance_within <- renderPlotly({
    plot_ly(AbsVariance, y = ~Variance, color = ~Party, 
            colors = get_color_palette(unique(AbsVariance$Party)),
            type = "box", text = ~VotingMatter) # %>%
      # layout(title = 'Variance within votings by party')
  })  
  
  output$plot_member_varience <- renderPlotly({
    plot_ly(MemberVarianceAggr, y = ~MeanVotingDifference, color = ~Party, 
            colors = get_color_palette(unique(MemberVarianceAggr$Party)),
            type = "box", text=~Member) # %>%
      # layout(title = 'Mean vote difference of party members')  
  })
  
    
  output$table <- renderDataTable(VotingData[,c(-1,-2)], 
                                  options = list(pageLength = 10))
  
  output$plot_PCA <- renderPlotly({
    if (input$pca_plot_type == "2D"){
      plot = plot_ly(PCA_for_Plot2d, x = ~x, y = ~y, color = ~color, 
                     colors = COLOR_PAL, type = "scatter", mode = "markers", 
                     text = ~text, hovertemplate = paste('%{text}'),
                     opacity= 0.7, marker =list(size = 12))  %>% 
        layout(xaxis=list(title=FALSE), yaxis=list(title=FALSE))
    }
    else if(input$pca_plot_type == "3D"){
      plot = plot_ly(PCA_for_Plot3d, x = ~x, y = ~y, z = ~z, color = ~color, 
                     colors = COLOR_PAL, text = ~text, 
                     hovertemplate = paste('%{text}'), type = "scatter3d", 
                     mode = "markers", opacity= 0.7, marker =list(size = 12)) %>% 
        layout(xaxis=list(title=FALSE), yaxis=list(title=FALSE))
    }
    else{
      plot = plot_ly(VarianceExplained[1:10], 
                     y=~`Explained Variance`, 
                     x=~Component, type = "bar") %>% 
        layout(xaxis=list(title=FALSE))
    }
    plot
  })
  
  output$pca_description <- renderUI({
    if (input$pca_plot_type == "2D"){
      text = HTML(
        DESC["plot_PCA_2D"]
      )
    }
    else if(input$pca_plot_type == "3D"){     
      text = HTML(
        DESC["plot_PCA_3D"]
      )      
    }
    else{
      text = HTML(
        DESC["plot_PCA_varience_explained"]
      )       
    }
    text    
  })  
  
  
}