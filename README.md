# Mustang CLI

### Setup
- Run the following command to install or update the cli 
    ```bash
    dart pub global activate -sgit git@bitbucket.org:lunchclub/open-mustang-cli.git
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
  
- Create a model file
    ```bash
    mcli -m vehicle
    ```

- Create a mustang utils file
    ```bash
    mcli -u
    ```

- Generate framework source files
    ```bash
    # Run this inside the root directory of a Flutter project
    # -w enables watch mode. Use -d for one time generation
    mcli -w 
    ```
- Clean generated framework source files
    ```bash
    # Run this inside the root directory of a Flutter project
    mcli -d 
    ```

