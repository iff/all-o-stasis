FROM node

ADD  . /app
WORKDIR /app

RUN ./script/bootstrap

CMD ["node_modules/.bin/coffee", "server.coffee"]
