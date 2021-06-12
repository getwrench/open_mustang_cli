# Mustang CLI

### Setup
- Run the following command to install or update the cli 
    ```bash
    dart pub global activate -sgit git@bitbucket.org:lunchclub/mustang_cli.git
    ```

### Commands
- Usage
    ```bash
    mcli # prints help
    ```

- Create the screen and model files
    ```bash
    # use routes/booking to create screen files inside sub-directory routes
    mcli -s booking
    ```
  
- Create a model files
    ```bash
    mcli -m vehicle
    ```
- Generate framework source files
    ```bash
    # run this inside flutter project's root dir
    mcli -w # -w enables watch mode. Use -d for one time generation 
    ```
- Clean generated framework source files
    ```bash
    # run this inside flutter project's root dir
    mcli -d 
    ```

