#!/bin/bash

if [ $# -eq 0 ]
then
  echo "Please provide an element as an argument."
else

  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  # check if element is an integer or string 
  if ! [[ $1 =~ ^[0-9]+$ ]];
  then
    # check if element exists 
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
  else
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
  fi

  # if element does not exist, output I could not find that element in the database.
  if [ -z $ATOMIC_NUMBER ]
  then
    echo "I could not find that element in the database."
  else
  # if element does exist
  # output facts when given an element

    # ELEMENT_PROPS=$($PSQL "select * from properties where atomic_number=$ATOMIC_NUMBER")
    $PSQL "select t1.atomic_number, t1.atomic_mass, t1.melting_point_celsius, t1.boiling_point_celsius,
    t2.symbol, t2.name,
    t3.type
    from properties t1 join elements t2 on t1.atomic_number = t2.atomic_number 
    join types t3 on t1.type_id = t3.type_id
    where t1.atomic_number=$ATOMIC_NUMBER" | while IFS="|" read atomic_number atomic_mass melting_point_celsius boiling_point_celsius symbol name type;do
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    done
  fi
fi
