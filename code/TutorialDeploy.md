# Tutorial Deploy em um multinode cluster usando Minikube

Vamos utilizar o minikube para fazer o deploy da aplicacao contida na pasta [nodeapp]().

## Iniciando o cluster

Para fazer simular um ambiente ? iremos utilizar o recurso do minikube de simular multiplos nodes.

Para isso, na inicializacao do cluster passamos a flag ``--nodes`` com o numero de nodes que queremos.Iremos utilizar 3 nodes, 1 Master e 2 Workes.

```bash
minikube start --nodes 3 
```

Caso ja tenha sido criado um cluster anteriormente, voce pode efetuar a remocao usando o comando ``minikube delete``. Caso nao queria deletar, utilize a flag ``-p`` seguida de um nome para utilizarmos outro namespace.

Agora precisamos definir labels para os nodes para que a aplicacao se divida entre eles.
Para isso utilizamos o comando ``kubectl label nodes <node-name> <label-key>=<label-value>``. Vamos definir uma label chamada "finality" com os valores "db" e "app" para que um node fique com a database e o outro fique com a aplicacao.

```bash 
kubectl label nodes minikube-m02 finality=db
kubectl label nodes minikube-m03 finality=app
```

## Criando um Persistent Volume e o database

Iremos criar agora o pod da database e seu Persistent Volume para proteger de perda de dados.

Para isso,usaremos os arquivos [pv-mysql.yaml]() para o persistent volume e [svdp-mysql.yaml] para a criacao do deployment e do servico.

```bash

kubectl apply -f pv-mysql.yaml
kubectl apply -f svdp-mysql.yaml
```

## Criando o Deployment da aplicacao e expondo ela

Para finalizar, basta apenas inserir a aplicacao no cluster e expor ela para a internet. Para isso, vamos precisar do arquivo [deployment-nodeapp.yaml].

```bash
kubectl apply -f deployment-nodeapp.yaml
```

Por fim, vamos criar um servico para que a internet tenha acesso a aplicacao. Para isso utilize o comando

``` bash
kubectl expose deployment nodeapp --type="NodePort"
minikube service --url nodeapp
```




