library("corrplot")
library("dplyr")
library("tidyr")
library(ggplot2)

data_rice <- read.csv(
  "/project/skresov/tillers/djasrot/Rice_project/Rice_GRIN-Global.csv")


# Convert columns into numeric
data_rice$AMYLOSE <- as.numeric(data_rice$AMYLOSE)
data_rice$`KERNEL.LENGTH.WIDTH.RATIO` <- as.numeric(data_rice$`KERNEL.LENGTH.WIDTH.RATIO`)
data_rice$`LENGTH.OF.KERNEL` <- as.numeric(data_rice$`LENGTH.OF.KERNEL`)
data_rice$`SALT.TOLERANCE` <- as.numeric(data_rice$`SALT.TOLERANCE`)
data_rice$`WIDTH.OF.KERNEL` <- as.numeric(data_rice$`WIDTH.OF.KERNEL`)


traits_rice <- c(
  "AMYLOSE",
  "KERNEL.LENGTH.WIDTH.RATIO",
  "LENGTH.OF.KERNEL",
  "WIDTH.OF.KERNEL",
  "SALT.TOLERANCE"
)

#plot1 - correlation matrix
cm <- cor(data_rice[traits_rice], use = "pairwise.complete.obs", method = "pearson")
corrplot(
  cm,
  method = "circle",
  type   = "lower",
  diag   = FALSE,
  tl.col = "red",
  tl.cex = 0.5,
  addCoef.col = "black",
  number.cex = 0.7,
  mar = c(0,0,2,0),
  title  = "Correlation between traits (Rice-GRIN)",
)

#trying to visualize number of origins in the data file
length(unique(data_rice$ORIGIN))
unique(data_rice$ORIGIN)

#no of origins in usa 
sum(grepl("United States", data_rice$ORIGIN, ignore.case = TRUE))

#plot2 - scatter plot between amylose and kernel length/width ratio
r_val <- cor(data_rice$AMYLOSE, data_rice$`KERNEL.LENGTH.WIDTH.RATIO`, use = "pairwise.complete.obs")

p <- ggplot(data_rice, aes(x = AMYLOSE, y = `KERNEL.LENGTH.WIDTH.RATIO`)) +
  geom_point(color = "blue", alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  annotate("text",
           x = max(data_rice$AMYLOSE, na.rm = TRUE) * 0.95,
           y = max(data_rice$`KERNEL.LENGTH.WIDTH.RATIO`, na.rm = TRUE) * 0.95,
           label = paste0("R = ", round(r_val, 2)),
           size = 5, color = "black", hjust = 1) +  
  theme_minimal(base_size = 13) +
  labs(title = "Scatterplot: Amylose vs kernel length/width ratio",
       x = "Amylose Content",
       y = "Kernel Length/Width Ratio") +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
        plot.title = element_text(hjust = 0.5, face = "bold"))

ggsave("scatter_amylose_vs_ratio_v2.pdf", p, width = 8, height = 6, dpi = 300)

  
