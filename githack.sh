#!/bin/bash

set -e

# Make sure that the format for Days is dd-mm-yyyy
# Change the start date here
date 01-01-2022

# Change the location to an Empty folder where you want to create a local git repo
cd /path/to/repo/folder
git init

# Get the current date
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set "dt=%%G"
set "year=%dt:~0,4%"
set "month=%dt:~4,2%"
set "day=%dt:~6,2%"

# Set the number of days to iterate
set "num_days=365"

# Loop through the specified number of days
for /l %%i in (1,1,%num_days%) do {

  # Get the maximum number of days for the current month
  if !month! equ 2 {
    # Check if the current year is a leap year
    set /a "leap_year=year %% 4"
    if !leap_year! equ 0 {
      set "max_days=29"
    } else {
      set "max_days=28"
    }
  } else if !month! equ 4 {
    set "max_days=30"
  } else if !month! equ 6 {
    set "max_days=30"
  } else if !month! equ 9 {
    set "max_days=30"
  } else if !month! equ 11 {
    set "max_days=30"
  } else {
    set "max_days=31"
  }

  # Increase the day by one
  set /a "day+=1"

  # Check if the day is greater than the maximum number of days in the current month
  if !day! gtr !max_days! {
    # Set the day to 1 and increase the month by one
    set "day=01"
    set /a "month+=1"
    
    # Check if the month is greater than 12
    if !month! gtr 12 {
      # Set the month to 1 and increase the year by one
      set "month=01"
      set /a "year+=1"
    }
  }

  # Set the new date
  set "newdate=!day!-!month!-!year!"
  
  # Set the system date to the new date
  date !newdate!
  
  # Write the new date to a file
  echo %newdate% >> /path/to/repo/folder/dates.txt
  
  # Save the file
  echo Dates updated >> /path/to/repo/folder/dates.txt

  # 3 refers to 3 iteration, change it to any number of commits you want
  for /l %%i in (1,1,3) do {
    cd /path/to/repo/folder
    git stage . && git commit -m "Changes"
  }
}

# Add your final operation here
pause
