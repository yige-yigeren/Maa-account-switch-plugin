@echo off
setlocal enabledelayedexpansion

rem ����ADB�ļ������·��
set "adb_path=%CD%/Plugin_switch-account_resource/platform-tools/adb.exe"

::�������շ��۹ٷ��������޸����Զ�������
::ʹ��ָ��adb shell dumpsys window | findstr mCurrentFocus��ȡ��ǰӦ�ð���
adb shell am start com.hypergryph.arknights/com.u8.sdk.U8UnityContext

call %CD%/account.bat

::����adb�����ȡ�豸��Ļ�ߴ�
for /f "delims=: tokens=2" %%A in ('adb shell wm size ^| find "Physical"') do (
    set SIZE=%%A
)

::�ֽ�õ�����Ļ�ߴ��ַ������ֱ�����Ϊsx��sy
for /f "tokens=1,2 delims=x " %%A in ("!SIZE!") do (
    set SX=%%A
    set SY=%%B
)

echo Screen Width: !SX!
echo Screen Height: !SY!

::�ȴ���Ϸ����
timeout /t 20

::�����¼ҳ��
set /A "X=!SX!*50/100"
set /A "Y=!SY!*50/100"
adb shell input tap !X! !Y!
timeout /t 10 

::����л��˺�
set /A "X=!SX!*75/100"
set /A "Y=!SY!*95/100"
adb shell input tap !X! !Y!
timeout /t 5

::�����¼
set /A "X=!SX!*45/100"
set /A "Y=!SY!*70/100"
adb shell input tap !X! !Y!
timeout /t 5

::����绰����
set /A "X=!SX!*50/100"
set /A "Y=!SY!*60/100"
adb shell input tap !X! !Y!
timeout /t 3

::����绰����
adb shell input text %PHN%
timeout /t 1
adb shell input keyevent 66

::�������
set /A "X=!SX!*50/100"
set /A "Y=!SY!*60/100+60"
adb shell input tap !X! !Y!
timeout /t 3

::��������
adb shell input text %PWD%
timeout /t 1
adb shell input keyevent 66

::�����¼
set /A "X=!SX!*50/100"
set /A "Y=!SY!*80/100"
adb shell input tap !X! !Y!
timeout /t 5

::����MAA
start MAA.exe
