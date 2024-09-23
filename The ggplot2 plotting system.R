library(tidyverse)
## ------------------------------------------------------------------------------------------------------------------------
#| message: false
library("tidyverse")
library("here")

#look at the data quickly by reading it in as a tibble with read_csv() in the tidyverse package.
maacs <- read_csv(here("data", "bmi_pm25_no2_sim.csv"),
                  col_types = "nnci"
)
maacs


## ------------------------------------------------------------------------------------------------------------------------
#The outcome we will look at here (NocturnalSymp)
#is the number of days in the past 2 weeks where the child
#experienced asthma symptoms (e.g. coughing, wheezing) while sleeping.

#The other key variables are:

# logpm25: average level of PM2.5 over the course of 7 days (micrograms per cubic meter) on the log scale

#logno2_new: exhaled nitric oxide on the log scale

#bmicat: categorical variable with BMI status

g <- ggplot(maacs, aes(
  x = logpm25,
  y = NocturnalSympt
))
summary(g)
class(g)
print(g)


## ------------------------------------------------------------------------------------------------------------------------
#| fig-cap: "Nothing to see here!"
g <- maacs %>%
  ggplot(aes(logpm25, NocturnalSympt))
print(g)


## ------------------------------------------------------------------------------------------------------------------------
#| fig-cap: "Scatterplot of PM2.5 and days with nocturnal symptoms"
#To make a scatter plot, we need add at least one geom, such as points.

#Here, we add the geom_point() function to create a traditional scatter plot.

g <- maacs %>%
  ggplot(aes(logpm25, NocturnalSympt))
g + geom_point()


## ------------------------------------------------------------------------------------------------------------------------
#| fig-cap: "Scatterplot with smoother"
#| message: false
g +
  geom_point() +
  geom_smooth()


## ------------------------------------------------------------------------------------------------------------------------
#smooth
#Because the data appear rather noisy, it might be better if we added a
#smoother on top of the points to see if there is a trend in the data with PM2.5.
#| fig-cap: "Scatterplot with linear regression line"
#| message: false
g +
  geom_point() +
  geom_smooth(method = "lm")


## ------------------------------------------------------------------------------------------------------------------------
# try it yourself

library("palmerpenguins")
penguins


## ------------------------------------------------------------------------------------------------------------------------
#We want one row and two columns, one column for each weight category.
#So we specify bmicat on the right hand side of the forumla
#passed to facet_grid().

#In this example we only want to see things by bmi category
#normal weight and overweight panels are the categories
#no association btwn normal weight and logpm25
#but there is an association between overweight and logpm25
#This plot suggests that overweight individuals may be more susceptible to the effects of PM2.5.
#see the upward trend looking at blue line

#| fig-width: 9
#| fig-cap: "Scatterplot of PM2.5 and nocturnal symptoms by BMI category"
#| message: false
g +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_grid(. ~ bmicat)


## ------------------------------------------------------------------------------------------------------------------------
##map aesthetics to constants
#For example, here we modify the points in the scatterplot
#to make the color “steelblue”, the size larger, and the alpha transparency greater.
#darker blue tells us we have at least 2 points in an area/data point
# this is the use of alpha 1/2
#also increased size of the point circles
#you can google r color names
#| fig-cap: "Modifying point color with a constant"
g + geom_point(color = "steelblue", size = 4, alpha = 1 / 2)


## ------------------------------------------------------------------------------------------------------------------------
#map aesthetics to variables
#In addition to setting specific geom attributes to constant values,
#we can map aesthetics to variables in our dataset.

#For example, we can map the aesthetic color to the variable bmicat,
#so the points will be colored according to the levels of bmicat.

#We use the aes() function to indicate this difference from the plot above.

#| fig-cap: "Mapping color to a variable"
g + geom_point(aes(color = bmicat), size = 4, alpha = 1 / 2)

#can also use
ggplot(maacs, aes(
  x = logpm25,
  y = NocturnalSympt,
  color - bmicat
)) + geom_point(size =4, alpha = 1/2)
## ------------------------------------------------------------------------------------------------------------------------
#Customizing the smooth
#We can also customize aspects of the geoms.
#For example, we can customize the smoother that we overlay
#on the points with geom_smooth().

