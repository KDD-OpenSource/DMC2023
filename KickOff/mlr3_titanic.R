# see also: https://mlr-org.com/gallery/pipelines/2020-04-27-mlr3pipelines-Imputation-titanic/
library(mlr3verse)

# load data
data("titanic", package = "mlr3data")
task = as_task_classif(titanic, target = "survived", positive = "yes")
task
task$head()



# some rows have missing labels
table(task$truth(), useNA = "ifany")
ids = task$row_ids[which(is.na(task$truth()))]
task$set_row_roles(ids, "holdout")

# feature types
task$feature_types
summary(task)

autoplot(task)
autoplot(task$clone()$select(c("sex", "age")), type = "pairs")


# PipeOp (part of pipeline) to drop all string columns
po_drop_strings = po("select", selector = selector_invert(selector_type("character")))

# PipeOp to mutate features - here used for feature extraction from strings
library("stringi")
po_fe = po("mutate", mutation = list(
  fare_per_person = ~ fare / (parch + sib_sp + 1),
  deck = ~ factor(stri_sub(cabin, 1, 1)), # first letter of cabin
  title = ~ factor(stri_match(name, regex = ", (.*)\\.")[, 2]), # part between ';' and '.'
  surname = ~ factor(stri_match(name, regex = "(.*),")[, 2]), # part before ','
  ticket_prefix = ~ factor(stri_replace_all_fixed(stri_trim(stri_match(ticket, regex = "(.*) ")[, 2]), ".", ""))
))

# Pipeline w/o feature engineering
preproc1 = po_drop_strings %>>% ppl("robustify")
preproc2 = po_fe %>>% preproc1

plot(preproc1)
# compare classification tree with random random forest
# investigate influence of feature extraction
learner1 = as_learner(preproc1 %>>% lrn("classif.rpart"))
learner1$id = "tree"
learner2 = as_learner(preproc2 %>>% lrn("classif.rpart"))
learner2$id = "fe+tree"
learner3 = as_learner(preproc1 %>>% lrn("classif.ranger"))
learner3$id = "forest"
learner4 = as_learner(preproc2 %>>% lrn("classif.ranger"))
learner4$id = "fe+forest"

set.seed(123)
bmr = benchmark(benchmark_grid(task, list(learner1, learner2, learner3, learner4), rsmp("cv", folds = 3)))
bmr$aggregate()
autoplot(bmr)
