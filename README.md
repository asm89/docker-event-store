docker-event-store
==================

A Dockerfile that produces a container that runs [EventStore].

[EventStore]: http://geteventstore.com/

## Building a container

Clone the repository, enter the directory, then build the image:

```bash
$ git clone https://github.com/asm89/docker-event-store.git
$ cd docker-event-store
$ docker build -t event-store .
```

## Running Event Store

After you've successfully built the container you can it like this:

```bash
$ docker run -t -i event-store:latest
```

Now find the ip address of the running event store:

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                NAMES
7c25c343e248        event-store:latest   mono-sgen /var/local  6 seconds ago       Up 5 seconds        1113/tcp, 2113/tcp   loving_pasteur
$ docker inspect 7c25c343e248 | grep IPAddress
        "IPAddress": "172.17.0.2",
```

Visit `http://172.17.0.2:2113` for the web ui!

## Thanks to

The Dockerfile in this repository is based on the original one by [pjvds] that
can be found [here].

[pjvds]: https://github.com/pjvds
[here]: https://github.com/pjvds/Dockerfiles
