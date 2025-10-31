#!/usr/bin/env bash

# ToggleIt.sh - Toggle between multiple expressions in any file
# Usage: toggleit.sh [file] [ExprName] [OptionName (optional)]

set -e

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Usage: $0 [file] [ExprName] [OptionName (optional)]"
    echo "Examples:"
    echo "  $0 config.kdl Brightness"
    echo "  $0 config.kdl Theme Opt2"
    exit 1
fi

FILE="$1"
NAME="$2"
SPECIFIC_OPT="${3:-}"

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found"
    exit 1
fi

# Function to extract named options from the file
extract_named_options() {
    local file="$1"
    local name="$2"
    declare -gA NAMED_OPTIONS
    
    local in_block=0
    local current_block_name=""
    
    while IFS= read -r line; do
        # Check if we're starting a named options block
        if [[ "$line" =~ ^[[:space:]]*//[[:space:]]*@TOGGLEIT\[(.*)\]${name}[[:space:]]*$ ]]; then
            current_block_name="$name"
            local options_str="${BASH_REMATCH[1]}"
            
            # Check if this uses named options (contains @)
            if [[ "$options_str" =~ @ ]]; then
                in_block=1
                continue
            fi
        fi
        
        # If we're in a named options block, extract definitions
        if [ $in_block -eq 1 ]; then
            if [[ "$line" =~ ^[[:space:]]*//[[:space:]]*@END[[:space:]]*$ ]]; then
                in_block=0
                current_block_name=""
            elif [[ "$line" =~ ^[[:space:]]*//[[:space:]]*@([^=]+)=(.*)$ ]]; then
                local opt_name="${BASH_REMATCH[1]}"
                local opt_value="${BASH_REMATCH[2]}"
                NAMED_OPTIONS["$opt_name"]="$opt_value"
            fi
        fi
    done < "$file"
}

# Create a temporary file
TEMP_FILE=$(mktemp)

# Flag to track if we found and toggled the expression
FOUND=0

# First pass: extract named options if they exist
declare -A NAMED_OPTIONS
extract_named_options "$FILE" "$NAME"

# Read the file line by line
while IFS= read -r line || [ -n "$line" ]; do
    # Check if this line is a TOGGLEIT comment for our target name
    if [[ "$line" =~ ^[[:space:]]*//[[:space:]]*@TOGGLEIT\[(.*)\]${NAME}[[:space:]]*$ ]]; then
        OPTIONS_STR="${BASH_REMATCH[1]}"
        
        # Check if this uses named options (contains @)
        if [[ "$OPTIONS_STR" =~ @ ]]; then
            # Named options mode
            echo "$line" >> "$TEMP_FILE"
            
            # Extract option names
            IFS='][' read -ra OPT_NAMES <<< "$OPTIONS_STR"
            declare -a EXPRESSIONS
            
            for opt in "${OPT_NAMES[@]}"; do
                opt=$(echo "$opt" | tr -d '[]@' | xargs)
                if [ -n "$opt" ]; then
                    if [ -n "${NAMED_OPTIONS[$opt]}" ]; then
                        EXPRESSIONS+=("${NAMED_OPTIONS[$opt]}")
                    fi
                fi
            done
            
            # Skip to @END and write those lines
            while IFS= read -r line || [ -n "$line" ]; do
                if [[ "$line" =~ ^[[:space:]]*//[[:space:]]*@END[[:space:]]*$ ]]; then
                    echo "$line" >> "$TEMP_FILE"
                    break
                fi
                echo "$line" >> "$TEMP_FILE"
            done
            
        else
            # Inline options mode
            echo "$line" >> "$TEMP_FILE"
            
            # Parse inline expressions
            IFS='][' read -ra EXPRESSIONS <<< "$OPTIONS_STR"
            # Clean up expressions
            for i in "${!EXPRESSIONS[@]}"; do
                EXPRESSIONS[$i]=$(echo "${EXPRESSIONS[$i]}" | tr -d '[]' | xargs)
            done
        fi
        
        # Read the next line (the actual expression)
        IFS= read -r next_line || [ -n "$next_line" ]
        trimmed_next=$(echo "$next_line" | xargs)
        
        # If specific option requested, use that
        if [ -n "$SPECIFIC_OPT" ]; then
            # Check if it's a named option or an index
            if [[ "$SPECIFIC_OPT" =~ ^[0-9]+$ ]]; then
                # Numeric index
                idx=$SPECIFIC_OPT
                if [ $idx -lt ${#EXPRESSIONS[@]} ]; then
                    echo "${EXPRESSIONS[$idx]}" >> "$TEMP_FILE"
                    echo "Set '$NAME' to option $idx: [${EXPRESSIONS[$idx]}]"
                    FOUND=1
                else
                    echo "Error: Option index $idx out of range (0-$((${#EXPRESSIONS[@]}-1)))"
                    rm "$TEMP_FILE"
                    exit 1
                fi
            else
                # Named option
                if [ -n "${NAMED_OPTIONS[$SPECIFIC_OPT]}" ]; then
                    echo "${NAMED_OPTIONS[$SPECIFIC_OPT]}" >> "$TEMP_FILE"
                    echo "Set '$NAME' to option '$SPECIFIC_OPT': [${NAMED_OPTIONS[$SPECIFIC_OPT]}]"
                    FOUND=1
                else
                    echo "Error: Named option '$SPECIFIC_OPT' not found"
                    rm "$TEMP_FILE"
                    exit 1
                fi
            fi
        else
            # Cycle through options
            CURRENT_IDX=-1
            
            # Find current expression index
            for i in "${!EXPRESSIONS[@]}"; do
                trimmed_expr=$(echo "${EXPRESSIONS[$i]}" | xargs)
                if [ "$trimmed_next" = "$trimmed_expr" ]; then
                    CURRENT_IDX=$i
                    break
                fi
            done
            
            if [ $CURRENT_IDX -eq -1 ]; then
                # Current value doesn't match, default to first option
                echo "${EXPRESSIONS[0]}" >> "$TEMP_FILE"
                echo "Warning: Current value doesn't match any option, defaulting to first option"
                echo "  Current: [$next_line]"
                echo "  Set to: [${EXPRESSIONS[0]}]"
                FOUND=1
            else
                # Toggle to next option (circular)
                NEXT_IDX=$(( (CURRENT_IDX + 1) % ${#EXPRESSIONS[@]} ))
                echo "${EXPRESSIONS[$NEXT_IDX]}" >> "$TEMP_FILE"
                echo "Toggled '$NAME': [${EXPRESSIONS[$CURRENT_IDX]}] -> [${EXPRESSIONS[$NEXT_IDX]}]"
                FOUND=1
            fi
        fi
    else
        echo "$line" >> "$TEMP_FILE"
    fi
done < "$FILE"

if [ $FOUND -eq 0 ]; then
    echo "Error: Toggle expression '$NAME' not found in file"
    rm "$TEMP_FILE"
    exit 1
fi

# Replace original file with modified version
mv "$TEMP_FILE" "$FILE"

echo "File updated successfully: $FILE"
