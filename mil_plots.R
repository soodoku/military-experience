"
Plot the UK PM Mil. Experience
5/14/2015

"

library(ggplot2)

ukmil <- read.csv("https://raw.githubusercontent.com/soodoku/military-experience/master/UKPMMilExp.csv")
ukmil$milexp <- ifelse(is.na(ukmil$Mil..Exp.), 0, ukmil$Mil..Exp.)

ggplot(ukmil, aes(x=jitter(Start.Year), y=milexp, label=Name))+
	geom_point(size=2, alpha=0.4)+
	geom_text(size=3, hjust=1.05, angle=90, vjust=.5) + 
  	#stat_smooth(method = "gam", formula = y ~ s(x), size = .75, colour="grey", alpha=0.05, se=F)+
  	xlab("Start Year")+
  	expand_limits(y=-1.2) +
  	scale_y_continuous(breaks=seq(0, 1, 1)) + 
  	scale_x_continuous(breaks = round(seq(min(ukmil$Start.Year), max(ukmil$Start.Year), by = 20),1)) + 
  	ylab("Military Experience")+
  	geom_hline(yintercept=0, alpha=.1) +
  	geom_hline(yintercept=1, alpha=.1) +
  	theme_bw() +
  	theme(axis.text.x = element_text(angle=45, vjust=.5), 
  		  panel.grid.major = element_blank(), 
  		  panel.grid.minor = element_blank()) +
  	coord_fixed(ratio=128)

ggsave("media/ukmil.pdf")