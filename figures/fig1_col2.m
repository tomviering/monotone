function fig1_col2(save_to_file, peaking)

%peaking = 0;

if peaking == 1
    load('e10_settings');
else
    load('e11_settings');
end

Nv_list = [5,15,25,50,100,1000]; % if Nv = 1000 it takes really long and 
% runs out of memory for some reason...
conf_list = [0.005, 0.05, 0.1, 0.25, 0.45, 0.49, 0.5];
%%

% first, average over first dim to get fraction (dim 1 = rounds)
% second, max over runs (dim 2 = runs)

%figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for Nv_id = 1:6
    for conf_id = 1:7
        [settings,r] = load_all(settings_obj{Nv_id,conf_id});
        % average AULCs. 
        % so first average over rounds (dim 1), then average over repeats
        % (dim 3)
        AULC(Nv_id,conf_id,:) = reshape(mean(mean(r.error,1),3),1,1,3);
    end
end

%% AULC vs NV

figure;
hold on;
first = 1;
for conf_id = 5:-1:1
    Y = squeeze(AULC(:,conf_id,:));
    X = repmat(Nv_list',1,size(Y,2));
    
    col = get(gca,'colororder');
    col = col(conf_id,:);
    
    if first
        i = 3;
        myleg = [r.leg{i},' '];
        Ynew = repmat(mean(Y(:,i)),6,1);
        plot((X(:,i)),Ynew,'*-','DisplayName',myleg,'Color','k');
        
        i = 1
        myleg = [r.leg{i}, ' '];
        plot((X(:,i)),Y(:,i),'*:','DisplayName',myleg,'Color',col,'LineWidth',2);
        
    end
    first = 0;
    
    for i = 2
        myleg = [r.leg{i}, sprintf(' $\\alpha$=%g',conf_list(conf_id))];
        plot((X(:,i)),Y(:,i),'*-','DisplayName',myleg,'Color',col);
    end
    
end

legend show
ylabel('AULC','Interpreter','Latex')
xlabel('$N_v$','Interpreter','Latex')

%set(gca,'XScale','log')
set(gca, 'XScale', 'log');
%set(gca,'YTick',conf_list(1:5))

set(gca, 'XTick', Nv_list)

fix_legend();

legend show
%ylabel('fraction of non-monotone decisions','Interpreter','Latex')
%xlabel('$N_v$','Interpreter','Latex')

legend('Location','NorthEast')


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

if peaking == 1
    fn = 'fig_peaking_2';
else
    fn = 'fig_dipping_2';
end

if (save_to_file)
    export_fig([fn '.pdf'],'-nocrop')
    legend off
    export_fig([fn '_nolegend.pdf'],'-nocrop')
    legend show
    h = legend;
    h.Interpreter = 'Latex';
end