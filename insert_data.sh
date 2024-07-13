#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL 'TRUNCATE teams, games')

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # find winner team in teams table
    WINNER_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    
    # if winner_team not found
    if [[ -z $WINNER_TEAM_NAME ]]
    then
      # Insert in winner teams table
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    
    # get winner_team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    # find opponent team in teams table
    OPPONENT_TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    
    # if opponent_team not found
    if [[ -z $OPPONENT_TEAM_NAME ]]
    then
      # Insert in opponent teams table
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    
    # get opponent_team_id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  # Insert into games table
  if [[ -n $WINNER_TEAM_ID && -n $OPPONENT_TEAM_ID ]]
  then
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi

done

