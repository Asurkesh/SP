#!/bin/bash
# sys_info_page: программа вывода страницы с информацией о системе (с графическим меню, использующим zenity)

PROGNAME=$(basename $0)
TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME=$(date +"%x %r %Z")
TIME_STAMP="Generated $CURRENT_TIME, by $USER"
HTML_FILE="sys_info_report.html"

report_uptime () {
cat <<- _EOF_
<H2>System Uptime</H2>
<PRE>$(uptime)</PRE>
_EOF_
return
}

report_disk_space () {
cat <<- _EOF_
<H2>Disk Space Utilization</H2>
<PRE>$(df -h)</PRE>
_EOF_
return
}

report_home_space () {
local format="%8s%10s%10s\n"
local i dir_list total_files total_dirs total_size user_name
if [[ $(id -u) -eq 0 ]]; then
    dir_list=/home/*
    user_name="All Users"
else
    dir_list=$HOME
    user_name=$USER
fi

echo "<H2>Home Space Utilization ($user_name)</H2>"
for i in $dir_list; do
    total_files=$(find $i -type f | wc -l)
    total_dirs=$(find $i -type d | wc -l)
    total_size=$(du -sh $i | cut -f 1)
    echo "<H3>$i</H3>"
    echo "<PRE>"
    printf "$format" "Dirs" "Files" "Size"
    printf "$format" "----" "-----" "----"
    printf "$format" $total_dirs $total_files $total_size
    echo "</PRE>"
done
return
}

write_html_page () {
cat <<- _EOF_
<HTML>
<HEAD>
<TITLE>$TITLE</TITLE>
</HEAD>
<BODY>
<H1>$TITLE</H1>
<P>$TIME_STAMP</P>
$(report_uptime)
$(report_disk_space)
$(report_home_space)
</BODY>
</HTML>
_EOF_
return
}

show_menu () {
while true; do
    choice=$(zenity --list --title="System Information Menu" \
        --column="Option" --column="Description" \
        1 "Uptime Report" \
        2 "Disk Space Report" \
        3 "Home Space Report" \
        4 "Generate Full Report" \
        5 "Exit" --height=400 --width=400)

    case $choice in
        1) write_html_page > $HTML_FILE
           xdg-open $HTML_FILE
           ;;
        2) write_html_page > $HTML_FILE
           xdg-open $HTML_FILE
           ;;
        3) write_html_page > $HTML_FILE
           xdg-open $HTML_FILE
           ;;
        4) write_html_page > $HTML_FILE
           xdg-open $HTML_FILE
           ;;
        5) echo "Exiting..."
           break
           ;;
        *) zenity --error --text="Invalid choice, try again."
           ;;
    esac
done
}

# Основной блок
show_menu
