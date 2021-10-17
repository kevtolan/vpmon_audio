# download audio templates drive.google.com/drive/folders/1R6VjI1TQPksERSB0YAKoBwg7S9EhSQXM

library(tuneR)
library(monitoR)
library(plyr) 

setwd()

#Create templates from existing audio files
WOFRITemplate1 <- makeBinTemplate("WOFRITemplate1.WAV", 
                                  t.lim = c(241.59,241.69),
                                  frq.lim = c(0,6),
                                  score.cutoff = 13,
                                  amp.cutoff = -29,  
                                  name="WOFRITemplate1")
WOFRITemplate2 <- makeBinTemplate("WOFRITemplate2.wav",
                                        t.lim = c(2.275,2.325),
                                        frq.lim = c(0,4), 
                                        amp.cutoff = -27,
                                        buffer = .5,
                                        score.cutoff = 16,
                                        name="WOFRITemplate2")
WOFRITemplate3 <- makeBinTemplate("WOFRITemplate3.wav",
                                       t.lim = c(0.06,.16),
                                       frq.lim = c(0,6),
                                       amp.cutoff =-33,
                                       dens = .75,
                                       score.cutoff = 12,
                                       name="WOFRITemplate3")
SPPEITemplate  <- makeBinTemplate("SPPEITemplate.wav",
                                  t.lim = c(.55,.9),
                                  rq.lim = c(2,6),
                                  amp.cutoff = -37,
                                  score.cutoff = 12,
                                  buffer = 1,
                                  name = "SPPEITemplate")
BADOTemplate <- makeCorTemplate("BADOTemplate.wav",
                                t.lim = c(2.65,3.35),
                                frq.lim = c(0.25,2.5),
                                score.cutoff = 0.4,
                                name="BADOTemplate")
BinTemplateList <- combineBinTemplates(WOFRITemplate1,WOFRITemplate2,WOFRITemplate3,SPPEITemplate)
CorTemplateList <-combineCorTemplates(BADOTemplate)


#Detect audio

x <- "pathname to target audio file"

BinMatch <- binMatch(x, BinTemplateList,
                              show.prog = TRUE,cor.method = "pearson",time.source = "fileinfo",
                              rec.tz = "US/Eastern")
BinDetects <- findPeaks(BinMatch, frame = 1.01)

CorMatch <- corMatch(x,CorTemplateList,
                             #show.prog = TRUE,cor.method = "pearson",time.source = "fileinfo",
                             #rec.tz = "US/Eastern")
CorDetects <- findPeaks(CorMatch, frame = 1.01)

 
# view number of detections

WOFRITemplate1_Detects <- nrow(BinDetects@detections[["WOFRITemplate1"]])
WOFRITemplate2_Detects <- nrow(BinDetects@detections[["WOFRITemplate2"]])
WOFRITemplate3_Detects <- nrow(BinDetects@detections[["WOFRITemplate3"]])
SPPEI_Detects <- nrow(BinDetects@detections[["SPPEITemplate"]])
BADO_Detects <-nrow(CorDetects@detections[["BADOTemplate"]])

WOFRITemplate1_Detects
WOFRITemplate2_Detects
WOFRITemplate3_Detects
SPPEI_Detects
BADO_Detects
