function downloadedFiles = download_data()
%DOWNLOAD_DATA Download the workshop EEGLAB sample dataset into data/.
% Run from the TMS_EEG_Workshop folder. The .set and .fdt files must stay
% together. The function downloads only when both published release assets are
% available and skips files whose sizes already match the release metadata.

repo = 'vyomas7/TMS_EEG_Workshop';
assetNames = [ ...
    "Workshop_Sample_Data.resampled.set"
    "Workshop_Sample_Data.resampled.fdt"];
root = fileparts(mfilename('fullpath'));
dataFolder = fullfile(root, 'data');
if ~isfolder(dataFolder)
    mkdir(dataFolder);
end

try
    releases = webread(sprintf('https://api.github.com/repos/%s/releases', repo), ...
        weboptions('Timeout', 30));
catch exception
    error('TMS_EEG_WORKSHOP:ReleaseLookupFailed', ...
        'Could not read the workshop release list. Check your internet connection and try again.\n%s', ...
        exception.message);
end

if isempty(releases)
    error('TMS_EEG_WORKSHOP:NoRelease', ...
        'No published workshop release is available yet. Please try again later.');
end

assets = [releases.assets];
selectedAssets = repmat(struct('name', '', 'size', 0, 'browser_download_url', ''), numel(assetNames), 1);
missing = strings(0, 1);
for k = 1:numel(assetNames)
    match = find(strcmp(string({assets.name}), assetNames(k)), 1, 'first');
    if isempty(match)
        missing(end+1, 1) = assetNames(k); %#ok<AGROW>
    else
        selectedAssets(k).name = assets(match).name;
        selectedAssets(k).size = assets(match).size;
        selectedAssets(k).browser_download_url = assets(match).browser_download_url;
    end
end

if ~isempty(missing)
    error('TMS_EEG_WORKSHOP:DataNotReady', ...
        'The complete workshop dataset is not published yet. Missing release asset(s): %s. Please try again later.', ...
        strjoin(missing, ', '));
end

downloadedFiles = strings(numel(selectedAssets), 1);
for k = 1:numel(selectedAssets)
    asset = selectedAssets(k);
    destination = fullfile(dataFolder, asset.name);
    if isfile(destination)
        details = dir(destination);
        if details.bytes == asset.size
            fprintf('Already downloaded: %s\n', destination);
            downloadedFiles(k) = string(destination);
            continue
        end
        error('TMS_EEG_WORKSHOP:ExistingFileSizeMismatch', ...
            ['An existing file has the wrong size: %s\n' ...
             'Delete that file from the data folder, then run download_data again.'], destination);
    end

    fprintf('Downloading %s...\n', asset.name);
    try
        websave(destination, asset.browser_download_url, weboptions('Timeout', 300));
    catch exception
        error('TMS_EEG_WORKSHOP:DownloadFailed', ...
            'Could not download %s. Please run download_data again.\n%s', asset.name, exception.message);
    end

    details = dir(destination);
    if isempty(details) || details.bytes ~= asset.size
        error('TMS_EEG_WORKSHOP:DownloadedFileSizeMismatch', ...
            'The download size for %s did not match the release. Delete it and run download_data again.', asset.name);
    end
    downloadedFiles(k) = string(destination);
    fprintf('Downloaded: %s\n', destination);
end

fprintf('\nWorkshop sample data is ready in: %s\n', dataFolder);
end
