

## 1. Rolling File Appender: custom timestamp key usage & LOG_DIR property usage
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true">
    <!-- Rolling File Appender: custom timestamp key usage & LOG_DIR property usage -->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <property name="LOG_DIR" value="/home/dalexander/Repos/tictactoe/data" />
        <timestamp key="timestamp" datePattern="yyyy-MM-ddTHH-mm"/>
        <file>${LOG_DIR}/tictactoe.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_DIR}/tictactoe.%d${timestamp}.log</fileNamePattern>
            <maxHistory>10</maxHistory>
        </rollingPolicy>
        <append>true</append>
        <layout class="ch.qos.logback.classic.PatternLayout">
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level [%file:%line]    - %msg%n</Pattern>
        </layout>
    </appender>
</configuration>
```

## 2. Rolling File Appender: custom datetime & indexing
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true">
    <!-- Rolling File Appender: custom datetime & indexing -->
    <appender name="RootFileAppender" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>tictactoe.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
            <fileNamePattern>tictactoe.%d{yyyy-MM-dd'T'HH-mm-ss}.%i.log</fileNamePattern>
            <minIndex>1</minIndex>
            <maxIndex>10</maxIndex>
        </rollingPolicy>
        <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
            <maxFileSize>3GB</maxFileSize>
        </triggeringPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level [%file:%line]    - %msg%n</pattern>
        </encoder>
    </appender>
</configuration>
```