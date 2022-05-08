# Mustang CLI

### Setup
- Run the following command to install or update the cli 
    ```bash
    dart pub global activate open_mustang_cli
    ```

### Commands
- Usage
    ```bash
    omcli # prints help
    ```

- Create the screen and model files
    ```bash
    # use routes/booking to create screen files inside sub-directory routes
    omcli -s booking
    ```
  
- Create a model file
    ```bash
    omcli -m vehicle
    ```

- Generate framework source files
    ```bash
    # Run this inside the root directory of a Flutter project
    # -w enables watch mode. Use -d for one time generation
    omcli -w 
    ```

- Clean generated framework source files
    ```bash
    # Run this inside the root directory of a Flutter project
    omcli -d 
    ```

### Config file (Advanced)
Source templates that this tool generates can be customized using config file.

 - Create file name `mustang.yaml` in the root of the project directory
 - Config file format
```yaml
  serializer: package:mypackage/mypackage_exports.dart
  screen:
    imports:
      - package:my_widgets/widgets.dart
    progress_widget: MyProgressIndicatorScreen()
    error_widget: MyErrorScreen()
```
