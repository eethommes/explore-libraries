#' ---
#' output: github_document
#' ---

#' 31 January 2018 - 01 February 2018
#' What They Forgot to Teach You About R, Jenny Bryan
#' RStudio Conference
#' Link to materials: rstd.io/forgot

# ---------------------------------------------------------------
# EXERCISE 1: EXPLORE LIBRARIES
# The following code pulls up a dropbox to this course which
# contains three files. All three files have the same objective, 
# but the code supplied within is for the advanced user 
# ("Spartan"),intermediate ("Comfy"), or beginner ("Jenny"). 
# install.packages("usethis")
library(usethis)
use_course("rstd.io/forgot_1")
# ---------------------------------------------------------------

# THE JIST of EXERCISE 1

# default library where packages live
.Library 

# all libraries for current sesssion
.libPaths() 

# wait, are thoe two locations the same? 
# install.packages("fs") #fs == file system
library(fs)
path_real(.Library)

# all installed packages
installed.packages()

# we can use tidyverse to summarize installed packaged in various ways
library(tidyverse)
ipt <- installed.packages() %>% as_tibble() 
View(ipt)

# how many total packages are there?
nrow(ipt) 

# how many packages by libpath and priority?
ipt %>% count(LibPath, Priority) 

# what proportion of the packages need compilation?
ipt %>% count(NeedsCompilation) %>% mutate(prop = n / sum(n))

# what proportion of the packages were built in which versions?
ipt %>% count(Built) %>% mutate(prop = n / sum(n))

## is every package in .Library either base or recommended?
all_default_pkgs <- list.files(.Library)
all_br_pkgs <- ipt %>%
  filter(Priority %in% c("base", "recommended")) %>%
  pull(Package)
setdiff(all_default_pkgs, all_br_pkgs)

## study package naming style (all lower case, contains '.', etc

## use `fields` argument to installed.packages() to get more info and use it!
ipt2 <- installed.packages(fields = "URL") %>%
  as_tibble()
ipt2 %>%
  mutate(github = grepl("github", URL)) %>%
  count(github) %>%
  mutate(prop = n / sum(n))

# ---------------------------------------------------------------
# EXERCISE 2: FILE SYSTEMS
# The deal as exercise 1, now for exercise 2. 
use_course("rstd.io/forgot_2")
# ---------------------------------------------------------------

# THE JIST of EXERCISE 2

list.files("~/Desktop/day1_s1_explore-libraries")
list.files("~/Desktop/day1_s1_explore-libraries", pattern = "\\.R$")
list.files(
  "~/Desktop/day1_s1_explore-libraries",
  pattern = "\\.R$",
  full.names = TRUE
)
(from_files <- list.files(
  "~/Desktop/day1_s1_explore-libraries",
  pattern = "\\.R$",
  full.names = TRUE
)) #so cool, adding extra set of parentheses around assignment statement prints out the new object!
(to_files <- basename(from_files))
file.copy(from_files, to_files)

list.files()

#issue here for me b/c i'm in the Rproj I started yesterday. Need to revisit.

## Clean it out, so we can refine ----
file.remove(to_files)
list.files()

## Copy again, tighter code ----
from_dir <- file.path("~", "Desktop", "day1_s1_explore-libraries")
from_files <- list.files(from_dir, pattern = "\\.R$", full.names = TRUE)
to_files <- basename(from_files)
file.copy(from_files, to_files)
list.files()

## Clean it out, so we can use fs ----
file.remove(to_files)
list.files()

## Copy again, using fs ----
library(fs)
(from_dir <- path_home("Desktop", "day1_s1_explore-libraries"))
(from_files <- dir_ls(from_dir, glob = "*.R"))
(to_files <- path_file(from_files))
(out <- file_copy(from_files, to_files))
dir_ls()
dir_info()

## Sidebar: Why does Jenny name files this way? ----
library(tidyverse)
library(stringr)

(ft <- tibble(files = dir_ls(glob = "*.R")))

ft %>%
  filter(str_detect(files, "explore"))

ft %>%
  mutate(files = path_ext_remove(files)) %>%
  separate(files, into = c("i", "topic", "flavor"), sep = "_")

dirs <- dir_ls(path_home("Desktop"), type = "directory")
(dt <- tibble(dirs = path_file(dirs)))
dt %>%
  separate(dirs, into = c("day", "session", "topic"), sep = "_")

## Principled use of delimiters --> meta-data can be recovered from filename

## Clean it out, so we reset for workshop ----
file_delete(to_files)
dir_ls()