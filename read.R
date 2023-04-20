library(data.table)

train_val = fread(file.path("data", "train_values.csv"),
                  stringsAsFactors = TRUE)
train_lab = fread(file.path("data", "train_labels.csv"),
                  stringsAsFactors = TRUE)
train = merge(train_val, train_lab)
summary(train)
