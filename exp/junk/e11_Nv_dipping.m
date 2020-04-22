clear all;

addpath('helpers');
addpath('../');
addpath('../prtools');
addpath('../learners');
addpath('../dat');

%% set up the settings for the experiments

Nv_list = [5,15,25,50,100, 1000]; 
conf_list = [0.005, 0.05, 0.1, 0.25, 0.45, 0.49, 0.5];

settings.Nl = 2; % samples per class
settings.n = 150;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 100;
settings.N_testsize = 10000;

settings.regularization_list = [];

settings.learner_list = [2,3,11];
% 1: normal learner
% 2: monotone simple
% 3: monotone binomial test

% 4: crossval slow
% 5: crossval fast

% 6: monotone binomial test add val
% 7: monotone binomial test reuse val
% 8: monotone simple add val
% 9: monotone simple reuse val

% 10: optimal regularization
% 11: train on training data only

settings.dataset_id = 3;

for Nv_id = 1:length(Nv_list)
    
    for conf_id = 1:length(conf_list)

        settings.Nv = Nv_list(Nv_id);
        settings.confidence_level = conf_list(conf_id);

        % 1: peaking (d=200)
        % 2: random
        % 3: dipping
        settings.d_peaking = 200;

        

    end
    
end
    
fclose(fid_alljobs);

syncjobs(); 
syncsettings(); 

if length(fast_jobs_all) == 0
    fprintf('\nMaster job script file written to %s.sh\nRun command: ./%s.sh\n',fn_alljobs,fn_alljobs);
    fprintf('\nDont forget to git pull!');
else
    fprintf('\nFirst submit fast jobs:\n');
    fprintf(fast_jobs_all);
    fprintf('\nDont forget to git pull!');
end

%%

clc;
load('e11_settings');
Nv_list = [5,15,25,50,100, 1000]; % if Nv = 1000 it takes really long and 
% runs out of memory for some reason...
conf_list = [0.005, 0.05, 0.1, 0.25, 0.45, 0.49, 0.5];


%% first plot to give impression

figure;

addpath('/home/tom/Projects/ND_code/export_fig');
save_to_file = 1;

conf_id = 2;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

first = 1;
for Nv_id = [2,5]
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
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
ylabel('$\bar{\epsilon}$','Interpreter','Latex')

set(gcf,'color','white')
h = legend;
set(h,'FontSize',11)
ax = findall(gcf,'-property','FontSize');
ax = ax(2);
set(ax,'FontSize',10)
set(gcf,'color','w');
ax = findall(gcf,'-property','FontSize');
ax = ax(3:4);
set(ax,'FontSize',16)

set(get(gca,'Children'),'LineWidth',2)

fn = 'fig_dipping_1';
if (save_to_file)
    export_fig([fn '.pdf'],'-nocrop')
    legend off
    export_fig([fn '_nolegend.pdf'],'-nocrop')
    legend show
    h = legend;
    h.Interpreter = 'Latex';
end




%% influence of NV
conf_id = 4;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for Nv_id = [1,6]
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    if Nv_id == 1
        addtoplotE(r,normal_learner,'',count_validation_data);
    end
    addtoplotE(r,binomial,sprintf('Nv=%d',settings.Nv),count_validation_data);
end

title(sprintf('confidence level %g',settings.confidence_level));

%% influence of NV on simple
conf_id = 1;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for Nv_id = 1:6
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    if Nv_id == 1
        addtoplot(r,normal_learner,'',count_validation_data);
    end
    addtoplot(r,simple,sprintf('Nv=%d',settings.Nv),count_validation_data);
end

%title(sprintf('confidence level %g',settings.confidence_level));

%% Influence of confidence

Nv_id = 5;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for conf_id = 1:7
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    if conf_id == 1
        addtoplot(r,simple,'',count_validation_data, ':');
    end
    if conf_id == 1
        addtoplot(r,binomial,sprintf('alpha=%g',settings.confidence_level),count_validation_data,'b');
    else
        addtoplot(r,binomial,sprintf('alpha=%g',settings.confidence_level),count_validation_data);
    end
    
