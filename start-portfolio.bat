@echo off
title Kepler Academic Portfolio Launcher
cd /d "%~dp0"
echo ========================================================
echo  Launching Kepler Academic Portfolio
echo  Directory: %CD%
echo ========================================================
echo.
echo Starting local web server on port 8080...
start "" "http://localhost:3001/index.html"
node server.js
pause

