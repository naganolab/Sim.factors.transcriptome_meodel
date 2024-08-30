# --args [start] [end] [attr] [weather] [exp] [weight] [outdir]

# library(FIT)
requireNamespace('FIT')

# parse args
args <- commandArgs(trailingOnly = T)
# args <- c('1', '2',
#           "attribute_150930_TuMV01_converted_woGC",
#           "weather_150526_new_woGC",
#           "150524-3_rpm_Ahg_converted_woGC_log2",
#           "150724-1_voom_weights_woGC"
# )

# file.attribute.train  <- args[1]
# file.weather.train    <- args[2]
# file.expression.train <- args[3]
# file.weights.train    <- args[4]

file.attribute.predi  <- args[1]
file.weather.predi    <- args[2]
# file.expression.predi <- args[3]
file.genes <- args[3]
file.models <- args[4]

prediction.file <- args[5]
tmp.dir <- tempdir()

tmp.attribute <- paste(tmp.dir, "at", sep = "/")
tmp.weather   <- paste(tmp.dir, "weather", sep = "/")

load(file.genes)
load(file.models)

# 前バージョンでは、typeがN8という表記だった。その違いを吸収する。
load(file.attribute.predi)
colnames(at)[match("N8", colnames(at))] <- "type"

# # 時刻の通し番号をずらす
# at[, 1] <- at[, 1]+(60*24*90)

save(at, file=tmp.attribute)
rm(at)

# weatherに、'radiation', 'temperature', 'wind', 'humidity', 'atmosphere', 'precipitation'のすべてのカラムがないとエラーになる
# ない場合はランダムな数値を入れておく
load(file.weather.predi)
if(!"radiation" %in% colnames(weather)){
  weather[["radiation"]] <- rnorm(nrow(weather), mean = 30, sd = 5)
}
if(!"temperature" %in% colnames(weather)){
  weather[["temperature"]] <- rnorm(nrow(weather), mean = 30, sd = 5)
}
if(!"wind" %in% colnames(weather)){
  weather[["wind"]] <- rnorm(nrow(weather), mean = 30, sd = 5)
}
if(!"humidity" %in% colnames(weather)){
  weather[["humidity"]] <- rnorm(nrow(weather), mean = 30, sd = 5)
}
if(!"atmosphere" %in% colnames(weather)){
  weather[["atmosphere"]] <- rnorm(nrow(weather), mean = 30, sd = 5)
}
if(!"precipitation" %in% colnames(weather)){
  weather[["precipitation"]] <- rnorm(nrow(weather), mean = 30, sd = 5)
}
save(weather, file=tmp.weather)
rm(weather)


# パラメータ空間の格子点を設定
grid.coords <- list(
  env.wind.threshold = c(1, 3, 5, 7, 9),
  env.wind.amplitude = c(-5, 5),
  env.temperature.threshold = c(10, 15, 20, 25, 30),
  env.temperature.amplitude = c(-5, 5),
  env.humidity.threshold = c(50, 60, 70, 80, 90),
  env.humidity.amplitude = c(-5, 5),
  env.atmosphere.threshold = c(995, 1000, 1005, 1010, 1015),
  env.atmosphere.amplitude = c(-5, 5),
  env.precipitation.threshold = c(0.1),
  env.precipitation.amplitude = c(-5, 5),
  env.radiation.threshold = c(1, 10, 20, 30, 40),
  env.radiation.amplitude = c(-5, 5),
  env.wind.period = c(10, 30, 90, 270, 720, 1440, 1440*3),
  env.temperature.period = c(10, 30, 90, 270, 720, 1440, 1440*3),
  env.humidity.period = c(10, 30, 90, 270, 720, 1440, 1440*3),
  env.atmosphere.period = c(10, 30, 90, 270, 720, 1440, 1440*3),
  env.precipitation.period = c(10, 30, 90, 270, 720, 1440, 1440*3),
  env.radiation.period = c(10, 30, 90, 270, 720, 1440, 1440*3),
  gate.wind.phase = seq(0, 23*60, 1*60),
  gate.temperature.phase = seq(0, 23*60, 1*60),
  gate.humidity.phase = seq(0, 23*60, 1*60),
  gate.atmosphere.phase = seq(0, 23*60, 1*60),
  gate.precipitation.phase = seq(0, 23*60, 1*60),
  gate.radiation.phase = seq(0, 23*60, 1*60),
  gate.wind.threshold = cos(pi*seq(4,24,4)/24),
  gate.temperature.threshold = cos(pi*seq(4,24,4)/24),
  gate.humidity.threshold = cos(pi*seq(4,24,4)/24),
  gate.atmosphere.threshold = cos(pi*seq(4,24,4)/24),
  gate.precipitation.threshold = cos(pi*seq(4,24,4)/24),
  gate.radiation.threshold = cos(pi*seq(4,24,4)/24),
  gate.wind.amplitude = c(-5, 5),
  gate.temperature.amplitude = c(-5, 5),
  gate.humidity.amplitude = c(-5, 5),
  gate.atmosphere.amplitude = c(-5, 5),
  gate.precipitation.amplitude = c(-5, 5),
  gate.radiation.amplitude = c(-5, 5)
)

# load training data
# print('### Load train data')
# training.attribute  <- FIT::load.attribute(file.attribute.train, 'at');
# training.weather    <- FIT::load.weather(file.weather.train, 'wt')
# training.expression <- FIT::load.expression(file.expression.train, 'rpm_log2', genes)
# training.weights <- FIT::load.weight(file.weights.train, 'weights', genes)

################
### training ###
################
# print('### Make recipe')
# recipe <- FIT::make.recipe(training.weather$entries,
#                                          init  = 'gridsearch',
#                                          optim = c('lm'),
#                                          fit   = 'fit.lasso',
#                                          init.data = grid.coords,
#                                          time.step = 1)

# print('### Make model')
# models <- FIT::train(training.expression,
#                                    training.attribute,
#                                    training.weather,
#                                    recipe,
#                                    training.weights)

# models.selected <- models[genes]
# models.selected.env <- as.list(NULL)
# for(model in models.selected){
#   geneid <- model[[1]]$gene
#   env <- model[[1]]$env
#   if (env == "radiation" || env == "temperature") {
#     models.selected.env[[geneid]] <- model
#   }
# }
# models.flatten <- unlist(models.selected.env)
models.flatten <- unlist(models)



# models <- models.selected.env
# save(models, file = "models_selected_by_env_20161013")
rm(models)

##################
### prediction ###
##################
print('### Load prediction data')
prediction.attribute  <- FIT::load.attribute(tmp.attribute, 'at');
prediction.weather    <- FIT::load.weather(tmp.weather, 'weather')
# prediction.expression <- FIT::load.expression(file.expression.predi, 'rpm_log2', genes)

print('### Predict results')
prediction.results <- FIT::predict(models.flatten,
                                                 prediction.attribute,
                                                 prediction.weather)
# print('### Predict errors')
# prediction.errors <- FIT::prediction.errors(models.flatten,
#                                                           prediction.expression,
#                                                           prediction.attribute,
#                                                           prediction.weather)

save(prediction.results, file=prediction.file)

print('DONE!')
