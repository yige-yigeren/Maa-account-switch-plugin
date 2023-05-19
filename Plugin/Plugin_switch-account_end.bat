@echo off
setlocal enabledelayedexpansion

rem 设置ADB文件的相对路径
set "adb_path=%CD%/Plugin_switch-account_resource/platform-tools/adb.exe"

::启动明日方舟官服（如需修改请自定包名）
::使用指令adb shell dumpsys window | findstr mCurrentFocus获取当前应用包名
adb shell am start com.hypergryph.arknights/com.u8.sdk.U8UnityContext

call %CD%/account.bat

::调用adb命令获取设备屏幕尺寸
for /f "delims=: tokens=2" %%A in ('adb shell wm size ^| find "Physical"') do (
    set SIZE=%%A
)

::分解得到的屏幕尺寸字符串，分别设置为sx和sy
for /f "tokens=1,2 delims=x " %%A in ("!SIZE!") do (
    set SX=%%A
    set SY=%%B
)

echo Screen Width: !SX!
echo Screen Height: !SY!

::等待游戏启动
timeout /t 20

::进入登录页面
set /A "X=!SX!*50/100"
set /A "Y=!SY!*50/100"
adb shell input tap !X! !Y!
timeout /t 10 

::点击切换账号
set /A "X=!SX!*75/100"
set /A "Y=!SY!*95/100"
adb shell input tap !X! !Y!
timeout /t 5

::点击登录
set /A "X=!SX!*45/100"
set /A "Y=!SY!*70/100"
adb shell input tap !X! !Y!
timeout /t 5

::点击电话号码
set /A "X=!SX!*50/100"
set /A "Y=!SY!*60/100"
adb shell input tap !X! !Y!
timeout /t 3

::输入电话号码
adb shell input text %PHN%
timeout /t 1
adb shell input keyevent 66

::点击密码
set /A "X=!SX!*50/100"
set /A "Y=!SY!*60/100+60"
adb shell input tap !X! !Y!
timeout /t 3

::输入密码
adb shell input text %PWD%
timeout /t 1
adb shell input keyevent 66

::点击登录
set /A "X=!SX!*50/100"
set /A "Y=!SY!*80/100"
adb shell input tap !X! !Y!
timeout /t 5

::唤醒MAA
start MAA.exe
