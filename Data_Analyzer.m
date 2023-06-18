function varargout = Data_Analyzer(varargin)
% DATA_ANALYZER MATLAB code for Data_Analyzer.fig
%      DATA_ANALYZER, by itself, creates a new DATA_ANALYZER or raises the existing
%      singleton*.
%
%      H = DATA_ANALYZER returns the handle to a new DATA_ANALYZER or the handle to
%      the existing singleton*.
%
%      DATA_ANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_ANALYZER.M with the given input arguments.
%
%      DATA_ANALYZER('Property','Value',...) creates a new DATA_ANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_Analyzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_Analyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_Analyzer

% Last Modified by GUIDE v2.5 18-Jun-2023 12:34:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_Analyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_Analyzer_OutputFcn, ...
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


% --- Executes just before Data_Analyzer is made visible.
function Data_Analyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Data_Analyzer (see VARARGIN)

set(findall(hObject,'-property','Units'),'Units','Normalized'); % Auto resize all objects in GUI

% Choose default command line output for Data_Analyzer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Data_Analyzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Data_Analyzer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in import_input_btn.
function import_input_btn_Callback(hObject, eventdata, handles)
% hObject    handle to import_input_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global remove_param_sig;
    global plot_obj;
    
    remove_param_sig = {};
    plot_obj = {};
    [inp_name, inp_path] = uigetfile('*.csv;*.mat;*.xlsx','Select Input CSV');
    if inp_name ~= 0
        set(handles.input_path,'string',[inp_path,inp_name]);
        global table_data;
        global signals_name;
        global plotted_sig;
        global extension;
        plotted_sig = [];

        set(handles.status_txt,'String','Loading Data, Please wait.....');
        pause(1);
        [~,~,extension] = fileparts(inp_name);
        
        % for csv or excel data
        if(strcmp(extension,'.csv') || strcmp(extension,'.xlsx'))
            table_data = readtable([inp_path,inp_name]);
            signals_name = table_data.Properties.VariableNames;
        else
            % for mat data
            table_data = load([inp_path,inp_name]);
            signals_name = fieldnames(table_data);
        end

        if ~strcmp(extension,'.mat')
            % set x-axis drpopdown
            set(handles.x_axis_dropdown,'String',signals_name);
            set(handles.x_axis_param,'Enable','on'); 
        else
            % set y axis dropdown excluding above one
            %y_params = signals_name(~strcmp(signals_name,x_param));
            set(handles.signal_dropdown,'String',signals_name);

            set(handles.plot_signal,'Enable','on');
        end
        set(handles.status_txt,'String','Data Imported Successfully!!','ForegroundColor',[0 0.4 0.2]);
        return;
    else
        set(handles.status_txt,'String','No Inputs Selected','ForegroundColor',[1 0 0]);
        return;
    end



function input_path_Callback(hObject, eventdata, handles)
% hObject    handle to input_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_path as text
%        str2double(get(hObject,'String')) returns contents of input_path as a double


% --- Executes during object creation, after setting all properties.
function input_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in signal_dropdown.
function signal_dropdown_Callback(hObject, eventdata, handles)
% hObject    handle to signal_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signal_dropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signal_dropdown


% --- Executes during object creation, after setting all properties.
function signal_dropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signal_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel1 is resized.
function uipanel1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plot_signal.
function plot_signal_Callback(hObject, eventdata, handles)
% hObject    handle to plot_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global table_data;
    %global signals_name;
    global x_param;
    global plotted_sig;
    global remove_param_sig;
    global plot_obj;
    global extension;
    
    interpret_flag = 0;
    
    selected_idx = get(handles.signal_dropdown,'Value');
    
    % if signal not plotted already, plot it
    if isempty(plotted_sig)|| ~ismember(selected_idx,plotted_sig)
        cr_sigName = handles.signal_dropdown.String{selected_idx};
        if strcmp(extension,'.csv') || strcmp(extension,'.xlsx')
            yData = table_data.(cr_sigName);
            xData = table_data.(x_param);
        else
            xData = table_data.(cr_sigName).Time;
            yData = table_data.(cr_sigName).Data;
        end
        if contains(cr_sigName,'_')
            cr_sigName = strrep(cr_sigName,'_',' ');
            interpret_flag = 1;
        end
        
        obj = plot(handles.axes1,xData,yData,'LineWidth',2,'DisplayName',cr_sigName);
        grid(handles.axes1,'on');
        legend(handles.axes1);
        hold on;
        
        if interpret_flag
            cr_sigName = strrep(cr_sigName,' ','_');
        end
        
        if isempty(plotted_sig)
            plotted_sig(1) = (selected_idx);
        else
            plotted_sig(end+1) = (selected_idx);
        end
        
        if isempty(remove_param_sig)
            remove_param_sig{1} = cr_sigName;
        else
            remove_param_sig{end+1} = cr_sigName;
        end
        
        if isempty(plot_obj)
            plot_obj{1} = obj;
        else
            plot_obj{end+1} = obj;
        end
        
        % update remove param drop down
        set(handles.remove_param_dropdown,'String',remove_param_sig);
        set(handles.remove_plot_btn,'Enable','on');
        set(handles.remove_param_dropdown,'Enable','on');
        set(handles.status_txt,'String',[cr_sigName,' plotted successfully!!!'],'ForegroundColor',[0 0.4 0]);
        return;
    else
        cr_sigName = handles.signal_dropdown.String{selected_idx};
        set(handles.status_txt,'String',[cr_sigName,' already plotted'],'ForegroundColor',[1 0 0]);
        return;
        
    end


