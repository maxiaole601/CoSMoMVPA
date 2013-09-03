function hdr=cosmo_map2fmri(dataset, fn)
% maps a dataset structure to a nifti structure or file
% 
% Usage 1: hdr=cosmo_map2fmri(dataset) returns a header structure
% Usage 2: cosmo_map2fmri(dataset, fn) saves dataset to a volumetric file.
%
% NNO Aug 2013

samples=dataset.samples;
[nsamples, nfeatures]=size(samples);

img_formats=struct();

img_formats.nii.builder=@build_nii;
img_formats.nii.writer=@write_nii;

img_formats.vmp.builder=@build_vmp;
img_formats.vmp.writer=@write_vmp;

img_format=get_img_format(dataset, img_formats);

builder=img_formats.(img_format).builder;
hdr=builder(dataset);

if nargin>1
    writer=img_formats.(img_format).writer;
    writer(fn, hdr);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% general helper functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img_format=get_img_format(dataset, img_formats)

fns=fieldnames(img_formats);
n=numel(fns);

count=0;
for k=1:n
    fn=fns{k};
    if isfield(dataset.a, ['hdr_' fn])
        img_format=fn;
        count=count+1;
    end
end

if count~=1
    error('Found %d image formats, expected 1', count)
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% format-specific helper functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Nifti

function hdr=build_nii(dataset)

nsamples=size(dataset.samples,1);

hdr=dataset.a.hdr_nii;

hdr.hdr.dime.dim(5)=nsamples;
hdr.hdr.dime.dim(2:4)=dataset.a.voldim;
hdr.img=cosmo_map2array(dataset);

function write_nii(fn, hdr)
save_nii(hdr, fn);


%% Brainvoyager VMP
function hdr=build_vmp(dataset)
samples=dataset.samples;
nsamples=size(samples,1);

hdr=dataset.a.hdr_vmp;

samples_cell=cell(1,nsamples);
vols=cosmo_map2array(dataset);

master_data=hdr.Map(1); 

set_zero={'Type','LowerThreshold','UpperThreshold','ClusterSize',...
            'DF1','DF2','BonferroniValue','FDRThresholds'};

fns=fieldnames(master_data);
n=numel(fns);

args=cell(1,n*2);
for k=1:n
    fn=fns{k};
    args{k*2-1}=fn;
    data=cell(1,nsamples);
    for j=1:nsamples
        dataj=master_data.(fn);
        if strcmp(fn,'VMPData')
            dataj=vols(:,:,:,j);
        elseif ~isempty(strmatch(fn,set_zero))
            dataj(:)=0;
        end
        data{j}=dataj;
    end
    args{k*2}=data;
end

hdr.Map=struct(args{:});

function write_vmp(fn, hdr)
hdr.SaveAs(fn);






