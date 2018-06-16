#!/bin/bash
#
#################################################
# Use zenity to zap through zattoo with yt-dl.
# Thanks to goggle for his contribution!  :-)
# (https://github.com/goggle)
#
# TODO: - Some channels are not working - maybe
#         they are premium only..
#       - Better describe different formats.
#       - Tweak yt-dl and $player arguments for
#         slower hardware (!)
#       - Clean up & comment this piece of code.
#       - Avoid executing yt-dl numerous times..
#
# Have fun and enjoy "faster changing channels
# without zattoo advertisments" - all for free!!
#
# Get yt-dl with:
#  sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
#  sudo chmod a+rx /usr/local/bin/youtube-dl
#
#################################################



#################################################
# Main variables
# (Adjust to your own needs)
#################################################
user="ant@believe.it"
pwd="mysecretpasswort"
player="mpv"
requires="youtube-dl zenity awk grep sed sort $player"



#################################################
# Requirement check
# 
#################################################
for i in $requires; do command -v $i >/dev/null 2>&1 || { echo >&2 "$i not found, please install it first.."; exit 1; }; done



#################################################
# Main loop
# 
#################################################

channels=$(curl "https://zattoo.com/ch/sender/" | \
           grep "/watch/" | \
           awk -F'"' '{print $2 $4}' | \
           sed 's/Stream/@ /g;s/\/watch\///g;' | \
           sort -u -t@ -k2 | \
           sort -u -t@ -k1 | \
           sed 's/^/"/g;s/ @/"/g;s/ /_/g;s/"_/" /g;' )

while(true)
do

  #############################
  # Select channel
  #############################
  if ! choice=$(zenity --list --print-column=2 \
    --title="Choose the Channel" \
    --column="Channel" --column="Link" \
    $(echo $channels) ); then
    exit;
  fi

  #############################
  # Get available formats
  #############################
  fmts=$(youtube-dl --username $user --password $pwd "https://zattoo.com/watch/$choice" -F | \
         awk '{print $1 " " $2 " " $3}' | \
         awk '/format code/{y=1;next}y' #prints everything after "format code"
  )

  #############################
  # Select format
  #############################
  if ! fmt_choice=$(zenity --list --print-column=1 \
    --title="Choose the Format" \
    --column="Format" --column="Extension" --column="Resolution" \
    $(echo $fmts) ); then
    exit;
  fi

  #############################
  # Watch channel
  #############################
  youtube-dl --username $user --password $pwd "https://zattoo.com/watch/$choice" -f $fmt_choice -o - | $player -

done

exit 0
