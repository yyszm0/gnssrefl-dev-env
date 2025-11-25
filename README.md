# gnssrefl-dev-env
Development Docker environment for gnssrefl.

## Directories
```
.
├── gnssrefl-dev-env # This repository
├── gnssrefl         # Git cloned repository
└── reflcode         # Workspace/
    ├── YYYY
    ├── Files
    ├── input
    ├── logs
    ├── nmea
    └── ...
```

## Steps
Modification of python code and local-run is following steps.
1. Modify the .env and designate the source code dir and working dir.
2. Build the image with docker-compose.
    ```
    ./compose.sh
    ```
3. Run and access the Jupyter notebook.
    ```
    ./run.sh
    ```
4. You can modify the local python code. You can also access the python code in the container (following path).
    ```
    /usr/src/gnssrefl
    ```
5. If you stop the server, command `ctrl +c` and implemant the `stop.sh`
    ```
    ./stop.sh
    ```

### Note:
- If you modified your code, you follow steps 5 and 3 above. The container will install the local python code by pip.
- Docker-compose error might occur if you have not configure your git. If you need not use git, please comment out following lines of docker-compose.yml.
    ```
    - ${HOME}/.ssh:/root/.ssh:ro
    - ${HOME}/.gitconfig:/root/.gitconfig:ro
    ```
