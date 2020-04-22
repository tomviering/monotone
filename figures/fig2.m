function fig2(save_to_file,dat_id)
% 1 = peaking
% 3 = dipping
% 4 = MNIST old buggy code
% 5 = MNIST fixed code

load('e14_settings')

%tmp = load('e18_settings_fixed');
%settings_obj{4} = tmp.settings_obj;
load('e19_settings')
settings_obj{5} = MNIST19_settings;

%% first plot to give impression

figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 1;

[settings,r] = load_all(settings_obj{dat_id});
r = filterruns(r,1:100);
listlearners(r)

if (dat_id ~= 4)&&(dat_id ~= 5) %MNIST didnt do stratified sampling ;)
    r.xval = r.xval*2;
    r.xval2 = r.xval2*2;
end

% 1,4,3,2,5

addtoplot(r,1,'',count_validation_data,'-');
addtoplot(r,4,'',count_validation_data,'-');
addtoplot(r,3,'',count_validation_data,'-');
addtoplot(r,2,'',count_validation_data,'-');
addtoplot(r,5,'',count_validation_data,'-');
%addtoplot(r,6,'',count_validation_data,'-');
%addtoplot(r,simple,sprintf('$N_v$=%d',settings.Nv),count_validation_data,':');

if (dat_id == 4)||(dat_id == 5)
    %xlim([0, 1000])
else
    xlim([0, 7500]);
end

fix_legend();

%title(sprintf('confidence level %g',settings.confidence_level));
xlabel('training set size','Interpreter','Latex')
ylabel('average error rate $\bar{\epsilon}$','Interpreter','Latex')

set(gcf,'color','white')
h = legend;
set(h,'FontSize',16)
ax = findall(gcf,'-property','FontSize');
ax = ax(2);
set(ax,'FontSize',10)
set(gcf,'color','w');
ax = findall(gcf,'-property','FontSize');
ax = ax(3:4);
set(ax,'FontSize',16)

set(get(gca,'Children'),'LineWidth',2)

if dat_id == 1
    fn = 'fig_peaking_4';
elseif dat_id == 3
    fn = 'fig_dipping_4';
    legend('Location','SouthEast')
elseif dat_id == 4
    fn = 'fig_MNIST';
    legend('Location','NorthEast')
elseif dat_id == 5
    fn = 'fig_MNIST_new';
    legend('Location','NorthEast')
end
%%
if (save_to_file)
    export_fig([fn '.pdf'],'-nocrop')
    legend off
    export_fig([fn '_nolegend.pdf'],'-nocrop')
    legend show
    h = legend;
    h.Interpreter = 'Latex';
end

