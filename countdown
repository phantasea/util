#!/usr/bin/bash
#
# countdown.sh
#
# Maintain a running count of days, hours, minutes, and seconds until some
# specific date and time. Usage:
#
# countdown.sh "date/time string"
#
# The date/time string is parsed by the 'date' utility, and can be any format
# that utility understands. FOr example:
#
# countdown.sh "dec 18 2024 4:00pm"
#
# Don't forget the quotes around the date/time string. Note that this script
# assumes conventional Linux terminal handling of \r and \n -- it might not
# work with a serial terminal.
#
# Copyright (c)2024 Kevin Boone, GPL v3.0

TARGET_DATE="$1"

# First, let's check whether the user has specified a target date. There is no
#   meaningful default.
if [ -z "$TARGET_DATE" ]; then
  echo "Usage:" $0 "[target_date]"
  exit 1
fi

# Now let's check that the date is valid. This is a bit nasty:
#   we rely on the fact that the 'date' utility will return nothing to
#   stdout on error, which will be parsed as an integer zero. If
#   'date' worked differently, we might need a different approach.
# We end up with TARGET_EPOCH as the target date in seconds since 
#   The Epoch. It doesn't #   matter what the 'Epoch' is in this case -- 
#   it's just some time in the past.
TARGET_EPOCH=`date --date "$TARGET_DATE" +%s`
if (( TARGET_EPOCH == 0 )); then
  exit 1
fi

# Convert the current time to a number of seconds since The Epoch. 
NOW_EPOCH=`date +%s`

# Now let's check that the target date is actually in the future. 
# Subtracting the two epoch dates will give a difference in seconds
EPOCH_DIFF=$(($TARGET_EPOCH - $NOW_EPOCH))

if (( $EPOCH_DIFF <= 0 )); then
  printf "%s: target date %s has passed\n" "$0" "$TARGET_DATE"
  exit 1
fi

# Define a function to clean up and exit. This might happen when the
#   current time reaches the target time, or it might be because the
#   user hits ctrl+c. We need to restore the terminal before exiting
#   the program.
function cleanup_exit() 
  {
  stty echoctl # Show ctrl+c when pressed
  tput cnorm # Show the cursor
  exit 0
  }

# Connect the INT (interrupt) and TERM signals to the cleanup handler.
# It may be necessary in some cases to trap additional signals. However,
# INT and TERM will catch most common ways of killing a program.
trap cleanup_exit INT TERM
stty -echoctl # Prevent ctrl+c being printed when pressed
tput civis # Turn off the cursor

# Now loop until the target time is reached, printing the time difference
#   every second.

while (( EPOCH_DIFF > 0 )); do
  # Split the time in seconds into days, hours, minutes and seconds.
  # This is just basic arithmetic, which can be done entirely within
  #   the Bash shell using arithmetic expansion.
  DAYS=$((EPOCH_DIFF / 86400)) # 86400 = seconds in one day
  DAY_SECS=$((DAYS * 86400))
  REM=$((EPOCH_DIFF - DAY_SECS))
  HOURS=$((REM / 3600))
  HOUR_SECS=$((HOURS * 3600))
  REM=$((EPOCH_DIFF - DAY_SECS - HOUR_SECS))
  MINS=$((REM / 60))
  REM=$((EPOCH_DIFF - DAY_SECS - HOUR_SECS - MINS * 60))
  SECS=$REM

  # Blank the line before printing, so all the output ends up on
  #   one, constantly-changing line, without scrolling.
  # NB. This only works if the terminal responds conventionally to a 
  #   carriage return (by returning to column 1 without line feed).
  printf "                                                                 \r" 
  
  # Note that we need to say 'day' or 'days' according to how many days
  #   it is, and the same for the other values. Is there a more elegant
  #   way than mine? I can't help thinking there must be.
  printf "%d day%.*s, " $DAYS $((DAYS != 1)) "s"
  printf "%d hour%.*s, " $HOURS $((HOURS != 1)) "s"
  printf "%d minute%.*s, " $MINS $((MINS != 1)) "s"
  printf "%d second%.*s\r" $SECS $((SECS != 1)) "s"

  # Recalculate the time difference and go around again.
  NOW_EPOCH=`date +%s`
  EPOCH_DIFF=$(($TARGET_EPOCH - $NOW_EPOCH))

  sleep 1
done

# We are done. We must print a line feed first, because the running count
#   did not do so.
printf "\nThe time has arrived!\n"

cleanup_exit

