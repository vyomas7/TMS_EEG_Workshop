function create_workshop_project()
%CREATE_WORKSHOP_PROJECT Maintainer-only MATLAB Project creation/repair.
% Run this once in MATLAB (not by participants), then commit Workshop.prj and
% resources/project. MATLAB owns those XML files; do not hand-edit them.

root = fileparts(fileparts(mfilename('fullpath')));
projectFile = fullfile(root, 'Workshop.prj');
if isfile(projectFile)
    proj = openProject(projectFile);
else
    proj = matlab.project.createProject('Name', 'Workshop', 'Folder', root, ...
        'DefinitionType', 'FixedPathMultiFile');
end

proj.Name = 'TMS/EEG Workshop';
proj.Description = ['Participant-facing MATLAB Online environment for the ' ...
    'TMS/EEG workshop. Dependencies are vendored and path-isolated.'];
proj.ProjectStartupFolder = root;

% Project root is the only project path. setup_workshop handles EEGLAB and
% FastICA explicitly and never recursively adds vendor folders.
existingPaths = proj.ProjectPath;
for k = 1:numel(existingPaths)
    removePath(proj, existingPaths(k).Path);
end
addPath(proj, root);

if ~isempty(proj.StartupFiles)
    removeStartupFile(proj, proj.StartupFiles);
end
if ~isempty(proj.ShutdownFiles)
    removeShutdownFile(proj, proj.ShutdownFiles);
end
addStartupFile(proj, fullfile(root, 'setup_workshop.m'));
addShutdownFile(proj, fullfile(root, 'teardown_workshop.m'));

assert(isfile(projectFile), 'TMS_EEG_WORKSHOP:ProjectNotCreated', ...
    'MATLAB did not create Workshop.prj.');
fprintf('Created/repaired %s. Commit Workshop.prj and resources/project.\n', projectFile);
end
