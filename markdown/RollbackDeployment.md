# Kubernetes - Deployment Rollback

## O que é um Deployment no Kubernetes?

É um objeto de recurso que fornece atualizações declarativas para aplicações. Ele nos permite descrever o ciclo de vida das aplicações, quais imagens usar, o quantidade de pods necessários e como devem ser feitas as atualizações.


Dentre as várias estratégias de gerenciamento de aplicações usando a implantação Kubernetes, a mais utilizada e que menos interfere no live traffic é a estratégia de atualizações contínuas.

Estratégia de atualização contínua:

Ocorre uma substituição controlada e em etapas dos pods de uma aplicação. Por padrão, somente 25% dos pods ficam indisponíveis por vez. O Deployment não elimina os pods antigos até que haja pods novos disponíveis em quantidade suficiente para manter o limite de disponibilidade.

<img src="https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/9cecb5e1b2a7fa08c134a842c0700730fbfd50bf/images/1.svg" width="375">
<img src="https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/9cecb5e1b2a7fa08c134a842c0700730fbfd50bf/images/2.svg" width="375">
<img src="https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/9cecb5e1b2a7fa08c134a842c0700730fbfd50bf/images/3.svg" width="375">
<img src="https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/9cecb5e1b2a7fa08c134a842c0700730fbfd50bf/images/4.svg" width="375">
<img src="https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/9cecb5e1b2a7fa08c134a842c0700730fbfd50bf/images/5.svg" width="375">
<img src="https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/9cecb5e1b2a7fa08c134a842c0700730fbfd50bf/images/6.svg" width="375">
<img src="https://raw.githubusercontent.com/Numb4r/KubernetesTutorial/9cecb5e1b2a7fa08c134a842c0700730fbfd50bf/images/7.svg" width="375">

## Problemas na atualização contínua - Deployment Rollback

Sabemos que mesmo quando utilizamos estratégias eficientes como a atualização contínua, problemas podem ocorrer. Desde um "typo" (erro de digitação) ou um problema maior, como sua aplicação não funcionar da maneira esperada após o término do seu Deployment.

Para corrigir erros assim utilizamos um recurso que está imbutido no Kubernetes: o Rollback de deployment.

## Deployment Rollback:

Para entendermos um pouco mais de como o Rollback de deployment funciona, precisamos compreender um pouco sobre como os deployments funcionam e o que são os ReplicaSets.

### ReplicaSets:
O Deployment não é o responsável por criar ou apagar pods. Esse trabalho é delegado pelo Deployment para o ReplicaSet e este é o resposável por gerenciar os pods (criar e deletar).

Dentro de cada ReplicaSet existe apenas um tipo de pod. Ou seja, não podemos guardar dois pods de versões diferentes em um mesmo ReplicaSet.

Quando um pod diferente aparece, o Deployment cria um novo ReplicaSet para a nova versão da aplicação. Após essa criação, ele passa um por um dos pods antigos para o novo modelo atualizado até que todos estejam no novo ReplicaSet e atualizados. Após essa atualização, o ReplicaSet que possui zero pods não é deletado. Pelo menos não imediatamente. Ele é mantido com o contador de replicas igual a zero.

### Realizando um Rollback:

Ao mantér os ReplicaSets antigos, é possível retornar ao estado dos pods presentes neles e voltando os pods um a um como em uma atualização contrária (Rollback).

Por padrão o Kubernates mantém os últimos 10 ReplicaSets e permite você realizar o rollback pra qualquer um deles.

Você pode utilizar o comando "kubectl rollout history deployment/app" para inspecionar o histórico de seu Deployment.

Você também pode dar rollback para uma versão específica através da seguinte linha de comando:

```kubectl rollout undo deployment/app --to-revision=2```

É importante ressaltar que Deployments não guardam referências de seus ReplicaSets. Logo os ReplicaSets são encontrados através da comparação da seção template no arquivo YAML.

Para saber a ordem, o Kubernates salva uma revisão em ReplicaSet.metatada.annotation e podemos inspecionar essa revisão através do seguinte comando:

```kubectl get replicaset *nome-do-replicaset* -o yaml```