% --- Executes on button press in Reset_button.
function Reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to Reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global table_data;
    global signals_name;
    %global sig_names;
    global plotted_sig;
    global plot_obj;
    global remove_param_sig;
    
    cla(handles.axes1);
    clear table_data;
    clear signals_name;
    %clear sig_names;
    clear plotted_sig;
    clear plot_obj;
    clear remove_param_sig;
    
%     childObjects = get(handles.signal_dropdown,'Children');
%     delete(childObjects);
    %set(handles.signal_dropdown,'String',{})
    set(handles.signal_dropdown,'String','Y Parameter');
    set(handles.signal_dropdown,'Value',1);
    set(handles.x_axis_dropdown,'String','X Parameter');
    set(handles.x_axis_dropdown,'Value',1);
    set(handles.remove_param_dropdown,'String','Parameter');
    set(handles.remove_param_dropdown,'Value',1);
    set(handles.remove_plot_btn,'Enable','off');
    set(handles.input_path,'String','');
    set(handles.x_axis_param,'Enable','off');
    set(handles.plot_signal,'Enable','off');
    set(handles.status_txt,'String','*');
    
    


% --- Executes on selection change in x_axis_dropdown.
function x_axis_dropdown_Callback(hObject, eventdata, handles)
% hObject    handle to x_axis_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns x_axis_dropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from x_axis_dropdown


% --- Executes during object creation, after setting all properties.
function x_axis_dropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_axis_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in x_axis_param.
function x_axis_param_Callback(hObject, eventdata, handles)
% hObject    handle to x_axis_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global signals_name;
    global x_param;
    
    selected_idx = get(handles.x_axis_dropdown,'Value');
    x_param = handles.x_axis_dropdown.String{selected_idx};
    set(handles.x_axis_dropdown,'String',x_param);
    
    % set y axis dropdown excluding above one
    y_params = signals_name(~strcmp(signals_name,x_param));
    set(handles.signal_dropdown,'String',y_params);
    
    set(handles.plot_signal,'Enable','on');
    set(handles.x_axis_param,'Enable','off');
    set(handles.x_axis_dropdown,'Enable','off');


% --- Executes on selection change in remove_param_dropdown.
function remove_param_dropdown_Callback(hObject, eventdata, handles)
% hObject    handle to remove_param_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns remove_param_dropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from remove_param_dropdown


% --- Executes during object creation, after setting all properties.
function remove_param_dropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_param_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in remove_plot_btn.
function remove_plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global plot_obj;
    global remove_param_sig;
    
    selected_idx = get(handles.remove_param_dropdown,'Value');
    signame = handles.remove_param_dropdown.String{selected_idx};
    
    delete(plot_obj{selected_idx});
    drawnow;
    
    % update both cell arrays
    plot_obj(selected_idx) = [];
    remove_param_sig(selected_idx) = [];
    
    if isempty(remove_param_sig)
        set(handles.remove_param_dropdown,'String','Parameter');
        set(handles.remove_param_dropdown,'Value',1);
        set(handles.remove_plot_btn,'Enable','off');
    else
        set(handles.remove_param_dropdown,'String',remove_param_sig);
        set(handles.remove_param_dropdown,'Value',1);
    end
    
    set(handles.status_txt,'String',[signame,' Removed Successfully!!!'],'ForegroundColor',[0 0.5 0]);
    return;
    
    
    
    
