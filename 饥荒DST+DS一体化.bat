@Echo Off

Set ScriptName=����DST+DSһ�廯  by:Rex.Pack v:1.1

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

REM ID�ļ�����  [��ѡ]
Set UID=
REM Cluster�ļ�����
Set Cluster=Cluster_1

REM ---- ·���趨 ----
REM ��Ⱥ
Set Path_Doc_DST=%Path_Doc%DoNotStarveTogether\
Set Path_Doc_DSTR=%Path_Doc%DoNotStarveTogetherRail\

REM ---- �״�ʹ�� ���е���·��
REM �������ļ���
Set Path_DST=%MainPath%\Don't Starve Together\
REM ������ļ���
Set Path_DSTDS=%MainPath%\Don't Starve Together Dedicated Server\
REM ѡ��Steam��Workshop\content\322330�ļ���
Set Workshop=D:\_Game\Game_Steam\workshop\content\322330\




REM ----
	Echo  1.����Ҫ���غ�Steam�����������������
	Echo  2.��ȡ���token,�����������̴洢���Cluster�ļ�����
	Echo  ----
	Echo  !!!!���޸Ĵ˽ű��е� [�Զ����趨] ����Ϊ��������Լ��ĵ��趨
	Echo  ----
	Echo  ��������Ҫ�󼴿ɼ���
	
:Main
	Pause
	CLS
	Echo ��
	Echo ��            %ScriptName%
	Echo ��
	Echo ---- ����
	Echo �� ʹ������������������� ��Ⱥ(Cluster) �� ģ��(MOD) ,���������[��Ⱥ]�޸�,��ӷ���������һ��
	Echo �� ���ڴ����������� [��Ⱥ]��[ģ��] ���ú�,��ֱ����Ϊ����������.
	Echo ��  ������������½�\�޸�һ��[��Ⱥ],��ɺ��������˳���[��Ⱥ](Ҳ���ǻص�������)
	Echo ��  �ٴӴ˴�����������,�����Լ��ķ�ʽ����
	Echo ��  ��� ����\ɾ�� ģ��,������ǰִ��һ�� [2.ͬ��MOD]
	Echo ��
	Echo ��  ����̨��������ο�
	Echo ��  c_connect("127.0.0.1",10999)  '�����ǽ
	Echo ��  c_connect("loaclhost",10999)
	Echo ��  c_connect("s.es-geom.com",10999,4)
	Echo ---- ȷ��
	Echo ��
	Echo �� ����·��: %MainPath%
	Echo ��
	Echo �� ������·��:%Path_DST%
If Exist "%Path_DST%" (
	Echo �� �� ����
) else (
	Echo �� �� ����
)
	Echo ��
	Echo �� ������·��:%Path_DSTDS%
If Exist "%Path_DSTDS%" (
	Echo �� �� ����
) else (
	Echo �� �� ����
)
	Echo ��
	Echo �� Workshop·��:%Workshop%
If Exist "%Workshop%" (
	Echo �� �� ����
) else (
	Echo �� �� ����
)
	Echo ��
	Echo �� �ĵ�·��:%Path_Doc%
	Echo �� �� �����漯Ⱥ:%Path_Doc_DST%
If Exist "%Workshop%" (
	Echo �� �� �� ����
) else (
	Echo �� �� �� ����
)
	Echo �� �� ��������Ⱥ:%Path_Doc_DSTR%    '��һ��ʹ��������ڴ˴�����[��Ⱥ] ��ת����[�����漯Ⱥ]
