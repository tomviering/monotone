function fig1_col1(save_to_file)

load('e10_settings');
Nv_list = [5,15,25,50,100,1000]; % if Nv = 1000 it takes really long and 
% runs out of memory for some reason...
conf_list = [0.005, 0.05, 0.1, 0.25, 0.45, 0.49, 0.5];


%% first plot to give impression

figure;

conf_id = 3;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for Nv_id = [2,5]
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    r.xval = r.xval*2;
    if Nv_id == 2
        addtoplot(r,normal_learner,'',count_validation_data,'-k');
    end
    addtoplot(r,binomial,sprintf('$N_v$=%d $\\alpha$=%g',settings.Nv,settings.confidence_level),count_validation_data,'-');
    addtoplot(r,simple,sprintf('$N_v$=%d',settings.Nv),count_validation_data,':');
end

[settings,r] = load_all(settings_obj{1,1});
r.xval = r.xval*2;
addtoplot(r,binomial,sprintf('$N_v$=%d $\\alpha$=%g',settings.Nv,settings.confidence_level),count_validation_data,'-');

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
%%
fn = 'fig_peaking_1';
if (save_to_file)
    export_fig([fn '.pdf'],'-nocrop')
    legend off
    export_fig([fn '_nolegend.pdf'],'-nocrop')
    legend show
    h = legend;
    h.Interpreter = 'Latex';
end

%%

load('e11_settings');
Nv_list = [5,15,25,50,100, 1000]; % if Nv = 1000 it takes really long and 
% runs out of memory for some reason...
conf_list = [0.005, 0.05, 0.1, 0.25, 0.45, 0.49, 0.5];


%% first plot to give impression

figure;

conf_id = 2;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

first = 1;
for Nv_id = [2,5]
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    r.xval = r.xval*2;
    if first
        addtoplot(r,normal_learner,'',count_validation_data,'-k');
        first = 0;
    end
    addtoplot(r,binomial,sprintf('$N_v$=%d $\\alpha$=%g',settings.Nv,settings.confidence_level),count_validation_data,'-');
    addtoplot(r,simple,sprintf('$N_v$=%d',settings.Nv),count_validation_data,':');
end

%[settings,r] = load_all(settings_obj{1,1});
%addtoplot(r,binomial,sprintf('$N_v$=%d $\\alpha$=%g',settings.Nv,settings.confidence_level),count_validation_data,'-');

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
%%
fn = 'fig_dipping_1';
if (save_to_file)
    export_fig([fn '.pdf'],'-nocrop')
    legend off
    export_fig([fn '_nolegend.pdf'],'-nocrop')
    legend show
    h = legend;
    h.Interpreter = 'Latex';
end

