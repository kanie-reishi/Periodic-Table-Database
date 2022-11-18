#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ $1 ]]
then
  SELECT_VALID=$($PSQL "SELECT atomic_number, symbol, name FROM properties JOIN elements USING(atomic_number)")
  CHECK_VALID=false
  while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
  do
  if [[ $1 -eq $ATOMIC_NUMBER ]]; then
  CHECK_VALID=true
  break
  fi
  if [[ $1 == $SYMBOL ]]; then
  CHECK_VALID=true
  break
  fi
  if [[ $1 == $NAME ]]; then
  CHECK_VALID=true
  break
  fi
  done <<< $SELECT_VALID
  if [[ $CHECK_VALID = true ]]; then
  SELECT_RESULT=$($PSQL "SELECT types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
  read TYPE BAR MASS BAR MELT BAR BOIL <<< $SELECT_RESULT
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  else
  echo "I could not find that element in the database."
  fi
else
echo "Please provide an element as an argument."
fi