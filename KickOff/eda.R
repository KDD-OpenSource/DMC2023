library("data.table")
library("mlr3data")
library("ggplot2")


data("titanic")


# There already was preprocessing of the data:
# - Passenger class "pclass" has been converted to an ordered factor.
# - Features "sex" and "embarked" have been converted to factors.
# - Empty strings in "cabin" and "embarked" have been encoded as missing values.

summary(titanic)


train <- subset(titanic, !is.na(survived))
test <- subset(titanic, is.na(survived))




# Erstellen eines Boxplots von Alter und Geschlecht
ggplot(titanic, aes(x = sex, y = age, fill = sex)) +
  geom_boxplot() +
  labs(x = "Sex", y = "Age", title = "Boxplot of Age by Sex")

# Erstellen eines Balkendiagramms von Überlebensrate und Geschlecht
ggplot(titanic, aes(x = survived, fill = sex)) +
  geom_bar() +
  labs(x = "Survived", y = "Count", title = "Survival Count by Sex")


# Erstellen eines Balkendiagramms von Überlebensrate und Geschlecht
ggplot(titanic, aes(x = survived, fill = embarked)) +
  geom_bar() +
  labs(x = "Survived", y = "Count", title = "Survival Count by Embarked")

# Erstellen eines Balkendiagramms von Überlebensrate und Klasse
ggplot(titanic, aes(x = survived, fill = pclass)) +
  geom_bar() +
  labs(x = "Survived", y = "Count", title = "Survival Count by Embarked")
# In Zahlen:
aggregate(2- as.numeric(survived) ~ pclass, data = train, FUN = mean)

# Ueberlebensrate von survived und sib_sp
aggregate(2- as.numeric(survived) ~ sib_sp, data = train, FUN = mean)
table(train$sib_sp)
# Ueberlebensrate von survived und parents and children aboard
aggregate(2- as.numeric(survived) ~ parch, data = train, FUN = mean)
table(train$parch)

# Ticketpreis nach Klasse
aggregate(fare ~ pclass, data = train, FUN = mean)
table(train$parch)



train$ticket

# Anteil NA in Ticket
mean(is.na(train$cabin))


train$titel <- factor(trimws(gsub(".*,(.*)\\..*", "\\1", train$name)))

ggplot(train, aes(x = titel, y = age, fill = titel)) +
  geom_boxplot() +
  labs(x = "Title", y = "Age", title = "Boxplot of Age by Title")

table(train$titel[is.na(train$age)])


