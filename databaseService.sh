#!/bin/bash

TABLE_NAMES=""

validate_table(){
  if grep -qx "TABLE: $table_name" "$DATABASE"; then
		echo "$table_name already exist in $DATABASE"
		exit 1
  fi	
}

validate_database_create(){
	if [[ -e "$DATABASE" ]]; then
		echo "Database with choosen name already exist"
		exit 1
	fi
}

validate_database(){
	if [[ ! -e "$DATABASE" ]]; then
		echo "Database $DATABASE doesn't exist"
	 	exit 1
	fi
}

create_database(){
	validate_database_create $DATABASE

	touch "$DATABASE"
	echo "Created $DATABASE"	

	display_menu
}

create_table(){
	echo "------------------------------------" >> "$DATABASE"
	printf "TABLE: %s\n" "$table_name" >> "$DATABASE"

	for i in "${!columns[@]}"; do
  if [[ $i -eq ${#columns[@]}-1 ]]; then
    printf "%-8s\n" "${columns[$i]}" >> "$DATABASE"
  else
    printf "%-8s|" "${columns[$i]}" >> "$DATABASE"
  fi
	done	
	echo "------------------------------------" >> "$DATABASE"

	echo "====================================" >> "$DATABASE"
	echo "You successfuly create table $table_name"
	display_menu
}

insert_data(){
	local row="** "
	for i in ${!data_array[@]}; do
		if [[ $i -eq ${#data_array[@]}-1 ]]; then
			row=$(printf "%s%-8s**" "$row" "${data_array[$i]}")
		else	
			row=$(printf "%s%-8s|" "$row" "${data_array[$i]}")
		fi
	done
	
	if [ $((${#row} - 5)) -gt 39 ]; then
		echo "The row you insert is greater than 39 characters"
		exit 1
	fi

	row_num=$(grep -n "TABLE: $TABLE" $DATABASE | cut -d ':' -f 1)
	row_num=$(($row_num + 2))
	echo "$row_num"

	sed -i '' "${row_num}a\\
$row\\
" "$DATABASE"
	
	display_menu
}

select_table(){	
		sed -n "/^TABLE: ${TABLE}/,/=====================================/p" $DATABASE		
	display_menu
}

delete_row(){
		local column_row=$(grep -n "TABLE: $TABLE" $DATABASE | cut -d ':' -f 1)
		local column_row=$(($column_row + 1))
		local column_names=$(sed -n "${column_row}p" ${DATABASE})	
		IFS='|' read -r -a array_columns <<< "$column_names"

		for i in "${!array_columns[@]}"; do
  		array_columns[$i]="${array_columns[$i]//[[:space:]]/}"
		done
				
		last_index_column=${#array_columns[@]}
		echo "last: $last_index_column"

		index_of_column=""
		for index in "${!array_columns[@]}"; do
			if [[ "${array_columns[$index]}" == $COLUMN ]]; then
				index_of_column=$index
			fi	
		done
		
		echo "$index_of_column"
		if [[ "$index_of_column" == "" ]]; then
			echo "Column $COLUMN do not exist in $TABLE table."
			exit 1
		fi

		start_line=$(($column_row + 2))
		end_line=$(grep -n "TABLE:" $DATABASE | grep -A 1 "TABLE: $TABLE" | tail -n -1 | cut -d ':' -f 1)
		
		if [[ $(( $start_line - 3 )) == $end_line ]]; then
			end_line=$( grep -c '^' $DATABASE) 
		fi

		delete_lines=()
		
		echo "st: $start_line, en: $end_line"

		for ((i="$start_line" ; i <= "$end_line" ; i++ )); do
			line=$(sed -n "${i},${i}p" "$DATABASE" | xargs | cut -d "|" -f "$(( $index_of_column + 1 ))")

			if [[ $(( $index_of_column + 1 )) == 1 ]]; then
				if [[ $line == "** $VALUE " ]]; then
					delete_lines+=($i)
				fi

			elif [[ $(( $index_of_column + 1 )) == $last_index_column ]]; then
				echo "$line+ 22 $VALUE+"
				if [[ $line == "$VALUE **" ]]; then
					delete_lines+=($i)
				fi

			else
				if [[ $line == "$VALUE " ]]; then	
					delete_lines+=($i)
				fi
			fi
		done

		if [[ "${#delete_lines[@]}" == 0 ]]; then
	   echo "Value does not exist in the table."
	   exit 1
   	fi
	
		for ((i=${#delete_lines[@]} -1 ; i >= 0; i-- )); do
			sed -i '' "${delete_lines[i]}d" "$DATABASE"
			echo "Line: ${delete_lines[i]} was deleted."
		done
	
		display_menu
}

display_menu(){	
	echo "MENU"
	echo "-------------"
	echo "1) Create Database"
	echo "2) Create Table"
	echo "3) Select Data"
	echo "4) Delete Data"
	echo "5) Insert Data"
	echo "6) Exit"
	read OPTION

	case $OPTION in
		1)
			echo -n "Write the name you want to set for new database: "
			read DATABASE
			create_database $DATABASE
			;;
		2)
			echo -n "Write in which database you want to create table: "
			read DATABASE
			validate_database $DATABASE
			echo "Write name of table and fields: (Tablename;column1;colum2;colum3...)"
			read TABLE
			local table_name=$(echo $TABLE | awk -F ';' '{print $1}')
			validate_table $DATABASE $table_name
			local columns=($(echo "$TABLE" | awk -F ';' '{for(i=2; i<=NF; i++) print $i}'))
		
			create_table $DATABASE $table_name $columns
			;;
		3)
			echo -n "Write from which database you want to select data: "
			read DATABASE
			validate_database $DATABASE
			echo -n "Write from which table you want to select data: "
			read TABLE
			validate_table $DATABASE $TABLE
		
			select_table $DATABASE $TABLE
			;;
		4)
      echo -n "Write from which database you want to delete data: "
			read DATABASE
			validate_database $DATABASE
			echo -n "Write from which table you want to delete data: "
			read TABLE
			validate_table $DATABASE $TABLE
			echo "Write which value you want to delete and which column it refers to: (value column)"
			read VALUE COLUMN
			delete_row $DATABASE $TABLE $VALUE $COLUMN
			;;
		5)
			echo -n "Write in which database you want to insert data: "
			read DATABASE
			validate_database $DATABASE
			echo -n "Write name of table in which you want to insert data: "
			read TABLE
			validate_table $DATABASE $TABLE
			echo "Write data you want to add to $TABLE table: (data1;data2;data3...)"
			read DATA
			data_array=($(echo "$DATA" | awk -F ';' '{for(i=1; i<=NF; i++) print $i}'))
		
			insert_data $DATABASE $TABLE $data_array 
			;;	
		6)
			exit 0;;
		*)
			echo "Invalid choice."
			exit 1;;
	esac
}

display_menu
