# app to dynamically generate charts and tables in an shiny dashboard

library(shiny)
library(shinydashboard)
library(tidyverse)
library(highcharter)
library(DT)

demographics <- tibble(
  category = c(rep("gender", 2), rep("age", 7), rep("social_grade", 5)),
  demographic = c("Male", "Female", "15-24", "25-34", "35-44", "45-54", "55-64", "65-74", "75+", LETTERS[1:5]),
  percent = c(48.706585, 51.293415, 18.676534, 21.136115, 19.066600, 18.326197, 10.709079, 7.270722, 
              4.814752, 8.143243, 33.772399, 34.756400, 15.035762, 8.292197)
)

source("modules.R")

ui <- dashboardPage(
  dashboardHeader(title = "Shiny Modules",
                  tags$li(a(href = "http://cultureofinsight.com/",
                            icon("info-circle"),
                            title = "Culture of Insight",
                            style = "cursor: pointer;"),
                          class = "dropdown"),
                  tags$li(a(href = "http://github.com/paulc91/module_example",
                            icon("github"),
                            title = "Code on Github",
                            style = "cursor: pointer;"),
                          class = "dropdown")
                  ),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    h1("Demographics Charts & Tables Rendered by Module Functions", style = "text-align: center; padding-bottom: 30px;"),
    fluidRow(
      map(unique(demographics$category), ~ chartTableBoxUI(id = .x))
    )
  )
)

server <- function(input, output, session) {
  map(unique(demographics$category), ~ callModule(chartTableBox, id = .x, data = demographics, dem_group = .x))
}

shinyApp(ui, server)