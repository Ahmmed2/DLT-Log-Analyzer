#!/bin/bash 

    # Delete All file Contents 
    echo -n "" > New_syslog.txt 
    echo -n "" > Filter_syslog.txt 
    echo -n "" > Filter_Error.txt 
    echo -n "" > Filter_Debug.txt
    echo -n "" > Filter_WARN.txt
    echo -n "" > Filter_INFO.txt

DLT_Data_Format () {



    declare File_Search="./New_syslog.txt"
    


    if [ "$choice" -eq 1 ]; then
    # Define the patterns and replacements
    patterns=("'error" "*error" "error:" "level=error" "error")
    replacement="ERROR"



# Read the log file line by line
while IFS= read -r line; do
    # Check if the line contains any of the specified patterns
    for pattern in "${patterns[@]}"; do
        if [[ $line =~ $pattern ]]; then
            # Extract the substring before the pattern until ":" and "." after it
           matched_text=$(echo "$line" | sed -n "s/.*:\(.*${pattern}[^ ]*\)\.*/\1/p" )
            # Concatenate "Debug" at the beginning of the matched text
            matched_text="ERROR $matched_text"
            # Concatenate the extracted text with the first two fields
            concatenated_line=$(echo "$line" | awk -v text="$matched_text " '{print$1 $2 text}')
            # Output the matched text to the output file
            echo "$concatenated_line" >> "Filter_Error.txt"
        fi
    done
done < "$File_Search"


    # Count Number of Errors 
    line_count=$(wc -l < Filter_Error.txt)
    echo "Number of Errors are : $line_count" >> "Filter_Error.txt"

    # Show content on CMD
    cat "Filter_Error.txt"

    fi 



if [ "$choice" -eq 2 ]; then
    
# Define the patterns and replacements
patterns=("[INFO]" "INFO:")
replacement="INFO"


# Loop through each pattern and replacement
for pattern in "${patterns[@]}"; do
    # Escape special characters in the pattern
    escaped_pattern=$(sed 's/[][\.^$*+?{}()|]/\\&/g' <<< "$pattern")
    # Use sed to perform the replacement
    sed -i "s/$escaped_pattern/$replacement/g" New_syslog.txt 
done


# Read the log file line by line
while IFS= read -r line; do
    # Check if the line contains any of the specified patterns
    for pattern in "${patterns[@]}"; do
        if [[ $line =~ $pattern ]]; then
            # Extract the substring before the pattern until ":" and "." after it
           matched_text=$(echo "$line" | sed -n "s/.*:\(.*${pattern}[^ ]*\)\.*/\1/p" )
            # Concatenate "INFO" at the beginning of the matched text
            matched_text="INFO $matched_text"
            # Concatenate the extracted text with the first two fields
            concatenated_line=$(echo "$line" | awk -v text="$matched_text " '{print$1 $2 text}')
            # Output the matched text to the output file
            echo "$concatenated_line" >> "Filter_INFO.txt"
        fi
    done
done < "$File_Search"


    # Count Number of INFO 
    line_count=$(wc -l < Filter_INFO.txt)
    echo "Number of Errors are : $line_count" >> "Filter_INFO.txt"

    # Show content on CMD
    cat "Filter_INFO.txt"

fi

# In case of Choosing Debug Log 
if [ "$choice" -eq 3 ]; then
    
# Define the patterns and replacements
patterns=("starting" "running" "debug")



# Read the log file line by line
while IFS= read -r line; do
    # Check if the line contains any of the specified patterns
    for pattern in "${patterns[@]}"; do
        if [[ $line =~ $pattern ]]; then
            # Extract the substring before the pattern until ":" and "." after it
           matched_text=$(echo "$line" | sed -n "s/.*:\(.*${pattern}[^ ]*\)\.*/\1/p" | sed 's/starting//g' )
            # Concatenate "Debug" at the beginning of the matched text
            matched_text="Debug $matched_text"
            # Concatenate the extracted text with the first two fields
            concatenated_line=$(echo "$line" | awk -v text="$matched_text " '{print$1 $2 text}')
            # Output the matched text to the output file
            echo "$concatenated_line" >> "Filter_Debug.txt"
        fi
    done
done < "$File_Search"


    # Count Number of Debug  
    line_count=$(wc -l < Filter_Debug.txt)
    echo "Number of Errors are : $line_count" >> "Filter_Debug.txt"

    # Show content on CMD
    cat "Filter_Debug.txt"
    
fi


# In case of choosing Warning log 
if [ "$choice" -eq 4 ]; then
    
# Define the patterns and replacements
patterns=("warning:" "WARNING:" "[WARNING]:")
replacement="WARNING"

# Loop through each pattern and replacement
for pattern in "${patterns[@]}"; do
    # Escape special characters in the pattern
    escaped_pattern=$(sed 's/[][\.^$*+?{}()|]/\\&/g' <<< "$pattern")
    # Use sed to perform the replacement
    sed -i "s/$escaped_pattern/$replacement/g" New_syslog.txt 
done

    
    patterns=("WARNING")

# Read the log file line by line
while IFS= read -r line; do
    # Check if the line contains any of the specified patterns
    for pattern in "${patterns[@]}"; do
        if [[ $line =~ $pattern ]]; then
            # Extract the substring before the pattern until ":" and "." after it
           matched_text=$(echo "$line" | sed -n "s/.*:\(.*${pattern}[^ ]*\)\.*/\1/p" )
            # Concatenate the extracted text with the first two fields
            concatenated_line=$(echo "$line" | awk -v text="$matched_text " '{print$1 $2 text}')
            # Output the matched text to the output file
            echo "$concatenated_line" >> "Filter_WARN.txt"
        fi
    done
done < "$File_Search"


    # Count Number of Warnning 
    line_count=$(wc -l < Filter_WARN.txt)
    echo "Number of Errors are : $line_count" >> "Filter_WARN.txt"

    # Show content on CMD
    cat "Filter_WARN.txt"

fi


}




