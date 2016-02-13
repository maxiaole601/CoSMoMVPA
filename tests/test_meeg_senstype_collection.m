function test_suite=test_meeg_senstype_collection
% tests for cosmo_meeg_senstype_collection

    initTestSuite;

function test_meeg_senstype_collection_
    if cosmo_skip_test_if_no_external('fieldtrip')
        return;
    end

    % get senstype properties
    % order is:
    % - senstype name
    % - acquisition system
    % - sensor type
    % - number of rows in channels
    % - number of columns in channels
    % - first and last channel label

    senstype_props=get_senstype_properties();

    % test each one
    n=numel(senstype_props);

    clear('cosmo_meeg_senstype_collection');
    stc=cosmo_meeg_senstype_collection();
    stc_cached=cosmo_meeg_senstype_collection();
    assertEqual(stc,stc_cached);
    for k=1:n
        prop=senstype_props{k};
        key=prop{1};
        is_required=numel(prop)>=7 && prop{7};

        if isfield(stc,key)
            sens=prop{2};
            type=prop{3};
            size_=[prop{4:5}];
            labels=prop{6}(:);

            assert(isfield(stc,key));
            st=stc.(key);

            assertEqual(st.sens,sens);
            assertEqual(st.type,type);
            assertEqual(size(st.label),size_);
            assertEqual(st.label([1;end]),labels);
        elseif is_required
            error('Missing key %s',key);
        end
    end


