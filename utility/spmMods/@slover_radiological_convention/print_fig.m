function print_fig(obj, filename, printstr)
% print slice overlay figure
% FORMAT print_fig(obj, filename, printstr)
% 
% Input 
% obj       - object
% filename  - optional filename to print to (obj.filename)
% printstr  - optional string giving print command (obj.printstr)
%
% Based on spm_figure print, and including fix from thence for ps
% printing
% 
% $Id: print_fig.m,v 1.1 2005/04/20 15:05:36 matthewbrett Exp $ 
  
if nargin < 2
  filename = [];
end
if isempty(filename)
  filename = obj.printfile;
end
if nargin < 3
  printstr = '';
end
if isempty(printstr)
  printstr = obj.printstr;
end

%-Note current figure, & switch to figure to print
cF = get(0,'CurrentFigure');
set(0,'CurrentFigure',obj.figure)

%-Temporarily change all units to normalized prior to printing
% (Fixes bizzarre problem with stuff jumping around!)
%-----------------------------------------------------------------------
H  = findobj(get(obj.figure,'Children'),'flat','Type','axes');
un = cellstr(get(H,'Units'));
set(H,'Units','normalized')

%-Print
%-----------------------------------------------------------------------
err = 0;
try, eval([printstr ' ' filename]), catch, err=1; end
if err
    errstr = lasterr;
    tmp = [find(abs(errstr)==10),length(errstr)+1];
    str = {errstr(1:tmp(1)-1)};
    for i = 1:length(tmp)-1
        if tmp(i)+1 < tmp(i+1) 
            str = [str, {errstr(tmp(i)+1:tmp(i+1)-1)}];
        end
    end
    str = {str{:},  '','- print command is:',['    ',printstr ' ' filename],...
            '','- current directory is:',['    ',pwd],...
            '','            * nothing has been printed *'};
    for i=1:length(str)
      disp(str{i});end
end

set(H,{'Units'},un)
set(0,'CurrentFigure',cF)

return
