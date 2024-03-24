SLEEPTIME_IN_SEC=300
LAST_WALLPAPER_FILE="/usr/wallpapers/lastwallpaper.txt"
ALL_WALLPAPERS_FILE="/usr/wallpapers/allwallpapers.txt"

cd /usr/wallpapers
if [[ ! -z /usr/wallpapers/lastwallpaper.txt ]]
then
    ls -1 *.JPG | sort > ${ALL_WALLPAPERS_FILE}
    cat ${ALL_WALLPAPERS_FILE} | head -n 1 > ${LAST_WALLPAPER_FILE}
fi

while true
do 
    current_name=$(cat ${LAST_WALLPAPER_FILE})
        
    echo "gsettings set org.gnome.desktop.background picture-uri \"file:///usr/wallpapers/${current_name}\""
    gsettings set org.gnome.desktop.background picture-uri "file:///usr/wallpapers/${current_name}"
    sleep $SLEEPTIME_IN_SEC

    current_name=$(cat ${LAST_WALLPAPER_FILE})
    echo "current_name = ${current_name}"

    last_line_no=$(grep -n ${current_name} ${ALL_WALLPAPERS_FILE}| awk -F":" '{print $1}')
    echo "last_line_no = ${last_line_no}"

    next_line_no=$(expr ${last_line_no} + 1)
    if [[ ${next_line_no} -gt $(wc -l ${ALL_WALLPAPERS_FILE} | awk '{print $1}') ]]
    then
      next_line_no=1
    fi
    echo "next_line_no = ${next_line_no}"

    next_name=$(cat ${ALL_WALLPAPERS_FILE} | sed "${next_line_no}q;d")
    echo "next_name = ${next_name}"

    echo $next_name > $LAST_WALLPAPER_FILE
done
