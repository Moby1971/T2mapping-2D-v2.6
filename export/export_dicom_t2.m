function export_dicom_t2(directory,m0map,t2map,r2map,parameters,tag)


% create folder if not exist, and clear
folder_name = [directory,[filesep,'T2map-DICOM-',tag]];
if (~exist(folder_name, 'dir')); mkdir(folder_name); end
delete([folder_name,filesep,'*']);


% Phase orientation correction
if isfield(parameters, 'PHASE_ORIENTATION')
    if parameters.PHASE_ORIENTATION == 1
        t2map = permute(rot90(permute(t2map,[2 1 3 4]),1),[2 1 3 4]);
        m0map = permute(rot90(permute(m0map,[2 1 3 4]),1),[2 1 3 4]);
        r2map = permute(rot90(permute(r2map,[2 1 3 4]),1),[2 1 3 4]);
    end
end


[dimx,dimy,dimz,dimd] = size(t2map);

% export the dicom images
dcmid = dicomuid;   % unique identifier
dcmid = dcmid(1:50);


for dynamic = 1:dimd

    for slice = 1:dimz

        dcm_header = generate_dicomheader_t2(parameters,slice,dynamic,dimx,dimy,dimz,dimd,dcmid);
        dcm_header.ProtocolName = 'T2-map';
        dcm_header.SequenceName = 'T2-map';
        dcm_header.EchoTime = 1.1;

        fn = ['0000',num2str(slice)];
        fn = fn(size(fn,2)-4:size(fn,2));
        dn = ['0000',num2str(dynamic)];
        dn = dn(size(dn,2)-4:size(dn,2));

        fname = [directory,filesep,'T2map-DICOM-',tag,filesep,'T2map-slice',fn,'-dynamic',dn,'.dcm'];
        image = rot90(squeeze(cast(round(t2map(:,:,slice,dynamic)),'uint16')));
        dicomwrite(image, fname, dcm_header);

    end

end


m0map = round(32767*m0map/max(m0map(:)));

for dynamic = 1:dimd

    for slice=1:dimz

        dcm_header = generate_dicomheader_t2(parameters,slice,dynamic,dimx,dimy,dimz,dimd,dcmid);
        dcm_header.ProtocolName = 'M0-map';
        dcm_header.SequenceName = 'M0-map';
        dcm_header.EchoTime = 1.2;

        fn = ['0000',num2str(slice)];
        fn = fn(size(fn,2)-4:size(fn,2));
        dn = ['0000',num2str(dynamic)];
        dn = dn(size(dn,2)-4:size(dn,2));

        fname = [directory,filesep,'T2map-DICOM-',tag,filesep,'M0map-slice',fn,'-dynamic',dn,'.dcm'];
        image = rot90(squeeze(cast(round(m0map(:,:,slice,dynamic)),'uint16')));
        dicomwrite(image, fname, dcm_header);

    end

end



for dynamic = 1:dimd

    for slice=1:dimz

        dcm_header = generate_dicomheader_t2(parameters,slice,dynamic,dimx,dimy,dimz,dimd,dcmid);
        dcm_header.ProtocolName = 'R^2-map';
        dcm_header.SequenceName = 'R^2-map';
        dcm_header.EchoTime = 1.3;

        fn = ['0000',num2str(slice)];
        fn = fn(size(fn,2)-4:size(fn,2));
        dn = ['0000',num2str(dynamic)];
        dn = dn(size(dn,2)-4:size(dn,2));

        fname = [directory,filesep,'T2map-DICOM-',tag,filesep,'R2map-slice',fn,'-dynamic',dn,'.dcm'];
        image = rot90(squeeze(cast(round(100*r2map(:,:,slice,dynamic)),'uint16')));
        dicomwrite(image, fname, dcm_header);

    end

end




end