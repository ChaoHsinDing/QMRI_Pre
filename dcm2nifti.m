function dcm2nifti(DicomDir,SaveNiftiDir)




RFNeededList = {'RF_MAP_1','RF_MAP_2'};
QMRNeededList = {'T1','MT','PD','T1_LOWRES_BODY','T1_LOWRES_HEAD'};
temp=dir(DicomDir);
temp=temp(~ismember({temp.name},{'.','..'}));
temp={temp.name};

for sub=1:length(temp)
    DicomDirtemp = DicomDir;
    SaveNiftiDirtemp = SaveNiftiDir;
    SaveNiftiDirtemp = fullfile(SaveNiftiDirtemp,temp{sub});
    DicomDirtemp = fullfile(DicomDirtemp,temp{sub});

    mkdir(fullfile(SaveNiftiDirtemp,'RF_map'));
    RFcellCounter = 1+(sub-1)*6;
    batchcounter = 6*(sub-1);
    dicomF=dir(fullfile(DicomDirtemp,RFNeededList{1}));
    RF_map1={dicomF.name};
    IMA = contains(RF_map1,'.IMA');
    RF_map1=RF_map1(IMA);
    for i = 1:length(RF_map1)
        t=fullfile(DicomDirtemp,RFNeededList{1},RF_map1(i));
         RF_cell{i,RFcellCounter}=t{1};
    end

    dicomF=dir(fullfile(DicomDirtemp,RFNeededList{2}));
    RF_map2={dicomF.name};
    IMA = contains(RF_map2,'.IMA');
    RF_map2=RF_map2(IMA);
    for i = length(RF_map1)+1:length(RF_map1)+length(RF_map2)
        t=fullfile(DicomDirtemp,RFNeededList{2},RF_map2(i-length(RF_map1)));
        RF_cell{i,RFcellCounter}=t{1};
    end
    RF = length(RF_map1)+length(RF_map2);
    matlabbatch{1+batchcounter}.spm.tools.hmri.dicom.data = RF_cell(1:RF,RFcellCounter);
    matlabbatch{1+batchcounter}.spm.tools.hmri.dicom.root = 'flat';
    matlabbatch{1+batchcounter}.spm.tools.hmri.dicom.outdir = {fullfile(SaveNiftiDirtemp,'RF_map')};
    matlabbatch{1+batchcounter}.spm.tools.hmri.dicom.protfilter = '.*';
    matlabbatch{1+batchcounter}.spm.tools.hmri.dicom.convopts.format = 'nii';
    matlabbatch{1+batchcounter}.spm.tools.hmri.dicom.convopts.metaopts.mformat = 'sep';
    matlabbatch{1+batchcounter}.spm.tools.hmri.dicom.convopts.icedims = 0;
    

    %convert maps
    len = [0,0,0,0,0];
    for i = 1:length(QMRNeededList)

        mkdir(fullfile(SaveNiftiDirtemp, QMRNeededList{i}));
        dicomF=dir(fullfile(DicomDirtemp, QMRNeededList{i}));
        fnames={dicomF.name};
        IMA = contains(fnames,'.IMA');
        fnames=fnames(IMA);
        for j = 1:length(fnames)
            t=fullfile(DicomDirtemp, QMRNeededList{i}, fnames(j));
            RF_cell{j,RFcellCounter+i}=t{1};
        end
        len(i) = length(fnames);
        
        matlabbatch{i+1+batchcounter}.spm.tools.hmri.dicom.data = RF_cell(1:len(i),RFcellCounter+i);
        matlabbatch{i+1+batchcounter}.spm.tools.hmri.dicom.root = 'flat';
        matlabbatch{i+1+batchcounter}.spm.tools.hmri.dicom.outdir = {fullfile(SaveNiftiDirtemp, QMRNeededList{i})};
        matlabbatch{i+1+batchcounter}.spm.tools.hmri.dicom.protfilter = '.*';
        matlabbatch{i+1+batchcounter}.spm.tools.hmri.dicom.convopts.format = 'nii';
        matlabbatch{i+1+batchcounter}.spm.tools.hmri.dicom.convopts.metaopts.mformat = 'sep';
        matlabbatch{i+1+batchcounter}.spm.tools.hmri.dicom.convopts.icedims = 0;
    end

end

parfor i = 1:length(temp)
    spm('defaults','fMRI');
    spm_jobman('run',matlabbatch(i));
end
