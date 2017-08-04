function varargout = cizim2(varargin)
% CIZIM2 MATLAB code for cizim2.fig
%      CIZIM2, by itself, creates a new CIZIM2 or raises the existing
%      singleton*.
%
%      H = CIZIM2 returns the handle to a new CIZIM2 or the handle to
%      the existing singleton*.
%
%      CIZIM2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIZIM2.M with the given input arguments.
%
%      CIZIM2('Property','Value',...) creates a new CIZIM2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cizim2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cizim2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cizim2

% Last Modified by GUIDE v2.5 02-Aug-2017 15:22:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cizim2_OpeningFcn, ...
                   'gui_OutputFcn',  @cizim2_OutputFcn, ...
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


% --- Executes just before cizim2 is made visible.
function cizim2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cizim2 (see VARARGIN)

% Choose default command line output for cizim2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cizim2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global axes;
axes=handles.axes1;
set(gca,'buttondownfcn',@mybttnfcn); %figure1_WindowButtonDownFcn'ý mybttnfcn yap
global x;
x = 0;

% --- Outputs from this function are returned to the command line.
function varargout = cizim2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%0 kalemi kaldýrýr; 1 indirir
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
    
function mybttnfcn(h,~,~)
    global circle;
    global axes;
    global lastX;
    global lastY;
    global x;
    hf = get(h,'parent');
    b = get(hf,'selectiontype');
    coord = get(axes,'CurrentPoint');
    if strcmpi(b,'normal') || strcmpi(b,'open') %normal týk ve çift týk
        if x==0
            hold on;
            circle=plot(coord(1), coord(3), '.k', 'MarkerSize',40);  %siyah daire çiz
            circle.HitTest='off';
            hold off;          %guiyi yenile 
        end
        if x >= 1
            arrayX=[lastX coord(1)];
            arrayY=[lastY coord(3)];
            l=line(arrayX,arrayY);
            l.HitTest='off';
            l.LineWidth=3;
            delete(circle);
        end
        lastX=coord(1);
        lastY=coord(3);
        xcoord = 351-round(coord(1)*349+1);
        ycoord = 751-round(coord(3)*749+1);
        send(xcoord,ycoord);
        x = x+1;
        pause(0.50);
        set_param('untitled/Constant2','value',num2str(1));
    elseif strcmpi(b,'alt') %sað týk
        set_param('untitled/Constant2','value',num2str(0));
        x=0;
    end