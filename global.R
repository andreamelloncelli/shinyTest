
# packages ----------------------------------------------------------------

library(shiny)
# library(DT)
library(DBI)
library(RMySQL)
library(ggplot2)
library(dplyr)
library(dbplyr)
library(lubridate)

# params ------------------------------------------------------------------

db_conn <- list(
	drv      = RMySQL::MySQL(max.con = 16, fetch.default.rec = 500),
	host     = "127.0.0.1",
	dbname   = "test_shiny",
	user     = "root",
	password = "toor",
	port     = 3306
)
dplyr_conn <- list(
	host     = db_conn$host,
	dbname   = db_conn$dbname,
	username = db_conn$user,
	password = db_conn$password,
	port     = 3306
)

if (!exists("dev")) { 
	dplyr_conn$host = "172.30.3.13" 
}

# functions ---------------------------------------------------------------

load_data <- function(conn, tab_name = NULL ) {
	tab_name <- "channel"
	db <- do.call(dbConnect, arg=conn)
	# sql <- paste0("CALL ",.list$procName,"(?id,?lang,?sel,?str);")
	sql <- paste0("SELECT * FROM ", tab_name, ";")
	sql <- sqlInterpolate(db, sql, id = .list$id_table, lang= .list$lang, sel=0,str='')
	tb <- dbGetQuery(db, sql)
	dbDisconnect(db)
	tb
}

as_epoch <-  function(dt) as.integer(dt) # from datetime

data_get <- function(tbl, from, to) {
	from <- as_datetime(from) %>% as_epoch
	to   <- as_datetime(to) %>% as_epoch
	tbl %>%
		filter( from < time, time < to ) %>% 
		collect %>% 
		mutate( time = as_datetime(time) )
}

time_range <- function(tbl) {
	historydata_stat <- 
		tbl %>% 
		summarize_all(funs(min, max)) %>%
		collect %>% 
		mutate_at( vars(starts_with("time_")), funs(as_datetime) )
	historydata_stat %>% 
		select(starts_with("time_"))
}

# initialization ----------------------------------------------------------
local = T
if (local) {
	historydata <- readRDS( "data/historydata_day.Rds" )
	channel     <- readRDS( "data/channel.Rds"  )
	customer    <- readRDS( "data/customer.Rds" )
} else {
	con     <- do.call(src_mysql, dplyr_conn)
	channel     <- tbl(con, "channel")
	customer    <- tbl(con, "customer")
	historydata <- tbl(con, "historydata")
}

