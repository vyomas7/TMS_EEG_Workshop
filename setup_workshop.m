function setup_workshop()
%SETUP_WORKSHOP Activate only this project's EEGLAB and FastICA paths.
% Called by the MATLAB Project startup task. This function never saves paths
% and deliberately does not start EEGLAB.

root = fileparts(mfilename('fullpath'));
eeglabRoot = fullfile(root, 'third_party', 'eeglab');
fasticaRoot = fullfile(root, 'third_party', 'fastica');

mustExist(eeglabRoot, 'dir', 'EEGLAB');
mustExist(fullfile(eeglabRoot, 'eeglab.m'), 'file', 'EEGLAB entry point');
mustExist(fasticaRoot, 'dir', 'FastICA');
mustExist(fullfile(fasticaRoot, 'fastica.m'), 'file', 'FastICA entry point');

stateKey = 'TMS_EEG_WORKSHOP_PATH_STATE';
state = getappdata(0, stateKey);
if isstruct(state) && isfield(state, 'root') && strcmp(state.root, root)
    addpath(eeglabRoot, '-begin');
    addpath(fasticaRoot, '-end');
    return
end

if isstruct(state)
    teardown_workshop();
end

entries = strsplit(path, pathsep);
otherRoots = unique(cellfun(@findEeglabRoot, entries, 'UniformOutput', false));
otherRoots = otherRoots(~cellfun(@isempty, otherRoots));
otherRoots = otherRoots(~strcmp(otherRoots, eeglabRoot));
removed = {};
for k = 1:numel(otherRoots)
    candidates = entries(cellfun(@(p) isWithin(p, otherRoots{k}), entries));
    if ~isempty(candidates)
        rmpath(candidates{:});
        removed = [removed candidates]; %#ok<AGROW>
    end
end

addpath(eeglabRoot, '-begin');
addpath(fasticaRoot, '-end');
setappdata(0, stateKey, struct('root', root, 'removedPaths', {unique(removed)}, ...
    'addedPaths', {{eeglabRoot, fasticaRoot}}));
fprintf('TMS/EEG workshop environment is ready. Run check_environment, then eeglab.\n');
end

function root = findEeglabRoot(candidate)
root = '';
if isempty(candidate) || ~isfolder(candidate)
    return
end
current = candidate;
while true
    if isfile(fullfile(current, 'eeglab.m')) && isfolder(fullfile(current, 'functions'))
        root = current;
        return
    end
    parent = fileparts(current);
    if strcmp(parent, current)
        return
    end
    current = parent;
end
end

function tf = isWithin(candidate, root)
candidate = char(java.io.File(candidate).getCanonicalPath());
root = char(java.io.File(root).getCanonicalPath());
tf = strcmp(candidate, root) || startsWith(candidate, [root filesep]);
end

function mustExist(target, kind, label)
if ~exist(target, kind)
    error('TMS_EEG_WORKSHOP:MissingDependency', '%s is missing: %s', label, target);
end
end

