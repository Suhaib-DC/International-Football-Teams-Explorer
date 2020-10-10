library(plotly)
library(ggplot2)
library(RColorBrewer)


data <- read.csv("results.csv")
year <- substring(data$date, 1,4)

home <- NULL
away <- NULL

for(i in 1:length(data$home_team)){
    if (data$home_score[i] > data$away_score[i]){
        home[i] <- "W"
    }
    else if(data$home_score[i] < data$away_score[i]){
        home[i] <- "L"
    }
    else {
        home[i] <- "D"
    }
}


for(i in 1:length(data$away_team)){
    if (data$home_score[i] > data$away_score[i]){
        away[i] <- "L"
    }
    else if(data$home_score[i] < data$away_score[i]){
        away[i] <- "W"
    }
    else {
        away[i] <- "D"
    }
}

year <- as.factor(c(year, year))
team <- as.factor(c(data$home_team, data$away_team))
rslt <- as.factor(c(home, away))
score <- c(data$home_score, data$away_score)
recive <- c(data$away_score, data$home_score)
NMR <- data.frame(year, team, rslt, score, recive)



library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$myPlot <- renderPlotly({
        
        # generate bins based on input$bins from ui.R
        x    <- as.character(input$era[1]:input$era[2])
        
        
        s <- NULL
        for(i in 1:length(x)){
            s <- rbind(s, subset(NMR, year == x[i]))
        }
        
        if(input$rb == 1){
            
            best <- data.frame()
            uniqteams <- s$team[!duplicated(s$team)]
            for(i in uniqteams){
                b <- subset(s, team == i)
                c <- c(table(b$rslt), sum(b$score), sum(b$recive))
                best <- rbind(best,c)
            }
            
            best <- cbind(uniqteams, best)
            best[7] <- 3 * best[4] + best[2]
            names(best) <- c("team", "D", "L", "W", "S", "R", "P")
            
            
            
            topw <- best[order(best$W, decreasing = TRUE),]
            topl <- best[order(best$L, decreasing = TRUE),]
            topd <- best[order(best$D, decreasing = TRUE),]
            top <- best[order(best$P, decreasing = TRUE),]
            tops <- best[order(best$S, decreasing = TRUE),]
            topr <- best[order(best$R, decreasing = TRUE),]
            
           
            
            p2 <- plot_ly(x = as.character(topw$team[1:10]), y = topw$W[1:10],
                          type = "bar", color = I(brewer.pal(6, "Dark2")[2]),
                          name = "Top Winning Teams")
            
            
            p3 <- plot_ly(x = as.character(topl$team[1:10]), y = topl$L[1:10],
                          type = "bar", color = I(brewer.pal(6, "Dark2")[3]),
                          name = "Top Losing Teams")
            
            
            
            p5 <- plot_ly(x = as.character(tops$team[1:10]), y = tops$S[1:10],
                          type = "bar", color = I(brewer.pal(6, "Dark2")[5]),
                          name = "Top Goal Scored")
            
            
            p6 <- plot_ly(x = as.character(topr$team[1:10]), y = topr$R[1:10],
                          type = "bar", color = I(brewer.pal(6, "Dark2")[6]),
                          name = "Top Goal Recived")
            
            
            subplot(p2,p3,p5,p6, nrows = 2, margin = 0.1)
        
        }
        
        else {
            s <- subset(NMR, team == input$tm)
            r <- c(sum(s$score), sum(s$recive))
            n <- c("Draw", "Lose", "Win")
            goal <- c("Scored", "Recived")
            
            p7 <- plot_ly(x = as.character(n), y = table(s$rslt),
                          type = "bar", color = I(brewer.pal(6, "Dark2")[6]),
                          name = "Maches")
            p7 <- p7 %>% layout(
                                xaxis = list(title = "Result of Match"),
                                yaxis = list(title = "Frequency"))
            
            
            p8 <- plot_ly(x = as.character(goal), y = r,
                          type = "bar", color = I(brewer.pal(6, "Dark2")[4]),
                          name = "Goals")
            p8 <- p8 %>% layout(
                                xaxis = list(title = "Goals"),
                                yaxis = list(title = "Frequency"))
            
            
            
            
            subplot(p7,p8, nrows = 2, margin = 0.1)
        }
    })
    
})
