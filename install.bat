@echo off
chcp 65001
SETLOCAL EnableDelayedExpansion

rem 管理者権限を確認、取得
openfiles > NUL 2>&1
if NOT %ERRORLEVEL% EQU 0 (
	powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process """%0""" -Verb runas"
	exit
)

rem 各種パスを変数に格納
set recotte_studio=C:\Program Files\RecotteStudio
set shader_path=\effects
set effect_path=\effects\effects
set transition_path=\effects\transitions
echo Installing...

rem パスの位置にレコスタがインストールされているか確認
if not exist "%recotte_studio%\" (
	echo RecotteStudio is not found
	pause > nul
	exit
)

rem ファイルをコピー
xcopy /y /s "%~dp0*.cso" "%recotte_studio%%shader_path%\"
xcopy /y /s "%~dp0ista_*.lua" "%recotte_studio%%effect_path%\"
xcopy /y /s "%~dp0ista_*.png" "%recotte_studio%%effect_path%\"
rem xcopy /s *_ista_*.lua "%recotte_studio%%transition_path%\"
rem xcopy /s *_ista_*.png "%recotte_studio%%transition_path%\"

rem uh_dummyがない場合に案内を表示する
if not exist "%recotte_studio%%transition_path%\uh_dummy.lua" (
	choice /m "エフェクトを動画に対して適用するには、うぷはし氏のuh_dummyエフェクトが必要です。ダウンロードページを開きますか？ "
	if !errorlevel! equ 1 (
		start https://github.com/wallstudio/RecotteShader/releases/latest
	)
)

echo Complete.
pause > nul