end

title(sprintf('NV %g',settings.Nv));

%% Confidence single run

rep = 1:20;
Nv_id = 3;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

skip_info = 1;

for conf_id = 1
    [settings,r] = load_all(settings_obj{Nv_id,conf_id},skip_info);
    if conf_id == 2
        %addtoplotsingle(r,simple,'',rep,count_validation_data, ':');
    end
    if conf_id == 2
        %addtoplotsingle(r,binomial,sprintf('alpha=%g',settings.confidence_level),rep,count_validation_data,'b');
    else
        %addtoplotsingle(r,binomial,sprintf('alpha=%g',settings.confidence_level),rep,count_validation_data);
    end
    
    
    for repi = 1:100
        h = addtoplotsingle(r,normal_learner,sprintf('alpha=%g',settings.confidence_level),repi,count_validation_data,'r');
        h{1,1}.Color = [1,0,0,0.1];
    end
    %for repi = 1:100
    %    h = addtoplotsingle(r,binomial,sprintf('alpha=%g',settings.confidence_level),repi,count_validation_data,'b');
    %    h{1,1}.Color = [0,0,1,0.3];
    %end
    %addtoplotsingle(r,binomial,sprintf('alpha=%g',settings.confidence_level),rep,count_validation_data,'r-*');
end
legend off
title(sprintf('NV %g confidence %g',settings.Nv,settings.confidence_level));

%%

conf_id = 1;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

for Nv_id = 1:6
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    if Nv_id == 1
        addtoplot(r,normal_learner,'');
    end
    addtoplot(r,binomial,sprintf('Nv=%d',settings.Nv));
end

title(sprintf('confidence level %g',settings.confidence_level));

%% look at models

Nv_id = 1;
conf_id = 1;
skip_info = 0;
[settings,r] = load_all(settings_obj{Nv_id,conf_id},skip_info);

%% Confidence single run

rep = 1;
Nv_id = 1;
conf_id = 1;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

skip_info = 0;

[settings,r] = load_all(settings_obj{Nv_id,conf_id},skip_info);

%%
figure;
addtoplotsingle(r,[1:3],'',rep,count_validation_data);

%%

r.info_keep{1,1,1}.w_best % simple
r.info_keep{1,2,1}.w_best % binomial
r.info_keep{1,3,1}.w_best % normal

%% Collect AULC data

conf_id = 3;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for Nv_id = 1:6
    for conf_id = 1:7
        [settings,r] = load_all(settings_obj{Nv_id,conf_id});
        AULC(Nv_id,conf_id,:) = reshape(mean(mean(r.error,1),3),1,1,3);
    end
end

%% normal learner check

figure;
hold on;
for Nv_id = 1:6
    Y = squeeze(AULC(Nv_id,:,:));
    X = repmat(conf_list',1,size(Y,2));
    
    col = get(gca,'colororder');
    col = col(Nv_id,:);
    i = 3;
    myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
    plot(X(:,i),Y(:,i),'.-','DisplayName',myleg,'Color','k');

end

legend show
ylabel('AULC')
xlabel('confidence level')


%% AULC vs confidence

figure;
hold on;
for Nv_id = 1:6
    Y = squeeze(AULC(Nv_id,:,:));
    X = repmat(conf_list',1,size(Y,2));
    
    col = get(gca,'colororder');
    col = col(Nv_id,:);
    for i = 1
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),':','DisplayName',myleg,'Color',col);
    end
    for i = 2
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),'.-','DisplayName',myleg,'Color',col);
    end
    if Nv_id == 6
        i = 3;
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),'.-','DisplayName',myleg,'Color','k');
    end
end

legend show
ylabel('AULC')
xlabel('confidence level')

%% AULC vs NV

