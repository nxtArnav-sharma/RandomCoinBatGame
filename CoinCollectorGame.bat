@echo off
setlocal enabledelayedexpansion

:: Initialize variables
set "grid=##### ##### ##### ##### #####"
set "player_x=0"
set "player_y=0"
set "coins_collected=0"

:: Function to place coins
:place_coins
for /L %%i in (1,1,5) do (
    set /a x=!random! %% 5
    set /a y=!random! %% 5
    set /a index=(5 * !y! + !x!)
    if "!grid:~%index%,1!" neq "$" (
        set "grid=!grid:~0,%index%!$!grid:~%index%+1!"
    ) else (
        set /a %%i-=1
    )
)
goto :eof

:: Function to display the grid
:display_grid
cls
echo.
for /L %%i in (0,1,4) do (
    set "line="
    for /L %%j in (0,1,4) do (
        set /a index=(5 * %%i + %%j)
        if !player_x! equ %%j if !player_y! equ %%i (
            set "line=!line!@"
        ) else (
            set "line=!line!!grid:~%index%,1!"
        )
    )
    echo !line!
)
echo.
echo Coins collected: !coins_collected!
echo.
goto :eof

:: Function to move the player
:move_player
set "key="
set /p "key=Use W/A/S/D to move: "
if /i "!key!" equ "w" set /a player_y-=1
if /i "!key!" equ "a" set /a player_x-=1
if /i "!key!" equ "s" set /a player_y+=1
if /i "!key!" equ "d" set /a player_x+=1

:: Check boundaries
if !player_x! lss 0 set /a player_x=0
if !player_x! gtr 4 set /a player_x=4
if !player_y! lss 0 set /a player_y=0
if !player_y! gtr 4 set /a player_y=4

:: Check for coins
set /a index=(5 * !player_y! + !player_x!)
if "!grid:~%index%,1!" equ "$" (
    set "grid=!grid:~0,%index%!#!grid:~%index%+1!"
    set /a coins_collected+=1
)
goto :eof

:start
call :place_coins
if !coins_collected! lss 5 (
    call :display_grid
    call :move_player
    goto start
) else (
    call :display_grid
    echo Congratulations! You've collected all the coins!
    pause
)

exit /b
