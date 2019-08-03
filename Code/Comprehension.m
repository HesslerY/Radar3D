function varargout = Comprehension(varargin)
% COMPREHENSION MATLAB code for Comprehension.fig
%      COMPREHENSION, by itself, creates a new COMPREHENSION or raises the existing
%      singleton*.
%
%      H = COMPREHENSION returns the handle to a new COMPREHENSION or the handle to
%      the existing singleton*.
%
%      COMPREHENSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPREHENSION.M with the given input arguments.
%
%      COMPREHENSION('Property','Value',...) creates a new COMPREHENSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Comprehension_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Comprehension_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Comprehension

% Last Modified by GUIDE v2.5 30-Jun-2019 13:15:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Comprehension_OpeningFcn, ...
                   'gui_OutputFcn',  @Comprehension_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Comprehension is made visible.
function Comprehension_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure


% varargin   command line arguments to Comprehension (see VARARGIN)

% Choose default command line output for Comprehension
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Comprehension wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Comprehension_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure



% Get default command line output from handles structure
varargout{1} = handles.output;



function Cv_Callback(hObject, eventdata, handles)
global C ;
C = str2double(get(hObject,'String')); %returns contents of Cv as a double

function Cv_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function C_Callback(hObject, eventdata, handles)
function C_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
global PulseNum ;
PulseNum = str2double(get(hObject,'String'));

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit7_Callback(hObject, eventdata, handles)
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit8_Callback(hObject, eventdata, handles)
global BandWidth ;
BandWidth = str2double(get(hObject,'String'));

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit9_Callback(hObject, eventdata, handles)
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit10_Callback(hObject, eventdata, handles)
global TimeWidth ;
TimeWidth = str2double(get(hObject,'String'));

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit11_Callback(hObject, eventdata, handles)
function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit12_Callback(hObject, eventdata, handles)
global PRT ;
PRT = str2double(get(hObject,'String'));

function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit13_Callback(hObject, eventdata, handles)
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit14_Callback(hObject, eventdata, handles)
global Fs ;
Fs = str2double(get(hObject,'String'));

function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit15_Callback(hObject, eventdata, handles)
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit16_Callback(hObject, eventdata, handles)
global NoiseNum ;
NoiseNum = str2double(get(hObject,'String'));

function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit17_Callback(hObject, eventdata, handles)
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit18_Callback(hObject, eventdata, handles)
global Fc ;
Fc = str2double(get(hObject,'String'));

function edit18_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit19_Callback(hObject, eventdata, handles)
function edit19_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Simulation.
function Simulation_Callback(hObject, eventdata, handles)
Radar0630

% hObject    handle to Simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% load('newData.mat');
% set(handles.uitable1,'Data',newData);
Data = xlsread('Cars.xlsx');
set(hObject, 'ColumnName', {'����','����','����','����λ��'}, 'data',Data) %���������õ�uitable�ؼ���
newData = Data;
save('cars.mat','newData');



% --- Executes on button press in NewRow.
function NewRow_Callback(hObject, eventdata, handles)

%��� ���Ӻ󵯳� �Ի���
prompt ={'���ͣ�����1-10��','������-4��4����0','���٣�0-50��','����λ�ã�30-120��'}; %�Ի���������ʾ
title = '����������';    %�Ի������
lines = [1,1,1,1]; %�������������
def = { '1','3','5','30'}; %Ĭ��ֵ
tab = inputdlg(prompt,title,lines,def);  %�Ի�������
for i = 1 : length(tab)
    newArray(i) = str2num(tab{i}); %�Ի���ڶ�������
end
oldData = get(handles.uitable1,'Data'); %����ԭ��������
newData = [oldData;newArray];  %�µ�����Դ
set(handles.uitable1,'Data',newData);  %��ʾ�������
%handles.tabale = newData;
save('cars.mat','newData'); %�����������Ա��棬�����´�ʹ��


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)

newData = get(hObject,'Data'); %��ȡ���ݾ���
hang = eventdata.Indices;  %��ȡ������
hangIndex = hang(1);  %��������ֵ
handles.hangIndex = hangIndex;  %����������ӵ��ṹ��
guidata(hObject, handles);  %���½ṹ��


% --- Executes on button press in Delete.
function Delete_Callback(hObject, eventdata, handles)

% hObject    handle to delEle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%arr=get(handles.uitable1,'Data')
hangIndex = handles.hangIndex;  %��ȡѡ���Ժ���� ������
newData = get(handles.uitable1,'Data');  %��ȡ������ݾ���
newData(hangIndex,:) = [];   %ɾ��ѡ�е�ĳ������
set(handles.uitable1,'Data',newData);  %��ʾ�������
save('cars.mat','newData');  %ɾ���Ժ󣬱���һ������


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Parameter;
global C PulseNum BandWidth TimeWidth PRT Fs NoisePower Fc
set(handles.Cv,'string',C)
set(handles.edit6,'string',PulseNum);
set(handles.edit8,'string',BandWidth);
set(handles.edit10,'string',TimeWidth);
set(handles.edit12,'string',PRT);
set(handles.edit14,'string',Fs);
set(handles.edit16,'string',NoisePower);
set(handles.edit18,'string',Fc);
