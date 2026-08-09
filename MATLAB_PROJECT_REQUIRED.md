# Generate the committed MATLAB Project once

`Workshop.prj` and `resources/project/` must be created by MATLAB, not edited
by hand. This checkout does not include generated project XML because MATLAB
is not installed in the build environment that assembled the source bundle.

Before the first public GitHub release, a maintainer must open this folder in a
licensed MATLAB installation or MATLAB Online and run:

```matlab
run('tools/create_workshop_project.m')
```

That script creates a fixed-path multi-file MATLAB Project, sets the repository
root as its startup folder, keeps only the root on the Project Path, and
registers `setup_workshop.m` and `teardown_workshop.m` as the startup and
shutdown tasks. Commit the generated `Workshop.prj` and `resources/project/`
files unchanged. Then validate the Open in MATLAB Online link on clean and
pre-existing-EEGLAB accounts before tagging `workshop-2026-v1`.

