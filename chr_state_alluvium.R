library(ggalluvial)
library(ggplot2)
state5 <- read.csv("/path/to/Chr_state/five.stage.chr.stage.csv",header = 1, sep="\t")
state5$state <- as.character(state5$state)
head(state5)
brewer.pal(n = 4, name = "PuOr")
# color to use PuOr "#E66101" "#FDB863" "#B2ABD2" "#5E3C99"
ggplot(state5, aes(x=Stage, stratum = state, alluvium = Bin, fill = state, label = state)) +
  geom_flow(color = "grey", alpha = .8) + geom_stratum(alpha = .8) +
  geom_text(stat = "stratum", size = 3) + scale_fill_manual(values = c("#E66101", "#FDB863", "#B2ABD2", "#5E3C99"))+
  theme(legend.position = "none", axis.text.y = element_blank())+theme_void()
