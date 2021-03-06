################################################################################
#
#
#
# This is a Shiny web application to support the implementation of health and
# nutrition coverage surveys in Liberia.
# 
# This code is for the server logic function of the Shiny web aplication.
#
#
################################################################################


################################################################################
#
# Server logic for web application
#
################################################################################
#
# Define server logic for application
#
server <- function(input, output, session) {
  ##
  ############################ Maps ############################################
  ##
  covHex <- reactive({
    covHex <- gmHexGrid
    covHex@data <- data.frame(covHex@data, ifaInt, iycfInt, mnpInt, vitInt, screenInt, cmamInt, anthroInt)
    covHex
  })
  observe({
    ##
    subList <- indicatorList[indicatorList$varLabel %in% c("ifa1", "ifa2", "ifa3", 
                                                           "ifa4", "ifa5", "ifa6", 
                                                           "ifa7", "icf1", "icf2",
                                                           "icf3", "mnp1", "mnp2",
                                                           "mnp3", "mnp4", "vit1",
                                                           "muac.screen", "oedema.screen",
                                                           "weight.screen", "height.screen",
                                                           "cf", "tc", "muac", "height",
                                                           "weight", "oedema", "waz",
                                                           "haz", "whz", "global.haz",
                                                           "moderate.haz", "severe.haz",
                                                           "global.waz", "moderate.waz",
                                                           "severe.waz", "gam.whz",
                                                           "mam.whz", "sam.whz",
                                                           "gam.muac", "mam.muac",
                                                           "sam.muac"), ]
    ##
    req(input$gm)
    ##
    indicatorChoices <- subList[subList$df == str_replace(string = input$gm, 
                                                          pattern = "GM|GB", 
                                                          replacement = "DF"),
                                "varLabel"]
    ##
    indicatorChoices <- as.character(indicatorChoices)
    ##
    names(indicatorChoices) <- subList[subList$df == str_replace(string = input$gm, 
                                                                 pattern = "GM|GB", 
                                                                 replacement = "DF"),
                                       "varNames"]
    ##
    if(input$gm == "stuntGM") {
      indicatorChoices <- c("global.haz", "moderate.haz", "severe.haz")
      names(indicatorChoices) <- c("Global sunting prevalence", 
                                   "Moderate stunting prevalence",
                                   "Severe stunting prevalence")
    }
    ##
    if(input$gm == "underweightGM") {
      indicatorChoices <- c("global.waz", "moderate.waz", "severe.waz")
      names(indicatorChoices) <- c("Global underweight prevalence", 
                                   "Moderate underweight prevalence",
                                   "Severe underweight prevalence")
    }
    ##
    if(input$gm == "whzGM") {
      indicatorChoices <- c("gam.whz", "mam.whz", "sam.whz")
      names(indicatorChoices) <- c("Global wasting prevalence by WHZ", 
                                   "Moderate wasting prevalence by WHZ",
                                   "Severe wasting prevalence by WHZ")
    }
    ##
    if(input$gm == "muacGM") {
      indicatorChoices <- c("gam.muac", "mam.muac", "sam.muac")
      names(indicatorChoices) <- c("Global wasting prevalence by MUAC", 
                                   "Moderate wasting prevalence by MUAC",
                                   "Severe wasting prevalence by MUAC")
    }
    ##
    if(input$gm == "oedemaGM") {
      indicatorChoices <- "oedema"
      names(indicatorChoices) <- "Oedema prevalence"
    }
    ##
    updateSelectInput(session,
      inputId = "varLabel",
      label = "Select indicator",
      choices = indicatorChoices
    )
  })
  ##
  output$mapGM <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = mapbox.street,
        attribution = "Maps by <a href='http://www.mapbox.com/'>Mapbox</a>"
      ) %>%
      #fitBounds(lng1 = gmLng1, lat1 = gmLat1,
      #          lng2 = gmLng2, lat2 = gmLat2)
      setView(lng = gmLng, lat = gmLat, zoom = 11)
  })
  ##
  observe({
    ##
    values <- c(0,1)
    palette <- brewer.pal(n = 10, name = "RdYlGn")
    ##
    if(input$varLabel == "global.haz") {
      values <- c(0, max(anthroInt$global.haz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "moderate.haz") {
      values <- c(0, max(anthroInt$moderate.haz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "severe.haz") {
      values <- c(0, max(anthroInt$severe.haz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "global.waz") {
      values <- c(0, max(anthroInt$global.waz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "moderate.waz") {
      values <- c(0, max(anthroInt$moderate.waz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "severe.waz") {
      values <- c(0, max(anthroInt$severe.waz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "gam.whz") {
      values <- c(0, max(anthroInt$gam.whz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "mam.whz") {
      values <- c(0, max(anthroInt$mam.whz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "sam.whz") {
      values <- c(0, max(anthroInt$sam.whz))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "gam.muac") {
      values <- c(0, max(anthroInt$gam.muac))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "mam.muac") {
      values <- c(0, max(anthroInt$mam.muac))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "sam.muac") {
      values <- c(0, max(anthroInt$sam.muac))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    if(input$varLabel == "oedema") {
      values <- c(0, max(anthroInt$oedema))
      palette <- rev(brewer.pal(n = 10, name = "RdYlGn"))
    }
    ##
    pal <- colorNumeric(palette = palette, domain = values)
    ##
    leafletProxy("mapGM") %>%
      clearShapes() %>%
      clearControls() %>%
      removeLayersControl() %>%
      addPolygons(data = covHex(),
        fillColor = pal(covHex()[[input$varLabel]]),
        weight = 1,
        opacity = 1,
        color = pal(covHex()[[input$varLabel]]),
        dashArray = "",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 3,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = paste(round(covHex()[[input$varLabel]] * 100, digits = 1), "%", sep = ""),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "12px",
          direction = "auto"))%>%
      addLegend(pal = pal, 
                opacity = 0.7,
                values = values,
                position = "bottomleft", 
                labFormat = labelFormat(suffix = "%", transform = function(x) x * 100),
                layerId = "legend")
  })
  ##
  ############################ Estimates #######################################
  ##
  ##
  observeEvent(input$round == "r2" & input$gm == "ifaGM", {
    output$ifaPlot <- renderPlotly({
      ##
      x <- ifaBoot[ifaBoot$varLabel %in% c("ifa1", "ifa2", "ifa3", 
                                           "ifa4", "ifa6", "ifa7"), ]
      ##
      xlabs <- c("At least one\nANC visit",
                 "Know/heard\nof IFA",
                 "Received/\npurchased IFA",
                 "Consumed\nIFA",
                 "Consumed\nIFA\nat least\n90 days",
                 "Consumed\nIFA\n180 days")
      ##
      x$varNames <- factor(x = x$varNames, 
                           levels = c("At least one ANC visit",
                                      "Know/heard about iron-folic acid",
                                      "Received/purchased iron-folic acid",
                                      "Consumed iron-folic acid",
                                      "Consumed iron-folic acid for at least 90 days",
                                      "Consumed iron-folic acid for 180 days"))
      ##
      ggplot(data = x, aes(x = varNames, y = estimate * 100)) + 
      geom_col(color = "#993300", fill = "#993300", alpha = 0.7) + 
      scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                         limits = c(0, 100)) +
      scale_x_discrete(labels = xlabs) +
      labs(x = "", y = "%") +
      #coord_flip() +
      themeSettings
    })
    ##
    output$ifaReasons <- renderPlotly({
      x <- ifaBoot[ifaBoot$varLabel %in% c(paste("ifa3", letters[1:9], sep = ""), 
      ##
                                           paste("ifa4", letters[1:4], sep = "")), ]
      ##
      x <- x[x$estimate != 0, ]
      ##
      ggplot(data = x, aes(x = reorder(varNames, -estimate), y = estimate * 100)) +
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7) +
        #scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
        #                   limits = c(0, 100)) +
        #scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        coord_flip() +
        themeSettings
    })
  })
  ##
  observeEvent(input$round == "r2" & input$gm == "iycfGM", {
    output$icfPlot <- renderPlotly({
      ##
      x <- iycfBoot[iycfBoot$varLabel %in% c("icf1", "icf2"), ]
      ##
      xlabs <- c("Know/heard \nabout\nIYCF\ncounselling",
                 "Attended\nIYCF\ncounselling")
      ##
      x$varNames <- factor(x = x$varNames, 
                           levels = c("Know/heard about IYCF counselling",
                                      "Attended IYCF counselling"))
      ##
      ggplot(data = x, aes(x = varNames, y = estimate * 100)) + 
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7, width = 0.3) + 
        scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                           limits = c(0, 100)) +
        scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        #coord_flip() +
        themeSettings
    })
    ##
    output$icfReasons <- renderPlotly({
      x <- iycfBoot[iycfBoot$varLabel %in% c(paste("icf2", letters[1:7], sep = "")), ]
      ##
      x <- x[x$estimate != 0, ]
      ##
      ggplot(data = x, aes(x = reorder(varNames, -estimate), y = estimate * 100)) +
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7) +
        #scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
        #                   limits = c(0, 100)) +
        #scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        coord_flip() +
        themeSettings
    })
  })
  ##
  observeEvent(input$round == "r2" & input$gm == "mnpGM", {
    output$mnpPlot <- renderPlotly({
      ##
      x <- mnpBoot[mnpBoot$varLabel %in% c("mnp1", "mnp2"), ]
      ##
      xlabs <- c("Know/heard\nabout\nMNP",
                 "Received/\npurchased\nMNP")
      ##
      x$varNames <- factor(x = x$varNames, 
                           levels = c("Heard about micronutrient powder",
                                      "Received/purchased micronutrient powder"))
      ##
      ggplot(data = x, aes(x = varNames, y = estimate * 100)) + 
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7, width = 0.3) + 
        scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                           limits = c(0, 100)) +
        scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        #coord_flip() +
        themeSettings
    })
    ##
    output$mnpReasons <- renderPlotly({
      x <- mnpBoot[mnpBoot$varLabel %in% c(paste("mnp2", letters[1:4], sep = ""),
                                           paste("mnp3", letters[1:10], sep = "")), ]
      ##
      x <- x[x$estimate != 0, ]
      ##
      ggplot(data = x, aes(x = reorder(varNames, -estimate), y = estimate * 100)) +
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7) +
        #scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
        #                   limits = c(0, 100)) +
        #scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        coord_flip() +
        themeSettings
    })
  })
  ##
  observeEvent(input$round == "r2" & input$gm == "vitGM", {
    output$vitPlot <- renderPlotly({
      ##
      x <- vitBoot[vitBoot$varLabel == "vit1", ]
      ##
      xlabs <- "Received\nvitamin A\nin the\npast 6 months"
      ##
      ggplot(data = x, aes(x = varNames, y = estimate * 100)) + 
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7, width = 0.3) + 
        scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                           limits = c(0, 100)) +
        scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        #coord_flip() +
        themeSettings
    })
    ##
    output$vitReasons <- renderPlotly({
      x <- vitBoot[vitBoot$varLabel %in% c(paste("vit1", letters[1:10], sep = "")), ]
      ##
      x <- x[x$estimate != 0, ]
      ##
      ggplot(data = x, aes(x = reorder(varNames, -estimate), y = estimate * 100)) +
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7) +
        #scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
        #                   limits = c(0, 100)) +
        #scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        coord_flip() +
        themeSettings
    })
  })
  ##
  observeEvent(input$round == "r2" & input$gm == "screenGM", {
    output$screenPlot <- renderPlotly({
      ##
      x <- screenBoot
      ##
      xlabs <- c("Child\nheight\nmeasured\nin the\npast month",
                 "Child\nMUAC\nmeasured\nin the\npast month",
                 "Child\nchecked\nfor\noedema\nin the\npast month",
                 "Child\nweight\nmeasured\nin the\npast month")
      ##
      x$varNames <- factor(x = x$varNames, 
                           levels = c("Child height measured in the past month",
                                      "Child MUAC measured in the past month",
                                      "Child checked for oedema in the past month",
                                      "Child weight measured in the past month"))
      ##
      ggplot(data = x, aes(x = varNames, y = estimate * 100)) + 
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7) + 
        scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                           limits = c(0, 100)) +
        scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        #coord_flip() +
        themeSettings
    })
  })  
  ##
  observeEvent(input$round == "r2" & input$gm == "cmamGM", {
    output$cmamPlot <- renderPlotly({
      ##
      x <- cmamEst
      ##
      xlabs <- c("Case-finding\neffectiveness",
                 "Treatment\ncoverage")
      ##
      x$varNames <- factor(x = x$varNames, 
                           levels = c("Case-finding effectiveness",
                                      "Treatment coverage"))
      ##
      ggplot(data = x, aes(x = varNames, y = estimate * 100)) + 
        geom_col(color = "#993300", fill = "#993300", alpha = 0.7, width = 0.3) + 
        scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
                           limits = c(0, 100)) +
        scale_x_discrete(labels = xlabs) +
        labs(x = "", y = "%") +
        #coord_flip() +
        themeSettings
    })
    ##
    #output$cmamReasons <- renderPlotly({
      #x <- cmamDF[iycfBoot$varLabel %in% c(paste("icf2", letters[1:7], sep = "")), ]
      ##
      #x <- x[x$estimate != 0, ]
      ##
      #ggplot(data = x, aes(x = reorder(varNames, -estimate), y = estimate * 100)) +
      #  geom_col(color = "#993300", fill = "#993300", alpha = 0.7) +
        #scale_y_continuous(breaks = seq(from = 0, to = 100, by = 10),
        #                   limits = c(0, 100)) +
        #scale_x_discrete(labels = xlabs) +
      #  labs(x = "", y = "%") +
      #  coord_flip() +
      #  themeSettings
    #})
  })
}
