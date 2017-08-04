function varargout = cizim(varargin)
% CIZIM MATLAB code for cizim.fig
%      CIZIM, by itself, creates a new CIZIM or raises the existing
%      singleton*.
%
%      H = CIZIM returns the handle to a new CIZIM or the handle to
%      the existing singleton*.
%
%      CIZIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIZIM.M with the given input arguments.
%
%      CIZIM('Property','Value',...) creates a new CIZIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cizim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cizim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cizim

% Last Modified by GUIDE v2.5 25-Jul-2017 15:21:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cizim_OpeningFcn, ...
                   'gui_OutputFcn',  @cizim_OutputFcn, ...
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


% --- Executes just before cizim is made visible.
function cizim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cizim (see VARARGIN
handles.output = hObject;
guidata(hObject, handles);
global bool;
bool=false;
global arrayX;
arrayX=zeros(1);
global arrayY;
arrayY=zeros(1);

    
 function empty(~,~,~)

 %0 kalemi indirir 1 kaldýrýr
function send(xcoord,ycoord)
    if xcoord < 1
        xcoord=1
       set_param('untitled/Constant2','value',num2str(0));
    elseif xcoord > 350
        xcoord=350
       set_param('untitled/Constant2','value',num2str(0));
    end
    
    if ycoord < 1
        ycoord=1
       set_param('untitled/Constant2','value',num2str(0));
    elseif ycoord > 750
        ycoord=750
        set_param('untitled/Constant2','value',num2str(0));
    end
    set_param('untitled/Constant','value',num2str(xcoord));
    set_param('untitled/Constant1','value',num2str(ycoord));
       
    
    
% --- Outputs from this function are returned to the command line.
function varargout = cizim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bool;
bool=false;
%fonksiyonu geri set et
set(handles.figure1,'WindowButtonMotionFcn',@(hObject,eventdata)figure1_WindowButtonMotionFcn(hObject,eventdata,guidata(hObject)));
set_param('untitled/Constant2','value',num2str(0));
global x;
x=0;

function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'WindowButtonMotionFcn',@empty); %iki fonksiyonunda çalýþmamasý için
global bool;
bool=true;
global lastX;
global lastY;
global x;
time=tic();
while bool    
    coord=get(handles.axes4,'CurrentPoint');
    xcoord = 351-round(coord(1)*349+1);
    ycoord = 751-round(coord(3)*749+1);
   if x > 1
    arrayX=[lastX coord(1)];
    arrayY=[lastY coord(3)];
    l=line(arrayX,arrayY);
    l.HitTest='off';
    l.LineWidth=3;
    if xcoord > 1 && xcoord < 350 && ycoord > 1 && ycoord < 750
        set_param('untitled/Constant2','value',num2str(1));
    else
        set_param('untitled/Constant2','value',num2str(0));
    end
   end
    drawnow;
    if toc(time) >= 0.20 %saniyede 5 kere gönder
        send(xcoord,ycoord);
        time = tic();
    end
    x = x+1;
    lastX=coord(1);
    lastY=coord(3);
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    coord=get(handles.axes4,'CurrentPoint');
    xcoord = 351-round(coord(1)*349+1);
    ycoord = 751-round(coord(3)*749+1);
    send(xcoord,ycoord);
