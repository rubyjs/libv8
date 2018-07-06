FROM alpine:3.7

MAINTAINER Andrew Cutler <andrew@panubo.com>

RUN apk update && \
    apk add sudo bash git openssh rsync && \
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    sed -i -e 's@^AuthorizedKeysFile.*@@g' /etc/ssh/sshd_config  && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    echo -e "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
