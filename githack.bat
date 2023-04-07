REM Starting Instructions
REM Initialize an empty git repository at a back date by changing the time
REM Change the Directory, to this Repo Folder
REM While doing all of these, disconnect from internet, until you want to publish your repo

@echo off

setlocal enableextensions enabledelayedexpansion

REM Make sure that the format for Days is dd-mm-yyyy
REM Change the start date here
date 01-01-2022

REM Change the location to an Empty folder where you want to create a local git repo
cd C:\Users\Username\RepoName
git init

REM Get the current date
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set "dt=%%G"
set "year=%dt:~0,4%"
set "month=%dt:~4,2%"
set "day=%dt:~6,2%"

REM Set the number of days to iterate
set "num_days=365"

REM Loop through the specified number of days
for /l %%i in (1,1,%num_days%) do (

  REM Get the maximum number of days for the current month
  if !month! equ 2 (
    REM Check if the current year is a leap year
    set /a "leap_year=year %% 4"
    if !leap_year! equ 0 (
      set "max_days=29"
    ) else (
      set "max_days=28"
    )
  ) else if !month! equ 4 (
    set "max_days=30"
  ) else if !month! equ 6 (
    set "max_days=30"
  ) else if !month! equ 9 (
    set "max_days=30"
  ) else if !month! equ 11 (
    set "max_days=30"
  ) else (
    set "max_days=31"
  )

  REM Increase the day by one
  set /a "day+=1"

  REM Check if the day is greater than the maximum number of days in the current month
  if !day! gtr !max_days! (
    REM Set the day to 1 and increase the month by one
    set "day=01"
    set /a "month+=1"
    
    REM Check if the month is greater than 12
    if !month! gtr 12 (
      REM Set the month to 1 and increase the year by one
      set "month=01"
      set /a "year+=1"
    )
  )

  REM Set the new date
  set "newdate=!day!-!month!-!year!"
  echo !newdate!
  
  REM Set the system date to the new date
  date !newdate!
  
  REM Write the new date to a file
  REM change the Directory Accordingly
  echo %newdate% >> C:\Users\Username\RepoName\dates.txt
  
  REM Save the file
  echo Dates updated >> C:\Users\Username\RepoName\dates.txt

  REM 3 refers to 3 iteration, change it to any number of commits you want
  for /l %%i in (1,1,3) do (
  cd C:\Users\Username\RepoName
  git stage . &&  git commit -m "Changes"
  )
)

REM Add your final operation here
pause