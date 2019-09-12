# Elm learning ToDo List

The goal of this project is to test and learn all the basic stuffs
related to the Elm framework.

It is just a simple To do list application made with [elm-mdc](https://github.com/aforemny/elm-mdc) which
offers all the material design components in Elm.

## Installation

The first step is to download the project's sources.

```shell script
git clone https://github.com/moutoum/elm-learning-todos.git
git submodule init
```

Then, build the `elm-mdc` library.

```shell script
cd elm-mdc && make && cd -
```

And to finish, build the application:

```shell script
elm make src/Main.elm --output=app.js
```

> Be sure `Elm` is correctly installed in your environment

## Configuration

To be able to perform requests from the web application and the server API,
you will have some troubles regarding the [CORS protection][CORS].

To make it works, I created a HTTP proxy to add the 'Access-Control-Allow-Origin'
header and route the requests on the good way.  

### Nginx

To configure the nginx server, create a file `/etc/nginx/sites-availables/todos.conf`
with the following content.

```
server {
        listen          80;
        server_name     localhost;

        location / {
                root                    <..path..to..>/elm-learning-todos;
                proxy_http_version      1.1;

                add_header              'Access-Control-Allow-Origin' '*';

                proxy_set_header        Upgrade $http_upgrade;
                proxy_set_header        Connection "Upgrade";
        }

        location /api {
                proxy_pass              http://localhost:8000;
                proxy_http_version      1.1;
        }
}
```

Then, create a symbolic link and restart the server.

```shell script
sudo ln -s /etc/nginx/sites-available/todos.conf /etc/nginx/sites-enabled/todos.conf
sudo systemctl restart nginx
```

## Run

To run the project, just go to your favourite browser and open `localhost`.

![](images/Screenshot_20190904_232147.png)

[CORS]: https://developer.mozilla.org/fr/docs/Web/HTTP/CORS