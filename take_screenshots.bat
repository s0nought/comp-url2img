@ECHO OFF

PUSHD "%~dp0"

RD /S /Q "%~1" 2> NUL
MD "%~1"

python take_screenshots.py "%~1"

POPD
