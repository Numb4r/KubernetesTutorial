O kubernetes eh uma plataforma de codigo aberto, portavel e extensiva para o gerenciamento de cargas de trabalho e serviços distribuidos
em conteiners, que facilita tanto a configuracao declarativa quanto a automacao. Ele possui um ecossistema grande, e de rapido crescimento. 
Servicos, suporte, e ferramentas para kubernetes estao amplamente disponiveis.
O Google(R)  tornou kubernetes um projeto de codigo-aberto em 2014. O nome Kuberbetes tem origem no Grego, significando timoneiro ou piloto.
K8s eh a abreviacao derivada de troca das oito letras "ubernete" por "8", se tornando K"8"s.

No inicio, as organizacoes executavam aplicacoes em servidores fisicos,mas o desempenho era inferior. Como solucao, foi introduzida a virtualizacao,
que permite que voce execute varias VMs (maquinas virtuais) em uma unica CPU de um servidor fisico.
Os conteiners sao semelhantes as VMs, mas tem propriedades de isolamento flexibilizados para compartilhar o sistema operacional (SO) entre outras
aplicacacoes, sendo considerados leves. Como sao separados da infraestrutura subjacente, eles sao portaveis entre nuvens e distribuicoes de SO.


Nesse manual sao abordados os assuntos: Nodes,ConfigMaps,Persistent Volume e Rollback de Deployment.

Esse manual utilizara o docker como forma de conternalizacao e o minikube como forma de gerenciamento dos conteiners.

# Sumario

* [Nodes](#nodes)
* [ConfigMaps](#configmaps)
* [Persistent Volumes](#persistent-volumes)
* [Rollback de Deployment](#rollback-de-deployment)
* [Referências Bibliográficas](#referências-bibliográficas)