figure;
hold on;
for conf_id = 1:6
    Y = squeeze(AULC(:,conf_id,:));
    X = repmat(Nv_list',1,size(Y,2));
    
    col = get(gca,'colororder');
    col = col(conf_id,:);
    
    for i = 2
        myleg = [r.leg{i}, sprintf('alpha=%g',conf_list(conf_id))];
        plot(log10(X(:,i)),Y(:,i),'.-','DisplayName',myleg,'Color',col);
    end
    if conf_id == 6
        i = 1
        myleg = [r.leg{i}, sprintf('alpha=%g',conf_list(conf_id))];
        plot(log10(X(:,i)),Y(:,i),'.:','DisplayName',myleg,'Color',col,'LineWidth',2);
    end
    if conf_id == 6
        i = 3;
        myleg = [r.leg{i}, sprintf('alpha=%g',conf_list(conf_id))];
        plot(log10(X(:,i)),Y(:,i),'.-','DisplayName',myleg,'Color','k');
    end
end

legend show
ylabel('AULC')
xlabel('NV')

%% #non-monotone

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for Nv_id = 1:6
    for conf_id = 1:7
        [settings,r] = load_all(settings_obj{Nv_id,conf_id});
        non_monotone_avg(Nv_id,conf_id,:) = mean(mean(r.non_monotone,1),3);
        %non_monotone_avg(Nv_id,conf_id,:) = reshape(max(mean(r.non_monotone,1),[],3),1,1,3);
    end
end

%% non-monotone vs NV

figure;
hold on;
for conf_id = 1:7
    Y = squeeze(non_monotone_avg(:,conf_id,:));
    X = repmat(Nv_list',1,size(Y,2));
    
    col = get(gca,'colororder');
    col = col(conf_id,:);
    
    for i = 2
        myleg = [r.leg{i}, sprintf('alpha=%g',conf_list(conf_id))];
        plot(log10(X(:,i)),log10(Y(:,i)),'.-','DisplayName',myleg,'Color',col);
    end
    if conf_id == 7
        i = 1
        myleg = [r.leg{i}, sprintf('alpha=%g',conf_list(conf_id))];
        plot(log10(X(:,i)),log10(Y(:,i)),'.:','DisplayName',myleg,'Color',col,'LineWidth',2);
    end
    if conf_id == 7
        i = 3;
        myleg = [r.leg{i}, sprintf('alpha=%g',conf_list(conf_id))];
        plot(log10(X(:,i)),log10(Y(:,i)),'.-','DisplayName',myleg,'Color','k');
    end
end

legend show
ylabel('log10(frac non-monotone)')
xlabel('log10(NV)')

%%

figure;
hold on;
for Nv_id = 1:6
    Y = squeeze(non_monotone_avg(Nv_id,:,:));
    X = repmat(conf_list',1,size(Y,2));
    
    col = get(gca,'colororder');
    col = col(Nv_id,:);
    for i = 1
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),':','DisplayName',myleg,'Color',col);
    end
    for i = 2
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),'.-','DisplayName',myleg,'Color',col);
    end
    if Nv_id == 6
        i = 3;
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),'.-','DisplayName',myleg,'Color','k');
    end
end

legend show
ylabel('frac non-monotone')
xlabel('confidence level')
%%
figure;
hold on;
for Nv_id = 1:6
    Y = squeeze(non_monotone_avg(Nv_id,:,:));
    X = repmat(conf_list',1,size(Y,2));
    
    col = get(gca,'colororder');
    col = col(Nv_id,:);
    %for i = 1
    %    myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
    %    plot(X(:,i),Y(:,i),':','DisplayName',myleg,'Color',col);
    %end
    for i = 2
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),'.-','DisplayName',myleg,'Color',col);
    end
    if Nv_id == 7
        i = 3;
        myleg = [r.leg{i}, sprintf('Nv=%d',Nv_list(Nv_id))];
        plot(X(:,i),Y(:,i),'.-','DisplayName',myleg,'Color','k');
    end
end

legend show
ylabel('frac non-monotone')
xlabel('confidence level')
