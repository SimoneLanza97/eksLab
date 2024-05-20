# KUBERNETES SECRETS

Quando facciamo il deploy di applicativi containerizzati in produzione potremmo trovarci nella condizione di definire alcune variabili d'ambiente 
per i nostri pod che contengano segreti , come ad esempio password o stringhe di connessione ai databases.Di conseguenza non vogliamo che i nostri segreti siano 
visibili come una normale variabile di ambiente ma vogliamo che restino privati.
In Kubernetes questo puo essere fatto attraverso l'uso di secrets, i secrets sono oggetti che ci permettono di gestire dati sensibili senza che questi siano esposti nel processo di creazione delle risorse .

I secrets vengono salvati dall' API Server di kubernets all'interno di ETCD , di base vengono salvati senza encryption , di conseguenza chiunque abbia accesso all API server può visualizzarli e modificarli. 
All'interno del pod i secrets vengono generalmente salvati all'interno di un file in modo che l'applicativo all'interno del pod possa comunque accedervi ma non siano visibili come delle variabili d'ambiente 

Per comprendere l'utilizzo dei secrets proveremo a fare il deploy di wordpress e mariaDB come nella sezione **03_kubernetes_foundamentals** , ma questa volta non inseriremo le password per l' utenza nel database utilizzando le env variables ma utilizzando i secrets. 


## KIND OF SECRETS

Esistono diverse tipologie di secrets in k8s, differenziate dal caso d'uso :

- Opaque                    -> Secret generico , normalmente contiene coppie chiave valore
- service-account-token     -> Secret contente il token utilizzato dai [service-account](https://kubernetes.io/docs/concepts/security/service-accounts/)
- dockercfg                 -> Utilizzato per autenticarsi ad un registro docker privato 
- dockerconfigjson          -> Uguale al precedente , ma utilizza un file json
- basic-auth                -> Conserva le credenziali di authentication come username e password
- ssh-auth                  -> Memorizza le chiavi ssh per l'accesso
- tls                       -> Conserva le coppie di chiavi TLS 
- bootstrap/token           -> Utilizzato per token bootstrap 

Noi ci concentreremo sopratutto sul secret di tipo Opaque che è il più generico , affrontarlo ci permetterà di comprendere come vengono gestiti i secrets in generale.

## SECRETS.YAML FILE

Il file secret.yaml è genericamente composto dalle seguenti sezioni principali:

- apiVersion
- kind 
- metadata  -> i dati relativi al secret , come il nome del secret che si vuole creare e labels associate
- data      -> il contenuto del secrets

**EXAMPLE**

        apiVersion: v1
        kind: Secret
        metadata:
          name: dotfile-secret
        data:
          .secret-file: dmFsdWUtMg0KDQo=

In questo esempio stiamo creando un secret chiamato dotfile-secret contenente un segreto identificato da ".secret-file" , questo secret verrà poi montato all'interno di un pod come volume e creerà all'interno del pod un file nascosto (.file) contenente la stringa che abbiamo inserito. 

## DEPLOY A SECRET

Quando creiamo un secret da file di configurazione , dobbiamo inserire il valore codificato in base64 all'interno del file, questo perché kubernetes si aspetta un valore base64 per poi decodificarlo automaticamente.
Per codificare in base64 il nostro secret possiamo usare il comando base64 su unix e mac (oppure possiamo andare al sito https://www.base64encode.org/ se stiamo utilizzando un device windows).

        echo -n "password" | base64     ->  cGFzc3dvcmQ=

The "-n" option is used to not print the output with the newline caracter (\n).

Il file secret.yaml creato ha questa configurazione:

        apiVersion: v1
        kind: Secret
        metadata:
          name: mariadb-passwords
        type: Opaque
        data:
          wordpress-user-password: ZXhhbXBsZQ==
          root-password: cm9vdA==

All'interno del file vengono definiti due valori , la password per l'utenza usata da wordpress e la password dell'utenza root del db.
I secret vengono poi richiamati all'interno del file deployement.yaml in questo modo:

        - name: MARIADB_USER
          value: wpadmindb
        - name: MARIADB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mariadb-passwords       -> SECRET'S NAME
              key: wordpress-user-password  -> KEY'S NAME
        - name: MARIADB_DATABASE
          value: app01db
        - name: MARIADB_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mariadb-passwords   -> SECRET'S NAME
              key: root-password        -> KEY'S NAME
