% Fieldtrip codes
% all_source_surf - a cell aray, where each cell is a subject data
% Written by Yiheng Hu (2024.10.27)

%% MCP ttest for two conditions (surface)
cfg                  = [];
cfg.tri              = all_source_surf{1}.tri;
cfg.insideorig       = all_source_surf{1}.inside;
cfg.origdim          = [sum(all_source_surf{1}.inside) length(all_source_surf{1}.time)];
cfg.method           = 'montecarlo';
cfg.parameter        = 'pow';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 1;
cfg.clustertail      = 1;
cfg.alpha            = 0.05;
cfg.numrandomization = 1000;
cfg.design(1,:)      = [ones(1,length(all_source_surf)),ones(1,length(all_source_surf))*2];
cfg.design(2,:)      = [1:length(all_source_surf),1:length(all_source_surf)];
cfg.ivar             = 1; % row of design matrix that contains independent variable (the conditions)
cfg.uvar             = 2; % row of design matrix that contains unit variable (in this case: subjects)
stat                 = ft_sourcestatistics(cfg, all_source_surf{:},all_null_surf{:});


%% MCP ttest for two conditions (volumn)
cfg                  = [];
cfg.dim              = all_source_vol{1}.dim;
cfg.method           = 'montecarlo';
cfg.parameter        = 'pow';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.tail             = 1;
cfg.clustertail      = 1;
cfg.alpha            = 0.05;
cfg.numrandomization = 1000;
cfg.design(1,:)      = [ones(1,length(all_source_vol)),ones(1,length(all_source_vol))*2];
cfg.design(2,:)      = [1:length(all_source_vol),1:length(all_source_vol)];
cfg.ivar             = 1; % row of design matrix that contains independent variable (the conditions)
cfg.uvar             = 2; % row of design matrix that contains unit variable (in this case: subjects)
stat                 = ft_sourcestatistics(cfg, all_source_vol{:},null_vol{:});


%% do statistics (ttest) without correction 
cfg                     = [];
cfg.method              = 'stats';
cfg.statistic           = 'ttest';
cfg.parameter           = 'avg.pow';
cfg.alpha               = 0.05;
cfg.tail                = 1;
cfg.design              = ones(1,length(subjects));
sourcestat = ft_sourcestatistics(cfg, all_source_vol{:});