#Here we change the line type and increase the size from the default.
#We also remove the shaded standard error from the line.
#se is the stadard error
# can change line type and line width
#| fig-cap: "Customizing a smoother"
#| message: false
g +
  geom_point(aes(color = bmicat),
             size = 2,
             alpha = 1 / 2
  ) +
  geom_smooth(
    linewidth = 1,
    linetype = 2,
    method = "lm",
    se = FALSE
  )


## ------------------------------------------------------------------------------------------------------------------------
# Changing the theme
#The default theme for ggplot2 uses the gray background with white grid lines.

#If you don’t find this suitable, you can use the black and white theme
#by using the theme_bw() function.

#The theme_bw() function also allows you to set the typeface for the plot,
#in case you don’t want the default Helvetica. Here we change the typeface to Times.
#you can find themes apropos("theme")
#default is "theme_gray"

#| fig-cap: "Modifying the theme for a plot"
g +
  geom_point(aes(color = bmicat)) +
  theme_bw(base_family = "Times")

g2 <- g +  geom_point(aes(color = bmicat)) +
  theme_gray(base_family = "Times")


## ------------------------------------------------------------------------------------------------------------------------
# try it yourself

library("palmerpenguins")
penguins

penguins %>%
  ggplot(mapping = aes(x = flipper_length_mm, y = bill_length_mm, color = species)) + geom_point() + geom
## ------------------------------------------------------------------------------------------------------------------------
#| fig-cap: "Modifying plot labels"
# labs change label names
#expression with [2.5] shows subscript
#changing key is the legend
g +
  geom_point(aes(color = bmicat)) +
  labs(title = "MAACS Cohort") +
  labs(
    x = expression("log " * PM[2.5]),
    y = "Nocturnal Symptoms"
  )
#changing the legend title
g +
  geom_point(aes(color = bmicat)) +
  labs(title = "MAACS Cohort") +
  labs(
    x = expression("log " * PM[2.5]),
    y = "Nocturnal Symptoms",
    color = "BMI category"
  )

## ------------------------------------------------------------------------------------------------------------------------
#A quick aside about axis limits
#One quick quirk about ggplot2 that caught me up when
#I first started using the package can be displayed in the following example.

#If you make a lot of time series plots,
#you often want to restrict the range of the y-axis
#while still plotting all the data.
#like a crazy outlier

#In the base graphics system you can do that as follows.

#| fig-cap: "Time series plot with base graphics"

g testdat <- data.frame(
  x = 1:100,
  y = rnorm(100)
)

testdat[50, 2] <- 100 ## Outlier!
plot(testdat$x,
     testdat$y,
     type = "l",
     ylim = c(-3, 3)
)


## ------------------------------------------------------------------------------------------------------------------------
#| fig-cap: "Time series plot with default settings"
g <- ggplot(testdat, aes(x = x, y = y))
g + geom_line()


## ------------------------------------------------------------------------------------------------------------------------
#| fig-cap: "Time series plot with modified ylim"
g +
  geom_line() +
  ylim(-3, 3)

## Install bbplot
remotes::install_github("bbc/bbplot")

## ------------------------------------------------------------------------------------------------------------------------
#| fig-cap: "Time series plot with restricted y-axis range"
g +
  geom_line() +
  coord_cartesian(ylim = c(-3, 3))


## ------------------------------------------------------------------------------------------------------------------------
#| eval: false
## ## Install bbplot
## remotes::install_github("bbc/bbplot")


## ------------------------------------------------------------------------------------------------------------------------
#| message: false
#| fig-width: 13
## Basic ggplot2 object with our data
g <- maacs %>%
  ggplot(aes(logpm25, NocturnalSympt))

## A plot we made before, but this time without the SE lines
g +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_grid(. ~ bmicat)

## Now let's add bbplot::bbc_style()
g +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_grid(. ~ bmicat) +
  bbplot::bbc_style()


## ------------------------------------------------------------------------------------------------------------------------
#| message: false
#| fig-width: 13
g +
  geom_point() +
  geom_smooth(colour = "#1380A1", method = "lm", se = FALSE) +
  facet_grid(. ~ bmicat) +
  bbplot::bbc_style() +
  labs(
    title = "Child asthma's link to air quality worsens in overweight children",
    subtitle = "Number of days with symptoms vs PM2.5 by weight group"
  )


