function reset_workshop_environment()
%RESET_WORKSHOP_ENVIRONMENT Reapply the isolated workshop path configuration.
teardown_workshop();
setup_workshop();
end

