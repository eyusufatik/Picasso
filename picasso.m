function [] = picasso(arg1)
    try    
        if arg1=='1' %bas�l� tutunca �izen mod
            open_system('untitled');
            set_param('untitled/Constant','value',num2str(175));
            set_param('untitled/Constant1','value',num2str(375));
            set_param('untitled','SimulationCommand', 'start');
            cizim;
        elseif arg1=='2' %her t�kta �izgi �izen mod
            open_system('untitled');
            set_param('untitled/Constant','value',num2str(175));
            set_param('untitled/Constant1','value',num2str(375));
            set_param('untitled','SimulationCommand', 'start');
            cizim2;
        end
    catch
        disp('"picasso 1" ya da "picasso 2" yaz�n�z');
end