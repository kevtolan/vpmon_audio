library(AMMonitor)
library(AMModels)
library(taxize)

#set vernal pool ID
VPMonID <- "ABC123"

#create directories, reset WD
ammCreateDirectories(amm.dir.name = "AMMonitor", 
                     file.path = "E:/Dropbox")
setwd('')

# Create a libraries
activity <- AMModels::amModelLib(description = "This library stores models that predict species activity patterns.")
classifiers <- AMModels::amModelLib(description = "This library stores classification models (machine learning models) that can be used to predict the probability that a detected signal is from a target species.")
soundscape <- AMModels::amModelLib(description = "This library stores results of a soundscape analysis.")
do_fp <- AMModels::amModelLib(description = "This library stores results of dynamic occupancy analyses that can handle false positive detections.")

# Create/add a list of metadata to be added to each library
info <- list(PI = 'Steve Faccio',
             Coordinator = 'Kevin Tolan'
             Organization = 'Vermont Center for Ecostudies')
ammlInfo(activity) <- info
ammlInfo(classifiers) <- info
ammlInfo(soundscape) <- info
ammlInfo(do_fp) <- info
#save libraries 
saveRDS(object = activity, file = "ammls/activity.RDS")
saveRDS(object = classifiers, file = "ammls/classifiers.RDS")
saveRDS(object = soundscape, file = "ammls/soundscape.RDS")
saveRDS(object = do_fp, file = "ammls/do_fp.RDS")

# create SQLite database
dbCreate(db.name = paste0(VPMonID,".sqlite"), 
               file.path = paste0(getwd(),"/database")) 
############################################################ FIX to paste poolID as sqlite
#### ALWAYS RUN
db.path <- paste0(getwd(), '/database/____.sqlite')
conx <- RSQLite::dbConnect(drv = dbDriver('SQLite'), dbname = db.path)
RSQLite::dbExecute(conn = conx, statement = "PRAGMA foreign_keys = ON;")

#view tables
dbReadTable(conx,people)
   
#### Add necessary components ####

#people
add.people <- data.frame(personID = 'ktolan@vtecostudies.org',
                         firstName = 'Kevin',
                         lastName = 'Tolan',
                         projectRole = 'Coordinator',
                         email = 'ktolan@vtecostudies.org',
                         phone = NULL )
