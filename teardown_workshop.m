function teardown_workshop()
%TEARDOWN_WORKSHOP Restore paths temporarily removed by setup_workshop.

stateKey = 'TMS_EEG_WORKSHOP_PATH_STATE';
if ~isappdata(0, stateKey)
    return
end
state = getappdata(0, stateKey);
if ~isstruct(state)
    rmappdata(0, stateKey);
    return
end

if isfield(state, 'addedPaths')
    existing = state.addedPaths(cellfun(@isfolder, state.addedPaths));
    if ~isempty(existing)
        rmpath(existing{:});
    end
end
if isfield(state, 'removedPaths')
    existing = state.removedPaths(cellfun(@isfolder, state.removedPaths));
    if ~isempty(existing)
        addpath(existing{:}, '-begin');
    end
end
rmappdata(0, stateKey);
end

