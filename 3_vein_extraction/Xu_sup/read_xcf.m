function [im_background, im_mask, im_groundtruth_roi, im_groundtruth_veins] = read_xcf(fn)
    imagemagick_dir = '/opt/local/bin';

    [~, fn_base, ~] = fileparts(fn);

    [~, output1] = system(sprintf('%s %s', fullfile(imagemagick_dir, 'identify'), fn));

    num_layers = numel(strfind(output1, 'xcf'));
    
    for i=0:(num_layers-1)
        [~, ~] = system(sprintf('%s %s[%d] %s_layer_%d.tif', fullfile(imagemagick_dir, 'convert'), fn, i, fn_base, i));
    end
    
    if (num_layers >= 3 && num_layers <= 4)
        im_background = imread(sprintf('%s_layer_0.tif', fn_base));
        im_background = im_background(:,:,1);
        delete(sprintf('%s_layer_0.tif', fn_base));
        
        if (num_layers==3)
            im_mask = true(size(im_background));
            
            im_groundtruth_roi = imread(sprintf('%s_layer_1.tif', fn_base));
            im_groundtruth_roi = im2bw(im_groundtruth_roi(:,:,1));
            delete(sprintf('%s_layer_1.tif', fn_base));
            
            im_groundtruth_veins = imread(sprintf('%s_layer_2.tif', fn_base));
            im_groundtruth_veins = im2bw(im_groundtruth_veins(:,:,1));
            delete(sprintf('%s_layer_2.tif', fn_base));
        else
            im_mask = imread(sprintf('%s_layer_1.tif', fn_base));
            im_mask = im2bw(im_mask(:,:,1));
            delete(sprintf('%s_layer_1.tif', fn_base));
            
            im_groundtruth_roi = imread(sprintf('%s_layer_2.tif', fn_base));
            im_groundtruth_roi = im2bw(im_groundtruth_roi(:,:,1));
            delete(sprintf('%s_layer_2.tif', fn_base));
            
            im_groundtruth_veins = imread(sprintf('%s_layer_3.tif', fn_base));
            im_groundtruth_veins = im2bw(im_groundtruth_veins(:,:,1));
            delete(sprintf('%s_layer_3.tif', fn_base));          
        end
    else
        error('Image %s had %d layers', fn, num_layers);
    end
end