FROM debian:stable-slim
# COPY source destination
COPY Learn_Docker /bin/goserver
CMD ["/bin/goserver"]
ENV PORT=8991

