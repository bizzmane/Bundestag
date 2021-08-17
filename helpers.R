library("data.table")
library("readxl")

source('mappings.R')

load_voting_data <- function(dir_path) {
  
  # Different encoding for the .xls files than for .xlsx
  # Therefore the first batch needs some encoding work
  files = list.files(path = DATA_PATH, pattern="*.xls$")
  DT1 = rbindlist(lapply(paste(DATA_PATH,files,sep = ""), read_excel, 1), fill = TRUE)
  DT1 = DT1[, Bezeichnung := iconv(Bezeichnung)]
  DT1 = DT1[, `Fraktion/Gruppe` := iconv(`Fraktion/Gruppe`)]
  DT1 = DT1[, Name := iconv(Name)]
  DT1 = DT1[, Vorname := iconv(Vorname)]
  colnames(DT1)[11] <- "ungültig"
  
  files = list.files(path = DATA_PATH, pattern="*.xlsx")
  DT2 = rbindlist(lapply(paste(DATA_PATH,files,sep = ""), read_excel, 1), fill = TRUE)
  DT2 = DT2[, c(-15)]
  colnames(DT2)[11] <- "ungültig"
  
  DT = rbind(DT1, DT2)
  
  DT = DT[, .(Abstimmnr,Sitzungnr,`Fraktion/Gruppe`, Bezeichnung,ja,nein,Enthaltung,nichtabgegeben)]
  DT = DT[, Abstimmung := paste("SNR",Sitzungnr,"_",Abstimmnr,sep = "")]
  DT = DT[, Bezeichnung := str_replace(Bezeichnung, "\\(.*\\)", "")]
  DT[`Fraktion/Gruppe` %like% "GR", `Fraktion/Gruppe` := "B90/GR"]
  
  return(DT)
}

normalize_member_names <- function(dt, regex_map){
  for (reg in names(reg_map)){
    dt[Member %like% reg, Member := reg_map[reg]]
  }
}


get_color_palette <- function(seleted_parties){
  return(COLOR_PAL[ALL_PARTIES %in% seleted_parties])
}