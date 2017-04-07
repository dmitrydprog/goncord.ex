FROM elixir

RUN yes | apt update
RUN yes | apt install libncursesw5 libncursesw5-dev
RUN ln -s /lib/x86_64-linux-gnu/libncursesw.so.5  /lib/x86_64-linux-gnu/libncursesw.so.6

ADD ./ /goncord
WORKDIR /goncord

EXPOSE 4000

CMD ["sh", "/goncord/start.sh"]

