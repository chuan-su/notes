# Spring Actuator

[Spring Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html) enables many production-ready features for your Spring Boot Applications such as health checks, metrics gathering.

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
</dependencies>
```

## Health Checks

When deploying applications to a kubenetes cluster, it is ofter necessary to configure [Liveness, Readiness probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).

The differences between `liveness probs` and `readiness probes` are, as follows:

- The [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/) uses liveness probes to know when to **restart** a container.
- The kubelet uses readiness probes to determine when a container is ready to start accepting traffic.

Spring Actuator exposes both liveness and readiness check endpoints. However, it is important to undertand what to be included in which health group - liveness or readiness.

Considering an Spring Boot application that connects to a Postgres or MySQL database, if the database itself is in outage, restarting the application will not solve the database issues. Therefore, the database health check should not be included in the `liveness` group. Rather, we want to prevent the container from accepting traffics by including the databae health check in the `readiness` group.  

```txt
management.server.port=9000
management.endpoints.web.exposure.include=info,health
management.endpoint.health.enabled=true
management.endpoint.health.show-details=always
management.endpoint.health.probes.enabled=true
management.endpoint.health.group.readiness.include=readinessState,db
```

The `readinessState` is what Spring Boot use to represent whether the application is ready to accept traffic or not. Similaly, the `livenessState` represents the liveness of the application and the correctness ofits internal state.

Therefore, the container readiness to accept traffics is dependent on both the application internal state and the database status.

To check the application readiness, you can go to [localhost:9000/actuator/health/readiness](http://localhost:9000/actuator/health/readiness), which is also what you should configure in the kubenetes readiness probs.

```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    scheme: HTTP
    port: 9000
  initialDelaySeconds: 45
  timeoutSeconds: 40
readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    scheme: HTTP 
    port: 9000
  initialDelaySeconds: 60
  timeoutSeconds: 10
```

### Custom Health Checks

To implement custom health checks, you can extend the Spring [AbstractHealthIndicator](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/actuate/health/AbstractHealthIndicator.html) class.

 However, for applications that use non-blocking clients, for intance, [Lettuce](https://lettuce.io/) for Redis. You need to instead extend the Spring [AbstractReactiveHealthIndicator](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/actuate/health/AbstractReactiveHealthIndicator.html). 

```java
import io.lettuce.core.RedisConnectionException;
import io.lettuce.core.api.StatefulRedisConnection;
import org.springframework.boot.actuate.health.AbstractReactiveHealthIndicator;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.Health.Builder;
import org.springframework.context.annotation.Configuration;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.io.StringReader;
import java.util.Properties;

@Configuration(proxyBeanMethods = false)
public class RedisHealthIndicator extends AbstractReactiveHealthIndicator {

  private final StatefulRedisConnection<String, String> connection;

  public RedisHealthIndicator(StatefulRedisConnection<String, String> connection) {
    super("Redis health check failed");
    this.connection = connection;
  }

  @Override
  protected Mono<Health> doHealthCheck(Builder builder) {

    if (!connection.isOpen()) {
      return Mono.just(this.down(builder, new RedisConnectionException("unable to connect")));
    }

    return connection.reactive().info("server")
        .map(info -> {
          final Properties p = new Properties();
          try {
            p.load(new StringReader(info));
          } catch (IOException e) {
            LOG.warn("failed to load redis server properties", e);
          }
          return this.up(builder, p);
        })
        .onErrorResume(throwable -> Mono.just(this.down(builder, throwable)));
  }

  private Health up(Builder builder, Properties info) {
    return builder.up().withDetail("server", info).build();
  }

  private Health down(Builder builder, Throwable cause) {
    return builder.down(cause).build();
  }
```

After having created the custom health indicator, you need to add it to the health group:

```txt
management.endpoint.health.group.readiness.include=readinessState,redis,db
```

**Note that** the naming needs to correspond to the class name. For example, if you have `PubsubHealthUbducator.java`, then you need to have `include=pubsub` in the actuator configuration. If you have `PubSubHealthIndicator.java`, then you need to have camel case `include=pubSub`.