function props=get_senstype_properties()

    props={{ 'biosemi64',...
                    'biosemi64','eeg',...
                    64,1,{'A1','B32'}},...
            {'biosemi128',...
                    'biosemi128','eeg',...
                    128,1,{'A1','D32'}},...
            {'biosemi256',...
                    'biosemi256','eeg',...
                    256,1,{'A1','H32'}},...
            {'bti148',...
                    'bti148','meg_axial',...
                    148,1,{'A1','A148'}},...
            {'bti148_planar',...
                    'bti148','meg_planar',...
                    148,2,{'A1_dH','A148_dV'}},...
            {'bti148_planar_combined',...
                    'bti148','meg_planar_combined',...
                    148,1,{'A1','A148'},false},...  % not required
            {'bti248',...
                    'bti248','meg_axial',...
                    248,1,{'A1','A248'}},...
            {'bti248_planar',...
                    'bti248','meg_planar',...
                    248,2,{'A1_dH','A248_dV'}},...
            {'bti248_planar_combined',...
                    'bti248','meg_planar_combined',...
                    248,1,{'A1','A248'},false},...  % not required
            {'ctf151',...
                    'ctf151','meg_axial',...
                    151,1,{'MLC11','MZP02'}},...
            {'ctf151_planar',...
                    'ctf151','meg_planar',...
                    151,2,{'MLC11_dH','MZP02_dV'}},...
            {'ctf151_planar_combined',...
                    'ctf151','meg_planar_combined',...
                    151,1,{'MLC11','MZP02'}},...
            {'ctf275',...
                    'ctf275','meg_axial',...
                    275,1,{'MLC11','MZP01'}},...
            {'ctf275_planar',...
                    'ctf275','meg_planar',...
                    275,2,{'MLC11_dH','MZP01_dV'}},...
            {'ctf275_planar_combined',...
                    'ctf275','meg_planar_combined',...
                    275,1,{'MLC11','MZP01'}},...
            {'eeg1005',...
                    'ext1020','eeg',...
                    343,1,{'Fp1','T6'}},...
            {'eeg1010',...
                    'ext1020','eeg',...
                    94,1,{'Fp1','T6'}},...
            {'eeg1020',...
                    'ext1020','eeg',...
                    29,1,{'Fp1','T6'}},...
            {'egi32',...
                    'egi32','eeg',...
                    34,1,{'E1','Cz'}},...
            {'egi64',...
                    'egi64','eeg',...
                    66,1,{'E1','Cz'}},...
            {'egi128',...
                    'egi128','eeg',...
                    130,1,{'E1','Cz'}},...
            {'egi256',...
                    'egi256','eeg',...
                    258,1,{'E1','Cz'}},...
            {'neuromag122_planar_combined',...
                    'neuromag122','meg_planar_combined',...
                    61,1,{'MEG 001+002','MEG 121+122'}},...
            {'neuromag306_planar_combined',...
                    'neuromag306','meg_planar_combined',...
                    102,1,{'MEG 0112+0113','MEG 2642+2643'}},...
            {'itab153',...
                    'itab153','meg',...
                    153,1,{'MAG_000','MAG_152'}},...
            {'itab153_planar',...
                    'itab153','meg_planar',...
                    153,2,{'MAG_000_dH','MAG_152_dV'}},...
            {'itab153_planar_combined',...
                    'itab153','meg_planar_combined',...
                    153,1,{'MAG_000','MAG_152'}},...
            {'yokogawa64',...
                    'yokogawa64','meg_axial',...
                    64,1,{'AG001','AG064'}},...
            {'yokogawa64_planar',...
                    'yokogawa64','meg_planar',...
                    64,2,{'AG001_dH','AG064_dV'}},...
            {'yokogawa64_planar_combined',...
                    'yokogawa64','meg_planar_combined',...
                    64,1,{'AG001','AG064'}},...
            {'yokogawa160',...
                    'yokogawa160','meg_axial',...
                    160,1,{'AG001','AG160'}},...
            {'yokogawa160_planar',...
                    'yokogawa160','meg_planar',...
                    160,2,{'AG001_dH','AG160_dV'}},...
            {'yokogawa160_planar_combined',...
                    'yokogawa160','meg_planar_combined',...
                    160,1,{'AG001','AG160'}},...
            {'yokogawa440',...
                    'yokogawa440','meg_axial',...
                    412,1,{'AG001','RM412'}},...
            {'yokogawa440_planar',...
                    'yokogawa440','meg_planar',...
                    210,2,{'AG001_dH','AG392_dV'}},...
            {'yokogawa440_planar_combined',...
                    'yokogawa440','meg_planar_combined',...
                    210,1,{'AG001','AG392'}},...
            {'neuromag122alt_planar_combined',...
                    'neuromag122','meg_planar_combined',...
                    61,1,{'MEG001+002','MEG121+122'}},...
            {'neuromag306alt_planar_combined',...
                    'neuromag306','meg_planar_combined',...
                    102,1,{'MEG0112+0113','MEG2642+2643'}},...
            {'neuromag306_planar',...
                    'neuromag306','meg_planar',...
                    102,2,{'MEG 0112','MEG 2643'}},...
            {'neuromag306_mag',...
                    'neuromag306','meg_axial',...
                    102,1,{'MEG 0111','MEG 2641'}},...
            {'neuromag306alt_planar',...
                    'neuromag306','meg_planar',...
                    102,2,{'MEG0112','MEG2643'}},...
            {'neuromag306alt_mag',...
                    'neuromag306','meg_axial',...
                    102,1,{'MEG0111','MEG2641'}},...
            {'neuromag122_planar',...
                    'neuromag122','meg_planar',...
                    61,2,{'MEG 001','MEG 122'}},...
            {'neuromag122alt_planar',...
                    'neuromag122','meg_planar',...
                    61,2,{'MEG001','MEG122'}}};


    % the data anobe was produced by the code below
    %
    % sc=cosmo_meeg_senstype_collection();
    % names=fieldnames(sc);
    %
    % names={'biosemi64','biosemi128','biosemi256',...
    %         'bti148','bti148_planar','bti148_planar_combined',...
    %         'bti248','bti248_planar','bti248_planar_combined',...
    %         'ctf151','ctf151_planar','ctf151_planar_combined',...
    %         'ctf275','ctf275_planar','ctf275_planar_combined',...
    %         'eeg1005','eeg1010','eeg1020',...
    %         'egi32','egi64','egi128','egi256',...
    %         'neuromag122_planar_combined',...
    %         'neuromag306_planar_combined',...
    %         'itab153','itab153_planar','itab153_planar_combined',...
    %         'yokogawa64','yokogawa64_planar','yokogawa64_planar_combined',...
    %         'yokogawa160','yokogawa160_planar',...
    %                             'yokogawa160_planar_combined',...
    %         'yokogawa440','yokogawa440_planar',...
    %                             'yokogawa440_planar_combined',...
    %         'neuromag122alt_planar_combined',...
    %         'neuromag306alt_planar_combined',...
    %         'neuromag306_planar',...
    %         'neuromag306_mag',...
    %         'neuromag306alt_planar',...
    %         'neuromag306alt_mag',...
    %         'neuromag122_planar',...
    %         'neuromag122alt_planar'};
    % for k=1:numel(names)
    %     name=names{k};
    %     s=sc.(name);
    %     fprintf(['{''%s'',...\n\t\t''%s'',''%s'',...\n\t\t'...
    %                 '%d,%d,{''%s'',''%s''}},...\n'],...
    %             name,s.sens,s.type,size(s.label),s.label{1},s.label{end})
    % end
    %
