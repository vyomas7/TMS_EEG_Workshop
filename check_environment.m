function ok = check_environment()
%CHECK_ENVIRONMENT Report whether the vendored workshop tools are available.
% This check does not launch EEGLAB or change the MATLAB path.

root = fileparts(mfilename('fullpath'));
eeglabRoot = fullfile(root, 'third_party', 'eeglab');
% Columns: display name, result, remediation, blocks this base environment.
checks = {
    'Workshop EEGLAB selected', whichStartsWith('eeglab', eeglabRoot), 'Run reset_workshop_environment.', true;
    'EEGLAB entry point', isfile(fullfile(eeglabRoot, 'eeglab.m')), 'Re-clone the repository.', true;
    'TESA plugin', isfile(fullfile(eeglabRoot, 'plugins', 'TESA', 'eegplugin_tesa.m')), 'Re-clone the repository.', true;
    'EEG-BIDS plugin', isfile(fullfile(eeglabRoot, 'plugins', 'EEG-BIDS', 'eegplugin_eegbids.m')), 'Re-clone the repository.', true;
    'BIOSIG plugin', isfile(fullfile(eeglabRoot, 'plugins', 'BIOSIG', 'eegplugin_biosig.m')), 'Re-clone the repository.', true;
    'FastICA', isfile(fullfile(root, 'third_party', 'fastica', 'fastica.m')), 'Re-clone the repository.', true;
    'EEGLAB default: DIPFIT', isfile(fullfile(eeglabRoot, 'plugins', 'dipfit', 'eegplugin_dipfit.m')), 'Re-clone the repository.', true;
    'EEGLAB default: clean_rawdata', isfile(fullfile(eeglabRoot, 'plugins', 'clean_rawdata', 'eegplugin_clean_rawdata.m')), 'Re-clone the repository.', true;
    'EEGLAB default: ICLabel', isfile(fullfile(eeglabRoot, 'plugins', 'ICLabel', 'eegplugin_iclabel.m')), 'Re-clone the repository.', true;
    'EEGLAB default: firfilt', isfile(fullfile(eeglabRoot, 'plugins', 'firfilt', 'eegplugin_firfilt.m')), 'Re-clone the repository.', true;
    'Signal Processing Toolbox license', hasLicense('Signal_Toolbox'), 'Ask the workshop organiser for a licensed MATLAB account.', true;
    'Statistics and Machine Learning Toolbox license', hasLicense('Statistics_Toolbox'), 'Some TESA workflows require it; ask the workshop organiser.', false
    };

fprintf('\nTMS/EEG workshop environment check\n');
fprintf('----------------------------------\n');
results = false(size(checks, 1), 1);
for k = 1:size(checks, 1)
    results(k) = checks{k, 2};
    if results(k)
        fprintf('[PASS] %s\n', checks{k, 1});
    elseif checks{k, 4}
        fprintf('[FAIL] %s — %s\n', checks{k, 1}, checks{k, 3});
    else
        fprintf('[WARN] %s — %s\n', checks{k, 1}, checks{k, 3});
    end
end
ok = all(results(cell2mat(checks(:, 4))));
if ok
    fprintf('All checks passed. You may now run: eeglab\n\n');
else
    fprintf('One or more checks failed. Do not begin the workshop until they pass.\n\n');
end
end

function tf = whichStartsWith(name, expectedRoot)
resolved = which(name);
tf = ~isempty(resolved) && startsWith(resolved, expectedRoot);
end

function tf = hasLicense(feature)
try
    tf = license('test', feature);
catch
    tf = false;
end
end