## ------------------------------------------------------------------------------------------------------------------------
#use color to show differences in groups

#| message: false
#| fig-width: 13
g +
  geom_smooth(aes(colour = bmicat), method = "lm", se = FALSE, linewidth = 2) +
  scale_colour_manual(values = c("#FAAB18", "#1380A1")) +
  bbplot::bbc_style() +
  labs(
    title = "Child asthma's link to air quality worsens in overweight children",
    subtitle = "Number of days with symptoms vs PM2.5 by weight group"
  )


## ------------------------------------------------------------------------------------------------------------------------
#| eval: false
## ## Install ThemePark from GitHub
## remotes::install_github("MatthewBJane/theme_park")


## ------------------------------------------------------------------------------------------------------------------------
#| message: false
#| fig-width: 13
## Barbie-inspired theme
g +
  geom_smooth(aes(colour = bmicat), method = "lm", se = FALSE, linewidth = 2) +
  scale_colour_manual(values = c("#FAAB18", "#1380A1")) +
  ThemePark::theme_barbie() +
  labs(
    title = "Child asthma's link to air quality worsens in overweight children",
    subtitle = "Number of days with symptoms vs PM2.5 by weight group"
  )

## Oppenheimer-inspired theme
g +
  geom_smooth(aes(colour = bmicat), method = "lm", se = FALSE, linewidth = 2) +
  scale_colour_manual(values = c("#FAAB18", "#1380A1")) +
  ThemePark::theme_oppenheimer() +
  labs(
    title = "Child asthma's link to air quality worsens in overweight children",
    subtitle = "Number of days with symptoms vs PM2.5 by weight group"
  )


## ------------------------------------------------------------------------------------------------------------------------
#| eval: false
## ## Install ggthemes from CRAN
## install.packages("ggthemes")


## ------------------------------------------------------------------------------------------------------------------------
#| message: false
## Your favorite statistics class theme ;)
## I bet that you could fool a few people into thinking
## that you are not using R ^_^'
g +
  geom_smooth(aes(colour = bmicat), method = "lm", se = FALSE, linewidth = 2) +
  scale_colour_manual(values = c("#FAAB18", "#1380A1")) +
  ggthemes::theme_stata() +
  labs(
    title = "Child asthma's link to air quality worsens in overweight children",
    subtitle = "Number of days with symptoms vs PM2.5 by weight group"
  )


## ------------------------------------------------------------------------------------------------------------------------
#| message: false
## Save our plot into an object
g_complete <- g +
  geom_point(aes(colour = bmicat)) +
  geom_smooth(aes(colour = bmicat), method = "lm", se = FALSE, linewidth = 2) +
  scale_colour_manual(values = c("#FAAB18", "#1380A1"))

## Make it interactive with plotly::ggplotly()
plotly::ggplotly((g_complete))


## ------------------------------------------------------------------------------------------------------------------------
#| eval: false
## ## Install colorblindr from GitHub
## remotes::install_github("clauswilke/colorblindr")


## ------------------------------------------------------------------------------------------------------------------------
#| message: false
colorblindr::cvd_grid(g_complete)


## ------------------------------------------------------------------------------------------------------------------------
cutpoints <- quantile(maacs$logno2_new, seq(0, 1, length = 4), na.rm = TRUE)


## ------------------------------------------------------------------------------------------------------------------------
maacs$no2tert <- cut(maacs$logno2_new, cutpoints)


## ------------------------------------------------------------------------------------------------------------------------
## See the levels of the newly created factor variable
levels(maacs$no2tert)


## ----fig.cap="PM2.5 and nocturnal symptoms by BMI category and NO2 tertile",fig.width=9, fig.height=5--------------------
## Setup ggplot with data frame
g <- maacs %>%
  ggplot(aes(logpm25, NocturnalSympt))

## Add layers
g + geom_point(alpha = 1 / 3) +
  facet_grid(bmicat ~ no2tert) +
  geom_smooth(method = "lm", se = FALSE, col = "steelblue") +
  theme_bw(base_family = "Avenir", base_size = 10) +
    labs(x = expression("log " * PM[2.5])) +
    labs(y = "Nocturnal Symptoms") +
    labs(title = "MAACS Cohort")


## ------------------------------------------------------------------------------------------------------------------------
options(width = 120)
sessioninfo::session_info()
