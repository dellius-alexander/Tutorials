FROM apachepulsar/pulsar:2.8.2
RUN apt-get update -y
CMD ["/bin/bash", "-c", "bin/apply-config-from-env.py conf/standalone.conf && exec bin/pulsar standalone --no-functions-worker --no-stream-storage"]
