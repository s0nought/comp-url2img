@ECHO OFF

TITLE Compare screenshots

SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

GOTO :Main

:getImageAttribute
    SET "%~3=0"
    FOR /F "usebackq tokens=* delims= " %%A IN (`identify -format "%%%~2" %~1`) DO SET "%~3=%%A"
    EXIT /B

:Main

SET "ResultFile=..\result.txt"

PUSHD "%~dp0"

SET "BeforeFilesCount=0"
SET "AfterFilesCount=0"

FOR /F "usebackq" %%A IN (`DIR /A-D /B "before\*.png" 2^>NUL ^| FIND /C /V ""`) DO (
    SET "BeforeFilesCount=%%A"
)

FOR /F "usebackq" %%A IN (`DIR /A-D /B "after\*.png" 2^>NUL ^| FIND /C /V ""`) DO (
    SET "AfterFilesCount=%%A"
)

IF %BeforeFilesCount% NEQ %AfterFilesCount% (
    ECHO Error: Number of files in 'before' and 'after' directories differ
    GOTO :Finalize
)

CD "before"

FOR %%A IN (*.png) DO (
    ECHO %%A

    @REM both images will have the same width
    CALL :getImageAttribute "%%A" "w" "ImgWidth"

    @REM height might differ though
    @REM need images with the same dimensions for comparison
    CALL :getImageAttribute "%%A" "h" "Img1Height"
    CALL :getImageAttribute "..\after\%%A" "h" "Img2Height"

    @REM if necessary, change height of the 'after' image
    IF !Img1Height! GTR !Img2Height! (
        magick "..\after\%%A" -extent !ImgWidth!x!Img1Height! "..\after\%%A"
    )

    @REM if necessary, change height of the 'before' image
    IF !Img2Height! GTR !Img1Height! (
        magick "%%A" -extent !ImgWidth!x!Img2Height! "%%A"
    )

    magick compare -metric PSNR "%%A" "..\after\%%A" ..\diff.png > NUL 2> NUL

    IF !ERRORLEVEL! EQU 0 (
        ECHO 0 %%A >> "%ResultFile%"
    ) ELSE IF !ERRORLEVEL! EQU 1 (
        ECHO 1 %%A >> "%ResultFile%"
    ) ELSE (
        ECHO 2 %%A >> "%ResultFile%"
    )
)

:Finalize

POPD

ENDLOCAL

PAUSE
