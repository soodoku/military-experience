"
Plot the UK PM Mil. Experience
5/25/2015

"

library(ggplot2)
library(grid)

ukmil <- read.csv("https://raw.githubusercontent.com/soodoku/military-experience/master/UKPMMilExp.csv")
ukmil$milexp <- ifelse(is.na(ukmil$Mil..Exp.), 0, ukmil$Mil..Exp.)

# We need to customize location of a few text labels to prevent overplotting
pos <- ukmil$Start.Year
diffs <-  which(diff(pos)<=1)+1
pos[diffs] <- pos[diffs] + 1
pos[10] <- pos[10] -1
pos[13] <- pos[13] - 1
pos[15] <- pos[15] - 2.5
pos[21] <- pos[21] + 1
pos[23] <- pos[23] - 1.5
pos[25] <- pos[25] + .5
pos[27] <- pos[27] - 1
pos[30] <- pos[30] + 1.5
pos[33] <- pos[33] - 1
pos[38] <- pos[38] - 1
pos[39] <- pos[39] - 1
pos[41]  <- pos[41] + 1
pos[44:45] <- pos[44:45] - 1
pos[46] <- pos[46] + .75
pos[55] <- pos[55] - 1

ggplot(ukmil, aes(x=Start.Year, y=milexp, label=Name))+
  geom_hline(yintercept=0, color="#cccccc", size=.5) +
  geom_hline(yintercept=1, color="#cccccc", size=.5) +
	geom_point(size=1.5, color="#cc0000", alpha=.7)+
	geom_text(aes(x = pos), size=3, hjust=1.05, angle=90, vjust=.2) + 
  scale_y_continuous(breaks=seq(0, 1, 1), labels=c("No Military\n Experience", "Have Military\n Experience")) + 
  scale_x_continuous(breaks = round(seq(min(ukmil$Start.Year)-1, max(ukmil$Start.Year), by = 20),1)) + 
  expand_limits(y=-1.2, x=c(1740,1990)) +
  theme_bw() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_text(angle=45, vjust=.5), 
        axis.title.y = element_blank(),
  		  panel.grid.major = element_blank(), 
  		  panel.grid.minor = element_blank(),
        plot.margin = unit(c(.5, .5, .5, .5), "cm"),
        panel.border = element_rect(0,0,0,0),
        axis.ticks = element_line(color="#cccccc"))
    
ggsave("ukmil.pdf", height=6, width=20)