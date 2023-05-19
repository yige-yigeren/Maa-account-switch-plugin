@echo off
title �˺��л��������
rem ��ʼ��

rem ���������ļ�·������Ҫ���ļ�ֵ��
rem ��ȡ�ű��ļ���Ŀ¼
set "config_file=%CD%\config\gui.json"
set "start_with_key=Start.StartsWithScript"
set "start_with_value=Plugin_switch-account_start.bat"
set "end_with_key=Start.EndsWithScript"
set "end_with_value=Plugin_switch-account_end.bat"

rem ��ʼ��״̬����
set "istatu=1"

rem ��������ļ��Ƿ����
echo 1
if not exist "%config_file%" (
    echo ���״̬��δ��װ��
    set isstatu=1
    set iestatu=1
) else (
    rem ��ȡ�����ļ����ݲ�������ֵ��
    set start_with_found=""
    set end_with_found=""
    for /f "usebackq tokens=1,* delims=: " %%a in ("%config_file%") do (
        if "%%a"=="%start_with_key%" (
            set start_with_found=%%b
        )
        if "%%a"=="%end_with_key%" (
            set end_with_found=%%b
        )
    )

    rem ���Start.StartsWithScript�Ƿ�ƥ��
    if defined start_with_found (
        if "%start_with_value%"=="%start_with_found%" (
            echo �����ʼģ��״̬���Ѱ�װ��
            set isstatu=0
        ) else (
            echo �����ʼģ��״̬����ͻ��
            set isstatu=2
        )
    )

    rem ���Start.EndsWithScript�Ƿ�ƥ��
    if defined end_with_found (
        if "%end_with_value%"=="%end_with_found%" (
            echo �������ģ��״̬���Ѱ�װ��
            set iestatu=0
        ) else (
            echo �������ģ��״̬����ͻ��
            set iestatu=2
        )
    )
    echo Tip:
    echo �����ֳ�ͻ�����Ƿ����������ʹ����MAA���ã���������������ֶ����Ƶ�\Plugin_switch-account_resource\compatible-plugin-loader\��������Ϊstart.bat��end.bat
    echo ��Ϊ������ľɰ汾����ѡ�񸲸ǰ�װ
)

:menu
echo ��ѡ��һ��ѡ�
echo [1] ��װ���
echo [2] ж�ز��
echo [3] �������
echo [4] �˳�

set /p option=������ѡ����룺

if "%option%"=="1" (
    call :installPlugin
    goto menu
) else if "%option%"=="2" (
    call :uninstallPlugin
    goto menu
) else if "%option%"=="3" (
    call :pluginSettingsMenu
    goto menu
) else if "%option%"=="4" (
    exit /b
) else (
    echo ��Ч��ѡ����������롣
    pause
    goto menu
)

:installPlugin

rem ��������ļ��Ƿ����
if not exist "%config_file%" (
    rem �����ļ������ڣ�������д���ֵ��
    echo [ERROR]MAA�����ļ������ڣ�����MAA�Ƿ�Ϊ���ݰ汾
) else (
    rem �����ļ����ڣ���ȡ���ݲ�����ֵ��
    set "content="
    for /f "usebackq delims=" %%a in ("%config_file%") do (
        set "content=%%a"
    )
    
    rem ����Ƿ����ָ���ļ�ֵ��
    echo %content% | findstr /C:"\"%start_with_key%\": \"%start_with_value%\"" >nul
    if %errorlevel% equ 0 (
        rem ��ֵ���Ѵ��ڣ������޸�
        echo ����Ѱ�װ���������
    ) else (
        rem ��ֵ�Բ����ڻ�ֵ��ͬ���޸������ļ�
        echo %content% | findstr /C:"\"%start_with_key%\"" >nul
        if %errorlevel% equ 0 (
            rem �����ڵ�ֵ��ͬ���滻��ֵ��
            set "content=!content:%start_with_key%=*!"
            set "content=!content:%end_with_key%=*!"
            echo {"%start_with_key%": "%start_with_value%", "%end_with_key%": "%end_with_value%"}>>"%config_file%.tmp"
            echo %content%>>"%config_file%.tmp"
            move /y "%config_file%.tmp" "%config_file%" >nul
            echo ��������Ѹ���
        ) else (
            rem �������ڣ���Ӽ�ֵ��
            echo {"%start_with_key%": "%start_with_value%", "%end_with_key%": "%end_with_value%"}>"%config_file%.tmp"
            echo %content%>>"%config_file%.tmp"
            move /y "%config_file%.tmp" "%config_file%" >nul
            echo ����Ѱ�װ
        )
    )
)

exit /b


:uninstallPlugin
rem ���������ļ�·������Ҫɾ���ļ�ֵ��

rem ��������ļ��Ƿ����
if not exist "%config_file%" (
    rem �����ļ������ڣ����δ��װ
    echo [ERROR]�����δ��װ
) else (
    rem �����ļ����ڣ���ȡ���ݲ�ɾ����ֵ��
    set "content="
    for /f "usebackq delims=" %%a in ("%config_file%") do (
        set "content=%%a"
    )

    rem ����Ƿ����ָ���ļ�ֵ��
    echo %content% | findstr /C:"\"%start_with_key%\"" >nul
    if %errorlevel% equ 0 (
        rem �����ڣ�ɾ����ֵ��
        set "content=!content:%start_with_key%=*!"
        set "content=!content:%end_with_key%=*!"
        echo %content%>"%config_file%.tmp"
        move /y "%config_file%.tmp" "%config_file%" >nul
        echo �����ж��
    ) else (
        rem �������ڣ����δ��װ
        echo [ERROR]�����δ��װ
    )
)

exit /b


:pluginSettingsMenu
cls
echo ������ã�
echo [1] ����ѡ��1
echo [2] ����ѡ��2
echo [3] �������˵�

set /p settingOption=����������ѡ����룺

if "%settingOption%"=="1" (
    call :pluginSetting1
    goto pluginSettingsMenu
) else if "%settingOption%"=="2" (
    call :pluginSetting2
    goto pluginSettingsMenu
) else if "%settingOption%"=="3" (
    goto menu
) else (
    echo ��Ч��ѡ����������롣
    pause
    goto pluginSettingsMenu
)

:pluginSetting1
rem �ڴ˴���Ӳ������ѡ��1���߼�
echo �������ѡ��1
pause
exit /b

:pluginSetting2
rem �ڴ˴���Ӳ������ѡ��2���߼�
echo �������ѡ��2
pause
exit /b
