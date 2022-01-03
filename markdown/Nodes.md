# Nodes

Nodes e' um componente do Kubernetes que faz parte da hierarquia Master/Worker, na qual ele e' um worker sendo controlado pelo control plane (Master). Em Kubernets, essa dinamica e' renomeada para Master/Nodes.

Kubernetes roda a atividade proposta dentro de containers, que estes sao colocados em Pods que rodam dentro de Nodes.Um Node pode conter  varios Pods, da mesma forma que um Pod pode conter varios conteiners. 

Um Node por ser virtual, em conjunto ao control plane e outros Nodes, ou uma maquina fisica, sendo controlado via rede. Tipicamente, um cluster possui dezenas de Nodes.

A estrutura de um Node possui 3 principais componentes:

1. Kubelet: Agent end-point de comunicacao entre Master e Nodes.
2. Kube-proxy: Estrutura de proxy do Node para redirecionamento de network traffic
3. Container runtime: Software responsavel por rodar os containers. Docker e' o mais comum container runtime.


## Gerenciamento 