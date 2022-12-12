library(shiny)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(plotly)

intro <- tabPanel(
  "Introduction",
  titlePanel("Investigating Carbon Dioxide Emissions and GDP"),
  img(src = "climate.jpg", alt = "factory pollution"),
  p("Author: Diana Tran"),
  h2("Introduction"),
  p("Climate change has, over the years, become more of an issue due
          to the rapid industrialization of the world. As we advance further
          as a society, our risk to the effects of climate change go up and so
          do all other organisms on the planet. The burning of fossil fuels and
          other methods have caused a large spike in the amount of carbon 
          dioxide put into the atmosphere. Although, as a planet we understand
          that our actions will eventually put us in dire circumstances, the
          thought is put aside when it comes to developing one's nation or
          country. In this report, I will be seeking to investigate the
          relationship between a country's GDP and their annual carbon dioxide
          emissions to see if there is a connection with a country having more
          resources to grow and their carbon dioxide emissions. This will be 
          done using R, specifically dplyr, ggplot, and plotly. The dataset that
          will be used is from, 'Our world in Data'. From this dataset we will
          be investigating two main variables, gdp, which is defined as 'Gross
          domestic product measured in international-$ using 2011 prices to
          adjust for price changes over time (inflation) and price differences
          between countries. Calculated by multiplying GDP per
          capita with population,' and co2, which is defined as, Annual total
          production-based emissions of carbon dioxide (CO₂), excluding land-use
          change, measured in million tonnes. This is based on territorial
          emissions, which do not account for emissions embedded in traded
          goods.' Using these two values I will investigate the difference in 
          carbon dioxide emissions from several countries over time and if there
          seems to be a relationship with the country's increase or decrease of 
          GDP."),
  h2("Highlighting Values"),
  uiOutput("intro")
)

# input choices for lineplot
lineplot_input <- sidebarPanel(
  uiOutput("selectVariable"),
  uiOutput("selectCountry"),
  uiOutput("selectYear")
)

# lineplot and brief reflection
lineplot <- mainPanel(plotlyOutput("lineplot"))

# lineplot page
lineplot_ui <- tabPanel(
  "Differences between countries' CO2 emissions and GDP",
  titlePanel("How do countries' carbon dioxide emissions compare to each other
             and how does their GDP compare?"),
  sidebarLayout(
    lineplot_input,
    lineplot
  ),
  h2("What This Visualization Reveals"),
  p("From the visualization we can see that GDP appears to have some effect on
    the carbon dioxide emission numbers. For example, when the countries, China,
    Japan, South Korea, Vietnam, and Taiwan, are selected, the visualization
    shows that China leads with the highest million tonnes of emissions, while
    Japan, then South Korea, then Vietnam and Taiwan follow. Vietnam and Taiwan
    are very close in numbers but Vietnam is slightly higher. Then, if we 
    switch our variable to show GDP, we can see that the order remains the same
    except Taiwan is above Vietnam in terms of GDP. Additionally, we can see
    how both the GDP and carbon dioxide emission have changed over time for
    these countries. It is important to see and understand these things because
    we can see that in some cases, a country's GDP increases but their carbon
    dioxide emissions decrease. Although, GDP increases seems to correlate with
    an increase in emissions, this visualization shows that it is possible to 
    raise GDP while not raising emissions. Meaning that advocating for decreases
    in emissions is possible without politicians arguing that the state of the
    country's economy and well being are at risk."))

ui <- navbarPage(
  "Importance of Climate Change",
  intro,
  lineplot_ui
)
