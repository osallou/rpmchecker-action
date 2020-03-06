FROM rpmbuild/centos7

USER root
RUN yum install -y rpmlint
RUN sed -i -e 's/Defaults    requiretty.*/ #Defaults    requiretty/g' /etc/sudoers
USER builder
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
