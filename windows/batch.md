# Batch Script

|Command|Description                 |Example                             |
|-------|----------------------------|------------------------------------|
|SET    |Set a variable              |`SET my_var="something"`, `%my_var%`|
|ECHO   |Print to screen             |`ECHO print something to screen`    |
|PAUSE  |Pause the console           |`PAUSE`                             |
|CD     |Change the current directory||
|CLS    |||
|DATE   |||
|DEL    |||
|DIR    |||
|FIND   |||
|MD     |Create a directory          ||
|RD     |Remove a directory          |`rd /s /q %folder%`                 |
|REN    |Rename a file or folder     ||
|MOVE   |Move files to a directory   ||
|TAR    |Archive files or folders    |`tar -a -c -f some.zip %target%`    |

## Rules

- A comment starts with double colons `::`
- Use `^` to escape special characters such as `()`
- Set a variable with `set VAR_NAME="something"` and use `%VAR_NAME%` to access it

## If-else

```bat
if exist "%target%" (
  :: do something
else
  :: ...
)
```

## Looping

## Function

```bat
call :myFunction parm1

:myFunction
set VAR=%1
echo The fist parameter is %VAR%
goto:eof
```
