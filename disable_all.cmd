@echo off
setlocal enabledelayedexpansion

set "SKIP_DIRS=.git smods lovely"

for /d %%f in (*) do (
    set "skip=no"
    for %%d in (%SKIP_DIRS%) do (
        if /i "%%f"=="%%d" (
            set "skip=yes"
        )
    )
    if "!skip!"=="no" (
        echo Disabling %%f
        type nul > "%%f\.lovelyignore"
    )
)

endlocal
