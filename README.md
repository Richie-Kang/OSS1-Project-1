# OSS1 Project 1: MLB Player Data Analysis

## Project Overview

본 프로젝트는 BASH 쉘 스크립트와 `awk`, `sed` 명령줄 도구를 활용하여 MLB 선수 통계 데이터 파일(`2024_MLB_Player_Stats.csv`)을 처리하고 분석하는 프로그램입니다. 사용자의 입력에 따라 선수 검색, 통계 분석, 보고서 생성 등의 기능을 수행합니다.

*   **개발 환경:** BASH 쉘, Linux/macOS 또는 Git Bash/WSL (Windows)
*   **사용 도구:** `awk`, `sort`, `head`, `date`, `tr`
*   **데이터 파일:** `2024_MLB_Player_Stats.csv`

## Requirements

본 스크립트 프로그램은 다음과 같은 7가지 요구사항을 만족하도록 구현되었습니다.

1.  **Search player statistics by name:** 선수 이름을 입력받아 해당 선수의 통계 정보를 출력합니다.
2.  **List top 5 players by SLG value:** 타석 수(PA) 502 이상인 선수 중 SLG(장타율) 상위 5명의 목록을 출력합니다.
3.  **Analyze the team stats:** 특정 팀의 평균 나이, 총 홈런, 총 타점 통계를 계산하여 출력합니다.
4.  **Compare players in different age groups:** 나이 그룹별(만 25세 미만, 25-30세, 30세 초과)로 PA 502 이상인 선수 중 SLG 상위 5명을 비교 출력합니다.
5.  **Find players meeting custom conditions:** 사용자가 입력한 최소 홈런 및 최소 타율 조건을 만족하는 선수 목록을 PA 502 조건과 함께 검색하고 홈런 기준 내림차순으로 출력합니다.
6.  **Generate performance reports for specific teams:** 특정 팀 소속 선수들의 상세 통계 보고서를 홈런 기준 내림차순으로 표 형식으로 출력합니다. 현재 날짜 및 팀 총 선수 수도 포함합니다.
7.  **Quit the application:** 프로그램을 종료합니다.

## How to Use

1.  스크립트 파일(`Project1.sh`)과 데이터 파일(`2024_MLB_Player_Stats.csv`)을 동일한 디렉토리에 다운로드합니다.
2.  터미널(Git Bash, WSL 등 BASH 환경)을 열고 해당 디렉토리로 이동합니다.
3.  스크립트 파일에 실행 권한을 부여합니다 (처음 한 번만 실행):
    ```bash
    chmod +x Project1.sh
    ```
4.  데이터 파일 이름을 인자로 함께 스크립트를 실행합니다:
    ```bash
    ./Project1.sh 2024_MLB_Player_Stats.csv
    ```
5.  화면에 표시되는 메뉴를 보고 원하는 기능의 번호(1~7)를 입력하여 실행합니다.

## Implementation Details

*   스크립트는 BASH 쉘 스크립트로 작성되었습니다.
*   데이터 처리, 필터링, 계산 및 포맷팅에는 주로 `awk` 명령어가 활용되었습니다.
*   선수 목록 및 보고서 정렬에는 `sort` 명령어가 사용되었습니다.
*   상위 N개 항목 선택에는 `head` 명령어가 사용되었습니다.
*   날짜 정보 및 문자열 처리를 위해 `date`, `tr` 명령어가 사용되었습니다.
*   데이터 파일(`.csv`)의 특정 열에서 정보를 추출하기 위해 `awk`의 `$숫자` 문법을 사용하였으며, 데이터 파일의 구조에 맞게 열 번호가 조정되었습니다. (예: 선수 이름 B열 -> `$2`, PA H열 -> `$8`, SLG V열 -> `$22` 등)

## Student Information

*   **Student ID:** 12213968
*   **Name:** 강우석

## Contact

richard5560781205@gmail.com
