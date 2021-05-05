@Echo Off

Set ScriptName=饥荒DST+DS一体化  by:Rex.Pack v:1.1

Title %ScriptName%
mode Con: Cols=128 Lines=56
Color e0


CD /d %~dp0
CD..

REM ----
For /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do (
	Set Path_Doc=%%j\Klei\
)
Set MainPath=%CD%

REM ID文件夹名  [可选]
Set UID=
REM Cluster文件夹名
Set Cluster=Cluster_1

REM ---- 路径设定 ----
REM 集群
Set Path_Doc_DST=%Path_Doc%DoNotStarveTogether\
Set Path_Doc_DSTR=%Path_Doc%DoNotStarveTogetherRail\

REM ---- 首次使用 自行调整路径
REM 联机版文件夹
Set Path_DST=%MainPath%\Don't Starve Together\
REM 服务端文件夹
Set Path_DSTDS=%MainPath%\Don't Starve Together Dedicated Server\
REM 选择Steam的Workshop\content\322330文件夹
Set Workshop=D:\_Game\Game_Steam\workshop\content\322330\




REM ----
	Echo  1.你需要下载好Steam联机版与服务器程序
	Echo  2.获取你的token,并按常规流程存储你的Cluster文件夹里
	Echo  ----
	Echo  !!!!请修改此脚本中的 [自定义设定] 内容为符合你电脑饥荒的设定
	Echo  ----
	Echo  符合以上要求即可继续
	
:Main
	Pause
	CLS
	Echo ┆
	Echo ┆            %ScriptName%
	Echo ┆
	Echo ---- 描述
	Echo ┆ 使你联机版与服务器共用 集群(Cluster) 与 模组(MOD) ,从联机版对[集群]修改,与从服务器运行一致
	Echo ┆ 便于从联机版配置 [集群]或[模组] 设置后,可直接作为服务器启动.
	Echo ┆  当你从联机版新建\修改一个[集群],完成后联机版退出该[集群](也就是回到主界面)
	Echo ┆  再从此处启动服务器,或你自己的方式启动
	Echo ┆  如果 新增\删除 模组,再启动前执行一次 [2.同步MOD]
	Echo ┆
	Echo ┆  控制台联机命令参考
	Echo ┆  c_connect("127.0.0.1",10999)  '免防火墙
	Echo ┆  c_connect("loaclhost",10999)
	Echo ┆  c_connect("s.es-geom.com",10999,4)
	Echo ---- 确认
	Echo ┆
	Echo ┆ 工作路径: %MainPath%
	Echo ┆
	Echo ┆ 联机版路径:%Path_DST%
If Exist "%Path_DST%" (
	Echo ┆ └ 存在
) else (
	Echo ┆ └ 错误
)
	Echo ┆
	Echo ┆ 服务器路径:%Path_DSTDS%
If Exist "%Path_DSTDS%" (
	Echo ┆ └ 存在
) else (
	Echo ┆ └ 错误
)
	Echo ┆
	Echo ┆ Workshop路径:%Workshop%
If Exist "%Workshop%" (
	Echo ┆ └ 存在
) else (
	Echo ┆ └ 错误
)
	Echo ┆
	Echo ┆ 文档路径:%Path_Doc%
	Echo ┆ ├ 联机版集群:%Path_Doc_DST%
If Exist "%Workshop%" (
	Echo ┆ │ └ 存在
) else (
	Echo ┆ │ └ 错误
)
	Echo ┆ ├ 服务器集群:%Path_Doc_DSTR%    '第一次使用如果你在此处已有[集群] 请转移至[联机版集群]
