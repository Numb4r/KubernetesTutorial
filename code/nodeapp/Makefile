image-name="numb4r/node-app"

build:
        docker build -t $(image-name) .

run:
        docker run -p 3000:3000 -d $(image-name)

tag:
        docker tag $(image-name) $(image-name):latest

push:
        docker push $(image-name)
