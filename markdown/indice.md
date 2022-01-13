O kubernetes é uma plataforma de código aberto, portável e extensiva para o gerenciamento de cargas de trabalho e serviços distribuídos
em contêiners, que facilita tanto a configuração declarativa quanto a automação. Ele possui um ecossistema grande, e de rápido crescimento. 
Serviços, suporte, e ferramentas para kubernetes estão amplamente disponíveis.
O Google(R)  tornou kubernetes um projeto de código-aberto em 2014. O nome Kuberbetes tem origem no Grego, significando timoneiro ou piloto.
K8s é a abreviação derivada de troca das oito letras "ubernete" por "8", se tornando K"8"s.

No início, as organizações executavam aplicações em servidores físicos,mas o desempenho era inferior. Como solução, foi introduzida a virtualização,
que permite que voce execute várias VMs (máquinas virtuais) em uma única CPU de um servidor físico.
Os contêiners são semelhantes as VMs, mas tem propriedades de isolamento flexibilizados para compartilhar o sistema operacional (SO) entre outras
aplicacações, sendo considerados leves. Como são separados da infraestrutura subjacente, eles são portáveis entre nuvens e distribuições de SO.


Nesse manual são abordados os assuntos: Nodes,ConfigMaps,Persistent Volume e Rollback de Deployment.

Esse manual utilizará o docker como forma de conternalização e o minikube como forma de gerenciamento dos contêiners.

# Sumário

* [Nodes](#nodes)
* [ConfigMaps](#configmaps)
* [Persistent Volumes](#persistent-volumes)
* [Rollback de Deployment](#rollback-de-deployment)
* [Referências Bibliográficas](#referências-bibliográficas)