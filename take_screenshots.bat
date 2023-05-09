@ECHO OFF

PUSHD "%~dp0"

IF "%~2"=="--reset" (
    RD /S /Q "%~1" 2> NUL
    MD "%~1"
)

python take_screenshots.py "%~1"

POPD

PAUSE
