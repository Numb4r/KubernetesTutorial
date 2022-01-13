# Tutorial Deploy em um multinode cluster usando Minikube
 
Vamos utilizar o minikube para fazer o deploy da aplicação contida na pasta [nodeapp](https://github.com/Numb4r/KubernetesTutorial/tree/master/code/nodeapp).
 
## Iniciando o cluster
 
Para se aproximar de  um ambiente de produção iremos utilizar o recurso do minikube de simular múltiplos nodes.
 
Para isso, na inicialização do cluster injetamos a flag ``--nodes`` com o número de nodes que queremos.Iremos utilizar 3 nodes, 1 Master e 2 Workes.

```bash
minikube start --nodes 3 
```

Caso já tenha sido criado um cluster anteriormente, você pode efetuar a remoção usando o comando ``minikube delete``. Caso não queria deletar, utilize a flag ``-p`` seguida de um nome para utilizarmos outro namespace.
 
Agora precisamos definir labels para os nodes para que a aplicação se divida entre eles.
Para isso utilizamos o comando ``kubectl label nodes <node-name> <label-key>=<label-value>``. Vamos definir uma label chamada "finality" com os valores "db" e "app" para que um node fique com a database e o outro fique com a aplicação.

```bash 
kubectl label nodes minikube-m02 finality=db
kubectl label nodes minikube-m03 finality=app
```

## Criando um Persistent Volume e o database

Iremos criar agora o pod da database e seu Persistent Volume para proteger de perda de dados.
 
Para isso,usaremos os arquivos [pv-mysql.yaml](https://github.com/Numb4r/KubernetesTutorial/blob/master/code/nodeapp/pv-mysql.yaml) para o persistent volume e [svdp-mysql.yaml](https://github.com/Numb4r/KubernetesTutorial/blob/master/code/nodeapp/pv-mysql.yaml) para a criação do deployment e do serviço.
 


```bash

kubectl apply -f pv-mysql.yaml
kubectl apply -f svdp-mysql.yaml
```

Agora precisamos aplicar a modelagem do banco de dados. Para isso, efetuamos os seguinte comandos
```bash
kubectl exec -it <mysql-node> /bin/sh
mysql -u root -p
Enter password: password
mysql> CREATE DATABASE IF NOT EXISTS TODO;
mysql> USE TODO;
mysql> CREATE TABLE IF NOT EXISTS task(id INTEGER PRIMARY KEY AUTO_INCREMENT,name VARCHAR(50), description VARCHAR(500));
mysql> exit
exit
```

## Criando o Deployment da aplicacao e expondo ela

Para finalizar, basta apenas inserir a aplicacao no cluster e expor ela para a internet. Para isso, vamos precisar do arquivo [deployment-webapp.yaml](https://github.com/Numb4r/KubernetesTutorial/blob/master/code/nodeapp/pv-mysql.yaml).

```bash
kubectl apply -f deployment-nodeapp.yaml
```

Por fim, vamos criar um serviço para que a internet tenha acesso a aplicação. Para isso utilize o comando

``` bash
kubectl expose deployment nodeapp --type="NodePort"
minikube service --url nodeapp
```




