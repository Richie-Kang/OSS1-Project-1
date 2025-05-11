#!/bin/bash

data_file="$1"

if [ -z "$data_file" ]; then
  echo "usage: ./2025_OSS_Project1.sh file"
  exit 1
fi

while true; do
  echo "************OSS1 - Project1************"
  echo "*        StudentID : 12213968         *"
  echo "*        Name : WooSeok Kang          *"
  echo "***************************************"

  echo "[MENU]"
  echo "1. Search player stats by name in MLB data"
  echo "2. List top 5 players by SLG value"
  echo "3. Analyze the team stats - average age and total home runs"
  echo "4. Compare players in different age groups"
  echo "5. Search the players who meet specific statistical conditions"
  echo "6. Generate a performance report (formatted data)"
  echo "7. Quit"

  read -p "Enter your COMMAND (1~7) : " command

    case "$command" in
    1)
      echo "Enter a player name to search: "
      read player_name

      echo "Player stats for \"$player_name\":"
      awk -v player_name="$player_name" '
      BEGIN { FS="," }
      NR > 1 {
        if ($2 ~ player_name) {
           # 선수 이름($2), 팀($4), 나이($3), WAR($6), 홈런($14), 타율($20) 열 사용
           print "Player: "$2", Team: "$4", Age: "$3", WAR: "$6", HR: "$14", BA: "$20
        }
      }
      ' "$data_file"

      ;;


    2)
      read -p "Do you want to see the top 5 players by SLG? (y/n) : " see_top5_slg
      if [ "$see_top5_slg" = "y" ] || [ "$see_top5_slg" = "Y" ]; then
        echo ""

        echo "***Top 5 Players by SLG***"

        awk '
        BEGIN { FS="," }
        NR > 1 {
          player_name=$2
          team=$4
          war=$6
          pa=$8
          slg=$22
          hr=$14
          rbi=$15

          if (pa >= 502) {
            printf "%.3f\t%s (%s) - SLG: %.3f, WAR: %.1f, HR: %d, RBI: %d\n", slg, player_name, team, slg, war, hr, rbi
          }
        }
        ' "$data_file" | \
        sort -t $'\t' -k 1,1nr | \
        head -n 5 | \
        awk '
        BEGIN { FS="\t" }
        {
          print NR ". " $2
        }
        '

      else
        echo "SLG 상위 5명 선수 목록 출력을 취소했습니다."
      fi
      ;;




    3)
      echo "Enter the team abbreviation (e.g., NYY): "
      read team_abbr

      awk -v team_abbr="$team_abbr" '
      BEGIN { FS="," }
      NR > 1 {
        if ($4 == team_abbr) {
          sum_age += $3
          sum_hr += $14
          sum_rbi += $15
          player_count++
        }
      }
      END {
        if (player_count > 0) {
          average_age = sum_age / player_count
          printf "Team: %s\n", team_abbr
          printf "Average Age: %.2f\n", average_age
          printf "Total Home Runs: %d\n", sum_hr
          printf "Total RBI: %d\n", sum_rbi
        } else {
          printf "Error: Team %s not found or no players for this team.\n", team_abbr
        }
      }
      ' "$data_file"

      ;;


    4)
      echo "Compare players by age groups:"
      echo " 1. Group A (Age < 25)"
      echo " 2. Group B (Age 25-30)"
      echo " 3. Group C (Age > 30)"
      read -p " Select age group (1-3): " age_group_selection

      selected_group_title=""

      case "$age_group_selection" in
        1)
          selected_group_title="Group A (Age < 25)"
          ;;
        2)
          selected_group_title="Group B (Age 25-30)"
          ;;
        3)
          selected_group_title="Group C (Age > 30)"
          ;;
        *)
          echo "Error: Invalid age group selection."
          continue
          ;;
      esac

      if [ "$age_group_selection" -ge 1 ] && [ "$age_group_selection" -le 3 ]; then
          echo ""
          echo "Top 5 by SLG in $selected_group_title:"

          awk -v group_select="$age_group_selection" '
          BEGIN { FS="," }
          NR > 1 {
            player_name=$2
            team=$4
            age=$3
            pa=$8
            slg=$22
            ba=$20
            hr=$14

            if (pa >= 502) {
              is_correct_age_group = 0
              if (group_select == 1 && age < 25) {
                is_correct_age_group = 1
              } else if (group_select == 2 && age >= 25 && age <= 30) {
                is_correct_age_group = 1
              } else if (group_select == 3 && age > 30) {
                is_correct_age_group = 1
              }

              if (is_correct_age_group == 1) {
                printf "%.3f\t%s (%s) - Age: %d, SLG: %.3f, BA: %.3f, HR: %d\n", slg, player_name, team, age, slg, ba, hr
              }
            }
          }
          ' "$data_file" | \
          sort -t $'\t' -k 1,1nr | \
          head -n 5 | \
          awk '
          BEGIN { FS="\t" }
          {
            print NR ". " $2
          }
          '
      fi

      ;;


    5)
      echo "Find players with specific criteria"
      read -p " Minimum home runs: " min_hr
      read -p " Minimum batting average (e.g., 0.280): " min_ba

      echo ""
      echo "Players with HR ≥ $min_hr and BA ≥ $min_ba:"

      awk -v min_hr="$min_hr" -v min_ba="$min_ba" '
      BEGIN { FS="," }
      NR > 1 {
        player_name=$2
        team=$4
        pa=$8
        hr=$14
        ba=$20
        rbi=$15
        slg=$22

        if (pa >= 502 && hr >= min_hr && ba >= min_ba) {
          printf "%d\t%s (%s) - HR: %d, BA: %.3f, RBI: %d, SLG: %.3f\n", hr, player_name, team, hr, ba, rbi, slg
        }
      }
      ' "$data_file" | \
      sort -t $'\t' -k 1,1nr | \
      awk '
      BEGIN { FS="\t" }
      {
        print NR ". " $2
      }
      '

      ;;


    6)
      echo "Generate a formatted player report for which team?"
      read -p "Enter team abbreviation (e.g., NYY, LAD, BOS): " team_abbr

      report_date=$(date +%Y/%m/%d)

      echo ""
      echo " ================== $(echo "$team_abbr" | tr '[:lower:]' '[:upper:]') PLAYER REPORT =================="
      echo " Date: $report_date"
      echo "------------------------------------------------------"
      printf "%-25s %-5s %-5s %-5s %-5s %-5s\n" "PLAYER" "HR" "RBI" "AVG" "OBP" "OPS"
      echo "------------------------------------------------------"

      awk -v team_abbr="$team_abbr" '
      BEGIN { FS="," }
      NR > 1 {
        player_name=$2
        team=$4
        hr=$14
        rbi=$15
        ba=$20
        obp=$21
        ops=$23

        if ($4 == team_abbr) {
          printf "%d\t%s\t%d\t%d\t%.3f\t%.3f\t%.3f\n", hr, player_name, hr, rbi, ba, obp, ops
        }
      }
      ' "$data_file" | \
      sort -t $'\t' -k 1,1nr | \
      awk '
      BEGIN { FS="\t" }
      {
        printf "%-25s %-5d %-5d %-5.3f %-5.3f %-5.3f\n", $2, $3, $4, $5, $6, $7
      }
      '

      total_players=$(awk -v team_abbr="$team_abbr" 'BEGIN { FS="," } NR > 1 { if ($4 == team_abbr) count++ } END { print count }' "$data_file")

      echo "------------------------------------------------------"
      printf "TEAM TOTALS: %d players\n" "$total_players"

      ;;



    7)
      echo "Have a good day!"
      break
      ;;

    *)
      echo "Error: 유효하지 않은 명령입니다. 1부터 7까지의 숫자를 입력해주세요."
      ;;
  esac 

  echo ""
done

exit 0
