function qmri(SaveNiftiDir,OutDir)



ImageList={'T1_LOWRES_HEAD','T1_LOWRES_BODY','RF_map','T1','MT','PD'};
temp=dir(SaveNiftiDir);
temp=temp(~ismember({temp.name},{'.','..'}));
temp={temp.name};

for sub=1:length(temp)
    SaveNiftiDir = fullfile(SaveNiftiDir,temp{sub});
    OutDir = fullfile(OutDir,temp{sub});
    
    mkdir(OutDir);
    dicomF=dir(fullfile(SaveNiftiDir,ImageList{1}));
    nnames={dicomF.name};
    NII = contains(nnames,'.nii');
    iname{1}=nnames(NII);
    dicomF=dir(fullfile(SaveNiftiDir,ImageList{2}));
    nnames={dicomF.name};
    NII = contains(nnames,'.nii');
    iname{2}=nnames(NII);

    matlabbatch{sub}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_once = {
                                                                         [SaveNiftiDir '\' ImageList{1} '\' iname{1}{1} ',1']
                                                                         [SaveNiftiDir '\' ImageList{2} '\' iname{2}{1} ',1']
                                                                         };

    clear iname
    dicomF=dir(fullfile(SaveNiftiDir,ImageList{3}));
    nnames={dicomF.name};
    NII = contains(nnames,'.nii');
    iname=nnames(NII);
    matlabbatch{sub}.spm.tools.hmri.create_mpm.subj.b1_type.rf_map.b1input = {
                                                                         [SaveNiftiDir '\' ImageList{3} '\' iname{1} ',1']
                                                                         [SaveNiftiDir '\' ImageList{3} '\' iname{2} ',1']
                                                                         };

    clear iname
    dicomF=dir(fullfile(SaveNiftiDir,ImageList{4}));
    nnames={dicomF.name};
    NII = contains(nnames,'.nii');
    iname=nnames(NII);
    matlabbatch{sub}.spm.tools.hmri.create_mpm.subj.raw_mpm.T1 = {
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{1} ',1']
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{2} ',1']
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{3} ',1']
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{4} ',1']
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{5} ',1']
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{6} ',1']
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{7} ',1']
                                                                [SaveNiftiDir '\' ImageList{4} '\' iname{8} ',1']
                                                                };
    clear iname
    dicomF=dir(fullfile(SaveNiftiDir,ImageList{5}));
    nnames={dicomF.name};
    NII = contains(nnames,'.nii');
    iname=nnames(NII);
    matlabbatch{sub}.spm.tools.hmri.create_mpm.subj.raw_mpm.MT = {
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{1} ',1']
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{2} ',1']
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{3} ',1']
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{4} ',1']
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{5} ',1']
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{6} ',1']
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{7} ',1']
                                                                [SaveNiftiDir '\' ImageList{5} '\' iname{8} ',1']
                                                                };
    clear iname
    dicomF=dir(fullfile(SaveNiftiDir,ImageList{6}));
    nnames={dicomF.name};
    NII = contains(nnames,'.nii');
    iname=nnames(NII);
    matlabbatch{sub}.spm.tools.hmri.create_mpm.subj.raw_mpm.PD = {
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{1} ',1']
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{2} ',1']
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{3} ',1']
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{4} ',1']
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{5} ',1']
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{6} ',1']
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{7} ',1']
                                                               [SaveNiftiDir '\' ImageList{6} '\' iname{8} ',1'] 
                                                               };

    matlabbatch{sub}.spm.tools.hmri.create_mpm.subj.popup = false;
    matlabbatch{sub}.spm.tools.hmri.create_mpm.subj.output.outdir={OutDir};
end

for i = 1:length(temp)
    spm('defaults','fMRI');
    spm_jobman('run',matlabbatch(i));
end
