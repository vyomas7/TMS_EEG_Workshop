# TMS/EEG Workshop — Participant SOP

1. Open this link in your browser:  
   https://matlab.mathworks.com/open/github/v1?repo=vyomas7/TMS_EEG_Workshop

2. Sign in to MATLAB Online.

3. Wait for the workshop files to open.

4. In the MATLAB Command Window, run:

   ```matlab
   setup_workshop
   ```

5. Download the workshop sample data:

   ```matlab
   download_data
   ```

6. Then run:

   ```matlab
   check_environment
   ```

7. Check that the required lines say `[PASS]`.

8. Start EEGLAB:

   ```matlab
   eeglab
   ```

9. If a required line says `[FAIL]`, run:

    ```matlab
    reset_workshop_environment
    check_environment
    ```

10. Do not install anything or change any settings.

11. When you finish, close EEGLAB and run:

    ```matlab
    teardown_workshop
    ```