If Exist "%Workshop%" (
	Echo ┆ │ └ 存在
) else (
	Echo ┆ │ └ 错误
)
	Echo ┆
	Echo ┆ cluster_token: "%Path_Doc_DST%%UID%%Cluster%\cluster_token.txt"
	If Exist "%Path_Doc_DST%%UID%%Cluster%\cluster_token.txt" (
		Echo ┆ └ 存在
	) Else (
		Echo ┆ └ 未发现    将无法启动该集群
	)
	Echo ┆
	Echo ┆ ::如果路径不正确,请勿执行
	Echo ┆
	Echo ---- 检查
	Echo ┆ ::如果需要使用其他Cluster请自行编辑此脚本REM中的文件夹名
	Echo ┆ 当前选定[UID]  : %UID%
	Echo ┆ 当前选定[集群] : %Cluster%
	Echo ┆ ::当然,token存在也需要确保其代码同你Klei账户里一致.
	Echo ┆
	Echo ---- 执行
	
	Echo  0.退出
	Echo  1.部署共享
	Echo  2.同步 MOD
	Echo  3.启动服务器 %Cluster% 地面+洞穴(无洞穴则跳过)
	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Master\" (
		Echo  4.启动服务器 %Cluster% 地面
	) Else (
		Echo  4.无 %Cluster% 地面  %Path_Doc_DST%%UID%\%Cluster%\Master\
	)
	If Exist "%Path_Doc_DST%%Cluster%\Caves\" (
		Echo  5.启动服务器 %Cluster% 洞穴
	) Else (
		Echo  5.无 %Cluster% 洞穴  %Path_Doc_DST%%UID%\%Cluster%\Caves\
	)
	Echo ----
	Set Sel=""
	Set /p Sel=^:
	If %Sel%==1 Goto mkPath
	If %Sel%==2 Goto UpDateMods
	If %Sel%==3 Goto RunSvr_MasterCaves
	If %Sel%==4 Goto RunSvr_Master
	If %Sel%==5 Goto RunSvr_Caves
	If %Sel%==0 Goto Bye
	
Goto Main

:mkPath
	Echo ----
	rem Echo 链接[模组]:%Path_DSTDS%mods\
	rem If Exist "%Path_DSTDS%mods\" (
	rem 	Echo 存在
	rem 	Echo 警告!!!!如果继续,将删除此文件夹,再创建链接文件夹. 确保此文件夹是链接类型或不是链接类型并内容不需要
	rem 	Pause
	rem 	Echo 删除链接文件夹
	rem 	rd "%Path_DSTDS%mods\"
	rem 	mklink /j "%Path_DSTDS%mods\" "%Path_DST%mods\"
	rem ) Else (
	rem 	Echo :不存在,创建链接
	rem 	mklink /j "%Path_DSTDS%mods\" "%Path_DST%mods\"
	rem )
	
	Echo ----
	Echo 链接服务器集群:%Path_Doc_DSTR%
	If Exist "%Path_Doc_DSTR%" (
		Echo :存在
		Echo 警告!!!!如果继续,将删除此文件夹,再创建链接文件夹. 确保此文件夹是链接类型或不是链接类型并内容不需要
		Pause
		rd "%Path_Doc_DSTR%"
	) Else (
		Echo :不存在,创建链接
	)
	mklink /j "%Path_Doc_DSTR%" "%Path_Doc_DST%" > nul
	Echo 完成.
Goto Main

:UpDateMods
	REM --清除现有链接,确保准确性
	for /d %%i in ("%Path_DSTDS%mods\*") do (
		rd "%%i"
	)
	
	REM --Workshop
	Echo 获取 Workshop
	CD /d "%Workshop%"
	for /d %%i in (*) do (
		if Exist "%Path_DSTDS%mods\workshop-%%i" (
			rem echo workshop-%%i 存在
		) else (
			echo workshop-%%i 缺失,创建链接
			mklink /j "%Path_DSTDS%mods\workshop-%%i" "%Workshop%%%i" > nul
		)
	)
	
	Echo 获取 联机版MODS
	REM --Path_DST
	CD /d "%Path_DST%mods\"
	for /d %%i in (*) do (
		if Exist "%Path_DSTDS%mods\%%i" (
			rem echo workshop-%%i 存在
		) else (
			echo workshop-%%i 缺失,创建链接
			mklink /j "%Path_DSTDS%mods\%%i" "%Path_DST%mods\%%i" > nul
		)
	)
	CD /d %MainPath%
Goto Main

:RunSvr_Master
	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Master\" (
		Start "饥荒 - %Cluster% 地面" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Master
	) Else (
		Echo 未发现 地面 %Path_Doc_DST%%UID%\%Cluster%\Master\
		Pause
	)
Goto Main

:RunSvr_Caves
	If Exist "%Path_Doc_DST%%Cluster%\Caves\" (
		Start "饥荒 - %Cluster% 洞穴" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Caves
	) Else (
		Echo 未发现 洞穴 %Path_Doc_DST%%Cluster%\Caves\
		Pause
	)
Goto Main

:RunSvr_MasterCaves
	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Master\" (
		Start "饥荒 - %Cluster% 地面" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Master
	) Else (
		Echo 未发现 地面 %Path_Doc_DST%%UID%\%Cluster%\Master\
		Pause
		Goto Main
	)

	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Caves\" (
		Start "饥荒 - %Cluster% 洞穴" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Caves
	) Else (
		Echo 未发现 洞穴 %Path_Doc_DST%%UID%\%Cluster%\Caves\
	)
Goto Main
pause

:Bye