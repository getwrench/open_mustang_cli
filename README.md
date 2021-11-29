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

- Create a mustang utils file
    ```bash
    omcli -u
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
