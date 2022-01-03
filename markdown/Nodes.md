# Nodes

Nodes e' um componente do Kubernetes que faz parte da hierarquia Master/Worker, na qual ele e' um worker sendo controlado pelo control plane (Master). Em Kubernets, essa dinamica e' renomeada para Master/Nodes.

Kubernetes roda a atividade proposta dentro de containers, que estes sao colocados em Pods que rodam dentro de Nodes.Um Node pode conter  varios Pods, da mesma forma que um Pod pode conter varios conteiners. O Kubernetes control plane e' responsavel por dividir automaticamente a carga de Pods entre os Nodes no cluster.

Um Node por ser virtual, em conjunto ao control plane e outros Nodes, ou uma maquina fisica, sendo controlado via rede. Tipicamente, um cluster possui dezenas de Nodes.

![](../images/module_03_nodes.svg)
A estrutura de um Node possui tres principais componentes:

1. Kubelet: Agent end-point de comunicacao entre Master e Nodes. E tarefa do kubelet comunicar ao Master caso um Pod caia.
2. Kube-proxy: Estrutura de proxy do Node para redirecionamento de network traffic
3. Container runtime: Software responsavel por rodar os containers. Docker e' o mais comum container runtime.


## Gerenciamento 

E' possivel criar Node de duas formas possiveis: O kubelet em um  node self-register no control plane e manualmente por usuario.

E' possivel criar um Node especificando um JSON manifest com suas especificacoes. Esse objeto Node e' criado internamente  dentro do kubernets e e' checado se o kubelet foi registrado no API server (control plane). Caso a saude do Node nao seja boa, ou seja, todos os servicoes estejam rodando, o Node e' ignorado pelo cluster ate que ele se torne saudavel. Caso ele seja saudavel, o Node podera' rodar Pods.

```javascript
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

Os nomes sao a forma de identificar cada Node, que devem ser unicos de cada um. Caso dois Nodes possuam o mesmo nome, o Kubernetes assumira que sao o mesmo objeto e possuem o mesmo estado (network, conteudo de disco) e atributos. 


### Criando um Node 

