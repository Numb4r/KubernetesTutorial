# ConfigMaps

Um ConfigMap é um objeto da API usado para guardar dados não confidenciais em pares chave-valor. Pods podem usar ConfigMaps como variáveis de ambiente, argumentos de linha de comando ou como arquivos de configuração para um volume. 

![Kubernetes-ConfigMap (1)](https://user-images.githubusercontent.com/60747654/148644360-4c9a9888-a5c8-4214-af1f-4ce3e4f4df7d.png)

O ConfigMap não oferece confidencialidade ou encriptação, caso os dados que deseja utilizar sejam confidenciais, utilize Secret ao invés de um ConfigMap.

O ConfigMap é utilizado para manter a configuração separada do código da aplicação. Os dados armazenados em um ConfigMap não podem exceder 1 MiB. Caso precise armazenar configurações maiores que esse valor, considere montar um volume ou utilizar um serviço separado de banco de dados ou de arquivamento de dados.

## O Objeto ConfigMap

Um ConfigMap é um objeto da API que permite o armazenamento de configurações para consumo por outros objetos. Diferente de outros objetos do Kubernetes que contém um campo ``spec``, o ConfigMap contém os campos ``data`` e ``binaryData``. Estes campos aceitam pares chave-valor como valores. Ambos os campos são opcionais. O campo ``data`` foi pensado para conter sequências de dados UTF-8, enquanto o campo ``binaryData`` foi planejado para conter dados binários em forma de strings codificadas em base 64. É obrigatório que o nome de um ConfigMap seja um subdomínio DNS válido. Cada chave sob as seções ``data`` ou ``binaryData`` pode conter quaisquer caracteres alfanuméricos, ``-``, ``_`` e ``.``. As chaves armazenadas em  ``data`` não podem colidir com as chaves armazenadas em ``binaryData``. A partir da versão v1.19 do Kubernetes é possível adicionar o campo ``immutable`` a uma definição de ConfigMap para criar um ConfigMap imutável.

## Antes de Começar
  É preciso ter um cluster no Kubernetes e a ferramenta kubectl deve estar configurada para comunicar com seu cluster. Se ainda não possuí um cluster, você pode criar um usando o minikube ou você pode usar um destes playgrounds do Kubernetes:

>[katakonda](https://www.katacoda.com/courses/kubernetes/playground)

>[Play With Kubernetes](https://labs.play-with-k8s.com)  

## Criando um ConfigMap
Um ConfigMap pode ser criado de várias formas, abaixo abordamos as várias maneiras de se criar os ConfigMaps utilizando exemplos: 
- Criando um ConfigMap com kubectl create configmap   
    Use o comando ``kubectl create configmap`` para criar ConfigMaps de diretórios, arquivos ou valores literais:
    ```
    kubectl create configmap <map-name> <data-source>
    ```
    Onde ``<map-name>`` é o nome que deseja associar ao ConfigMap e ``<data-source>``o diretorio, arquivo ou valor literal de onde irá extrair os dados.
    Quando você cria um ConfigMap com base em um arquivo, a chave em ``<data-source>`` é associada ao nome do arquivo e o valor associado ao conteúdo do arquivo. 
    
- Criando ConfigMaps a partir de diretórios 
    
    Você pode usar o comando ``kubectl create configmap`` para criar um ConfigMap a partir de vários arquivos no mesmo diretório. Quando você está criando um ConfigMap com base em um diretório, o kubectl identifica os arquivos cujo nome de base é uma chave válida no diretório e empacota cada um desses arquivos no novo ConfigMap. Quaisquer entradas de diretório, exceto arquivos regulares, são ignoradas (por exemplo, subdiretórios, links simbólicos, dispositivos, canais, etc).
  Por Exemplo:
  ```
   # Create the local directory
   mkdir -p configure-pod-container/configmap/
    
   # Download the sample files into `configure-pod-container/configmap/` directory
   wget https://kubernetes.io/examples/configmap/game.properties -O configure-pod-container/configmap/game.properties
   wget https://kubernetes.io/examples/configmap/ui.properties -O configure-pod-container/configmap/ui.properties

   # Create the configmap
   kubectl create configmap game-config --from-file=configure-pod-container/configmap/
  ```
  O comando acima empacota cada arquivo, neste caso, ``game.properties`` e ``ui.properties`` no diretório ``configure-pod-container/configmap/``no ConfigMap game-config. Você pode exibir detalhes do ConfigMap usando o seguinte comando:
  
  ```
   kubectl describe configmaps game-config
  ```
  Se tudo ocorreu corretamente, a saída será:
  
  ![part3](https://user-images.githubusercontent.com/55333375/148653200-d68d40bc-f06a-4a62-b94a-46602805b2d8.png)

  Os arquivos ``game.properties`` e ``ui.properties`` no diretório ``configure-pod-container/configmap/`` são representados na seção ``data`` do ConfigMap.
  
  Você pode verificar o arquivo com a seguinte linha de comando:
  ```
  kubectl get configmaps game-config -o yaml
  ```
  Se tudo ocorreu corretamente, a saída será:
  
  ![part5](https://user-images.githubusercontent.com/55333375/148653231-faa6f241-20e1-4465-8f35-b4e62326d29e.png)


- Criando ConfigMaps a partir de arquivos
  
  Você também pode usar o comando ``kubectl create configmaps`` para criar um ConfigMap de um arquivo individual ou de múltiplos arquivos.
  Por exemplo:
  ```
  kubectl create configmap game-config-2 --from-file=configure-pod-container/configmap/game.properties
  ```
  Irá gerar o seguinte ConfigMap:
  
  ![part1](https://user-images.githubusercontent.com/55333375/148653261-fc32dbd1-8e7a-44d7-942d-8e8b88571d30.png)

  Você pode passar o argumento ``--from-file`` várias vezes para criar um ConfigMap a partir de várias fontes de dados.
  ```
  kubectl create configmap game-config-2 --from-file=configure-pod-container/configmap/game.properties --from-file=configure-pod-container/configmap/ui.properties
  ```
  Usando o seguinte comando você poderá ver os detalhes do ``game-config-2``:
  ```
  kubectl describe configmaps game-config-2
  ```
  Se tudo ocorreu corretamente, a saída será:
  
  ![part3](https://user-images.githubusercontent.com/55333375/148653286-faf25fbb-d4da-46ea-bef5-babaa9695521.png)

  Quando o ``kubectl`` cria um ConfigMap de entradas que não são ASCII iu UTF-8, a ferramenta coloca as entradas no ``binaryData`` e não em ``data``.As fontes de dados de texto e binárias podem ser combinadas em um ConfigMap. Se quiser visualizar as chaves ``binaryData`` (e seus valores) em um ConfigMap, você pode executar ``kubectl get configmap -o jsonpath = '{. BinaryData}' <nome>``.
  
  ```
  # Download the sample files into `configure-pod-container/configmap/` directory
  wget https://kubernetes.io/examples/configmap/game-env-file.properties -O configure-pod-container/configmap/game-env-   file.properties

  # The env-file `game-env-file.properties` looks like below
  cat configure-pod-container/configmap/game-env-file.properties
  enemies=aliens
  lives=3
  allowed="true"

  # This comment and the empty line above it are ignored    
  ```
  ```
  kubectl create configmap game-config-env-file \
       --from-env-file=configure-pod-container/configmap/game-env-file.properties
  ```
  Isso irá produzir o seguinte configmap:

  ![part5](https://user-images.githubusercontent.com/55333375/148653306-c6f69410-57b2-4802-a091-140f46c67f63.png)

  ### Definindo a chave a ser usada ao criar um ConfigMap a partir de um arquivo
    Você pode definir uma chave diferente do nome do arquivo para usar na seção de dados do seu ConfigMap ao usar o argumento ``--from-file``:
    
    ```
    kubectl create configmap game-config-3 --from-file=<my-key-name>=<path-to-file>
    ```
    Onde ``<my-key-name>`` é a chave que você deseja usar no ConfigMap e ``<path-to-file>`` é a localização do arquivo de origem de dados que você deseja que a chave represente.

    Por exemplo:
    ```
    kubectl create configmap game-config-3 --from-file=game-special-key=configure-pod-container/configmap/game.properties
    ```
    Realizando o comando acima a saída será:
    
    ![part1](https://user-images.githubusercontent.com/55333375/148653319-a8fab412-a4e2-4a71-b7d6-73bc2a7177b9.png)

- Criando ConfigMaps a partir de valores literais
  
  Você pode usar kubectl create configmap com o argumento --from-literal para definir um valor literal na linha de comando:
    ```
    kubectl create configmap special-config --from-literal=special.how=very --from-literal=special.type=charm
    ```
    Podem ser passados vários pares de valores-chave. Cada par fornecido na linha de comando é representado como uma entrada      separada na seção de dados do ConfigMap.
    
    Usando ``kubectl get configmaps game-config-3 -o yaml`` pode verificar o configmap:
    
    ![part1](https://user-images.githubusercontent.com/55333375/148653330-f9219a07-e1e4-4f74-8e1b-d103ad3048dc.png)

- Criando ConfigMaps a partir de um gerador
    
    O ``kubectl`` suporta ``kustomization.yaml`` desde a v1.14. Você também pode criar um ConfigMap a partir de geradores e então aplicá-lo para criar o objeto no Apiserver. Os geradores devem ser especificados em um ``kustomization.yaml`` dentro de um diretório.
    ### Gerando ConfigMaps de arquivos
    Por exemplo, para gerar um ConfigMap a partir dos arquivos ``configure-pod-container/configmap/game.properties``
    
    ```
    # Create a kustomization.yaml file with ConfigMapGenerator
    cat <<EOF >./kustomization.yaml
    configMapGenerator:
    - name: game-config-4
      files:
      - configure-pod-container/configmap/game.properties
    EOF
    ```
    Aplique o diretório do kustomization para criar o objeto ConfigMap.
    
    ```
    kubectl apply -k .
    configmap/game-config-4-m9dm2f92bt created
    ```
    Você pode verificar se o ConfigMap foi criado assim: `` kubectl get configmap ``
    Se tudo ocorreu corretamente irá aparecer:
    
    ![part1](https://user-images.githubusercontent.com/55333375/148653342-4c68467f-1698-4d74-ab0b-9d58319ac5f8.png)
    ![part2](https://user-images.githubusercontent.com/55333375/148653343-d1b6f8fb-12c7-4cca-892a-68093204effd.png)

    Observe que o nome do ConfigMap gerado possui um sufixo anexado ao hash do conteúdo. Isso garante que um novo ConfigMap   seja gerado cada vez que o conteúdo for modificado.
    
    ### Definindo a chave a ser usada ao gerar um ConfigMap a partir de um arquivo
    
    Você pode definir uma chave diferente do nome do arquivo para usar no gerador de ConfigMap. Por exemplo, para gerar um ConfigMap a partir dos arquivos ``configure-pod-container/configmap/game.properties`` com a chave ``game-special-key``
    
    ```
    # Create a kustomization.yaml file with ConfigMapGenerator
    cat <<EOF >./kustomization.yaml
    configMapGenerator:
    - name: game-config-5
      files:
      - game-special-key=configure-pod-container/configmap/game.properties
    EOF
    ```
    Aplique o diretório do kustomization para criar o objeto ConfigMap.
    ```
    kubectl apply -k .
    configmap/game-config-5-m67dt67794 created
    ```
    Você pode verificar se o ConfigMap foi criado assim: `` kubectl describe configmaps/<configmap_name> ``
    Se tudo ocorreu corretamente irá aparecer:
    
    ![part1](https://user-images.githubusercontent.com/55333375/148653439-9b4d9c14-00b1-49b9-a5ac-01d3bb2c610b.png)

    ### Gerando ConfigMaps a partir de literais
    Para gerar um ConfigMap a partir dos literais ``special.type = charm`` e ``special.how = very``, você pode especificar o gerador do ConfigMap em ``kustomization.yaml`` como
    ```
    # Create a kustomization.yaml file with ConfigMapGenerator
    cat <<EOF >./kustomization.yaml
    configMapGenerator:
    - name: special-config-2
      literals:
      - special.how=very
      - special.type=charm
    EOF
    ```
    Aplique o diretório do kustomization para criar o objeto ConfigMap.
    ```
    kubectl apply -k .
    configmap/special-config-2-c92b5mmcf2 created
    ```
    Você pode verificar se o ConfigMap foi criado assim: `` kubectl describe configmaps/<configmap_name> ``
    Se tudo ocorreu corretamente irá aparecer:
    
    ![part1](https://user-images.githubusercontent.com/55333375/148653463-c21089d3-7761-4233-ba5f-4a92f08c6eb7.png)

## Trabalhando com variáveis de ambiente de container usando ConfigMap

### Definindo uma variável de ambiente do container com dados de um único ConfigMap
  Defina uma variável de ambiente como um par de valores-chave em um ConfigMap:
  ```
  kubectl create configmap special-config --from-literal=special.how=very
  ```
  Atribua o valor ``special.how`` definido no ConfigMap à variável de ambiente ``SPECIAL_LEVEL_KEY`` na especificação do pod.
  ```
  apiVersion: v1
  kind: Pod
  metadata:
    name: dapi-test-pod
  spec:
    containers:
      - name: test-container
        image: k8s.gcr.io/busybox
        command: [ "/bin/sh", "-c", "env" ]
        env:
        # Define the environment variable
          - name: SPECIAL_LEVEL_KEY
            valueFrom:
              configMapKeyRef:
                # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
                name: special-config
                # Specify the key associated with the value
                key: special.how
  restartPolicy: Never

  ```
  Crie o Pod:
  ```
  kubectl create -f https://kubernetes.io/examples/pods/pod-single-configmap-env-variable.yaml
  ```
  Agora, a saída do Pod inclui a variável de ambiente ``SPECIAL_LEVEL_KEY = very``.
### Definindo as variáveis de ambiente do container com dados de vários ConfigMaps  
  Como visto no exemplo anterior crie um ConfigMap primeiro 
  ```
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: special-config
    namespace: default
  data:
    special.how: very
  ---
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: env-config
    namespace: default
  data:
    log_level: INFO
  ```
  ```
  kubectl create -f https://kubernetes.io/examples/configmap/configmaps.yaml
  ```
  Defina as variáveis de ambiente na especificação do pod.
  ```
  apiVersion: v1
  kind: Pod
  metadata:
    name: dapi-test-pod
  spec:
    containers:
      - name: test-container
        image: k8s.gcr.io/busybox
        command: [ "/bin/sh", "-c", "env" ]
        env:
          - name: SPECIAL_LEVEL_KEY
            valueFrom:
              configMapKeyRef:
                name: special-config
                key: special.how
          - name: LOG_LEVEL
            valueFrom:
              configMapKeyRef:
                name: env-config
                key: log_level
  restartPolicy: Never
  ```
  Crie o Pod:
  ```
  kubectl create -f https://kubernetes.io/examples/pods/pod-multiple-configmap-env-variable.yaml
  ```
  
  Agora, a saída do Pod inclui as variáveis de ambiente ``SPECIAL_LEVEL_KEY = very`` e ``LOG_LEVEL = INFO``.
  
  
### Configurando todos os pares de valores-chave em um ConfigMap como variáveis de ambiente de container  
  
  Crie um ConfigMap contendo vários pares de valores-chave.
  ```
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: special-config
    namespace: default
  data:
    SPECIAL_LEVEL: very
    SPECIAL_TYPE: charm
  ```
  Crie o ConfigMap:
  ```
  kubectl create -f https://kubernetes.io/examples/configmap/configmap-multikeys.yaml
  ```
  Use envFrom para definir todos os dados do ConfigMap como variáveis de ambiente do container. A chave do ConfigMap se torna o nome da variável de ambiente no pod.
  ```
  apiVersion: v1
  kind: Pod
  metadata:
    name: dapi-test-pod
  spec:
    containers:
      - name: test-container
        image: k8s.gcr.io/busybox
        command: [ "/bin/sh", "-c", "env" ]
        envFrom:
        - configMapRef:
            name: special-config
    restartPolicy: Never
  ```
  Crie o Pod:
  ```
  kubectl create -f https://kubernetes.io/examples/pods/pod-configmap-envFrom.yaml
  ```
  Agora, a saída do Pod inclui as variáveis de ambiente ``SPECIAL_LEVEL = very`` e ``SPECIAL_TYPE = charme``.
   ## Adicionando dados do ConfigMap a um Volume
   Conforme explicado em Criando ConfigMaps a partir de arquivos, ao criar um ConfigMap usando ``--from-file``, o nome do arquivo se torna uma chave armazenada na seção de dados do ConfigMap. O conteúdo do arquivo se torna o valor da chave.
   ```
   apiVersion: v1
  kind: ConfigMap
  metadata:
    name: special-config
    namespace: default
  data:
    SPECIAL_LEVEL: very
    SPECIAL_TYPE: charm
   ```
  
### Populando um Volume com dados guardados no ConfigMap 
Adicione o nome do ConfigMap na seção de volumes da especificação do pod. Isso adiciona os dados do ConfigMap ao diretório especificado como ``volumeMounts.mountPath`` (neste caso, / etc / config). A seção de comando lista arquivos de diretório com nomes que correspondem às chaves no ConfigMap.
  ```
  apiVersion: v1
  kind: Pod
  metadata:
    name: dapi-test-pod
  spec:
    containers:
      - name: test-container
        image: k8s.gcr.io/busybox
        command: [ "/bin/sh", "-c", "ls /etc/config/" ]
        volumeMounts:
        - name: config-volume
          mountPath: /etc/config
    volumes:
      - name: config-volume
        configMap:
          # Provide the name of the ConfigMap containing the files you want
          # to add to the container
          name: special-config
    restartPolicy: Never
  ```
  Crie o Pod:
  ```
  kubectl create -f https://kubernetes.io/examples/pods/pod-configmap-volume.yaml
  ```
  Quando o pod é executado, o comando ``ls/etc/config/`` produz a saída abaixo:
  ```
  SPECIAL_LEVEL
  SPECIAL_TYPE
  ```  
  
