
chartTableBoxUI <- function(id, div_width = "col-xs-12 col-sm-6 col-md-4") {
  
  ns <- NS(id)
  
  div(class = div_width,
         tabBox(width = 12, title = str_to_title(str_replace(id, "_", " ")),
                tabPanel(icon("bar-chart"),
                         highchartOutput(ns("chart"))
                ),
                tabPanel(icon("table"),
                         DT::dataTableOutput(ns("table"))
                )
         )
  )
  
}

chartTableBox <- function(input, output, session, data, dem_group) {
  
  mod_data <- reactive({
    data %>% filter(category == dem_group)
  })
  
  output$chart <- renderHighchart({
    
    hchart(mod_data(), "column", hcaes(x = demographic, y = percent)) %>%
      hc_xAxis(title = list(text = "")) %>% 
      hc_yAxis(title = list(text = ""), labels = list(format = "{value}%")) %>%  
      hc_tooltip(valueDecimals = 1, valueSuffix = " %") #%>%
      #hc_add_theme(hc_theme_smpl())
    
  })
  
  output$table <- renderDataTable({
    
    dat <- mod_data() %>% select(demographic, percent) %>% mutate(percent = (percent / 100))
    
    DT::datatable(dat, style = "bootstrap", class = "display", options=list(scrollX=TRUE, dom = 't')) %>% 
      formatPercentage('percent', 0)
    
  })
  
}