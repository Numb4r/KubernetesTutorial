## Nodes

Nodes é um componente do Kubernetes que faz parte da hierarquia Master/Worker, na qual ele é um worker sendo controlado pelo control plane (Master). Em Kubernetes, essa dinâmica é renomeada para Master/Nodes.
 
Kubernetes roda a atividade proposta dentro de containers, que estes são colocados em Pods que rodam dentro de Nodes.Um Node pode conter  vários Pods, da mesma forma que um Pod pode conter vários containers. O Kubernetes control plane é responsável por dividir automaticamente a carga de Pods entre os Nodes do cluster.
 
Um Node por ser virtual, em conjunto ao control plane e outros Nodes, ou uma máquina física, sendo controlado via rede. Tipicamente, um cluster possui dezenas de Nodes.

![primeira imagem](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/images/module_03_nodes.svg "a" )\

A estrutura de um Node possui três principais componentes:
 
1. Kubelet: Gerenciador principal do Node, responsável por orquestrar os Pods atribuídos a ele. Além disso, ele é um agent end-point de comunicação entre Master e Nodes. é tarefa do kubelet comunicar ao Master caso um Pod caia.
2. Kube-proxy: Estrutura de proxy do Node para redirecionamento de network traffic. Responsável por conectar os serviços entre Nodes e o mundo externo.
3. Container runtime: Software responsável por rodar os containers. Docker é o mais comum container runtime.


### Gerenciamento 

É possível criar Node de duas formas possíveis: O kubelet em um  node self-register no control plane e manualmente por usuário.
 
É possível criar um Node especificando um JSON manifest com suas especificações. Esse objeto Node é criado internamente  dentro do kubernets e é checado se o kubelet foi registrado no API server (control plane). Caso a saúde do Node não seja boa, ou seja, todos os serviços estejam rodando, o Node é ignorado pelo cluster até que ele se torne saudável. Caso ele seja saudável, o Node poderá rodar Pods.


``` javascript
{
  "kind": "Node",
  "apiVersion": "v1",
  "metadata": {
    "name": "10.240.79.157",
    "labels": {
      "name": "my-first-k8s-node"
    }
  }
}
```

Os nomes são a forma de identificar cada Node, que devem ser únicos de cada um. Caso dois Nodes possuam o mesmo nome, o Kubernetes assumirá que são o mesmo objeto e possuem o mesmo estado (network, conteúdo de disco) e atributos.
 

### Criando um Cluster Multi-Node (Minikube)

É possível criar um demonstrativo de como é o comportamento de um cluster com multi nodes dentro do Minikube. Para isso execute ``minikube start --nodes 2 -p multinode-demo``. Esse comando ira criar um novo cluster e dentro dele dois nodes.
 
Você pode visualizar todos os Nodes usando o comando ``kubectl get nodes``. Da mesma forma, você pode conferir o status de um Node usando o comando ``minikube status -p multinode-demo``


![kubectl get nodes](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/images/2022-01-06_10:34:36.png)

![minikube status -p multinode-demo](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/images/2022-01-06_10:37:36.png)


A flag ``-p`` indica uma mudança de profile do minikube. No caso acima, criamos um novo profile com o nome "multinode-demo". Sempre que for necessário a execução de algum comando do minikube que impacta em algum profile específico que não seja o default (minikube) é necessário informar pela flag em qual profile será executado. Após a criação do cluster, o ``kubectl`` irá usar o profile como padrão.
 
Usaremos o arquivo [hello-deployment.yaml](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/code/hello-deployment.yaml) para realizar um deployment que utilize os dois Nodes. Para isso utilizaremos o comando ``kubectl apply -f hello-deployment.yaml``. Podemos notar que foram criadas duas réplicas do mesmo deployment. Para que se tenha certeza que os Pods serão criados em Nodes distintos, declaramos na linha 22 do arquivo yaml a propriedade ``PodAntiAffinity`` em conjunto com ``requiredDuringSchedulingIgnoredDuringExecution``. Isso irá dizer para dizer para o Kubernetes apenas aplicar as regras na criação dos Pods. A propriedade ``labelSelector`` em conjunto com ``matchExpressions`` irá fazer a distinção entre um Node e outro, fazendo que as réplicas fiquem em Nodes diferentes.
 
Podemos usar o arquivo [hello-svc.yaml](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/code/hello-svc.yaml) para fazer um deploy de um servico que ira dividir as requisicoes IP feita pelo server entre os dois Nodes. Aplicamos o arquivo [hello-svc.yaml](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/code/hello-svc.yaml) pelo comando ``kubectl apply -f hello-svc.yaml``. Checamos o IP fornecido por esse serviço pelo comando ``minikube service list -p multinode-demo``


![minikube service list -p multinode-demo](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/images/2022-01-06_15:36:24.png)

Com isso, podemos fazer uma requisição para o IP fornecido e verificar quais os Nodes são chamados. é possível conferir o IP interno de cada Pod pelo comando ``kubectl get pods -o wide``
 
![Teste de intercalabilidade entre Nodes](https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/master/images/2022-01-06_15:38:44.png)
 
Podemos ver que o Kubernetes acessa mais de um Node durante as requisições. Isso é feito com o intuito de balanceamento de carga.
