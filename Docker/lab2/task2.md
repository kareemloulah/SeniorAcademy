# create a cotainarized flask app 
as shown in
-flaskapp---
         ---
            -app.py
            -Dockerfile
            -requirements.txt 

the docker files only need app.py and the requirements for the app to function
they must be included in the image and there should be a RUN for the requirements.txt to be installed in the building process


# combined services nginx and a DB in an isolated network but both can still comunicate with each other and add nginx only to a seperate network that is exposed 