DLT_Filter_Log_Lines () {

local log_file="$1"

grep "INFO" "$log_file" >> Filter_syslog.txt
grep "error" "$log_file" >> Filter_syslog.txt
grep "WARN" "$log_file" >> Filter_syslog.txt
grep "debug" "$log_file" >> Filter_syslog.txt
grep "running" "$log_file" >> Filter_syslog.txt
grep "starting" "$log_file" >> Filter_syslog.txt

}


DLT_Adjust_Time_Format () {
    local log_file="Filter_syslog.txt"
    local pattern="^([A-Za-z]{3}\s+[0-9]{1,2}\s[0-9]{2}:[0-9]{2}:[0-9]{2})\s([^ ]+)\s(.*)$"

    # Read the log file line by line
     while IFS= read -r line; do
        if [[ $line =~ $pattern ]]; then
        
            # Extract the date and time part using awk
            timestamp=$(echo "$line" | awk '{print $1,$2,$3}')

            # Formatting the date and time
            formatted_date=$(date -d "$timestamp" +'[%Y-%m-%d %H:%M:%S]')

            # Replace the original timestamp with the formatted one
            # shellcheck disable=SC2001
            new_line=$(echo "$line" | sed "s/^$timestamp/$formatted_date/")

            # Output the modified line
            echo "$new_line" >> "New_syslog.txt"

        fi
        
    done < "$log_file"
}


DLT_Display ()
{
    DLT_Filter_Log_Lines "$1"
    DLT_Adjust_Time_Format "$1"
    DLT_Data_Format "$choice"
   
}






# Display Available Options 
DLT_Display_Menu () {

    echo "DLT Log Analyzer"
    while true; do
    echo "Choose Option :"
    echo "1. Display Error logs"
    echo "2. Display Info logs"
    echo "3. Display Debuging logs"
    echo "4. Display Warning logs"
    echo "5. Exit"
    read -p "Enter your choice: " choice
    echo -e "\n"
    
    case $choice in
        # Error
        1) DLT_Display "$1" "$choice" ;;
        # Info
        2) DLT_Display "$1" "$choice" ;;
        # Debug 
        3) DLT_Display "$1" "$choice" ;;
        # Warnning 
        4) DLT_Display "$1" "$choice" ;;
        5) echo "See you Soon."; break ;; 
        *) echo "Invalid choice. Please try again." 
           echo -e "\n";;
           
        
    esac
done
}




main () {
    
    # Display all Available Options 
    DLT_Display_Menu "$1"
    
}


# Calling main Function 
main "$1"