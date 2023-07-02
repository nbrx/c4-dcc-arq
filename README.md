# c4-dcc-arq
tarea para el dcc curso de arquitectura de software

# ejemplo push modelo en workspace 1 
structurizr.sh push -url http://localhost:8080/api -id 1 -key 2db4f2ac-9a2f-427c-94a5-b9a25c8c1f2b -secret be53cbbb-f90b-4bb6-a640-49fdca2435e2

# Arrancar servidor
docker run -it --rm -p 8080:8080 -v /mnt/data/structurizr/docker:/usr/local/structurizr structurizr/onpremises

# Publicar en server
structurizr.sh push -url http://146.190.142.96:8080/api -id 1 -key <key> -secret <secret> -w model.dsl

structurizr.sh pull -url http://146.190.142.96:8080/api -id 1 -key <key> -secret <secret>


# Generar sitio usando structurizr-site-generatr
structurizr-site-generatr serve -w modelv2.dsl

# crear el sitio estático con structurizr-site-generatr 
structurizr-site-generatr generate-site -w modelv2.dsl

# Generar especificación en puml y crear las imagenes con kroki 
# realiza un cleanup del direcotorio
rm -rf plantuml curl.sh

# realiza el export a formato planuml 
structurizr.sh export -workspace structurizr-1-workspace.json -format plantuml -output plantuml 

# Genera los archivos SVG 
for i in $(ls plantuml)
do
 echo "curl https://kroki.io/plantuml/svg --data-binary '@plantuml/$i' > plantuml/$i.svg" >> curl.sh
done
chmod u+x curl.sh
./curl.sh

# para mejorar la velocidad usar:
docker run -p 8000:8000 yuzutech/kroki

# Genera los archivos SVG 
for i in $(ls plantuml)
do
 echo "curl http://localhost:8000/plantuml/svg --data-binary '@plantuml/$i' > plantuml/$i.svg" >> curl.sh
done
chmod u+x curl.sh
./curl.sh
