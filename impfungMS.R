rm(list=ls()) 

library(telegram.bot)
library(rvest)
library(xml2)

#### Building an R Bot in 3 steps ----
# 1. Creating the Updater object
updater <- Updater(token = Sys.getenv("RTELEGRAMBOT_TOKEN"))

bot <- updater[["bot"]]

# Get bot info
print(bot$getMe())

# Get updates
updates <- bot$getUpdates()

# Retrieve your chat id
# Note: you should text the bot before calling `getUpdates`
chat_id <- Sys.getenv("CHAT_ID")

#### scrap rare observation ----
impfzentrumMSpage <- "https://impfzentrum-bbi-stadt-muenster.ticket.io/?onlyTag=erstimpfung"
impfzentrumMS <- read_html(impfzentrumMSpage)
impfzentrumMS
str(impfzentrumMS)

txt_obs <- impfzentrumMS %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//p[contains(@class, 'lead text-muted')]") %>% 
  rvest::html_text()

txt_obs_old <- "There are no active events at the moment"

txt_update <- "NEUE TERMINE IMPFZENTRUM"

# send message if list is updated
if (txt_obs_old!=txt_obs) {
  bot$sendMessage(chat_id = chat_id, text = txt_update, parse_mode = "Markdown")
}