RSQLite::dbWriteTable(conn = conx, name = 'people', value = add.people,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
# species
new.species <- data.frame(speciesID = 'wofr', 
                          commonName = 'Wood Frog',
                          ITIS = '775117',
                          genus = 'Lithobates',
                          species = 'sylvaticus',
                          notes = NA, 
                          stringsAsFactors = FALSE)
RSQLite::dbWriteTable(conn = conx, name = 'species', value = new.species,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
new.species <- data.frame(speciesID = 'sppe', 
                          commonName = 'Spring Peeper',
                          ITIS = '207303',
                          genus = 'Pseudacris',
                          species = 'crucifer',
                          notes = NA, 
                          stringsAsFactors = FALSE)
RSQLite::dbWriteTable(conn = conx, name = 'species', value = new.species,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
new.species <- data.frame(speciesID = 'bado', 
                          commonName = 'Barred Owl',
                          ITIS = '177921',
                          genus = 'Strix',
                          species = 'varia',
                          notes = NA, 
                          stringsAsFactors = FALSE)
RSQLite::dbWriteTable(conn = conx, name = 'species', value = new.species,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
new.species <- data.frame(speciesID = 'ewpw', 
                          commonName = 'Eastern Whip-poor-will',
                          ITIS = '1077358',
                          genus = 'Antrostomus',
                          species = 'vociferus',
                          notes = NA, 
                          stringsAsFactors = FALSE)
RSQLite::dbWriteTable(conn = conx, name = 'species', value = new.species,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
#library
new.library <- data.frame(speciesID = 'wofr', 
                          speciesID = 'wofr',
                          type = NULL,
                          desription = NULL)
RSQLite::dbWriteTable(conn = conx, name = 'library', value = new.library,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
new.library <- data.frame(speciesID = 'sppe', 
                          speciesID = 'sppe',
                          type = NULL,
                          desription = NULL)
RSQLite::dbWriteTable(conn = conx, name = 'library', value = new.library,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
new.library <- data.frame(speciesID = 'bado', 
                          speciesID = 'bado',
                          type = 'Hoot',
                          desription = NULL)
RSQLite::dbWriteTable(conn = conx, name = 'library', value = new.library,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
new.library <- data.frame(speciesID = 'ewpw', 
                          speciesID = 'ewpw',
                          type = 'Song',
                          desription = NULL)
RSQLite::dbWriteTable(conn = conx, name = 'library', value = new.library,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
# location
new.location <- data.frame(locationID = paste0(VPMonID),
                           type = 'Vernal Pool ARU',
                           lat = '',
                           long = '',
                           datum = 'WGS84',
                           tz = 'UTC',
                           personID = '')
RSQLite::dbWriteTable(conn = conx, name = 'location', value = new.location,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
# accounts
new.account <- data.frame(accountID = paste0(VPMonID))
RSQLite::dbWriteTable(conn = conx, name = 'accounts', value = new.account,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
# equipment
RSQLite::dbExecute(conn = conx, statement = 
                     "ALTER TABLE equipment ADD COLUMN MicroSD varchar;") 
new.equipment <- data.frame(equipmentID = '',
                           accountID = paste0(VPMonID),
                           microSD = '')
RSQLite::dbWriteTable(conn = conx, name = 'equipment', value = new.equipment,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
# deployment
new.deployment <- data.frame(equipmentID = '',
                            locationID = '',
                            dateDeployed = '',
                            dateRetrieved = NULL) # DON"T FILL IN DATE RETRIEVED
RSQLite::dbWriteTable(conn = conx, name = 'deployment', value = new.deployment,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
# schedule
new.schedule <- data.frame(equipmentID = '',
                             locationID = '',
                             subject = 'Vernal Pool',
                             startDate = '',
                             startTime = '') 
RSQLite::dbWriteTable(conn = conx, name = 'schedule', value = new.schedule,
                      row.names = FALSE, overwrite = FALSE,
                      append = TRUE, header = FALSE)
# file rename
AudioFiles <- list.files(path = "recording_drop", pattern = ".WAV", all.files = TRUE,
                         full.names = TRUE, recursive = TRUE,
                         ignore.case = TRUE, include.dirs = TRUE)
AudioFiles2 <- parse_date_time(AudioFiles, "Ymd HMS", tz = 'UTC')
AudioFiles3 <- as.character(AudioFiles2)
AudioFiles4 <- str_replace_all(AudioFiles3,' ','_')
AudioFiles5 <- str_replace_all(AudioFiles4,':','-')
AudioFiles6 <- paste0(VPMonID, AudioFiles5)
AudioFiles7 <- str_replace_all(AudioFiles6,'~','recording_drop/')
AudioFiles8 <- file.rename(AudioFiles,paste0(AudioFiles7,'.wav'))
# fill recordings table
dropboxMoveBatch(db.path = db.path,
                 table = 'recordings', 
                 dir.from = 'recording_drop', 
                 dir.to = 'recordings', 
                 token.path = 'settings/dropbox-token.RDS')
#create templates

setwd()
WOFRITemplate1 <- makeBinTemplate("WOFRITemplate1.WAV", 
                                  t.lim = c(241.59,241.69),
                                  frq.lim = c(0,6),
                                  score.cutoff = 0,
                                  amp.cutoff = -29,  
                                  name="WOFRITemplate1")
WOFRITemplate2 <- makeBinTemplate("WOFRITemplate2.wav",
                                  t.lim = c(2.275,2.325),
                                  frq.lim = c(0,4), 
                                  amp.cutoff = -27,
                                  buffer = .5,
                                  score.cutoff = 0,
                                  name="WOFRITemplate2")
WOFRITemplate3 <- makeBinTemplate("WOFRITemplate3.wav",
                                  t.lim = c(0.06,.16),
                                  frq.lim = c(0,6),
                                  amp.cutoff =-33,
                                  dens = .75,
                                  score.cutoff = 0,
                                  name="WOFRITemplate3")
SPPEITemplate  <- makeBinTemplate("SPPEITemplate.wav",
                                  t.lim = c(.55,.9),
                                  rq.lim = c(2,6),
                                  amp.cutoff = -37,
                                  score.cutoff = 0,
                                  buffer = 1,
                                  name = "SPPEITemplate")
EWPWTemplate <- makeBinTemplate("EWPWTemplate.WAV",
                                amp.cutoff = -40, 
                                score.cutoff = 0,
                                frq.lim = c(0,6),
                                name = "EWPWTemplate")
BADOTemplate <- makeCorTemplate("BADOTemplate.wav",
                                t.lim = c(2.65,3.35),
                                frq.lim = c(0.25,2.5),
                                score.cutoff = 0,
                                name="BADOTemplate")
BinTemplateList <- combineBinTemplates(WOFRITemplate1,WOFRITemplate2,WOFRITemplate3,SPPEITemplate,EWPWTemplate)
CorTemplateList <- combineCorTemplates(BADOTemplate)

templatesInsert(db.path = db.path, 
                template.list = combineBinTemplates(WOFRITemplate1,WOFRITemplate2,WOFRITemplate3,SPPEITemplate,EWPWTemplate), 
                libraryID = c(combineBinTemplates('WOFRITemplate1','WOFRITemplate2','WOFRITemplate3','SPPEITemplate','EWPWTemplate')),
                personID = 'ktolan@vtecostudies.org')
templatesInsert(db.path = db.path, 
                template.list = BADOTemplate, 
                libraryID = 'BADOTemplate',
                personID = 'ktolan@vtecostudies.org')

#calculate scores
ranscores <- scoresDetect(db.path = db.path, 
                      directory = 'recordings', 
                      recordingID = 'all',
                      templateID = 'all',
                      score.thresholds = c(13,16,12,7,0.4),
                      #listID = 'Target Species Templates',     
                      token.path = 'settings/dropbox-token.RDS', 
                      db.insert = TRUE) 










