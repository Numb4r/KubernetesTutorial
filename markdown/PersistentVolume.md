
## Persistent Volumes

Antes de aprendermos sobre os Persistent Volumes é necessário saber um pouco sobre o que exatamente são os Volumes no Kubernetes.

### Volumes

Os dados utilizados e gerados por um Pod, só estarão disponíveis enquanto o Pod estiver em funcionamento, caso ele crashe ou seja finalizado, todos os dados gerados até então serão perdidos, pois o Kubernetes automaticamente os destrói. Para resolver o “problema” do descarte de dados, precisamos usar então aquilo que o Kubernetes chama de Volumes, que são basicamente diretórios contendo dados que podem ser acessados pelos Conteiners de um Pod. Os volumes que possuem o tempo de vida de um Pod são chamados de Volumes Efêmeros (Ephemeral Volumes).

Existem vários tipos de volumes, como não é o foco no momento iremos apresentar apenas o awsElasticBlockStore, que é um volume que monta um Amazon Web Services (AWS) EBS volume no seu pod. Antes de usar é necessário criar o volume e isso pode ser feito com o comando ``aws ec2 create-volume --availability-zone=eu-west-1a --size=10 --volume-type=gp2``. Após criarmos o volume podemos utilizar ele em nosso Pod, um exemplo de configuração para o AWS EBS ficaria da seguinte forma:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-ebs
spec:
  containers:
  - image: k8s.gcr.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /test-ebs #Define o caminho onde o volume será montado
      name: test-volume
  volumes:
  - name: test-volume
    # Abaixo serão incluídas as informações referentes ao volume criado com o comando acima.
    awsElasticBlockStore:
      volumeID: "<volume id>"
      fsType: ext4
```
### Settando o Ambiente

Para acompanhar o seguinte tutorial será necessário rodar alguns comandos no shell da sua ferramenta utilizada para rodar o Kubernetes é necessário também que você esteja  rodando apenas um Node no seu cluster. Primeiramente acesse o shell da sua ferramenta, caso esteja usando o Minikube basta digitar ``minikube ssh``, agora utilize o seguinte código para criar um diretório: ``sudo mkdir /mnt/data``. Após criar o diretório crie um arquivo com o seguinte código: ``sudo sh -c "echo 'Hello from Kubernetes storage' > /mnt/data/index.html"``, para testar se o arquivo foi criado utilize ``cat /mnt/data/index.html``
e a saída deve ser ``Hello from Kubernetes storage``, caso a mensagem apareça corretamente você pode dar sequência ao tutorial.

### Persistent Volumes (PV)

A utilização de Volumes é algo que pode vir a se tornar algo complicado na criação de novos Pods, dado que para utilizar um Volume em um pod, é necessário ter informações como o volumeID, o fsType e o volumeType que podem ser informações que nem todos os usuários possuem. Para que evitar então que essas informações sejam necessárias para todos é utilizado um PV. Um PV é uma parte do armazenamento dentro do cluster e que tenha sido manualmente criado por um administrador, que detenha todas as informações do ambiente, ou dinamicamente utilizando Storage Classes. Abaixo há um exemplo de como criar um PV de nome task-pv-volume, capacidade de armazenamento de 10GB e que será montado no caminho "/mnt/data". 
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
```
Pode-se criar o PV utilizando o comando ``kubectl apply -f pv-volume.yaml`` e com o comando ``kubectl get pv task-pv-volume`` é possível ver as informações do PV criado. O modo de acesso ReadWriteOnce faz com que o PV possa ser montado em modo de escrita-leitura por apenas um Node. Existem mais outros dois modos de acesso o modo o ReadOnlyMany, permite que o PV seja montado por múltiplos Nodes mas apenas em modo de leitura, e o modo  ReadWriteMany, permite que o PV seja montado por múltiplos Nodes em modo de leitura e escrita. O PV é uma API que tem então por objetivo facilitar os detalhes à implementação do armazenamento, essa API recebe requests de uma outra API chamada de Persistent Volume Claim (PVC).

### Persistent Volume Claim (PVC)

Como dito acima, uma PVC é então um API que faz requests ao PV, que são para armazenamento e feitas por um usuário. Pode-se pensar nos PVCs como sendo Pods tendo em vista que Pods consomem recursos do Node e os PVCs consomem recursos do PV. Os PVCs podem fazer requests de tamanhos e modos de acesso específicos. Um PVC pode ser criado seguindo o exemplo abaixo, esse PVC requisitará 3GB de armazenamento e modelo de acesso ReadWriteOnce. 
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```
Para criar o PVC deve-se utilizar o seguinte comando: ``kubectl apply -f pv-claim.yaml``. Utilizando o comando para visualizar as informações do PV criado é possível ver que o campo Status passou de Available para Bound e utilizando o comando ``kubectl get pvc task-pv-claim`` é possível ver que o PVC criado está ligado ao PV.

### Utilizando PV e PVC em um Pod

Primeiramente é necessário criar um Pod que utilize os PVC e PV criados, isso pode ser feito utilizando o seguinte arquivo yalm: 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: task-pv-storage

```
Para criar o Pod utilize o seguinte comando: ``kubectl apply -f pv-pod.yaml``

Verifique se o Pod está rodando utilizando o comando: ``kubectl get pod task-pv-pod``

Inicia um shell para o container rodando no Pod criado: ``kubectl exec -it task-pv-pod -- /bin/bash``

Após entrar no shell, rode os seguintes comandos: 
```shell
apt update
apt install curl
curl http://localhost
```
Caso você veja a mensagem: ``
Hello from Kubernetes storage
``, significa que você obteve sucesso em configurar o Pod para utilizar o dado armazenado no PVC criado acima.