If Exist "%Workshop%" (
	Echo �� �� �� ����
) else (
	Echo �� �� �� ����
)
	Echo ��
	Echo �� cluster_token: "%Path_Doc_DST%%UID%%Cluster%\cluster_token.txt"
	If Exist "%Path_Doc_DST%%UID%%Cluster%\cluster_token.txt" (
		Echo �� �� ����
	) Else (
		Echo �� �� δ����    ���޷������ü�Ⱥ
	)
	Echo ��
	Echo �� ::���·������ȷ,����ִ��
	Echo ��
	Echo ---- ���
	Echo �� ::�����Ҫʹ������Cluster�����б༭�˽ű�REM�е��ļ�����
	Echo �� ��ǰѡ��[UID]  : %UID%
	Echo �� ��ǰѡ��[��Ⱥ] : %Cluster%
	Echo �� ::��Ȼ,token����Ҳ��Ҫȷ�������ͬ��Klei�˻���һ��.
	Echo ��
	Echo ---- ִ��
	
	Echo  0.�˳�
	Echo  1.������
	Echo  2.ͬ�� MOD
	Echo  3.���������� %Cluster% ����+��Ѩ(�޶�Ѩ������)
	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Master\" (
		Echo  4.���������� %Cluster% ����
	) Else (
		Echo  4.�� %Cluster% ����  %Path_Doc_DST%%UID%\%Cluster%\Master\
	)
	If Exist "%Path_Doc_DST%%Cluster%\Caves\" (
		Echo  5.���������� %Cluster% ��Ѩ
	) Else (
		Echo  5.�� %Cluster% ��Ѩ  %Path_Doc_DST%%UID%\%Cluster%\Caves\
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
	rem Echo ����[ģ��]:%Path_DSTDS%mods\
	rem If Exist "%Path_DSTDS%mods\" (
	rem 	Echo ����
	rem 	Echo ����!!!!�������,��ɾ�����ļ���,�ٴ��������ļ���. ȷ�����ļ������������ͻ����������Ͳ����ݲ���Ҫ
	rem 	Pause
	rem 	Echo ɾ�������ļ���
	rem 	rd "%Path_DSTDS%mods\"
	rem 	mklink /j "%Path_DSTDS%mods\" "%Path_DST%mods\"
	rem ) Else (
	rem 	Echo :������,��������
	rem 	mklink /j "%Path_DSTDS%mods\" "%Path_DST%mods\"
	rem )
	
	Echo ----
	Echo ���ӷ�������Ⱥ:%Path_Doc_DSTR%
	If Exist "%Path_Doc_DSTR%" (
		Echo :����
		Echo ����!!!!�������,��ɾ�����ļ���,�ٴ��������ļ���. ȷ�����ļ������������ͻ����������Ͳ����ݲ���Ҫ
		Pause
		rd "%Path_Doc_DSTR%"
	) Else (
		Echo :������,��������
	)
	mklink /j "%Path_Doc_DSTR%" "%Path_Doc_DST%" > nul
	Echo ���.
Goto Main

:UpDateMods
	REM --�����������,ȷ��׼ȷ��
	for /d %%i in ("%Path_DSTDS%mods\*") do (
		rd "%%i"
	)
	
	REM --Workshop
	Echo ��ȡ Workshop
	CD /d "%Workshop%"
	for /d %%i in (*) do (
		if Exist "%Path_DSTDS%mods\workshop-%%i" (
			rem echo workshop-%%i ����
		) else (
			echo workshop-%%i ȱʧ,��������
			mklink /j "%Path_DSTDS%mods\workshop-%%i" "%Workshop%%%i" > nul
		)
	)
	
	Echo ��ȡ ������MODS
	REM --Path_DST
	CD /d "%Path_DST%mods\"
	for /d %%i in (*) do (
		if Exist "%Path_DSTDS%mods\%%i" (
			rem echo workshop-%%i ����
		) else (
			echo workshop-%%i ȱʧ,��������
			mklink /j "%Path_DSTDS%mods\%%i" "%Path_DST%mods\%%i" > nul
		)
	)
	CD /d %MainPath%
Goto Main

:RunSvr_Master
	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Master\" (
		Start "���� - %Cluster% ����" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Master
	) Else (
		Echo δ���� ���� %Path_Doc_DST%%UID%\%Cluster%\Master\
		Pause
	)
Goto Main

:RunSvr_Caves
	If Exist "%Path_Doc_DST%%Cluster%\Caves\" (
		Start "���� - %Cluster% ��Ѩ" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Caves
	) Else (
		Echo δ���� ��Ѩ %Path_Doc_DST%%Cluster%\Caves\
		Pause
	)
Goto Main

:RunSvr_MasterCaves
	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Master\" (
		Start "���� - %Cluster% ����" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Master
	) Else (
		Echo δ���� ���� %Path_Doc_DST%%UID%\%Cluster%\Master\
		Pause
		Goto Main
	)

	If Exist "%Path_Doc_DST%%UID%\%Cluster%\Caves\" (
		Start "���� - %Cluster% ��Ѩ" /d "%Path_DSTDS%bin\" cmd /k "%Path_DSTDS%bin\dontstarve_dedicated_server_nullrenderer.exe" -console -cluster %UID%\%Cluster% -shard Caves
	) Else (
		Echo δ���� ��Ѩ %Path_Doc_DST%%UID%\%Cluster%\Caves\
	)
Goto Main
pause

:Bye