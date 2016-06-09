# experimentation with Microsoft project Oxford
# https://www.microsoft.com/cognitive-services/en-us/emotion-api

# inspired by:
# http://www.r-bloggers.com/analyze-face-emotions-with-r/

# a Microsoft account is required:
# https://login.live.com/

# you need to provice 'Cognitive Sites" access your account
# on the website of Microsoft Cognitives servives, activate the emotions API
# there you get your keys and tokens

# required packages
library("httr")
library("XML")
library("stringr")
library("ggplot2")

# define image source (large enough)
img_url <- "xxxx"

# define Microsoft API URL
URL_emoface <- 'https://api.projectoxford.ai/emotion/v1.0/recognize'

# Define access key 
# (access key is available via: https://www.microsoft.com/cognitive-services/en-us/emotion-api)
emotionKEY <- "xxxx"

# Define image
mybody <- list(url = img_url)

# Request data from Microsoft
faceEMO <- POST(
        url = URL_emoface, 
        content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = emotionKEY)),
        body = mybody,
        encode = 'json'
)

# Show request results (if Status=200, request is okay)
faceEMO

# Reuqest results from face analysis
response <- httr::content(faceEMO)[[1]]
response
# Define results in data frame
o<-as.data.frame(as.matrix(response$scores))

# Make some transformation
o$V1 <- lapply(strsplit(as.character(o$V1 ), "e"), "[", 1)
o$V1<-as.numeric(o$V1)
colnames(o)[1] <- "Level"

# Define names
o$Emotion<- rownames(o)

# Make plot
ggplot(data=o, aes(x=Emotion, y=Level)) +
        geom_bar(stat="identity")
