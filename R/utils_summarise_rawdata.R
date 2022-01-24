#' Summarise time series data into a descriptive table
#' 
#' Creates a table for a clicked population on the point map. This function can then be used within the \code{summarise_rawdata} module to generate the table on the dashboard in reaction to a click.
#'
#' @param clicked_population Population selected from a user's click on the point map.
#' 
#' @return A table describing the raw time series data.
#' @export

make_summarise_rawdata <- function(clicked_population){
 
  # import dataset
  
  # set api token as environment variable
  Sys.setenv("ATLAS_API_TOKEN" = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoicmVhZF9vbmx5X2FsbCIsIm1haWwiOiJrYXRoZXJpbmUuaGViZXJ0QHVzaGVyYnJvb2tlLmNhIn0.jHfCLsRseU0--5qFB5A_PfIOEv0I24PQw1ip3q_3KQw')
  
  # get time series and taxonomic info to observations
  obs <- dplyr::left_join(ratlas::get_timeseries(), 
                          ratlas::get_gen(endpoint="taxa"), 
                          by = c("id_taxa" = "id"))
  obs$id <- as.character(obs$id)
  obs <- obs[which(obs$id == clicked_population),]
  
  # summarise information about this dataset
  summary_table <- data.frame(
    "Description" = c("Nom scientifique",
                  "Longueur du suivi",
                  "Statut (Québec)",
                  "Groupe"#,
                  #"Source"
                  ),
    "Détails" = c(gsub("_", " ", obs$scientific_name[1]),
                  paste0(min(obs$years[[1]]), "-", max(obs$years[[1]]), 
                         " (", length(obs$years[[1]]), " ans)"),
                  if(is.na(obs$qc_status[1])){"-"} else{obs$qc_status[1]},
                  obs$species_gr[1]#,
                  #df$intellectual_rights[1]
                  )
  )
  return(summary_table)
}
  