tabPanel("File Input",
         sidebarLayout(
           sidebarPanel(
             radioButtons(
               "data_type_input",
               choices = c("Data folder", "SQLite File", "Excel Files", "Logger Files", "Miscellaneous"),
               label = "Add data using:"
             ),
             conditionalPanel(
               condition = "input.data_type_input == 'SQLite File'",
               h6("Add data stored in previous sessions"),
               fileInput(
                 "SQLite_filepath",
                 "Upload data",
                 multiple = TRUE,
                 accept = NULL,
                 width = NULL
               ) %>% {
                 temp = .
                 temp$children[[2]]$children[[1]]$children[[1]]$children[[2]]$attribs$onchange <- "document.getElementById('add_data').disabled = true;"
                 temp
               }
             ),
             conditionalPanel(
               condition = "input.data_type_input == 'Logger Files'",
               h6("Add data stored in previous sessions"),
               fileInput(
                 "logger_filepath",
                 "Upload data",
                 multiple = TRUE,
                 accept = NULL,
                 width = NULL
               )%>% {
                 temp = .
                 temp$children[[2]]$children[[1]]$children[[1]]$children[[2]]$attribs$onchange <- "document.getElementById('add_data').disabled = true;"
                 temp
               },
               textInput("receiver_name_input","Please enter antenna name", value = "receiver_1"),
               textInput("station_name_input","Please enter station name", value = "station_1")
             ),
             conditionalPanel(
               condition = "input.data_type_input == 'Excel Files'",
               radioButtons("excel_data_content",
                            choices = c("Antennas", "Frequencies", "Connections", "Calibration", "Map Markers"),
                            label = "Add following data:"
               ),
               conditionalPanel(
                 condition = "input.excel_data_content == 'Antennas'",
                 h6("Information about each antenna used"),
                 fileInput(
                   "excel_filepath_receivers",
                   "",
                   multiple = FALSE,
                   accept = c(".xlsx", ".xls"),
                   width = NULL
                 )
               ),
               conditionalPanel(
                 condition = "input.excel_data_content == 'Frequencies'",
                 h6("Information about used frequencies"),
                 fileInput(
                   "excel_filepath_frequencies",
                   "",
                   multiple = FALSE,
                   accept = c(".xlsx", ".xls"),
                   width = NULL
                 )
               ),
               conditionalPanel(
                 condition = "input.excel_data_content == 'Connections'",
                 h6("Information about remote connections"),
                 fileInput(
                   "excel_filepath_remote",
                   "",
                   multiple = FALSE,
                   accept = c(".xlsx", ".xls"),
                   width = NULL
                 )
               ),
               conditionalPanel(
                 condition = "input.excel_data_content == 'Calibration'",
                 h6("Calibration of antenna's sensitivity"),
                 fileInput(
                   "excel_filepath_calibration",
                   "",
                   multiple = FALSE,
                   accept = c(".xlsx", ".xls"),
                   width = NULL
                 )
               ),
               conditionalPanel(
                 condition = "input.excel_data_content == 'Map Markers'",
                 h6("Map markers with comments"),
                 fileInput(
                   "excel_filepath_map_markers",
                   "",
                   multiple = FALSE,
                   accept = c(".xlsx", ".xls"),
                   width = NULL
                 )
               )
             ),
             conditionalPanel(
                condition = "input.data_type_input == 'Miscellaneous'",
                radioButtons(
                  "misc_type_input",
                  choices = c("GPX","KML","KMZ","readOGR","readcsv"),
                  label = "File type:"
                ),
                h6("Coordinates for map"),
                fileInput(
                  "coordinates_filepath",
                  "",
                  multiple = FALSE,
                  accept = c(".gpx",".kmz",".kml",".gpkg",".csv"),
                  width = NULL
                )
            ),
             actionButton(
               "add_data",
               h4("    Add Data    ")
             )
           ),
           mainPanel(
             tabsetPanel(
             id = "data_tab_tabset",
             tabPanel("Preview of upload",
                      dataTableOutput("data_tab_preview")),
             tabPanel("All Logger Data",
                      dataTableOutput("data_tab_logger_table"),
                      actionButton("clear_logger_data", "Clear table")
             ),
             tabPanel("Antennas",
                      dataTableOutput("data_tab_antennae_table"),
                      actionButton("clear_receivers_data", "Clear table")
             ),
             tabPanel("Remote Connections",
                      dataTableOutput("data_tab_remote_con_table"),
                      actionButton("clear_connections_data", "Clear table")
             ),
             tabPanel("Frequencies used",
                      dataTableOutput("data_tab_freq_table"),
                      actionButton("clear_frequencies_data", "Clear table")
             ),
             tabPanel("Calibration",
                      dataTableOutput("data_tab_calibration_table"),
                      actionButton("clear_calibration_data", "Clear table")
             ),
             tabPanel("Map Markers",
                      dataTableOutput("data_tab_map_markers_table"),
                      actionButton("clear_map_markers_data", "Clear table")
             ),
             tabPanel("Keepalives",
                      dataTableOutput("data_tab_keepalive_table"),
                      actionButton("clear_keepalive_data", "Clear table")
             ),
             tabPanel("Help",
                      "1) First select the data source on the right",
                      br(),
                      "2) Check the preview window if it is the correct data"
                      )
           ))
         ))
