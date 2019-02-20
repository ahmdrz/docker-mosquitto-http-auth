### Mosquitto + Authentication in a Docker image.
🦟 HTTP Authentication ready to use for Mosquitto as Docker image.

> MQTT and Websocket is ready to use 💪

### Environment Variables

By default:

1. `auth_opt_http_ip` is equal to `127.0.0.1`, you can change it with `HTTP_IP` ENV variable.
2. `auth_opt_http_port` is equal to `80`, you can change it with `HTTP_PORT`.
3. `auth_opt_http_hostname` is equal to `localhost`, you can change it with `HTTP_HOSTNAME`.

Other parameters in Mosquitto configuration file:

```
auth_opt_http_getuser_uri /mqtt/auth
auth_opt_http_superuser_uri /mqtt/superuser
auth_opt_http_aclcheck_uri /mqtt/acl
```

### Docker

```bash
$ docker pull ahmdrz/mosquitto:latest
$ docker run -p 9001:9001 -p 1883:1883 ahmdrz/mosquitto:latest
```

You can mount `/var/lib/mosquitto/` to persist Mosquitto data.