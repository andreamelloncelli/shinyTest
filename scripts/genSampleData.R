data_summary(historydata)

saveRDS(historydata_day, "data/historydata_day.Rds")
saveRDS(channel_d, "data/channel.Rds")
saveRDS(customer_d, "data/customer.Rds")

historydata <- readRDS( "data/historydata_day.Rds" )
channel     <- readRDS( "data/channel.Rds"  )
customer    <- readRDS( "data/customer.Rds" )

