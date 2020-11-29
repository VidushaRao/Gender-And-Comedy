library(dplyr)
library(ggplot2)

#read in data
comedy = read.csv("C:\\Users\\Vidusha\\Documents\\MSA\\SideProjectIdeas\\comedy\\ccp_updated.csv")

#plot overall data split by gender
ggplot(data = comedy, aes(x = Gender, y = user_rating, color = Gender, fill = Gender)) +
  geom_boxplot() +
  scale_color_manual(values = c("black", "black")) +
  scale_fill_manual(values = c("red", "blue")) +
  stat_summary(fun = mean, geom = 'point') +
  ggtitle('Boxplots Comparing User Ratings between Male and Female Comedians') +
  labs(x = 'Gender of Comedian', y = 'Average User Rating')

#read in timeperiod indicator data
sascomedy = read.csv('C:\\Users\\Vidusha\\Documents\\MSA\\SideProjectIdeas\\comedy\\SasComedy.csv')

#subset by time period
group1 = sascomedy[which(sascomedy$timezone == '1'),]
group2 = sascomedy[which(sascomedy$timezone == '2'),]
group2 = sascomedy[which(sascomedy$Gender != ''),]

#group 1 plto
ggplot(data = group1, aes(x = Gender, y = user_rating, color = Gender, fill = Gender)) +
  geom_boxplot() +
  scale_color_manual(values = c("black", "black")) +
  scale_fill_manual(values = c("red", "blue")) +
  stat_summary(fun = mean, geom = 'point') +
  ggtitle('Boxplots Comparing User Ratings between Male and Female Comedians in Group 1') +
  labs(x = 'Gender of Comedian', y = 'Average User Rating')

# group 2 plot
ggplot(data = group2, aes(x = Gender, y = user_rating, color = Gender, fill = Gender)) +
  geom_boxplot() +
  scale_color_manual(values = c("black", "black")) +
  scale_fill_manual(values = c("red", "blue")) +
  stat_summary(fun = mean, geom = 'point') +
  ggtitle('Boxplots Comparing User Ratings between Male and Female Comedians in Group 2') +
  labs(x = 'Gender of Comedian', y = 'Average User Rating')

# combined bar chart
gender = c('Male','Female','Male','Female')
group = c('1998 to 2006','1998 to 2006','2006 to 2011','2006 to 2011')
rating = c(7.146,6.005,6.553,6.312)

timezonedf = data.frame(gender,group,rating)
timezonedf = timezonedf[order(timezonedf$group),]

ggplot(data = timezonedf, aes(x = group, y = rating, fill = gender)) +
  geom_bar(stat = 'identity', position='dodge') +
  scale_color_manual(values = c("black", "black")) +
  scale_fill_manual(values = c("red", "blue")) +
  ggtitle('Rating Difference by Gender for each Time Group') +
  labs(x = 'Time Group', y = 'Average Episode Rating')
