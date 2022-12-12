options(scipen = 999)
library(shiny)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(plotly)

data <- read.csv("./data/owid-co2-data.csv", header = TRUE, stringsAsFactors = FALSE)

countries <- data %>%
  select(country, co2, gdp) %>%
  drop_na(co2) %>%
  drop_na(gdp)

values <- list()

# average 2021 annual co2 emissions
values$average_2021_co2 <- data %>%
  filter(year == "2021") %>%
  filter(country != "World") %>%
  summarize(avg = round(mean(co2, na.rm = TRUE))) %>%
  pull(avg)

# country with the highest co2 emissions 
values$highest_2021_co2_country <- data %>%
  filter(year == "2021") %>%
  filter(country != 'World') %>%
  filter(co2 == (max(co2, na.rm = TRUE))) %>%
  select(country, co2)

# country with the lowest co2 emissions
values$lowest_2021_co2_country <- data %>%
  filter(year == "2021") %>%
  filter(country != 'World') %>%
  filter(co2 == min(co2, na.rm = TRUE)) %>%
  select(country, co2)

server <- function(input, output) {
  
  # renders intro with 3 key values
  output$intro <- renderText({
    paste("Climate change has been a significant concern for many people in the
    world. Many people wonder if there is a way to decrease the amount of 
    carbon dioxide being released in the atmosphere, however to do so requires a
    lot of disadvantages. In the current state of the world, countries are
    silently fighting to develop and reach first world status or to outshine
    other countries. Whether that's through increasing their trade potential or
    creating a better place to live, they all release a substancial amount of
    carbon dioxide. This number has only gotten worse over the years and I would
    like to highlight some values I found from the dataset. In 2021, the average
    annual millon tonnes of carbon dioxide emissions was ", 
    values$average_2021_co2, ". That amount is no small number. Additionally,
    the country with the highest annual million tonnes of carbon dioxide
    emissions was ", values$highest_2021_co2_country$country, " with ",
    format(round(values$highest_2021_co2_country$co2), big.mark=","), " million tonnes. In comparison,
    the country with the lowest was ", values$lowest_2021_co2_country$country, " 
    with ", values$lowest_2021_co2_country$co2, " million tonnes. The
    difference in million tonnes is large, but what contributes to that
    difference? The answer is likely GDP. The higher a country's GDP, the 
    more resources they have to expand, industrialize, and evolve.")
  })
  
  
  # Variable selector
  output$selectVariable <- renderUI({
    radioButtons(
      inputId = "variable",
      label = "Select a Variable",
      choices = c("co2", "gdp"), 
      selected = "co2")
  })
  
  # Country selector
  output$selectCountry <- renderUI({
    selectizeInput(
      inputId = 'country',
      label = "Select 5 Countries",
      choices = distinct(countries, country),
      selected = NULL,
      multiple = TRUE,
      options = 
        list(
        plugins = list("remove_button"),
        maxItems = 5
        )
    )
  })
  
  # Year selector
  output$selectYear <- renderUI({
    sliderInput(
      inputId = "range",
      label = "Select a Range of Years",
      min = min(data$year),
      max = max(data$year),
      value = c(min(data$year), max(data$year)))
  })
  
  # Creating the line plot
  lineplot <- reactive({
    if(is.null(input$country)) {
      filtered <- data %>%
        filter(year >= input$range[1]) %>%
        filter(year <= input$range[2])
    } else {
      filtered <- data %>%
        filter(year >= input$range[1]) %>%
        filter(year <= input$range[2]) %>%
        filter(country %in% input$country)
    }

    if(input$variable == "co2") {
      filtered <- filtered %>%
        select(country, year, co2) %>%
        drop_na(co2)
      
      lineplot <- ggplot(data = filtered) +
        aes(
          x = year,
          y = co2,
          group = country,
          xmin = input$range[1],
          ymin = input$range[2],
          color = country
        ) +
        geom_line() + 
        labs(
          x = "Year",
          y = str_wrap(
            "Annual million tonnes of total production-based
            carbon dioxide emissions", 50)
        ) +
        ggtitle(
          "Annual million tonnes of total production-based carbon dioxide
          emissions for countries"
        ) +
        scale_y_continuous(
          labels = scales::comma
        ) +
        theme(
          legend.position='none'
        )
      lineplot
    } else {
      
      filtered <- filtered %>%
        select(country, year, gdp) %>%
        drop_na(gdp)
      
      lineplot <- ggplot(data = filtered) +
        aes(
          x = year,
          y = gdp,
          group = country,
          xmin = input$range[1],
          ymin = input$range[2],
          color = country
        ) +
        geom_line() + 
        labs(
          x = "Year",
          y = "Gross domestic product measured in international-$"
        ) +
        ggtitle(
          "Gross domestic product measured in international-$ for countries"
        ) +
        scale_y_continuous(
          labels = scales::label_number_si()
        ) +
        theme(
          legend.position='none'
        )
      lineplot
    }
  })
  
  # Outputting the lineplot
  output$lineplot <- renderPlotly({
    lineplot()
  })
  
}


