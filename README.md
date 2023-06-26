# c4-dcc-arq
tarea para el dcc curso de arquitectura de software

-url http://localhost:8080/api -id 1 -key 2db4f2ac-9a2f-427c-94a5-b9a25c8c1f2b -secret be53cbbb-f90b-4bb6-a640-49fdca2435e2

# Arrancar servidor
docker run -it --rm -p 8080:8080 -v /mnt/data/structurizr/docker:/usr/local/structurizr structurizr/onpremises

# Publicar en server
structurizr.sh push -url http://146.190.142.96:8080/api -id 1 -key 60ef9ee1-17e2-4126-ae7a-8155e0cc5bd7 -secret f2296a8b-8a88-4435-93dd-46fe8cfece27 -w model.dsl
